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
#	`NETCONTROL_interactors_libraries_cryptographies_openssl_decrypt_using_passphrase`
#	is to decrypt an encrypted payload with a passphrase. It is the backward
#	compatible counterpart of decrypting every supported revision of
#	`NETCONTROL_interactors_libraries_cryptographies_openssl_encrypt_with_passphrase`
#	function.
#
#	The current supported algorithms are:
#		* Method:
#			* Encryption-then-MAC (EtM)
#		* Password:
#			* argon2id (ARGON2ID)
#				* Pointers below are enforced the same way as
#					its encryption counterpart. You **MUST**
#					use a compliant passphrase. Otherwise,
#					this decryption rejects it.
#				* Minimum characters: 32
#				* Must have at least one(1) 'A-Z'
#				* Must have at least one(1) 'a-z'
#				* Must have at least one(1) '0-9'
#				* Must have at least one(1) '#$%&@^`~\\/\|_-'
#				* 'Salt':
#					* minimum length: '32'
#					* default length: '32'
#					* length nature: even number (dividable by 2)
#				* 'Hash Iteration':
#					* minimum: '2' (OWASP)
#					* default: '3'
#				* 'Memory Size' in kB:
#					* minimum: '19456' (19 * 1024) (OWASP)
#					* default: '26624' (26 * 1024)
#				* 'Parallelism':
#					* minimum: '1' (OWASP)
#					* default: '1'
#		* Encryption:
#			* chacha20 (CHACHA20)
#		* MAC:
#			* HMAC-SHA256
#				* using SHA-256 for MAC.
#			* HMAC-SHA512
#				* using SHA-512 for MAC.
#			* HMAC-SHA512-256
#				* using SHA-512-256 for MAC.
#		* Input Format:
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
#	Backward Compatibility:
#		(1)	The 'Method:' field inside the signature block and the
#			payload block acts as the dispatch switch for selecting
#			the correct algorithms. Any unrecognized method is
#			rejected accordingly.
#
#		(2)	Unknown 'Key: Value' parameters are ignored.
#
#	This function requires OpenSSL ≥ 3.2 to operate.
#
#	Any pre-existing temporary working file ('{FILENAME}.enc.tmp') is
#	removed before processing.
# Parameters:
#	(1) Target		REQUIRED.
#				The target to decrypt. It can be string or
#				filepath. When it is a filepath, ensures its
#				file extension '.enc' is attached
#				('{FILENAME}.enc') and the corresponding output
#				target '{FILENAME}' next to it is absent.
#
#				Otherwise, it will be treated as string. The
#				output is printed to STDOUT instead.
#	(2) Passphrase		REQUIRED.
#				The secret passphrase to decrypt the payload in
#				string format.
# Outputs:
#	(1) Decrypted Payload	The decrypted output in the designated channel.
#				It can be empty when any error occurred.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given target is empty.
#	'3'
#		*	means the given target is invalid (e.g. not a file).
#		*	means the given target does not have '.enc' file
#			extension.
#		*	means the given target filepath's output path
#			('{FILENAME}') is already exists.
#		*	means the given target is an invalid file (e.g. cannot
#			decapsulate).
#	'4'
#		*	means the os cannot cater this function (e.g. missing
#			or incompatible openssl).
#	'1'
#		*	means bad execution.
#		*	means invalid password.
#		*	means invalid file (e.g. invalid format).
NETCONTROL_interactors_libraries_cryptographies_openssl_decrypt_using_passphrase() {
	#____target="$1"
	#____passphrase="$2"


	# validate inputs
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
			case "${1:-}" in
			*.enc)
				;;
			*)
				return 3
				;;
			esac

			if [ -e "${1%.enc}" ] || [ -L "${1%.enc}" ]; then
				return 3
			fi

			if [ ! -s "${1:-}" ]; then
				return 2
			fi

			if [ -e "${1:-}.tmp" ] || [ -L "${1:-}.tmp" ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}.tmp"
			fi
		fi
		;;
	esac


	# execute
	## de-encapsulate the encrypted payload
	if [ -f "${1:-}" ]; then
		## file
		____target="${1:-}.tmp"
	else
		## string
		____target="string"
	fi

	____ret_headers="$(
		NETCONTROL_interactors_libraries_cryptographies_decapsulate \
			"$____target" \
			"PRIVATE PAYLOAD" \
			"${1:-}" \
	)"
	case $? in
	0)
		unset ____target

		if [ "$____ret_headers" = "" ]; then
			if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}.tmp"
			fi

			unset ____ret_headers
			return 1
		fi
		;;
	6)
		# failed - given payload is empty
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____target ____ret_headers
		return 2
		;;
	7)
		# failed - given payload is invalid
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____target ____ret_headers
		return 3
		;;
	*)
		# failed - everything else as bad exec
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____target ____ret_headers
		return 1
		;;
	esac

	## parse headers
	____hmac_type=""
	____hmac_verdict=""
	____passphrase_cipher=""
	____encryption_cipher=""
	____salt=""
	____iteration=""
	____memory_size=""
	____parallelism=""
	____payload=""
	____parse_state=""
	while IFS="" read -r ____line || [ -n "$____line" ]; do
		case "$____line" in
		"core|::|hmac|::|Method")
			if [ ! "$____hmac_type" = "" ]; then
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
			fi

			____parse_state="hmac_type"
			;;
		"core|::|hmac|::|Digest")
			if [ ! "$____hmac_verdict" = "" ]; then
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
			fi

			____parse_state="hmac_verdict"
			;;
		"core|::|headers|::|Method")
			if [ ! "$____passphrase_cipher" = "" ]; then
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
			fi

			____parse_state="passphrase_cipher"
			;;
		"core|::|headers|::|Encryption")
			if [ ! "$____encryption_cipher" = "" ]; then
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
			fi

			____parse_state="encryption_cipher"
			;;
		"core|::|headers|::|Salt")
			if [ ! "$____salt" = "" ]; then
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
			fi

			____parse_state="salt"
			;;
		"core|::|headers|::|Iteration")
			if [ ! "$____iteration" = "" ]; then
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
			fi

			____parse_state="iteration"
			;;
		"core|::|headers|::|Memory-Size")
			if [ ! "$____memory_size" = "" ]; then
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
			fi

			____parse_state="memory_size"
			;;
		"core|::|headers|::|Parallelism")
			if [ ! "$____parallelism" = "" ]; then
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
			fi

			____parse_state="parallelism"
			;;
		"core|::|payload")
			if [ ! "$____payload" = "" ]; then
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
			fi

			____parse_state="payload"
			;;
		"core|::|"*)
			## unknown header - do not parse and skip
			____parse_state=""
			continue
			;;
		*)
			## assume values or garbage
			case "$____parse_state" in
			"")
				## not in parse mode - skip
				continue
				;;
			hmac_type)
				____hmac_type="\
${____hmac_type}${____line}"
				;;
			hmac_verdict)
				____hmac_verdict="\
${____hmac_verdict}${____line}"
				;;
			passphrase_cipher)
				____passphrase_cipher="\
${____passphrase_cipher}${____line}"
				;;
			encryption_cipher)
				____encryption_cipher="\
${____encryption_cipher}${____line}"
				;;
			salt)
				____salt="\
${____salt}${____line}"
				;;
			iteration)
				____iteration="\
${____iteration}${____line}"
				;;
			memory_size)
				____memory_size="\
${____memory_size}${____line}"
				;;
			parallelism)
				____parallelism="\
${____parallelism}${____line}"
				;;
			payload)
				____payload="\
${____payload}${____line}
"
				;;
			*)
				# broken format - exit
				if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
						"${1:-}.tmp"
				fi

				unset ____line \
					____ret_headers \
					____parse_state \
					____payload \
					____parallelism \
					____memory_size \
					____iteration \
					____salt \
					____encryption_cipher \
					____passphrase_cipher \
					____hmac_verdict \
					____hmac_type

				return 3
				;;
			esac
			;;
		esac
	done<<EOF
