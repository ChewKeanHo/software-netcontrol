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
#	`NETCONTROL_interactors_libraries_cryptographies_decapsulate` is to
#	extract a given containerized source from a standardized cryptography
#	format back into its headers and payload data. This is famously used for
#	containerizing an encrypted payload, keys, certs, etc.
#
#	This function employs the following custom 'PGP+PEM' text-friendly
#	format designed based on OpenPGP ASCII Armor (RFC 4880 §6) wearing PEM's
#	delimiters:
#		-----BEGIN [NAME] SIGNATURE-----\n
#		Method: <HMAC type>\n
#		\n
#		\n
#		<HMAC digest>\n
#		-----END [NAME] SIGNATURE-----\n
#		-----BEGIN [NAME]-----\n
#		Key1: Value1\n
#		Key2: Value2\n
#		...
#		\n
#		\n
#		<payload data>\n
#		-----END [NAME]-----\n
#	Important Notes:
#		* The focus is based on reliable parsability line-by-line even
#			by primitive tools such as but no limited to simple
#			POSIX Shell while loop.
#		* The 'SIGNATURE' block, 'Key: Value' headers, and
#			'Payload Data' are all rendered with no cryptography
#			compute. Afterall, this is just a container format.
#		* 'SIGNATURE' block is optional but recommended.
#		* One **MUST NOT** place any secret (e.g. password or secret
#			key) inside the 'Key: Value' header.
#		* It is **STRONGLY RECOMMENDED** to use the following plain
#			extensions to avoid any conflict with existing
#			standards (e.g. PGP, PEM, PKCS, etc):
#			* `.armored`		- armored text designation
#			* `.enc`, `.encrypted`	- encrypted payload
#			* `.signed`		- signed payload
#			* `.secret`		- private file (e.g. secret key)
#			* `.public`		- public file (e.g. public key)
# Parameters:
#	(1) Output Path		REQUIRED.
#				The output filepath. Set to 'string' for STDOUT
#				instead.
#	(2) Name		REQUIRED.
#				The ASCII-ONLY UPPERCASE name for filling
#				'[NAME]' fields. Only the following characters
#				are allowed:
#					* 'A-Z'
#					* '0-9'
#					* ' '
#					* '_'
#					* '-'
#	(3) Payload		REQUIRED.
#				The payload data body containing the
#				encapsulated container. It can be string or
#				file.
#
#				Otherwise, it will be treated as string.
# Outputs:
#	(1) Processed Output	The output payload via the designated channel.
#				It can be empty when any error occured.
#
#				When 'Output Path' is set to 'string', the
#				payload is attached into the 'Headers' output as
#				the last entry under 'core|::|payload' header.
#				It is placed as the last entry for safe
#				parsing. This output is then left blank.
#	(2) Headers		The parsed headers list return to STDOUT. It can
#				be empty when any error occured.
#
#				The query is per-line loop parse with '|::|' as
#				delimiter and designating the line as Key.
#				Example, for 'Key: Value':
#					Line 1 = core|::|headers|::|Key
#					Line 2 = Value
#				After a header, the following line is value of
#				the Key as shown above.
#
#				When HMAC signature block is detected, the
#				headers should have something as such:
#					Line 1 = core|::|hmac|::|Method
#					Line 2 = Method's Value
#					Line 3 = core|::|hmac|::|Digest
#					Line 4 = Digest's Value
#				There is a possibility that either of them is
#				missing (e.g. tempered|damaged file). However,
#				this function leaves it verbatim to the caller
#				function to handle.
#
#				Exception to 'core|::|payload', any occuring
#				empty line MUST BE ignored.
#
#				The process repeat again with the next line
#				containing '|::|' pattern.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means the given output path is empty.
#	'3'
#		*	means the given output path is invalid (e.g. not a file
#			or 'string' as value).
#		*	means the given output path is already exists.
#		*	means the housing directory for the output path is
#			missing.
#	'4'
#		*	means the given name is empty.
#	'5'
#		*	means the given name is invalid (e.g. not uppercase or
#			containing illegal characters).
#	'6'
#		*	means the given payload is empty.
#	'7'
#		*	means the given payload is invalid (e.g. a directory).
#	'1'
#		*	means bad execution.
NETCONTROL_interactors_libraries_cryptographies_decapsulate() {
	#____output_path="$1"
	#____name="$2"
	#____payload="$3"


	# validate inputs
	case "${1:-}" in
	"")
		return 2
		;;
	string)
		;;
	*)
		## file
		if [ -b "${1:-}" ] ||
		[ -c "${1:-}" ] ||
		[ -d "${1:-}" ] ||
		[ -p "${1:-}" ] ||
		[ -S "${1:-}" ] ||
		[ -L "${1:-}" ] ||
		[ -f "${1:-}" ] ||
		[ -e "${1:-}" ]; then
			return 3
		elif [ ! "${1%/*}" = "${1:-}" ] &&
		[ ! "${1%/*}" = "" ] &&
		[ ! -d "${1%/*}" ]; then
			return 3
		fi
		;;
	esac

	case "${2:-}" in
	"")
		return 4
		;;
	*[!ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_\ -]*)
		return 5
		;;
	*)
		;;
	esac

	case "${3:-}" in
	"")
		return 6
		;;
	*)
		if [ -b "${3:-}" ] ||
		[ -c "${3:-}" ] ||
		[ -d "${3:-}" ] ||
		[ -p "${3:-}" ] ||
		[ -S "${3:-}" ] ||
		[ -L "${3:-}" ]; then
			return 7
		fi

		if [ -f "${3:-}" ] && [ ! -s "${3:-}" ]; then
			return 6
		fi
		;;
	esac


	# execute
	____output_headers=""
	____parse_state="hmac_opening"
	____is_empty_payload=true
	____temp_file=""

	### prepare for processing
	if [ ! "${1:-}" = "string" ]; then
		____temp_file="$( \
			mktemp "${1:-}.tmp.XXXXXXXX" 2> /dev/null \
		)"

		### create randomized temporary file for preventing
		### symlink exploitation vulnerability.
		if [ "$____temp_file" = "" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"$____temp_file"
			unset ____temp_file \
				____is_empty_payload \
				____parse_state \
				____output_headers
			return 1
		fi
	else
		____output_payload=""
	fi

	### parse payload
	if [ -f "${3:-}" ]; then
		## file
		while IFS="" read -r ____line || [ -n "$____line" ]; do
			case "$____line" in
			"-----BEGIN ${2:-} SIGNATURE-----")
				case "$____parse_state" in
				"hmac_opening")
					____parse_state="hmac_headers"
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			"-----END ${2:-} SIGNATURE-----")
				case "$____parse_state" in
				"hmac_closing"|"hmac_value")
					____parse_state="payload_opening"
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			"-----BEGIN ${2:-}-----")
				case "$____parse_state" in
				"hmac_opening"|"payload_opening")
					____parse_state="payload_headers"
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			"-----END ${2:-}-----")
				case "$____parse_state" in
				"payload_value")
					____parse_state="payload_end"
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			"")
				# newline ('\n') stripped by read
				case "$____parse_state" in
				"hmac_opening"|"payload_opening"|"payload_end")
					# invalid line - ignored
					continue
					;;
				"hmac_headers")
					# this is payload_separator_1 - so jump
					# straight to payload_separator_2
					____parse_state="hmac_separator_2"
					;;
				"hmac_separator_2")
					____parse_state="hmac_value"
					;;
				"payload_headers")
					# this is payload_separator_1 - so jump
					# straight to payload_separator_2
					____parse_state="payload_separator_2"
					;;
				"payload_separator_2")
					____parse_state="payload_value"
					;;
				"payload_value")
					____is_empty_payload=false
					if [ ! "${1:-}" = "string" ]; then
						printf -- "\n" >> "$____temp_file"
						if [ $? -ne 0 ]; then
							NETCONTROL_interactors_libraries_fs_delete_node \
								"$____temp_file"
							unset ____is_empty_payload \
								____line \
								____parse_state \
								____temp_file \
								____output_payload \
								____output_headers
							return 1
						fi
					else
						____output_payload="\
${____output_payload}
"
					fi
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			*": "*)
				case "$____parse_state" in
				"hmac_opening"|"payload_opening"|"payload_end")
					# invalid line - ignored
					continue
					;;
				"hmac_headers")
