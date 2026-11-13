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
#	`NETCONTROL_interactors_libraries_numbers_is_positive` is to validate
#	a given input is a legit number in positive region including ZERO (0).
#	Only the following numeric patterns are accepted:
#		* [NUMBER]...
#		* +[NUMBER]...
#		* +[ZERO]
#		* [ZERO]
#		* -[ZERO]
#
#	[NUMBER] can be represented in the following formats:
#		* Octal (base-8): 0[0...0][0-7]...
#		* Hexadecimal (base-16): 0[xX][0...0][0123456789aAbBcCdDeEfF]...
#		* Decimal (base-10): [0-9]...
#			* NOTE: Leading-zero (010) forms are octal, not decimal.
#		* NOTE: Only minus-signed ZERO literals (e.g. -0, -00, -0x0) are
#			accepted and interpreted as 0. Any other negative value
#			is rejected.
#
#	This function only validates whole number.
# Parameters:
#	(1) Input		REQUIRED.
#				A given input data for validation.
# Outputs:
#	(1) Exit Code		For inline operation uses.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given input is empty.
#	'1'
#		*	means the given input is not a positive number.
NETCONTROL_interactors_libraries_numbers_is_positive() {
	#____input="$1"


	# execute
	____interactors_input="${1:-}"
	case "$____interactors_input" in
	"")
		# empty input
		unset ____interactors_input
		printf -- "%s" 2
		return 2
		;;
	-*)
		____interactors_input="${____interactors_input#?}"

		case "$____interactors_input" in
		"")
			;;
		0)
			;;
		0[xX]*)
			____interactors_input="${____interactors_input#??}"
			;;
		0*)
			____interactors_input="${____interactors_input#?}"
			;;
		*)
			;;
		esac

		case "$____interactors_input" in
		""|*[!0]*)
			## error - bare '-' sign
			## only positive number
			unset ____interactors_input
			printf -- "%s" 1
			return 1
			;;
		*)
			## only minus-signed ZERO is a ZERO byte (-0 == 0)
			;;
		esac
		;;
	+*)
		____interactors_input="${____interactors_input#?}"
		;;
	*)
		;;
	esac

	case "$____interactors_input" in
	"")
		## error - just '[+-]' syntax
		unset ____interactors_input
		printf -- "%s" 1
		return 1
		;;
	0)
		## 0
		;;
	0[xX]*)
		# seek hexadecimal
		____interactors_input="${____interactors_input#??}"
		case "$____interactors_input" in
		"")
			## error - just '0[xX]' syntax
			unset ____interactors_input
			printf -- "%s" 1
			return 1
			;;
		*[!0]*)
			case "$____interactors_input" in
			*[!0123456789aAbBcCdDeEfF]*)
				## error - contains invalid characters
				unset ____interactors_input
				printf -- "%s" 1
				return 1
				;;
			*)
				;;
			esac
			;;
		*)
			## 0x00...00
			;;
		esac
		;;
	0*)
		# seek octal
		____interactors_input="${____interactors_input#?}"
		case "$____interactors_input" in
		"")
			## 0
			;;
		*[!0]*)
			case "$____interactors_input" in
			*[!01234567]*)
				## error - contains invalid characters
				unset ____interactors_input
				printf -- "%s" 1
				return 1
				;;
			*)
				;;
			esac
			;;
		*)
			## 00..00
			;;
		esac
		;;
	*)
		# seek decimal
		case "$____interactors_input" in
		*[!0123456789]*)
			## error - contains invalid characters
			unset ____interactors_input
			printf -- "%s" 1
			return 1
			;;
		*)
			;;
		esac
		;;
	esac
	unset ____interactors_input


	# report status
	printf -- "%s" 0
	return 0
}




# report import status
return 0
