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
#	`NETCONTROL_interactors_libraries_cryptographies_openssl_create_checksum_with_sha512`
#	is to create a checksum value against a given payload without a specific
#	MAC secret key.
#
#	This function requires OpenSSL ≥ 3.2 to operate.
# Parameters:
#	(1) Payload		REQUIRED.
#				The payload data body or file. When it is a
#				filepath, ensures it is readable.
#
#				Otherwise, it will be treated as string. The
#				string is checksummed with a trailing newline
#				('\n') appended (echo-compatible convention).
#
#				A string that matches an existing filepath is
#				indistinguishable from a filepath and is
#				processed as the latter.
#
#				!!! CAUTION !!!
#				This is a fast-hashing algorithm not feasible
#				for secret and password hashing. For those, use
#				slow-hashing algorithm like Argon2id instead.
# Outputs:
#	(1) Derived Checksum	The derived checksum value with colon (':')
#				separator and without the 'SHA...(...)= '
#				prefix. Example: 'AA:BB:CC:...'. Empty when any
#				error occurred.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given payload is empty.
#		*	means the given payload file is empty.
#	'3'
#		*	means the given payload is invalid (e.g. a directory).
#	'4'
#		*	means the os cannot cater this function (e.g. missing
#			or incompatible openssl).
#	'1'
#		*	means bad execution.
NETCONTROL_interactors_libraries_cryptographies_openssl_create_checksum_with_sha512() {
	#____payload="$1"


	# validate inputs
	NETCONTROL_interactors_libraries_cryptographies_openssl_is_available
	if [ $? -ne 0 ]; then
		return 4
	fi

	## payload
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

		if [ -f "${1:-}" ] && [ ! -s "${1:-}" ]; then
			return 2
		fi
		;;
	esac


	# execute
	if [ -f "${1:-}" ]; then
		## file
		____output="$( \
			openssl dgst \
				-sha512 \
				-c \
				2> /dev/null \
				< "${1:-}" \
		)"
	else
		## string
		____output="$( \
			printf -- "%s\n" "${1:-}" \
			| openssl dgst \
				-sha512 \
				-c \
				2> /dev/null \
		)"
	fi
	if [ "$____output" = "" ]; then
		unset ____output
		return 1
	fi
	____output="${____output##*= }"

	## convert into uppercase
	____remainder="$____output"
	____output=""
	____index=0
	while [ ! "$____remainder" = "" ]; do
		____char="${____remainder%%"${____remainder#?}"}"
		____remainder="${____remainder#?}"
		____index="$(( $____index + 1 ))"

		case "$____char" in
		a)
			____output="${____output}A"
			;;
		b)
			____output="${____output}B"
			;;
		c)
			____output="${____output}C"
			;;
		d)
			____output="${____output}D"
			;;
		e)
			____output="${____output}E"
			;;
		f)
			____output="${____output}F"
			;;
		*)
			____output="${____output}${____char}"
			;;
		esac
	done
	unset ____char ____remainder

	if [ "$____index" -ne 191 ]; then
		unset ____index ____output
		return 1
	fi
	unset ____index

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