____output_headers="\
${____output_headers}core|::|hmac|::|${____line%%": "*}
${____line#*": "}
"
					;;
				"payload_headers")
____output_headers="\
${____output_headers}core|::|headers|::|${____line%%": "*}
${____line#*": "}
"
					;;
				"payload_value")
					____is_empty_payload=false
					if [ ! "${1:-}" = "string" ]; then
						printf -- "%s\n" \
							"$____line" \
							>> "$____temp_file"
						if [ $? -ne 0 ]; then
							NETCONTROL_interactors_libraries_fs_delete_node \
								"$____temp_file"
							unset ____is_empty_payload \
								____line \
								____parse_state \
								____temp_file \
								____output_payload \
								____output_headers
							return 1
						fi
					else
						____output_payload="\
${____output_payload}${____line}
"
					fi
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			*)
				case "$____parse_state" in
				"hmac_value")
					____parse_state="hmac_closing"
					____output_headers="\
${____output_headers}core|::|hmac|::|Digest
${____line}
"
					;;
				"payload_value")
					____is_empty_payload=false
					if [ ! "${1:-}" = "string" ]; then
						printf -- "%s\n" \
							"$____line" \
							>> "$____temp_file"
						if [ $? -ne 0 ]; then
							NETCONTROL_interactors_libraries_fs_delete_node \
								"$____temp_file"
							unset ____is_empty_payload \
								____line \
								____parse_state \
								____temp_file \
								____output_payload \
								____output_headers
							return 1
						fi
					else
						____output_payload="\
${____output_payload}${____line}
"
					fi
					;;
				"hmac_separator_2"|"payload_separator_2")
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				*)
					# invalid line - ignored
					;;
				esac
				;;
			esac
		done < "${3:-}"
		unset ____line
	else
		## string
		while IFS="" read -r ____line || [ -n "$____line" ]; do
			case "$____line" in
			"-----BEGIN ${2:-} SIGNATURE-----")
				case "$____parse_state" in
				"hmac_opening")
					____parse_state="hmac_headers"
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			"-----END ${2:-} SIGNATURE-----")
				case "$____parse_state" in
				"hmac_closing"|"hmac_value")
					____parse_state="payload_opening"
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			"-----BEGIN ${2:-}-----")
				case "$____parse_state" in
				"hmac_opening"|"payload_opening")
					____parse_state="payload_headers"
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			"-----END ${2:-}-----")
				case "$____parse_state" in
				"payload_value")
					____parse_state="payload_end"
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			"")
				# newline ('\n') stripped by read
				case "$____parse_state" in
				"hmac_opening"|"payload_opening"|"payload_end")
					# invalid line - ignored
					continue
					;;
				"hmac_headers")
					# this is payload_separator_1 - so jump
					# straight to payload_separator_2
					____parse_state="hmac_separator_2"
					;;
				"hmac_separator_2")
					____parse_state="hmac_value"
					;;
				"payload_headers")
					# this is payload_separator_1 - so jump
					# straight to payload_separator_2
					____parse_state="payload_separator_2"
					;;
				"payload_separator_2")
					____parse_state="payload_value"
					;;
				"payload_value")
					____is_empty_payload=false
					if [ ! "${1:-}" = "string" ]; then
						printf -- "\n" >> "$____temp_file"
						if [ $? -ne 0 ]; then
							NETCONTROL_interactors_libraries_fs_delete_node \
								"$____temp_file"
							unset ____is_empty_payload \
								____line \
								____parse_state \
								____temp_file \
								____output_payload \
								____output_headers
							return 1
						fi
					else
						____output_payload="\
${____output_payload}
"
					fi
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			*": "*)
				case "$____parse_state" in
				"hmac_opening"|"payload_opening"|"payload_end")
					# invalid line - ignored
					continue
					;;
				"hmac_headers")
