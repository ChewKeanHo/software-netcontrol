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
# `NETCONTROL_interactors_libraries_fs_delete_node` is to delete a given
# filesystem node from this current operating system.
#
# This deletion is atomic by performing a move to a temporary node next to it
# prior to its actual deletion. An OS synchonization will run after the deletion
# for avoiding filesystem cache data corruption. Therefore, it requires 'rm',
# 'mv', and 'sync' to work properly.
# Parameters:
#	(1) Input		REQUIRED.
#				The input path for deletion.
#	(2) Recursive Mode	OPTIONAL.
#				Flag to remove the node recursively (e.g. for
#				directory node). It accepts either 'true' or
#				'false'.
#
#				Default is 'false'.
# Outputs:
#	(1) Deleted Node	The node is deleted.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		*	ok.
#	'2'
#		*	means the given input is empty.
#	'3'
#		*	means the given input is invalid (e.g. not a path, a
#			block/character device).
#	'4'
#		*	means the given recursive mode is invalid (e.g. not a
#			boolean 'true' or 'false').
#	'5'
#		*	means the os cannot cater this function (e.g. missing or
#			incompatible rm).
#	'1'
#		*	bad execution (e.g. non-recursive mode for a directory).
NETCONTROL_interactors_libraries_fs_delete_node() {
	#____input="$1"
	#____recursive_mode="$2"


	# validate inputs
	case "${1:-}" in
	"")
		return 2
		;;
	*)
		if [ -b "${1:-}" ] || [ -c "${1:-}" ]; then
			return 3
		elif [ ! -e "${1:-}" ]; then
			return 0
		fi
		;;
	esac

	case "${2:-}" in
	true|True|TRUE)
		;;
	""|false|False|FALSE)
		if [ -d "${1:-}" ]; then
			return 1
		fi
		;;
	*)
		return 4
		;;
	esac

	NETCONTROL_interactors_libraries_os_is_command_available \
		"rm" \
		> /dev/null \
		2> /dev/null
	if [ $? -ne 0 ]; then
		return 5
	fi

	NETCONTROL_interactors_libraries_os_is_command_available \
		"sync" \
		> /dev/null \
		2> /dev/null
	if [ $? -ne 0 ]; then
		return 5
	fi

	NETCONTROL_interactors_libraries_os_is_command_available \
		"mv" \
		> /dev/null \
		2> /dev/null
	if [ $? -ne 0 ]; then
		return 5
	fi


	# execute
	## move the node into a temporary one
	mv -- "${1:-}" "${1:-}.delete$$" > /dev/null 2> /dev/null
	if [ $? -eq 0 ]; then
		sync -- "${1:-}" > /dev/null 2> /dev/null
		case "${2:-}" in
		true|True|TRUE)
			rm -rf -- "${1:-}.delete$$" > /dev/null 2> /dev/null
			____process=$?
			;;
		*)
			rm -f -- "${1:-}.delete$$" > /dev/null 2> /dev/null
			____process=$?
			;;
		esac
	else
		# target is still at its original location
		case "${2:-}" in
		true|True|TRUE)
			rm -rf -- "${1:-}" > /dev/null 2> /dev/null
			____process=$?
			;;
		*)
			rm -f -- "${1:-}" > /dev/null 2> /dev/null
			____process=$?
			;;
		esac
	fi

	## perform cleaned sync
	if [ ! "${1%/*}" = "${1:-}" ]; then
		sync -- "${1%/*}" > /dev/null 2> /dev/null
	else
		sync -- > /dev/null 2> /dev/null
	fi

	## handle error
	if [ $____process -ne 0 ]; then
		unset ____process
		return 1
	fi
	unset ____process


	# report status
	return 0
}




# report import status
return 0
