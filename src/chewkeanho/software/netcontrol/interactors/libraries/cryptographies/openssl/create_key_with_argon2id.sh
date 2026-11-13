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
#	`NETCONTROL_interactors_libraries_cryptographies_openssl_create_key_with_argon2id`
#	is to create a key with the specified length using Argon2id algorithm.
#
#	The current default values and passphrase requirements are:
#		* Minimum characters: 32
#		* Must have at least one(1) 'A-Z'
#		* Must have at least one(1) 'a-z'
#		* Must have at least one(1) '0-9'
#		* Must have at least one(1) '#$%&@^`~\\/\|_-'
#		* 'Salt':
#			* minimum length: '32'
#			* length nature: even number (dividable by 2)
#		* 'Hash Iteration':
#			* minimum: '2' (OWASP)
#			* default: '3'
#		* 'Memory Size' in kB:
#			* minimum: '19456' (19 * 1024) (OWASP)
#			* default: '26624' (26 * 1024)
#		* 'Parallelism':
#			* minimum: '1' (OWASP)
#			* default: '1'
#
#	This function requires OpenSSL ≥ 3.2 to operate.
# Parameters:
#	(1) Passphrase		REQUIRED.
#				The secret passphrase for deriving the key in
#				plaintext string format.
#
#				!!! CAUTION !!!
#				Passphrase is visible in ps/ /proc/*/cmdline
#				while openssl runs and can retain in shell
#				history if typed interactively. Hence, be
#				careful on when to query, where to query, and
#				when to clear the plaintext passphrase.
#	(2) Length		REQUIRED.
#				The key length. MUST BE a positive number (>0)
#				in decimal (base-10) format. Octal and
#				hexadecimal will be rejected. Argon2id minimum
#				length is '4'.
#
#				Each count yields 2 hexadecimal characters (e.g.
#				'4' -> 'AA:BB:CC:DD') with colon separator.
#	(3) Salt		REQUIRED.
#				The salt hexadecimal data for passphrase
#				processing. It is a cryptography randomized
#				values with equal or greater than the minimum
#				characters length. Salt is not secret (not to be
#				confused with 'pepper').
#
#				The length **MUST** be an EVEN length (dividable
#				by 2).
#
#				Refer to description for minimum length.
#	(4) Hash Iteration	OPTIONAL.
#				The iteration rate for passphrase processing in
#				positive decimal (base-10) format. Octal and
#				hexadecimal will be rejected.
#
#				Refer to description for default value when left
#				empty.
#	(5) Memory Size		OPTIONAL.
#				The required memory size for passphrase
#				processing in positive decimal (base-10) format.
#				Octal and hexadecimal will be rejected.
#
#				Refer to description for default value when left
#				empty.
#	(6) Parallelism		OPTIONAL.
#				The required Parallelism count for passphrase
#				processing in positive decimal (base-10) format.
#				Octal and hexadecimal will be rejected.
#
#				Refer to description for default value when left
#				empty.
# Outputs:
#	(1) Derived Key		The derived key with colon (':') separator.
#				Example: 'AA:BB:CC:...'. Empty when any error
#				occurred.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given passphrase is empty.
#	'3'
#		*	means the given passphrase is invalid (e.g. too weak).
#	'4'
#		*	means the given length is empty.
#	'5'
#		*	means the given length is invalid (e.g. not a positive
#			number).
#	'6'
#		*	means the given salt is empty.
#	'7'
#		*	means the given salt is invalid (e.g. not a hexadecimal
#			value string, value is too short).
#	'8'
#		*	means the given hash iteration is invalid (e.g. not a
#			positive number).
#	'9'
#		*	means the given memory size is invalid (e.g. not a
#			positive number).
#	'10'
#		*	means the given parallelism count is invalid (e.g. not
#			a positive number).
#	'11'
#		*	means the os cannot cater this function (e.g. missing
#			or incompatible openssl).
#	'1'
#		*	means bad execution.
NETCONTROL_interactors_libraries_cryptographies_openssl_create_key_with_argon2id() {
	#____passphrase="$1"
	#____length="$2"
	#____salt="$3"
	#____hash_iteration="$4"
	#____memory_size="$5"
	#____parallelism="$6"


	# validate inputs
	NETCONTROL_interactors_libraries_os_is_command_available \
		"openssl" \
		> /dev/null \
		2> /dev/null
	if [ $? -ne 0 ]; then
		return 11
	fi

	case "$(openssl --version 2> /dev/null)" in
	""|\
	OpenSSL\ [012].*|\
	OpenSSL\ 3.[01].*)
		return 11
		;;
	OpenSSL\ *)
		;;
	*)
		## non-OpenSSL builds (e.g. LibreSSL, BoringSSL) are not
		## verified for support.
		return 11
		;;
	esac

	case "${1:-}" in
	"")
		return 2
		;;
	*)
		____verdict="$( \
			NETCONTROL_interactors_libraries_cryptographies_is_password_compliant \
				"${1:-}" \
				"32" \
				"1|::|abcdefghijklmnopqrstuvwxyz" \
				"1|::|ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
				"1|::|0123456789" \
				"1|::|#$%\\\&@^\\\`~\\\\/\\|_-]" \
		)"
		case "$____verdict" in
		""|*[123456789]*)
			unset ____verdict
			return 3
			;;
		*)
			unset ____verdict
			;;
		esac
		;;
	esac

	## length
	case "${2:-}" in
	"")
		return 4
		;;
	0*|*[!0123456789]*)
		return 5
		;;
	*)
		if [ "${2:-}" -lt 4 ]; then
			return 5
		fi
		;;
	esac

	## salt
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
		if [ "${#3}" -lt 32 ]; then
			return 7
		fi

		## salt cannot be in odd length
		if [ "$(( ${#3} % 2 ))" -ne 0 ]; then
			return 7
		fi
		;;
	esac

	## hash iteration
	case "${4:-}" in
	"")
		;;
	0*|*[!0123456789]*)
		return 8
		;;
	*)
		if [ "${4:-}" -lt 2 ]; then
			return 8
		fi
		;;
	esac

	## memory size
	case "${5:-}" in
	"")
		;;
	0*|*[!0123456789]*)
		return 9
		;;
	*)
		if [ "${5:-}" -lt 19456 ]; then
			return 9
		fi
		;;
	esac

	## parallelism
	case "${6:-}" in
	"")
		;;
	0*|*[!0123456789]*)
		return 10
		;;
	*)
		if [ "${6:-}" -lt 1 ]; then
			return 10
		fi

		____cpu="$(NETCONTROL_interactors_libraries_os_read_total_online_cpu)"
		if [ "${6:-}" -gt "$____cpu" ]; then
			unset ____cpu
			return 10
		fi
		unset ____cpu
		;;
	esac


	# execute
	____output="$( \
		openssl kdf \
			-keylen "${2:-}" \
			-kdfopt pass:"${1:-}" \
			-kdfopt hexsalt:"${3:-}" \
			-kdfopt iter:"${4:-3}" \
			-kdfopt memcost:"${5:-26624}" \
			-kdfopt lanes:"${6:-1}" \
			ARGON2ID \
			2> /dev/null \
	)"
	if [ "$____output" = "" ]; then
		unset ____output
		return 1
	fi

	## all good - export now
	printf -- "%s" "$____output"
	if [ $? -ne 0 ]; then
		unset ____output
		return 1
	fi
	unset ____output


	# report status
	return 0
}




# report import status
return 0
