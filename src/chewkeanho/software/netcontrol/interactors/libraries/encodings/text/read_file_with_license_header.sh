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
# `NETCONTROL_interactors_libraries_encodings_text_read_file_with_license_header`
# is to read a text file with trimmed license header instead of "as it is".
# Parameters:
#	(1) Filepath		REQUIRED.
#				The filepath to read the conf file.
#
# Outputs:
#	(1) Printed String	The file content with stripped license header.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
#	'2'
#		* missing filepath.
#	'3'
#		* invalid filepath.
#	'1'
#		* bad exec
NETCONTROL_interactors_libraries_encodings_text_read_file_with_license_header() {
	#____filepath="$1"


	# validate inputs
	if [ "${1:-}" = "" ]; then
		return 2
	fi

	if [ ! -f "${1:-}" ]; then
		return 3
	fi


	# execute
	____intreactors_parse_state="license"
	____interactors_parsed_value=""
	while IFS="" read -r ____line || [ -n "$____line" ]; do
		case "${____line%%"#"*}" in
		"")
			case "$____intreactors_parse_state" in
			content)
				____intreactors_parse_value="\
${____intreactors_parse_value}${____line}
"
				;;
			*)
				continue
				;;
			esac
			;;
		*)
			____intreactors_parse_state="content"
			____intreactors_parse_value="\
${____intreactors_parse_value}${____line}
"
			;;
		esac
	done < "${1:-}"
	unset ____line ____intreactors_parse_state

	## output data
	printf -- "%s" "$____intreactors_parse_value"
	if [ $? -ne 0 ]; then
		return 1
	fi


	# report status
	return 0
}




# report import status
return 0
