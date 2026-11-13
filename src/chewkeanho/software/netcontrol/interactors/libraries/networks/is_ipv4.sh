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
# `NETCONTROL_interactor_libraries_networks_is_ipv4` is to validate a given
# input is an IPv4 address.
#
# The output relies on the exit code both return as output and as exit code
# itself.
# Parameters:
#	(1) Input		REQUIRED.
#				The input string for validation.
# Outputs:
#	(1) Printed Exit Code	The exit code for embedded checking.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
#	'2'
#		* input is empty.
#	'3'
#		* input is invalid.
#	'1'
#		* bad execution.
NETCONTROL_interactor_libraries_networks_is_ipv4() {
	#____input="$1"


	# execute
	case "${1:-}" in
	"")
		printf -- "%s" "2"
		return 2
	;;
	*.*.*.*)
		# IPv4 format
		____interactor_remainder="${1:-}"
		____interactor_count=1
		while [ ! "$____interactor_remainder" = "" ]; do
			case "${____interactor_remainder%%.*}" in
			[2][0-5][0-5]|\
			[1][0-9][0-9]|\
			[0-9][0-9]|\
			[0-9])
				case "$____interactor_remainder" in
				*.*)
					____interactor_remainder="${____interactor_remainder#*.}"
					____interactor_count="$(( $____interactor_count + 1 ))"
					continue
					;;
				*)
					____interactor_remainder=""
					break
					;;
				esac
				;;
			*)
				unset ____interactor_remainder \
					____interactor_count
				printf -- "%s" "3"
				return 3
				;;
			esac
		done
		unset ____interactor_remainder

		case "$____interactor_count" in
		4)
			unset ____interactor_count
			printf -- "%s" "0"
			return 0
			;;
		*)
			;;
		esac
		unset ____interactor_count
		;;
	*)
		;;
	esac


	# report status
	printf -- "%s" "3"
	return 3
}




# report import status
return 0
