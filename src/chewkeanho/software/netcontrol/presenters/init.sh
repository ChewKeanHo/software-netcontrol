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
NETCONTROL_VERSION="0.0.1"
NETCONTROL_LICENSE="BSD-3-Clause"




# locate NETCONTROL_DIRECTORY.
# This is already set by the scanner Start.sh.ps1 script. Hence, no additional
# work is required.
#
# If it is unset, this means the script is operating using invalid method to
# initialize so it **MUST** be failed at all time.
if [ "$NETCONTROL_DIRECTORY" = "" ]; then
	1>&2 printf -- "%s" "\
E: '\$NETCONTROL_DIRECTORY' -> ?!?!  <- Dev!!!

"
	return 1
elif [ "${NETCONTROL_DIRECTORY%"init.sh"}" = "$NETCONTROL_DIRECTORY" ]; then
	1>&2 printf -- "%s" "\
E: '\$NETCONTROL_DIRECTORY' -> ?!?!  <- Dev!!!

"
	return 1
elif [ ! -f "$NETCONTROL_DIRECTORY" ]; then
	1>&2 printf -- "%s" "\
E: '\$NETCONTROL_DIRECTORY' -> ?!?!  <- Dev!!!

"
	return 1
fi




# locate the NETCONTROL_DIRECTORY_ROOT App directory
NETCONTROL_DIRECTORY_ROOT="${NETCONTROL_DIRECTORY%"init.sh"}"
NETCONTROL_DIRECTORY_ROOT="${NETCONTROL_DIRECTORY_ROOT%"/"}"
NETCONTROL_DIRECTORY_ROOT="${NETCONTROL_DIRECTORY_ROOT%"presenters"}"
NETCONTROL_DIRECTORY_ROOT="${NETCONTROL_DIRECTORY_ROOT%"/"}"




# import libraries
if [ ! -f "${NETCONTROL_DIRECTORY_ROOT}/interactors/libraries/runtimes/load_modules.sh" ]; then
	1>&2 printf -- "%s" "\
E: 'runtimes/load_modules' -> ?!?!  <- Dev!!!

"
	return 1
fi

. "${NETCONTROL_DIRECTORY_ROOT}/interactors/libraries/runtimes/load_modules.sh"
command -v NETCONTROL_interactors_libraries_runtimes_load_modules \
	> /dev/null \
	2> /dev/null
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: 'NETCONTROL_interactors_libraries_runtimes_load_modules' -> ?!?!  <- Dev!!!

"
	return 1
fi

NETCONTROL_interactors_libraries_runtimes_load_modules \
	"${NETCONTROL_DIRECTORY_ROOT}/entities"
NETCONTROL_interactors_libraries_runtimes_load_modules \
	"${NETCONTROL_DIRECTORY_ROOT}/views"
NETCONTROL_interactors_libraries_runtimes_load_modules \
	"${NETCONTROL_DIRECTORY_ROOT}/interactors"




# configure console colors
NETCONTROL_COLOR_MODE="$( \
	NETCONTROL_interactors_libraries_os_read_terminal_color_mode \
)"




# save NETCONTROL_DIRECTORY_PWD current directory
NETCONTROL_DIRECTORY_PWD="$PWD"




# locate NETCONTROL_DIRECTORY_PROJECT directory
NETCONTROL_DIRECTORY_PROJECT="$PWD"
while true; do
	if [ "$NETCONTROL_DIRECTORY_PROJECT" = "/" ]; then
		NETCONTROL_interactors_libraries_os_print_error "\
'\$NETCONTROL_DIRECTORY_PROJECT' -> ?!?!  <- Dev!!!

" "$NETCONTROL_COLOR_MODE"
		return 1
	elif [ -d "${NETCONTROL_DIRECTORY_PROJECT}/.git" ]; then
		break
	fi

	NETCONTROL_DIRECTORY_PROJECT="${NETCONTROL_DIRECTORY_PROJECT%/*}"
done




# execute by first parameter
case "${1:-}" in
add)
	. "${NETCONTROL_DIRECTORY_ROOT}/presenters/add/start.sh"
	return $?
	;;
bootstrap)
	. "${NETCONTROL_DIRECTORY_ROOT}/presenters/bootstrap/start.sh"
	return $?
	;;
-h|help|Help|HELP)
	. "${NETCONTROL_DIRECTORY_ROOT}/presenters/help/start.sh"
	return 0
	;;
license)
	. "${NETCONTROL_DIRECTORY_ROOT}/presenters/license/start.sh"
	return 0
	;;
lock)
	. "${NETCONTROL_DIRECTORY_ROOT}/presenters/lock/start.sh"
	return $?
	;;
remove)
	. "${NETCONTROL_DIRECTORY_ROOT}/presenters/remove/start.sh"
	return $?
	;;
unlock)
	. "${NETCONTROL_DIRECTORY_ROOT}/presenters/unlock/start.sh"
	return $?
	;;
version)
	. "${NETCONTROL_DIRECTORY_ROOT}/presenters/version/start.sh"
	return 0
	;;
*)
	NETCONTROL_interactors_libraries_os_print_error "\
'${1:-}' => ???
" "$NETCONTROL_COLOR_MODE"
	return 1
	;;
esac
