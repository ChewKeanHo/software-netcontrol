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
#	`NETCONTROL_interactors_libraries_compress_gz_read` is to test a given
#	gz-compressed file is bona-fide and healthy.
# Parameters:
#	(1) Target Path			REQUIRED.
#					The given gz-compressed filepath for
#					testing.
# Outputs:
#	(1) Printed Exit Code		The exit code for embedded checking.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given target path is empty.
#	'3'
#		*	means the given target path is invalid (e.g. a
#			directory).
#	'4'
#		*	means the os cannot cater this function (e.g. missing or
#			incompatible gunzip or gzip).
#	'1'
#		*	means bad execution.
#		*	means the target filepath is not a gz-compressed file.
#		*	means the target filepath is in bad shape.
NETCONTROL_interactors_libraries_compress_gz_read() {
	#____target_path="$1"


	# validate inputs
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
		[ -L "${1:-}" ] ||
		[ ! -e "${1:-}" ]; then
			return 3
		elif [ ! "${1%/*}" = "${1:-}" ] &&
		[ ! "${1%/*}" = "" ] &&
		[ ! -d "${1%/*}" ]; then
			return 3
		fi

		if [ ! -f "${1:-}" ]; then
			return 3
		fi

		if [ ! -s "${1:-}" ]; then
			return 2
		fi
		;;
	esac

	NETCONTROL_interactors_libraries_compress_gz_is_available
	if [ $? -ne 0 ]; then
		return 4
	fi


	# execute
	NETCONTROL_interactors_libraries_os_is_command_available \
		"gunzip" \
		> /dev/null
	if [ $? -eq 0 ]; then
		gunzip --test "${2:-}" > /dev/null 2> /dev/null
	else
		gzip --test "${2:-}" > /dev/null 2> /dev/null
	fi
	case $? in
	0)
		return 0
		;;
	*)
		return 1
		;;
	esac
}




# report import status
return 0
