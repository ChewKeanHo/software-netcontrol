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
#	`NETCONTROL_interactors_libraries_cryptographies_openssl_create_key_with_random`
#	is to create a key with the specified length using cryptographic
#	randomness.
#
#	This function requires OpenSSL ≥ 3.2 to operate.
# Parameters:
#	(1) Length		REQUIRED.
#				The key length. MUST BE a positive number (>0)
#				in decimal (Base-10 '0-9') format. Octal and
#				hexadecimal formats will be rejected.
#
#				Each count yields 2 hexadecimal characters (e.g.
#				'4' -> 'AABBCCDD') without colon separator.
# Outputs:
#	(1) Derived Key		The derived key without colon (':') separator.
#				Example: 'AABBCC...'. Empty when any error
#				occurred.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given length is empty.
#	'3'
#		*	means the given length is invalid (e.g. not a positive
#			number).
#	'4'
#		*	means the os cannot cater this function (e.g. missing
#			or incompatible openssl).
#	'1'
#		*	means bad execution.
NETCONTROL_interactors_libraries_cryptographies_openssl_create_key_with_random() {
	#____length="$1"


	# validate inputs
	NETCONTROL_interactors_libraries_cryptographies_openssl_is_available
	if [ $? -ne 0 ]; then
		return 4
	fi

	## length
	case "${1:-}" in
	"")
		return 2
		;;
	0*)
		return 3
		;;
	*[!0123456789]*)
		return 3
		;;
	*)
		;;
	esac


	# execute
	____output="$(openssl rand -hex "${1:-}" 2> /dev/null)"
	if [ "$____output" = "" ]; then
		unset ____output
		return 1
	fi

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

	if [ "$____index" -ne $(( ${1:-} * 2 )) ]; then
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