${____ret_headers}
EOF
	unset ____line ____parse_state ____ret_headers

	## validate parameters
	### payload
	if [ -f "${1:-}" ]; then
		## file
		if [ ! -f "${1:-}.tmp" ] ||
		([ -f "${1:-}.tmp" ] && [ ! -s "${1:-}.tmp" ]); then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"

			unset ____payload \
				____parallelism \
				____memory_size \
				____iteration \
				____salt \
				____encryption_cipher \
				____passphrase_cipher \
				____hmac_verdict \
				____hmac_type

			return 1
		fi
	else
		## string
		if [ "$____payload" = "" ]; then
			unset ____payload \
				____parallelism \
				____memory_size \
				____iteration \
				____salt \
				____encryption_cipher \
				____passphrase_cipher \
				____hmac_verdict \
				____hmac_type

			return 1
		fi
	fi

	### salt
	case "$____salt" in
	""|*[!0123456789abcdefABCDEF]*)
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____payload \
			____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____encryption_cipher \
			____passphrase_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	*)
		;;
	esac

	### hash iteration
	case "$____iteration" in
	""|0*|*[!0123456789]*)
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____payload \
			____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____encryption_cipher \
			____passphrase_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	*)
		;;
	esac

	### memory size
	case "$____memory_size" in
	""|0*|*[!0123456789]*)
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____payload \
			____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____encryption_cipher \
			____passphrase_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	*)
		;;
	esac

	### parallelism
	case "$____parallelism" in
	""|0*|*[!0123456789]*)
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____payload \
			____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____encryption_cipher \
			____passphrase_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	*)
		;;
	esac

	## calculate length
	____length=0
	case "$____hmac_type" in
	HMAC-SHA256)
		____length="$(( $____length + 64 ))"
		;;
	HMAC-SHA512)
		____length="$(( $____length + 128 ))"
		;;
	HMAC-SHA512-256)
		____length="$(( $____length + 64 ))"
		;;
	*)
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____length \
			____payload \
			____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____encryption_cipher \
			____passphrase_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	esac

	case "$____encryption_cipher" in
	CHACHA20)
		### 64 (key) + 32 (IV)
		____length="$(( $____length + 64 + 32 ))"
		;;
	*)
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____length \
			____payload \
			____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____encryption_cipher \
			____passphrase_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	esac

	## re-create key from passphrase for the required length
	case "$____passphrase_cipher" in
	ARGON2ID)
		____ret_output="$( \
			NETCONTROL_interactors_libraries_cryptographies_openssl_create_key_with_argon2id \
				"${2:-}" \
				"$(( $____length / 2 ))" \
				"$____salt" \
				"$____iteration" \
				"$____memory_size" \
				"$____parallelism"
		)"
		;;
	*)
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____length \
			____payload \
			____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____encryption_cipher \
			____passphrase_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	esac
	case $? in
	0)
		unset ____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____passphrase_cipher

		if [ "$____ret_output" = "" ]; then
			if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}.tmp"
			fi

			unset ____ret_output \
				____length \
				____payload \
				____encryption_cipher \
				____hmac_verdict \
				____hmac_type

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
		unset ____char ____index ____length ____ret_output
		;;
	11)
		## os cannot cater service
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____ret_output \
			____length \
			____payload \
			____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____encryption_cipher \
			____passphrase_cipher \
			____hmac_verdict \
			____hmac_type

		return 4
		;;
	*)
		# all else - considered bad exec
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____ret_output \
			____length \
			____payload \
			____parallelism \
			____memory_size \
			____iteration \
			____salt \
			____encryption_cipher \
			____passphrase_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	esac

	## mac the payload
	if [ -f "${1:-}" ]; then
		## file
		____payload="${1:-}.tmp"
	else
		## string
		____payload="${____payload%"
