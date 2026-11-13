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
# `NETCONTROL_interactors_libraries_networks_ssh_copy_id` is to transfer the
# current SSH public keys to the remote location as authorized keys.
# Parameters:
#	(1) Remote User		REQUIRED.
#				The remote user to execute this command.
#	(2) Remote Address	REQUIRED.
#				The remote address (e.g. IP or domain).
#	(3) Remote Port		REQUIRED.
#				The remote port number (default '22').
# Outputs:
#	(1) Remote Output	The execution output from remote.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
#	'2'
#		* user input is empty.
#	'3'
#		* user input is invalid.
#	'4'
#		* address input is empty.
#	'5'
#		* address input is invalid.
#	'6'
#		* port input is empty.
#	'7'
#		* port input is invalid.
#	'8'
#		* 'ssh-copy-id' command is unavailable.
#	'1'
#		* bad execution.
NETCONTROL_interactors_libraries_networks_ssh_copy_id() {
	#____user="$1"
	#____remote_address="$2"
	#____remote_port="$3"
	#____command="$4"


	# validate inputs
	if [ "${1:-}" = "" ]; then
		return 2
	fi

	if [ "${2:-}" = "" ]; then
		return 4
	fi

	NETCONTROL_interactors_libraries_numbers_is_positive \
		"${3:-22}" \
		> /dev/null
	case $? in
	0)
		;;
	2)
		return 6
		;;
	*)
		return 7
		;;
	esac

	NETCONTROL_interactors_libraries_os_is_command_available \
		"ssh-copy-id" \
		> /dev/null
	if [ $? -ne 0 ]; then
		return 8
	fi


	# execute
	ssh-copy-id "${1:-}@${2:-}"
	if [ $? -ne 0 ]; then
		return 1
	fi


	# report status
	return 0
}




# report import status
return 0