____output_headers="\
${____output_headers}core|::|hmac|::|${____line%%": "*}
${____line#*": "}
"
					;;
				"payload_headers")
____output_headers="\
${____output_headers}core|::|headers|::|${____line%%": "*}
${____line#*": "}
"
					;;
				"payload_value")
					____is_empty_payload=false
					if [ ! "${1:-}" = "string" ]; then
						printf -- "%s\n" \
							"$____line" \
							>> "$____temp_file"
						if [ $? -ne 0 ]; then
							NETCONTROL_interactors_libraries_fs_delete_node \
								"$____temp_file"
							unset ____is_empty_payload \
								____line \
								____parse_state \
								____temp_file \
								____output_payload \
								____output_headers
							return 1
						fi
					else
						____output_payload="\
${____output_payload}${____line}
"
					fi
					;;
				*)
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				esac
				;;
			*)
				case "$____parse_state" in
				"hmac_value")
					____parse_state="hmac_closing"
					____output_headers="\
${____output_headers}core|::|hmac|::|Digest
${____line}
"
					;;
				"payload_value")
					____is_empty_payload=false
					if [ ! "${1:-}" = "string" ]; then
						printf -- "%s\n" \
							"$____line" \
							>> "$____temp_file"
						if [ $? -ne 0 ]; then
							NETCONTROL_interactors_libraries_fs_delete_node \
								"$____temp_file"
							unset ____is_empty_payload \
								____line \
								____parse_state \
								____temp_file \
								____output_payload \
								____output_headers
							return 1
						fi
					else
						____output_payload="\
${____output_payload}${____line}
"
					fi
					;;
				"hmac_separator_2"|"payload_separator_2")
					# format error - exit
					NETCONTROL_interactors_libraries_fs_delete_node \
						"$____temp_file"
					unset ____is_empty_payload \
						____line \
						____parse_state \
						____temp_file \
						____output_payload \
						____output_headers
					return 1
					;;
				*)
					# invalid line - ignored
					;;
				esac
				;;
			esac
		done <<EOF