"}"
	fi

	case "$____hmac_type" in
	HMAC-SHA512)
		____hash="$( \
			NETCONTROL_interactors_libraries_cryptographies_openssl_create_hmac_with_sha512 \
				"$____payload" \
				"$____MK" \
		)"
		;;
	HMAC-SHA512-256)
		____hash="$( \
			NETCONTROL_interactors_libraries_cryptographies_openssl_create_hmac_with_sha512_256 \
				"$____payload" \
				"$____MK" \
		)"
		;;
	HMAC-SHA256)
		____hash="$( \
			NETCONTROL_interactors_libraries_cryptographies_openssl_create_hmac_with_sha256 \
				"$____payload" \
				"$____MK" \
		)"
		;;
	*)
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____IV \
			____K \
			____MK \
			____payload \
			____encryption_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	esac
	case $? in
	0)
		unset ____MK

		if [ "$____hash" = "" ]; then
			## failed - mac misbehaved
			if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}.tmp"
			fi

			unset ____hash \
				____IV \
				____K \
				____payload \
				____encryption_cipher \
				____hmac_verdict \
				____hmac_type

			return 1
		fi
		;;
	6)
		# os cannot cater service
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____hash \
			____MK \
			____IV \
			____K \
			____payload \
			____encryption_cipher \
			____hmac_verdict \
			____hmac_type

		return 4
		;;
	*)
		# all else - considered bad exec
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____hash \
			____MK \
			____IV \
			____K \
			____payload \
			____encryption_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
		;;
	esac

	## verdict the hmac and hash
	if [ ! "$____hash" = "$____hmac_verdict" ]; then
		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____hash \
			____IV \
			____K \
			____payload \
			____encryption_cipher \
			____hmac_verdict \
			____hmac_type

		return 1
	fi
	unset ____hash ____hmac_verdict ____hmac_type

	## decrypt the payload
	if [ -f "${1:-}" ]; then
		##file
		____ret_output="${1%.enc}"
	else
		## string
		____ret_output="string"
	fi

	case "$____encryption_cipher" in
	CHACHA20)
		____ret_output="$( \
			NETCONTROL_interactors_libraries_cryptographies_openssl_decrypt_with_chacha20 \
				"$____ret_output" \
				"$____payload" \
				"$____K" \
				"$____IV" \
				2> /dev/null \
		)"
		;;
	*)
		unset ____ret_output \
			____IV \
			____K \
			____payload \
			____encryption_cipher

		return 1
		;;
	esac
	case $? in
	0)
		unset ____IV \
			____K \
			____payload \
			____encryption_cipher

		if [ -f "${1:-}" ]; then
			## file
			if [ ! -s "${1%.enc}" ]; then
				### failed decryption misbehaved
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1%.enc}"
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}.tmp"
				unset ____ret_output
				return 1
			fi

			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
			sync "${1%.enc}" > /dev/null 2> /dev/null
		else
			## string
			if [ "$____ret_output" = "" ]; then
				unset ____ret_output
				return 1
			fi

			printf -- "%s\n" "$____ret_output"
		fi

		unset ____ret_output
		return 0
		;;
	10)
		# os cannot cater service
		if [ -f "${1:-}" ] && [ -f "${1%.enc}" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1%.enc}"
		fi

		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____ret_output \
			____IV \
			____K \
			____payload \
			____encryption_cipher

		return 4
		;;
	*)
		# all else - considered bad exec
		if [ -f "${1:-}" ] && [ -f "${1%.enc}" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1%.enc}"
		fi

		if [ -f "${1:-}" ] && [ -f "${1:-}.tmp" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}.tmp"
		fi

		unset ____ret_output \
			____IV \
			____K \
			____payload \
			____encryption_cipher

		return 1
		;;
	esac
}




# report import status
return 0
