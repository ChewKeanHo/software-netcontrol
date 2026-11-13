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
#	`NETCONTROL_interactors_libraries_cryptographies_is_password_compliant`
#	is to check a given passphrase is compliant to a set of password
#	requirements.
#
#	This function output all requirements' test results per request for
#	time-sensitive synchronous (e.g. graphical user interface) presentation
#	purposes.
# Parameters:
#	(1) Passphrase			REQUIRED.
#					The passphrase to test with.
#	(2) Minimum Length		REQUIRED.
#					The minimum length of passphrase in
#					decimal number (Base-10) only. Octal and
#					hexadecimal will be rejected.
#	(3), (4), ... Conditions	OPTIONAL.
#					Set the quantity of a condition. The
#					format is '[number]|::|[characters]' per
#					condition.
#
#					There **MUST BE ONLY ONE(1)** '|::|' in
#					each condition. If more than one is
#					present, only the FIRST and LAST
#					segments are used.
#
#					The supported format for [number] is
#					decimal number (Base-10) only. Octal and
#					hexadecimal will be rejected.
#
#					For [characters], it can be any
#					character. Multiple conditions
#					facilitates conditions grouping
#					purposes.
#					Examples:
#						* At least ONE(1) 'A-Z'
#							'1|::|ABC...XYZ'
#						* At least ONE(1) 'a-z'
#							'1|::|abc...xyz'
#						* At least ONE(1) '0-9'
#							'1|::|0123456789'
#						* At least ONE(1) '#$%&@^`~\/|_-'
#							'1|::|#$%&@^`~\/|_-'
#						* At least TEN(10) '[]'
#							'10|::|[]'
#
#					Should a condition have empty
#					[characters], an error will be raised
#					instead.
#
#					Should a character matches multiple
#					conditions, **ONLY THE FIRST MATCH** is
#					counted.
#
#					When no condition is available, then
#					this function only measures length.
# Outputs:
#	(1) Responses			List of exit codes line-by-line in this
#					format:
#					Line 1: Length
#					Line 2: Condition 1 (Parameter 3)
#					Line 3: Condition 2 (Parameter 4)
#					...
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given passphrase is empty.
#	'3'
#		*	means the given length or [number] is empty.
#	'4'
#		*	means the given length or [number] is invalid (e.g. an
#			octal-format number).
#	'5'
#		*	means a given condition is malformed (e.g. missing
#			'|::|' separator, invalid or empty [number], or empty
#			[characters]).
#	'6'
#		*	means a given condition is not fulfilled.
#		*	means the minimum length is not fulfilled.
#	'1'
#		*	means bad execution.
NETCONTROL_interactors_libraries_cryptographies_is_password_compliant() {
	#____passphrase="$1"
	#____length="$2"
	#____condition1="$3"
	#____condition2="$4"
	#...


	# validate inputs
	## passphrase
	if [ "${1:-}" = "" ]; then
		return 2
	fi

	## length
	case "${2:-}" in
	"")
		return 3
		;;
	0*|*[!0123456789]*)
		return 4
		;;
	*)
		;;
	esac

	## conditions
	____position=0
	for ____condition in "$@"; do
		____position="$(( $____position + 1 ))"
		if [ "$____position" -lt 3 ]; then
			#### skip passphrase and length
			continue
		fi

		### validate condition is usable before doing anything
		case "$____condition" in
		*"|::|"*)
			;;
		*)
			#### condition is having format error
			unset ____condition ____position
			return 5
			;;
		esac

		case "${____condition%%"|::|"*}" in
		""|0*|*[!0123456789]*)
			#### condition's quantity is not an acceptable number
			unset ____condition ____position
			return 5
			;;
		*)
			;;
		esac

		case "${____condition##*"|::|"}" in
		"")
			#### condition's characters list is empty.
			unset ____condition ____position
			return 5
			;;
		*)
			;;
		esac
	done
	unset ____condition ____position


	# execute
	## loop over passphrase and perform scanning
	____length=0
	____counters=""
	____remainder="${1:-}"
	while [ ! "$____remainder" = "" ]; do
		____char="${____remainder%%"${____remainder#?}"}"
		____remainder="${____remainder#?}"
		____length="$(( $____length + 1 ))"

		### scan each conditions
		____position=0
		____is_found=false
		for ____condition in "$@"; do
			____position="$(( $____position + 1 ))"
			if [ "$____position" -lt 3 ]; then
				#### skip passphrase and length
				continue
			fi

			### good - now perform scanning
			____condition="${____condition##*"|::|"}"
			while [ ! "$____condition" = "" ]; do
				if [ "$____char" = "${____condition%%"${____condition#?}"}" ]; then
					____is_found=true
					____counters="\
${____counters}${____position}
"
					break
				fi

				____condition="${____condition#?}"
			done
			unset ____condition

			if [ "$____is_found" = "true" ]; then
				break
			fi
		done
	done
	unset ____condition ____is_found ____position ____char ____remainder

	## process output
	### length
	____verdict_output=""
	if [ "$____length" -ge "${2:-}" ]; then
		____verdict_output="\
0
"
	else
		____verdict_output="\
6
"
	fi
	unset ____length

	### each condition
	____position=0
	for ____condition in "$@"; do
		____position="$(( $____position + 1 ))"
		if [ "$____position" -lt 3 ]; then
			#### skip passphrase and length
			continue
		fi

		### perform counting
		____count=0
		while IFS="" read -r ____line || [ -n "$____line" ]; do
			if [ "$____line" = "$____position" ]; then
				____count="$(( $____count + 1 ))"
			fi
		done<<EOF
${____counters}
EOF
		unset ____line

		### register to output
		if [ "$____count" -ge "${____condition%%"|::|"*}" ]; then
			____verdict_output="\
${____verdict_output}0
"
		else
			____verdict_output="\
${____verdict_output}6
"
		fi
	done
	unset ____count ____position ____condition ____counters


	## all good - export now
	printf -- "%s" "$____verdict_output"
	case "$____verdict_output" in
	*6*)
		unset ____verdict_output
		return 6
		;;
	*)
		unset ____verdict_output
		return 0
		;;
	esac
}




# report import status
return 0
