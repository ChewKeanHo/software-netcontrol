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
#	`NETCONTROL_interactors_libraries_cryptographies_read_password_from_terminal`
#	is to securely request a passphrase from a terminal interface.
# Parameters:
# Outputs:
#	(1) Passphrase		The input data into STDOUT channel.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the os cannot cater this function (e.g. missing
#			or incompatible stty).
#	'1'
#		*	means bad execution.
NETCONTROL_interactors_libraries_cryptographies_read_password_from_terminal() {
	# validate inputs
	if [ ! -t 0 ]; then
		return 2
	fi

	NETCONTROL_interactors_libraries_os_is_command_available \
		"stty" \
		> /dev/null \
		2> /dev/null
	if [ $? -ne 0 ]; then
		return 2
	fi


	# execute
	____passphrase=""
	____passphrase="$({
		____stty="$(stty -g 2> /dev/null)"
		if [ $? -ne 0 ]; then
			unset ____stty
			exit 1
		fi

		trap 'stty "$____stty" > /dev/null 2>&1' INT TERM HUP
		stty -echo 2> /dev/null
		if [ $? -ne 0 ]; then
			stty "$____stty" > /dev/null 2> /dev/null
			unset ____stty
			trap - INT TERM HUP
			exit 1
		fi

		## request input
		1>&2 printf -- "%s" "<<<{o}: "
		IFS="" read -r ____secret
		____status=$?

		## print output
		stty "$____stty" > /dev/null 2> /dev/null
		trap - INT TERM HUP
		if [ "$____status" -ne 0 ]; then
			1>&2 printf '\n'
			unset ____stty
			exit 1
		fi
		unset ____stty

		1>&2 printf '*******************************************\n'
		printf -- "%s" "$____secret"
		unset ____stty
		exit 0
	})"
	if [ $? -ne 0 ]; then
		unset ____passphrase
		return 1
	fi

	## all good - output now
	printf -- "%s" "$____passphrase"
	if [ $? -ne 0 ]; then
		unset ____passphrase
		return 1
	fi
	unset ____passphrase


	# report status
	return 0
}




# report import status
return 0
