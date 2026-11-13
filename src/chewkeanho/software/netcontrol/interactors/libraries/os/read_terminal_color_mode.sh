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
# `NETCONTROL_interactors_libraries_os_read_terminal_color_mode` is to get the
# current terminal console's color mode in bit size.
# Parameters:
# Outputs:
#	(1) Color Depth (number)	The color bits of the current terminal.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
NETCONTROL_interactors_libraries_os_read_terminal_color_mode() {
	# execute
	## try parse from $COLORTERM environment variable.
	case "${COLORTERM:-}" in
	truecolor|24bit|24-bit)
		printf -- "%s" 24
		return 0
		;;
	*)
		;;
	esac

	## try parse from tput command when available
	for ____runtime_command in "tput" \
	"/bin/tput" \
	"/usr/bin/tput" \
	"/usr/local/bin/tput"; do
		if [ "$____runtime_command" = "tput" ]; then
			command -v "$____runtime_command" \
				> /dev/null \
				2> /dev/null
			if [ $? -ne 0 ]; then
				continue
			fi
		else
			if [ ! -x "$____runtime_command" ]; then
				continue
			fi
		fi

		____runtime_color_count="$(\
			"$____runtime_command" colors 2> /dev/null \
		)"
		case "$____runtime_color_count" in
		-1)
			printf -- "%s" "1"
			unset ____runtime_color_count
			return 0
			;;
		''|*[!0-9]*)
			# error occured - try source from others
			unset ____runtime_color_count
			;;
		*)
			if [ "$____runtime_color_count" -ge 16777216 ]; then
				printf -- "%s" "24"
				unset ____runtime_color_count
				return 0
			elif [ "$____runtime_color_count" -ge 256 ]; then
				printf -- "%s" "8"
				unset ____runtime_color_count
				return 0
			elif [ "$____runtime_color_count" -ge 16 ]; then
				printf -- "%s" "4"
				unset ____runtime_color_count
				return 0
			elif [ "$____runtime_color_count" -ge 8 ]; then
				printf -- "%s" "3"
				unset ____runtime_color_count
				return 0
			else
				# unknown - try outer sources
				unset ____runtime_color_count
			fi
			;;
		esac
	done

	## try parse from $TERM environment variable.
	case "${TERM:-}" in
	vt100)
		printf -- "%s" "1"
		;;
	*-24bit|*-direct|*-truecolor)
		printf -- "%s" "24"
		;;
	*-256color|*-256colour|*256*|*kitty*)
		printf -- "%s" "8"
		;;
	xterm-16color|*-16color|*-16colour)
		printf -- "%s" "4"
		;;
	ansi|linux|console|eterm|rxvt|screen*|tmux*|\
	xterm*|vt???*|mlterm*|putty*|mintty*|st-*)
		printf -- "%s" "4"
		;;
	*)
		printf -- "%s" "1"
		;;
	esac


	# report status
	return 0
}




# report import status
return 0
