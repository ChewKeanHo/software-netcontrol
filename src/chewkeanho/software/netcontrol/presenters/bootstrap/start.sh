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




# sanitize config directory
case "${2:-}" in
"")
	NETCONTROL_interactors_libraries_os_print_error "\
Missing Profile Directory Name.
Ensure '[PROFILE_NAME]' is Pointing to a Directory Inside 'etc/openwrt/config/'.
For Example: 'main' for 'etc/openwrt/config/main'.
Then Use Command: $ chewkeanho-openwrt bootstrap [PROFILE_NAME] [IP_ADDRESS]
Unable to Proceed.
Bailing Out...

" "$NETCONTROL_COLOR_MODE"
	;;
*)
	if [ ! -d "${NETCONTROL_DIRECTORY_PROJECT}/etc/openwrt/config/${2:-}" ]; then
		NETCONTROL_interactors_libraries_os_print_error "\
Invalid Profile Directory Name ('${2:-}').
Ensure '[PROFILE_NAME]' is Pointing to a Directory Inside 'etc/openwrt/config/'.
For Example: 'main' for 'etc/config/main'.
Then Use Command: $ chewkeanho-openwrt bootstrap [PROFILE_NAME] [IP_ADDRESS]
Unable to Proceed.
Bailing Out...

" "$NETCONTROL_COLOR_MODE"
		return 1
	fi
	;;
esac




# sanitize parameters
NETCONTROL_interactor_libraries_networks_is_ip "${3:-}" > /dev/null
case $? in
0)
	NETCONTROL_interactors_libraries_os_print_info "\

Remote Device's IP:
${3:-}
" "$NETCONTROL_COLOR_MODE"
	;;
2)
	NETCONTROL_interactors_libraries_os_print_error "\
Empty Remote IP Address.
Use Command: $ chewkeanho-openwrt bootstrap [PROFILE_NAME] [IP_ADDRESS]
Unable to Proceed.
Bailing Out...

" "$NETCONTROL_COLOR_MODE"
	return 1
	;;
*)
	NETCONTROL_interactors_libraries_os_print_error "\
Invalid IP Address.
Only IPv4 or IPv6 Address is Accepted.
Unable to Proceed.
Bailing Out...

" "$NETCONTROL_COLOR_MODE"
	return 1
	;;
esac




# resetting local known host
NETCONTROL_interactors_libraries_os_print_info "\

Resetting '${3:-}' from '\${HOME}/.ssh/known_host'...
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_remove_host_from_known_host \
	"${3:-}"
if [ $? -ne 0 ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
Reset Failed.
Please Check '\${HOME}/.ssh/known_host' Validity and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	return 1
fi




# accept SSH fingerprint
NETCONTROL_interactors_libraries_os_print_info "\

Accepting '${3:-}:22' Fingerprint...
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_execute \
	"root" \
	"${3:-}" \
	"22" \
	"ls /" \
	> /dev/null
	2> /dev/null
if [ $? -ne 0 ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed.
Please Do Manual Check and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	return 1
fi




# establish ssh public key
NETCONTROL_interactors_libraries_os_print_info "\

Installing SSH Keys As 'root@${3:-}:22' Authorized Keys...
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_copy_id \
	"root" \
	"${3:-}" \
	"22"
if [ $? -ne 0 ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed.
Please Do Manual Check and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	return 1
fi


NETCONTROL_interactors_libraries_networks_ssh_execute \
	"root" \
	"${3:-}" \
	"22" \
	"mv /root/.ssh/authorized_keys /etc/dropbear/authorized_keys"
if [ $? -ne 0 ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed.
Please Do Manual Check and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	return 1
fi




# transfer all etc/config/ files to target device
for ____source in "${NETCONTROL_DIRECTORY_PROJECT}/etc/openwrt/config/${2:-}/"*; do
	if [ ! -e "$____source" ]; then
		continue
	fi

	____dest="/etc/config/${____source##*"/"}"
	NETCONTROL_interactors_libraries_os_print_info "\

Transfering '${____source}' to '${3:-}:${____dest}'...
" "$NETCONTROL_COLOR_MODE"
	NETCONTROL_interactors_libraries_networks_ssh_transfer_file \
		"root" \
		"${3:-}" \
		"22" \
		"$____source" \
		"$____dest"
	if [ $? -ne 0 ]; then
		NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed.
Please Do Manual Check and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
		unset ____source ____dest
		return 1
	fi
done
unset ____source ____dest




# set root password
NETCONTROL_interactors_libraries_os_print_info "\

Set Root Password for Target Device...
" "$NETCONTROL_COLOR_MODE"


NETCONTROL_interactors_libraries_networks_ssh_execute \
	"root" \
	"${3:-}" \
	"22" \
	"passwd"
if [ $? -ne 0 ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed.
Please Do Manual Check and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	return 1
fi




# all good - now reboot with the updated configurations
NETCONTROL_interactors_libraries_os_print_info "\

Rebooting Target Device...
" "$NETCONTROL_COLOR_MODE"


NETCONTROL_interactors_libraries_networks_ssh_execute \
	"root" \
	"${3:-}" \
	"22" \
	"reboot"
if [ $? -ne 0 ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed.
Please Do Manual Check and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	return 1
fi




# report status
NETCONTROL_interactors_libraries_os_print_info "\

Please Wait For Target Reboot and Check for New IP Address.
Then, run:
	(1) $ chewkeanho-openwrt add stubby [PROFILE_NAME] [IP_Address]
	(2) $ chewkeanho-openwrt add wpad-mbedtls [PROFILE_NAME] [IP_Address]
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_os_print_success "\

Bootstrap Completed.
" "$NETCONTROL_COLOR_MODE"
return 0
