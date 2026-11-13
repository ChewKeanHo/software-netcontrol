#!/bin/sh
# Copyright 2026 The (Holloway) Chew, Kean Ho's NetControl Project Team (https://github.com/ChewKeanHo/software-netcontrol)
#
# The above unified aliases have one or more actual legal entities listed
# outside of this document: (1) 'CREATORS.txt' or 'AUTHORS.txt'; and (2)
# 'CONTRIBUTORS.txt'. They are usually placed next to this document in their
# respective project repository. Please refer to them for compiling the complete
# list accordingly.
#
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its contributors
# may be used to endorse or promote products derived from this software without
# specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.




# Description:
#	`NETCONTROL_interactors_libraries_cryptographies_openssl_encrypt_using_passphrase`
#	is to encrypt a payload with a passphrase. The current algorithms are:
#		* Method: Encryption-then-MAC (EtM)
#		* Password: argon2id
#			* Minimum characters: 32
#			* Must have at least one(1) 'A-Z'
#			* Must have at least one(1) 'a-z'
#			* Must have at least one(1) '0-9'
#			* Must have at least one(1) '#$%&@^`~\\/\|_-'
#			* 'Salt':
#				* minimum length: '32'
#				* default length: '32'
#				* length nature: even number (dividable by 2)
#			* 'Hash Iteration':
#				* minimum: '2' (OWASP)
#				* default: '3'
#			* 'Memory Size' in kB:
#				* minimum: '19456' (19 * 1024) (OWASP)
#				* default: '26624' (26 * 1024)
#			* 'Parallelism':
#				* minimum: '1' (OWASP)
#				* default: '1'
#		* Encryption:
#			* chacha20
#		* MAC:
#			* HMAC-SHA256 (default)
#				* using SHA-256 for MAC.
#			* HMAC-SHA512
#				* using SHA-512 for MAC.
#			* HMAC-SHA512-256
#				* using SHA-512-256 for MAC.
#		* Output Format:
#			-----BEGIN PRIVATE PAYLOAD SIGNATURE-----\n
#			Method: <HMAC type>\n
#			\n
#			\n
#			<HMAC digest>\n
#			-----END PRIVATE PAYLOAD SIGNATURE-----\n
#			-----BEGIN PRIVATE PAYLOAD-----\n
#			Method: <ID>\n
#			Encryption: <ID>\n
#			Salt: <hex>\n
#			Iteration: <number>\n
#			Memory-Size: <number>\n
#			Parallelism: <number>\n
#			...
#			\n
#			\n
#			<base64 ciphertext>\n
#			-----END PRIVATE PAYLOAD-----\n
#
#	This function requires OpenSSL ≥ 3.2 to operate.
#
#	The project maintainers have absolute vetoes to upgrade any of the
#	cryptography algorithms for future improvements.
#
#	Any pre-existing temporary working file ('{FILENAME}.enc.tmp') is
#	removed before processing.
# Parameters:
#	(1) Target		REQUIRED.
#				The target to encrypt. It can be string or
#				filepath. When it is filepath, ensures its
#				output file ('{FILENAME}.enc') next to it is
#				not available.
#
#				Otherwise, it will be treated as string. The
#				output is printed to STDOUT instead.
#	(2) Passphrase		REQUIRED.
#				The secret passphrase for deriving the key in
#				plaintext string format.
#
#				!!! CAUTION !!!
#				Passphrase is visible in ps/ /proc/*/cmdline
#				while openssl runs and can retain in shell
#				history if typed interactively. Hence, be
#				careful on when to query, where to query, and
#				when to clear the plaintext passphrase.
#	(3) Salt Length		OPTIONAL.
#				The salt hex length for passphrase processing in
#				positive Base-10 (0-9) number format only. Octal
#				and hexadecimal format will be rejected.
#
#				Refer to description for default value when left
#				empty.
#	(4) Hash Iteration	OPTIONAL.
#				The iteration rate for passphrase processing in
#				positive number only.
#
#				Refer to description for default value when left
#				empty.
#	(5) Memory Size		OPTIONAL.
#				The required memory size for passphrase
#				processing in positive number only.
#
#				Refer to description for default value when left
#				empty.
#	(6) Parallelism		OPTIONAL.
#				The required Parallelism count for passphrase
#				processing in positive number only.
#
#				Refer to description for default value when left
#				empty.
#	(7) HMAC Type		OPTIONAL.
#				The required HMAC Type for MAC hash processing
#				use.
#
#				Refer to description for all available values
#				and default value when left empty.
# Outputs:
#	(1) Exit Code		For inline operation uses.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given target is empty.
#	'3'
#		*	means the given target is invalid (e.g. not a file).
#		*	means the given target filepath's output path
#			('${FILENAME}.enc') is already exists.
#	'4'
#		*	means the given passphrase is empty.
#	'5'
#		*	means the given passphrase is invalid (e.g. too weak).
#	'6'
#		*	means the given salt length is invalid (e.g. not a
#			positive number).
#	'7'
#		*	means the given hash iteration is invalid (e.g. not a
#			positive number).
#	'8'
#		*	means the given memory size is invalid (e.g. not a
#			positive number).
#	'9'
#		*	means the given parallelism count is invalid (e.g. not
#			a positive number).
#	'10'
#		*	means the given hmac type is invalid (e.g. unrecognized
#			value).
#		*	means the given hmac type is unsupported.
#	'11'
#		*	means the os cannot cater this function (e.g. missing
#			or incompatible openssl).
#	'1'
#		*	means bad execution.
NETCONTROL_interactors_libraries_cryptographies_openssl_encrypt_using_passphrase() {
	#____target="$1"
	#____passphrase="$2"
	#____salt_length="$3"
	#____hash_iteration="$4"
	#____memory_size="$5"
	#____parallelism="$6"
	#____hmac_type="$7"


	# validate inputs
	## target
	case "${1:-}" in
	"")
		return 2
		;;
	*)
		if [ -b "${1:-}" ] ||
		[ -c "${1:-}" ] ||
		[ -d "${1:-}" ] ||
		[ -p "${1:-}" ] ||
		[ -S "${1:-}" ] ||
		[ -L "${1:-}" ]; then
			return 3
		fi

		if [ -f "${1:-}" ]; then
			if [ ! -s "${1:-}" ]; then
				return 2
			fi

			if [ -e "${1:-}.enc" ] || [ -L "${1:-}.enc" ]; then
				return 3
			fi
		fi
		;;
	esac

	## salt length
	case "${3:-}" in
	"")
		;;
	0*|*[!0123456789]*)
		return 6
		;;
	*)
		if [ "${3:-}" -lt 32 ]; then
			return 6
		fi

		if [ "$(( ${3:-} % 2 ))" -ne 0 ]; then
			return 6
		fi
		;;
	esac


	# execute
	## process salt
	____salt="$( \
		NETCONTROL_interactors_libraries_cryptographies_openssl_create_key_with_random \
			"$(( ${3:-32} / 2 ))" \
	)"
	case $? in
	0)
		if [ "$____salt" = "" ]; then
			unset ____salt
			return 1
		fi
		;;
	2)
		unset ____salt
		return 1
		;;
	3)
		unset ____salt
		return 1
		;;
	4)
		# os cannot cater service
		unset ____salt
		return 11
		;;
	*)
		# all else - considered bad exec
		unset ____salt
		return 1
		;;
	esac

	## calculate required length
	____length="$(( 64 + 32 ))" ### chacha20 requires 64 (key) + 32 (IV)
	case "${7:-}" in
	""|HMAC-SHA256)
		____length="$(( $____length + 64 ))"
		;;
	HMAC-SHA512)
		____length="$(( $____length + 128 ))"
		;;
	HMAC-SHA512-256)
		____length="$(( $____length + 64 ))"
		;;
	*)
		unset ____length ____salt
		return 10
		;;
	esac

	## create key from passphrase for the required length
	____ret_output="$( \
		NETCONTROL_interactors_libraries_cryptographies_openssl_create_key_with_argon2id \
			"${2:-}" \
			"$(( $____length / 2 ))" \
			"$____salt" \
			"${4:-3}" \
			"${5:-26624}" \
			"${6:-1}"
	)"
	case $? in
	0)
		if [ "$____ret_output" = "" ]; then
			unset ____ret_output ____length ____salt
			return 1
		fi

		## parse cipher keys
		____K=""
		____IV=""
		____MK=""
		____index=0
		while [ ! "$____ret_output" = "" ]; do
			____char="${____ret_output%%"${____ret_output#?}"}"
			____ret_output="${____ret_output#?}"

			if [ "$____char" = ":" ]; then
				continue
			elif [ "$____index" -lt 64 ]; then
				____K="${____K}${____char}"
				unset ____char
				____index=$(( $____index + 1 ))
			elif [ "$____index" -lt 96 ]; then
				____IV="${____IV}${____char}"
				unset ____char
				____index=$(( $____index + 1 ))
			elif [ "$____index" -lt "$____length" ]; then
				____MK="${____MK}${____char}"
				unset ____char
				____index=$(( $____index + 1 ))
			fi
		done
		unset ____char ____index ____ret_output

		if [ "${#____K}" -ne 64 ] ||
		[ "${#____IV}" -ne 32 ] ||
		[ "${#____MK}" -ne "$(( $____length - 96 ))" ]; then
			## key derivation misbehaved - abort
			unset ____K ____IV ____MK ____length ____salt
			return 1
		fi

		unset ____length
		;;
	2)
		# passphrase empty
		unset ____ret_output ____length ____salt
		return 4
		;;
	3)
		# passphrase invalid
		unset ____ret_output ____length ____salt
		return 5
		;;
	6|7)
		# salt is invalid or empty
		unset ____ret_output ____length ____salt
		return 6
		;;
	8)
		# hash iteration
		unset ____ret_output ____length ____salt
		return 7
		;;
	9)
		# memory size
		unset ____ret_output ____length ____salt
		return 8
		;;
	10)
		# parallelism
		unset ____ret_output ____length ____salt
		return 9
		;;
	11)
		# os cannot cater service
		unset ____ret_output ____length ____salt
		return 11
		;;
	*)
		# all else - considered bad exec
		unset ____ret_output ____length ____salt
		return 1
		;;
	esac

	## encrypt the payload
	if [ -f "${1:-}" ]; then
		##file
		____ret_output="${1:-}.enc.tmp"
		NETCONTROL_interactors_libraries_fs_delete_node "${1:-}.enc.tmp"
	else
		## string
		____ret_output="string"
	fi

	____ret_output="$( \
		NETCONTROL_interactors_libraries_cryptographies_openssl_encrypt_with_chacha20 \
			"$____ret_output" \
			"${1:-}" \
			"$____K" \
			"$____IV" \
			2> /dev/null \
	)"
	case $? in
	0)
		unset ____K ____IV

		if [ -f "${1:-}" ]; then
			##file
			____ret_output="${1:-}.enc.tmp"
		fi
		;;
	4)
		# payload is empty
		if [ -f "${1:-}" ] && [ -f "${1:-}.enc.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.enc.tmp"
		fi

		unset ____ret_output ____K ____IV ____MK ____salt
		return 2
		;;
	5)
		# payload is invalid
		if [ -f "${1:-}" ] && [ -f "${1:-}.enc.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.enc.tmp"
		fi

		unset ____ret_output ____K ____IV ____MK ____salt
		return 3
		;;
	10)
		# os cannot cater service
		if [ -f "${1:-}" ] && [ -f "${1:-}.enc.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.enc.tmp"
		fi

		unset ____ret_output ____K ____IV ____MK ____salt
		return 11
		;;
	*)
		# all else - considered bad exec
		if [ -f "${1:-}" ] && [ -f "${1:-}.enc.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.enc.tmp"
		fi

		unset ____ret_output ____K ____IV ____MK ____salt
		return 1
		;;
	esac

	## mac the payload
	case "${7:-}" in
	HMAC-SHA512)
		____hash_type="HMAC-SHA512"
		____hash="$( \
			NETCONTROL_interactors_libraries_cryptographies_openssl_create_hmac_with_sha512 \
				"$____ret_output" \
				"$____MK"
		)"
		;;
	HMAC-SHA512-256)
		____hash_type="HMAC-SHA512-256"
		____hash="$( \
			NETCONTROL_interactors_libraries_cryptographies_openssl_create_hmac_with_sha512_256 \
				"$____ret_output" \
				"$____MK"
		)"
		;;
	*)
		____hash_type="HMAC-SHA256"
		____hash="$( \
			NETCONTROL_interactors_libraries_cryptographies_openssl_create_hmac_with_sha256 \
				"$____ret_output" \
				"$____MK"
		)"
		;;
	esac
	case $? in
	0)
		unset ____MK

		if [ "$____hash" = "" ]; then
			## failed - mac misbehaved
			if [ -f "${1:-}" ] && [ -f "${1:-}.enc.tmp" ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}.enc.tmp"
			fi

			unset ____hash_type ____hash ____ret_output ____salt
			return 1
		fi
		;;
	6)
		# os cannot cater service
		if [ -f "${1:-}" ] && [ -f "${1:-}.enc.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.enc.tmp"
		fi

		unset ____hash_type ____hash ____ret_output ____MK ____salt
		return 11
		;;
	*)
		# all else - considered bad exec
		if [ -f "${1:-}" ] && [ -f "${1:-}.enc.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.enc.tmp"
		fi

		unset ____hash_type ____hash ____ret_output ____MK ____salt
		return 1
		;;
	esac

	## output encrypted payload
	if [ -f "${1:-}" ]; then
		##file
		____target="${1:-}.enc"
	else
		## string
		____target="string"
	fi

	____ret_output="$( \
		NETCONTROL_interactors_libraries_cryptographies_encapsulate \
			"$____target" \
			"PRIVATE PAYLOAD" \
			"$____ret_output" \
			"\
Method: ARGON2ID
Encryption: CHACHA20
Salt: ${____salt}
Iteration: ${4:-3}
Memory-Size: ${5:-26624}
Parallelism: ${6:-1}
" \
			"$____hash_type" \
			"$____hash" \
			2> /dev/null \
	)"
	case $? in
	0)
		if [ -f "${1:-}" ]; then
			## file
			if [ ! -s "${1:-}.enc" ]; then
				### failed encapsulate misbehaved
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}.enc"
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}.enc.tmp"
				unset ____target \
					____hash_type \
					____hash \
					____ret_output \
					____salt
				return 1
			fi

			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.enc.tmp"
			sync "${1:-}.enc" > /dev/null 2> /dev/null
		else
			## string
			if [ "$____ret_output" = "" ]; then
				unset ____target \
					____hash_type \
					____hash \
					____ret_output \
					____salt
				return 1
			fi

			printf -- "%s\n" "$____ret_output"
		fi

		unset ____target ____hash_type ____hash ____ret_output ____salt
		return 0
		;;
	*)
		# all else - considered bad exec
		if [ -f "${1:-}" ] && [ -f "${1:-}.enc" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.enc"
		fi

		if [ -f "${1:-}" ] && [ -f "${1:-}.enc.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.enc.tmp"
		fi

		unset ____target ____hash_type ____hash ____ret_output ____salt
		;;
	esac


	# report status
	return 1
}




# report import status
return 0
