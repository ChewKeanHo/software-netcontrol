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
#	`NETCONTROL_interactors_libraries_cryptographies_openssl_decrypt_with_chacha20`
#	is to decrypt a given encrypted payload with a secret key and an IV
#	input with chacha20 encryption algorithm.
#
#	This function only decrypts the payload. It DOES NOT perform any MAC
#	checksum to the encrypted payload before decryption. Use the appropriate
#	MAC checksum functions to further securing the data authenticity prior
#	to this calling function.
#
#	This function requires OpenSSL ≥ 3.2 to operate.
#
#	The Base64 payload is decoded in one-block mode ('-A'): wrapped,
#	single-line, and newline-free Base64 bodies with lines of any length
#	are accepted. Without one-block mode, OpenSSL's line-mode Base64
#	decoder silently discards (rc=0, empty output) any Base64 line longer
#	than 1024 bytes, and any final line missing its terminating newline.
# Parameters:
#	(1) Output Path		REQUIRED.
#				The output filepath. Set to 'string' for STDOUT
#				instead.
#
#				Both 'string' and 'file' modes will output the
#				raw plaintext data format. String mode is
#				intended for text payloads; binary payloads must
#				use file output.
#	(2) Payload		REQUIRED.
#				The payload data body or file in Base64
#				ciphertext format. When it is a filepath,
#				ensures it is readable.
#
#				Otherwise, it will be treated as string.
#	(3) Secret Key		REQUIRED.
#				The secret key created using cryptographic
#				randomness in hexadecimal value string format.
#				The key **MUST BE** precisely 64 characters
#				long.
#
#				!!! CAUTION !!!
#				Secret key is visible in ps/ /proc/*/cmdline
#				while openssl runs and can retain in shell
#				history if typed interactively. Hence, be
#				careful on when to query, where to query, and
#				when to clear the plaintext secret key.
#	(4) IV			REQUIRED.
#				The IV value created using cryptographic
#				randomness in hexadecimal value string format.
#				The uniqueness of the value matters. IV
#				**MUST BE** precisely 32 characters long.
#
#				!!! CAUTION !!!
#				IV is visible in ps/ /proc/*/cmdline
#				while openssl runs and can retain in shell
#				history if typed interactively. Hence, be
#				careful on when to query, where to query, and
#				when to clear the plaintext IV value.
# Outputs:
#	(1) Decrypted Payload	The decrypted payload to the designated channel.
#				Can be empty when any error occurred.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given output path is empty.
#	'3'
#		*	means the given output path is invalid (e.g. not a file
#			or 'string' as value).
#		*	means the given output path is already exists.
#		*	means the housing directory for the output path is
#			missing.
#	'4'
#		*	means the given payload is empty.
#	'5'
#		*	means the given payload is invalid (e.g. given a
#			directory).
#	'6'
#		*	means the given key is empty.
#	'7'
#		*	means the given key is invalid (e.g. unmatched length,
#			not a hexadecimal string).
#	'8'
#		*	means the given IV is empty.
#	'9'
#		*	means the given IV is invalid (e.g. unmatched length,
#			not a hexadecimal string).
#	'10'
#		*	means the os cannot cater this function (e.g. missing
#			or incompatible openssl).
#	'1'
#		*	means bad execution.
NETCONTROL_interactors_libraries_cryptographies_openssl_decrypt_with_chacha20() {
	#____target_path="$1"
	#____payload="$2"
	#____secret_key="$3"
	#____iv="$4"


	# validate inputs
	NETCONTROL_interactors_libraries_cryptographies_openssl_is_available
	if [ $? -ne 0 ]; then
		return 10
	fi

	## target path
	case "${1:-}" in
	"")
		return 2
		;;
	string)
		;;
	*)
		## file
		if [ -b "${1:-}" ] ||
		[ -c "${1:-}" ] ||
		[ -d "${1:-}" ] ||
		[ -p "${1:-}" ] ||
		[ -S "${1:-}" ] ||
		[ -L "${1:-}" ] ||
		[ -f "${1:-}" ] ||
		[ -e "${1:-}" ]; then
			return 3
		elif [ ! "${1%/*}" = "${1:-}" ] &&
		[ ! "${1%/*}" = "" ] &&
		[ ! -d "${1%/*}" ]; then
			return 3
		fi
		;;
	esac

	## payload
	case "${2:-}" in
	"")
		return 4
		;;
	*)
		if [ -b "${2:-}" ] ||
		[ -c "${2:-}" ] ||
		[ -d "${2:-}" ] ||
		[ -p "${2:-}" ] ||
		[ -S "${2:-}" ] ||
		[ -L "${2:-}" ]; then
			return 5
		fi

		if [ -f "${2:-}" ] && [ ! -s "${2:-}" ]; then
			return 4
		fi
		;;
	esac

	## key
	case "${3:-}" in
	"")
		return 6
		;;
	*[!0123456789abcdefABCDEF]*)
		return 7
		;;
	*)
		## it is only ASCII characters so it is safe to use ${#VAR}
		## method.
		if [ "${#3}" -ne 64 ]; then
			return 7
		fi
		;;
	esac

	## iv
	case "${4:-}" in
	"")
		return 8
		;;
	*[!0123456789abcdefABCDEF]*)
		return 9
		;;
	*)
		## it is only ASCII characters so it is safe to use ${#VAR}
		## method.
		if [ "${#4}" -ne 32 ]; then
			return 9
		fi
		;;
	esac


	# execute
	if [ -f "${2:-}" ]; then
		## file
		if [ ! "${1:-}" = "string" ]; then
			### create randomized temporary file for preventing
			### symlink exploitation vulnerability.
			____temp_file="$( \
				mktemp "${1:-}.tmp.XXXXXXXX" 2> /dev/null \
			)"
			if [ "$____temp_file" = "" ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"$____temp_file"
				unset ____temp_file
				return 1
			fi

			openssl enc \
				-chacha20 \
				-K "${3:-}" \
				-iv "${4:-}" \
				-d \
				-base64 \
				-A \
				-in "${2:-}" \
				> "$____temp_file" \
				2> /dev/null
			if [ $? -ne 0 ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"$____temp_file"
				unset ____temp_file
				return 1
			fi

			sync "$____temp_file" > /dev/null 2> /dev/null
			mv -f "$____temp_file" "${1:-}"
			if [ $? -ne 0 ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}"
				NETCONTROL_interactors_libraries_fs_delete_node \
					"$____temp_file"
				rm -f "${1:-}" > /dev/null 2> /dev/null
				sync "${1:-}" > /dev/null 2> /dev/null
				unset ____temp_file
				return 1
			fi

			unset ____temp_file
		else
			____output="$( \
				openssl enc \
					-chacha20 \
					-K "${3:-}" \
					-iv "${4:-}" \
					-d \
					-base64 \
					-A \
					-in "${2:-}" \
					2> /dev/null \
			)"
			if [ $? -ne 0 ]; then
				unset ____output
				return 1
			fi

			printf -- "%s\n" "$____output"
			if [ $? -ne 0 ]; then
				unset ____output
				return 1
			fi
			unset ____output
		fi
	else
		## string
		if [ ! "${1:-}" = "string" ]; then
			### create randomized temporary file for preventing
			### symlink exploitation vulnerability.
			____temp_file="$( \
				mktemp "${1:-}.tmp.XXXXXXXX" 2> /dev/null \
			)"
			if [ "$____temp_file" = "" ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"$____temp_file"
				unset ____temp_file
				return 1
			fi

			printf -- "%s\n" "${2:-}" \
				| openssl enc \
					-chacha20 \
					-K "${3:-}" \
					-iv "${4:-}" \
					-d \
					-base64 \
					-A \
					> "$____temp_file" \
					2> /dev/null
			if [ $? -ne 0 ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"$____temp_file"
				unset ____temp_file
				return 1
			fi

			sync "$____temp_file" > /dev/null 2> /dev/null
			mv -f "$____temp_file" "${1:-}"
			if [ $? -ne 0 ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"${1:-}"
				NETCONTROL_interactors_libraries_fs_delete_node \
					"$____temp_file"
				unset ____temp_file
				return 1
			fi

			unset ____temp_file
		else
			____output="$( \
				printf -- "%s\n" "${2:-}" \
					| openssl enc \
						-chacha20 \
						-K "${3:-}" \
						-iv "${4:-}" \
						-d \
						-base64 \
						-A \
						2> /dev/null
			)"
			if [ $? -ne 0 ]; then
				unset ____output
				return 1
			fi

			printf -- "%s" "$____output"
			if [ $? -ne 0 ]; then
				unset ____output
				return 1
			fi
			unset ____output
		fi
	fi


	# report status
	return 0
}




# report import status
return 0
