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
#	`NETCONTROL_interactors_libraries_archive_tar_unpack` is to unpack a
#	given tar archived file (compressed or otherwise) back into a directory.
# Parameters:
#	(1) Target Path		REQUIRED.
#				The given directory path to unpack into.
#	(2) Source Path		REQUIRED.
#				The given tar-archived filepath.
# Outputs:
#	(1) Exit Code		For inline operation uses.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given directory path is empty.
#	'3'
#		*	means the given directory path is invalid (e.g. missing
#			directory).
#	'4'
#		*	means the given target path is empty.
#	'5'
#		*	means the given target path is already exists.
#	'6'
#		*	means the os cannot cater this function (e.g. missing or
#			incompatible tar).
#	'1'
#		*	means bad execution.
NETCONTROL_interactors_libraries_archive_tar_unpack() {
	#____target_path="$1"
	#____source_path="$2"


	# validate inputs
	case "${1:-}" in
	"")
		return 2
		;;
	*)
		if [ -b "${1:-}" ] ||
		[ -c "${1:-}" ] ||
		[ -p "${1:-}" ] ||
		[ -S "${1:-}" ] ||
		[ -L "${1:-}" ] ||
		[ -f "${1:-}" ]; then
			return 3
		elif [ ! "${1%/*}" = "${1:-}" ] &&
		[ ! "${1%/*}" = "" ] &&
		[ ! -d "${1%/*}" ]; then
			return 3
		fi

		if [ ! -d "${1:-}" ]; then
			return 3
		fi
		;;
	esac

	case "${2:-}" in
	"")
		return 4
		;;
	*)
		if [ -b "${2:-}" ] ||
		[ -c "${2:-}" ] ||
		[ -d "${2:-}" ] ||
		[ -p "${2:-}" ] ||
		[ -S "${2:-}" ] ||
		[ -L "${2:-}" ]; then
			return 5
		fi

		if [ ! -f "${2:-}" ]; then
			return 5
		fi

		if [ ! -s "${2:-}" ]; then
			return 5
		fi
		;;
	esac

	NETCONTROL_interactors_libraries_archive_tar_is_available
	if [ $? -ne 0 ]; then
		return 6
	fi


	# execute
	cp "${2:-}" "${1:-}/${2##*/}" > /dev/null 2> /dev/null
	case $? in
	0)
		;;
	*)
		NETCONTROL_interactors_libraries_fs_delete_node "./${2##*/}"
		return 1
		;;
	esac

	____current_directory="$PWD"
	cd "${1:-}"
	tar -xvf "./${2##*/}"
	case $? in
	0)
		NETCONTROL_interactors_libraries_fs_delete_node "./${2##*/}"
		cd "$____current_directory"
		unset ____current_directory
		return 0
		;;
	*)
		NETCONTROL_interactors_libraries_fs_delete_node "./${2##*/}"
		cd "$____current_directory"
		unset ____current_directory
		return 1
		;;
	esac
}




# report import status
return 0
