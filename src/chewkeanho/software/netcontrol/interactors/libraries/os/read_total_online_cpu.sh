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
#	`NETCONTROL_interactors_libraries_os_read_total_online_cpu` is to get
#	the current available online CPU for data processing.
#
#	Limitations:
#		* When 'sysfs' is available, this function parse from there.
#		* Otherwise, it fallback to '/proc/cpuinfo' when available.
#		* Otherwise, it fallback to 'sysctl' control.
#		* When all else fails, it returns a hard-coded '1'.
# Parameters:
# Outputs:
#	(1) Count	The total available CPU count.
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
#	'3'
#		* means the operating system cannot execute the operation.
#	'1'
#		* bad execution.
NETCONTROL_interactors_libraries_os_read_total_online_cpu() {
	# execute
	## try sysfs when available
	if [ -r "/sys/devices/system/cpu/online" ]; then
		____runtime_count=""
		while IFS="" read -r ____line || [ -n "$____line" ]; do
			if [ "$____line" = "" ]; then
				continue
			fi

			____runtime_count="$____line"
		done < "/sys/devices/system/cpu/online"
		unset ____line

		case "$____runtime_count" in
		""|*[!0-9,-]*)
			# invalid output
			unset ____runtime_count
			;;
		*)
			____runtime_total=0
			____runtime_valid=1
			____runtime_remainder="$____runtime_count"
			while true; do
				case "$____runtime_remainder" in
				*,*)
					____runtime_item="${____runtime_remainder%%,*}"
					____runtime_remainder="${____runtime_remainder#*,}"
					;;
				*)
					____runtime_item="$____runtime_remainder"
					____runtime_remainder=""
					;;
				esac

				case "$____runtime_item" in
				*-*)
					____runtime_a="${____runtime_item%-*}"
					____runtime_b="${____runtime_item#*-}"
					;;
				*)
					____runtime_a="$____runtime_item"
					____runtime_b="$____runtime_item"
					;;
				esac

				case "$____runtime_a" in
				""|*[!0-9]*)
					____runtime_valid=0
					break
					;;
				esac

				case "$____runtime_b" in
				""|*[!0-9]*)
					____runtime_valid=0
					break
					;;
				esac

				____runtime_total="\
$(( $____runtime_total + $____runtime_b - $____runtime_a + 1 ))\
"
				if [ "$____runtime_remainder" = "" ]; then
					break
				fi
			done
			unset ____runtime_item \
				____runtime_remainder \
				____runtime_a \
				____runtime_b

			if [ "$____runtime_valid" = "1" ] && \
			[ "$____runtime_total" -gt 0 ]; then
				printf -- "%s" "$____runtime_total"
				unset ____runtime_count \
					____runtime_total \
					____runtime_valid
				return 0
			fi

			unset ____runtime_count \
				____runtime_total \
				____runtime_valid
			;;
		esac
	fi

	## try procfs when available
	if [ -r "/proc/cpuinfo" ]; then
		____runtime_count=0
		while IFS="" read -r ____line || [ -n "$____line" ]; do
			if [ "$____line" = "" ]; then
				continue
			fi

			if [ ! "${____line#"processor"}" = "$____line" ]; then
				____runtime_count=$(( $____runtime_count + 1 ))
			fi

		done < "/proc/cpuinfo"
		unset ____line

		if [ "$____runtime_count" -gt 0 ]; then
			printf -- "%s" "$____runtime_count"
			unset ____runtime_count
			return 0
		fi
		unset ____runtime_count
	fi

	## try sysctl hw.ncpu when available
	for ____runtime_command in "sysctl" \
	"/sbin/sysctl" \
	"/usr/sbin/sysctl" \
	"/usr/local/sbin/sysctl"; do
		if [ "$____runtime_command" = "sysctl" ]; then
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

		____runtime_count="$( \
			"$____runtime_command" -n hw.ncpu 2> /dev/null \
		)"
		if [ $? -eq 0 ] && [ "$____runtime_count" != "" ]; then
			printf -- "%s" "$____runtime_count"
			unset ____runtime_count ____runtime_command
			return 0
		fi
	done
	unset ____runtime_count ____runtime_command


	# report status
	printf -- "%s" "1"
	return 3
}




# report import status
return 0