${3:-}
EOF
		unset ____line
	fi

	if [ "$____parse_state" != "payload_end" ]; then
		# format error - exit
		if [ -f "$____temp_file" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"$____temp_file"
		fi

		unset ____is_empty_payload \
			____parse_state \
			____temp_file \
			____output_payload \
			____output_headers

		return 1
	fi
	unset ____parse_state

	if [ "$____is_empty_payload" = "true" ]; then
		# format error - exit
		NETCONTROL_interactors_libraries_fs_delete_node \
			"$____temp_file"
		unset ____is_empty_payload \
			____temp_file \
			____output_payload \
			____output_headers
		return 1
	fi
	unset ____is_empty_payload

	## all good - export now
	if [ ! "${1:-}" = "string" ]; then
		## file
		sync "$____temp_file" > /dev/null 2> /dev/null
		mv -f "$____temp_file" "${1:-}"
		if [ $? -ne 0 ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}"
			NETCONTROL_interactors_libraries_fs_delete_node \
				"$____temp_file"
			unset ____temp_file ____output_headers
			return 1
		fi
		rm -f "$____temp_file" > /dev/null 2> /dev/null
		sync "$____temp_file" > /dev/null 2> /dev/null
		unset ____temp_file

		printf -- "%s" "\
${____output_headers}
"
		if [ $? -ne 0 ]; then
			unset ____output_headers
			return 1
		fi
		unset ____output_headers
	else
		## string
		printf -- "%s" "\
${____output_headers}
core|::|payload
${____output_payload}"
		if [ $? -ne 0 ]; then
			unset ____output_headers \
				____output_payload \
				____temp_file
			return 1
		fi
		unset ____output_headers ____output_payload ____temp_file
	fi


	# report status
	return 0
}




# report import status
return 0
