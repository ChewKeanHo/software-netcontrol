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
# 'NETCONTROL_interactors_libraries_encodings_conf_read_file' is to read a
# configuration file for its value.
# Parameters:
#	(1) Filepath		REQUIRED.
#				The filepath to read the conf file.
#	(2) Name		REQUIRED.
#				The variable name from the confgiuration file.
#
#				Default is monochrome.
#
# Outputs:
#	(1) Printed String	The content is printed onto terminal's STDERR
#				console.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
#	'2'
#		* missing filepath.
#	'3'
#		* invalid filepath.
#	'4'
#		* missing name.
#	'5'
#		* invalid name.
#	'6'
#		* mismatched variable name.
#	'1'
#		* bad exec
NETCONTROL_interactors_libraries_encodings_conf_read_file() {
	#____filepath="$1"
	#____name="$2"


	# validate inputs
	if [ "${1:-}" = "" ]; then
		return 2
	fi

	if [ ! -f "${1:-}" ]; then
		return 3
	fi

	case "${2:-}" in
	"")
		;;
	*[a-z]*)
		return 3
		;;
	[0-9]*)
		return 3
		;;
	*[!A-Z_])
		return 3
		;;
	*)
		;;
	esac


	# execute
	____intreactors_parse_state="opener"
	____interactors_parsed_value=""
	while IFS="" read -r ____line || [ -n "$____line" ]; do
		case "${____line%%"#"*}" in
		"")
			continue
			;;
		*' = """')
			case "$____intreactors_parse_state" in
			opener)
				____intreactors_parse_state="content"
				;;
			*)
				return 1
				;;
			esac

			case "${____line%%" = "*}" in
			"${2:-}")
				;;
			*)
				return 6
				;;
			esac
			;;
		'"""')
			case "$____intreactors_parse_state" in
			content)
				____intreactors_parse_state="end"
				break
				;;
			*)
				return 1
				;;
			esac
			;;
		*)
			case "$____intreactors_parse_state" in
			content)
				____interactors_parsed_value="\
${____interactors_parsed_value}${____line}
"
				;;
			*)
				;;
			esac
			;;
		esac
	done < "${1:-}"
	unset ____line


	# report status
	case "$____intreactors_parse_state" in
	end)
		export "${2:-}"="${____interactors_parsed_value%"
"}"
		unset ____intreactors_parse_state ____interactors_parsed_value
		return 0
		;;
	*)
		export "${2:-}"=""
		unset ____intreactors_parse_state ____interactors_parsed_value
		return 1
		;;
	esac
}




# report import status
return 0
