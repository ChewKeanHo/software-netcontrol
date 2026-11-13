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
# `NETCONTROL_interactors_libraries_os_print_error` is to print a given
# intepreted content into the terminal's STDERR console.
#
# The content is printed red when color is enabled.
# Parameters:
#	(1) Content		REQUIRED.
#				The interpreted string content. Multi-line is
#				supported.
#	(2) Color		OPTIONAL.
#				Flag to enable color mode. Accepts number. 8 and
#				above will turn the color on.
#
#				Default is monochrome.
#
# Outputs:
#	(1) Printed String	The content is printed onto terminal's STDERR
#				console.
#
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
NETCONTROL_interactors_libraries_os_print_error() {
	#____content="$1"
	#____color="$2"


	## !!! IMPORTANT NOTICE !!!
	## The variable names here are intentionally misspelled for avoiding
	## unwanted naming collision.


	# validate inputs
	_____runtime_x_retnirp_color=false
	case "${2:-}" in
	"")
		;;
	*[!0-9]*)
		;;
	*)
		if [ "$2" -ge "8" ]; then
			_____runtime_x_retnirp_color=true
		fi
		;;
	esac


	# execute
	printf -- "%s\n" "${1%"
"}" |
	while IFS="" read -r _____runtime_x_retnirp_line || \
	[ -n "$_____runtime_x_retnirp_line" ]; do
		if [ "$_____runtime_x_retnirp_color" = "true" ]; then
			1>&2 printf -- "%b%s%b\n" \
				"\\033[1;31mE:\\033[0m \\033[31m" \
				"${_____runtime_x_retnirp_line}" \
				"\\033[0m"
		else
			1>&2 printf -- "E: %s\n" "$_____runtime_x_retnirp_line"
		fi
	done
	unset _____runtime_x_retnirp_line _____runtime_x_retnirp_color


	# report status
	return 0
}




# report import status
return 0
