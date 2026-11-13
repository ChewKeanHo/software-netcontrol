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




# sanitize package type
case "${2:-}" in
"wpad-mbedtls")
	;;
*)
	NETCONTROL_interactors_libraries_os_print_error "\
Mismatched Package Type ('${2:-}'). Expect 'wpad-mbedtls'.
Nothing You Can Do. Contact Developer to Fix This Bug!
Unable to Proceed.
Bailing Out...

" "$NETCONTROL_COLOR_MODE"
	return 1
	;;
esac




# sanitize config directory
case "${3:-}" in
"")
	NETCONTROL_interactors_libraries_os_print_error "\
Missing Profile Directory Name.
Ensure '[PROFILE_NAME]' is Pointing to a Directory Inside 'etc/openwrt/config/'.
For Example: 'main' for 'etc/openwrt/config/main'.
Then Use Command: $ chewkeanho-openwrt remove wpad-mbedtls [PROFILE_NAME] [IP_ADDRESS]
Unable to Proceed.
Bailing Out...

" "$NETCONTROL_COLOR_MODE"
	return 1
	;;
*)
	if [ ! -d "${NETCONTROL_DIRECTORY_PROJECT}/etc/openwrt/config/${3:-}" ]; then
		NETCONTROL_interactors_libraries_os_print_error "\
Invalid Profile Directory Name ('${3:-}').
Ensure '[PROFILE_NAME]' is Pointing to a Directory Inside 'etc/openwrt/config/'.
For Example: 'main' for 'etc/config/main'.
Then Use Command: $ chewkeanho-openwrt remove wpad-mbedtls [PROFILE_NAME] [IP_ADDRESS]
Unable to Proceed.
Bailing Out...

" "$NETCONTROL_COLOR_MODE"
		return 1
	fi
	;;
esac


for ____target in \
"etc/openwrt/config/${3:-}/wireless" \
; do
	NETCONTROL_interactors_libraries_os_print_info "\
Checking '${____target}' Availability...
" "$NETCONTROL_COLOR_MODE"

	if [ ! -f "${NETCONTROL_DIRECTORY_PROJECT}/${____target}" ]; then
		NETCONTROL_interactors_libraries_os_print_error "\
Missing Configuration File.
Place the Secret File at: '${NETCONTROL_DIRECTORY_PROJECT}/${____target}'
Then Try Again.
Unable to Proceed.
Bailing Out...

" "$NETCONTROL_COLOR_MODE"
		return 1
	fi
done




# sanitize parameters
NETCONTROL_interactor_libraries_networks_is_ip "${4:-}" > /dev/null
case $? in
0)
	NETCONTROL_interactors_libraries_os_print_info "\

Remote Device's IP:
${4:-}
" "$NETCONTROL_COLOR_MODE"
	;;
2)
	NETCONTROL_interactors_libraries_os_print_error "\
Empty Remote IP Address.
Use Command: $ chewkeanho-openwrt remove wpad-mbedtls [PROFILE_NAME] [IP_ADDRESS]
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

Resetting '${4:-}' from '\${HOME}/.ssh/known_host'...
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_remove_host_from_known_host \
	"${4:-}"
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

Accepting '${4:-}:22' Fingerprint...
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_execute \
	"root" \
	"${4:-}" \
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




# update package list
NETCONTROL_interactors_libraries_os_print_info "\

Updating '${4:-}:22' Packages List..
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_execute \
	"root" \
	"${4:-}" \
	"22" \
	"apk update"
if [ $? -ne 0 ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed.
Please Do Manual Check and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	return 1
fi




# transfer wireless config
NETCONTROL_interactors_libraries_os_print_info "\

Transfer Wireless Config into '${4:-}:22'...
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_transfer_file \
	"root" \
	"${4:-}" \
	"22" \
	"${NETCONTROL_DIRECTORY_PROJECT}/etc/openwrt/config/${3:-}/wireless" \
	"/etc/config/wireless"
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




# remove wpad-basic-mbedtls package
NETCONTROL_interactors_libraries_os_print_info "\

Removing 'wpad-mbedtls' Package into '${4:-}:22'...
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_execute \
	"root" \
	"${4:-}" \
	"22" \
	"apk del wpad-mbedtls"
if [ $? -ne 0 ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed.
Please Do Manual Check and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	return 1
fi




# install wpad-mbedtls package
NETCONTROL_interactors_libraries_os_print_info "\

Installing 'wpad-basic-mbedtls' Package into '${4:-}:22'...
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_execute \
	"root" \
	"${4:-}" \
	"22" \
	"apk add wpad-basic-mbedtls"
if [ $? -ne 0 ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed.
Please Do Manual Check and Try Again.
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	return 1
fi




# restart wpad service
NETCONTROL_interactors_libraries_os_print_info "\

Restarting 'wpad' Service '${4:-}:22'...
" "$NETCONTROL_COLOR_MODE"
NETCONTROL_interactors_libraries_networks_ssh_execute \
	"root" \
	"${4:-}" \
	"22" \
	"service wpad restart"
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
NETCONTROL_interactors_libraries_os_print_success "\

Install Completed.
" "$NETCONTROL_COLOR_MODE"
return 0
