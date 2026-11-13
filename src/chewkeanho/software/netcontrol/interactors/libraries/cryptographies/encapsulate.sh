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
#	`NETCONTROL_interactors_libraries_cryptographies_encapsulate` is to
#	containerize a given payload into a standardized cryptography format for
#	storage and transit purposes. This is famously used for containerizing
#	an encrypted payload, keys, certs, etc.
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
#	Note that:
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
#				The payload data body (e.g. Base64 data). It can
#				be string or file. When it is filepath, ensures
#				its content is text-only. Use Base64 function to
#				convert any binary blob before calling this
#				function.
#
#				Otherwise, it will be treated as string. The
#				output is printed to STDOUT instead.
#	(4) Headers		OPTIONAL.
#				The list of headers (KeyN: ValueN). Can be
#				multiple values where each line is an
#				independent 'KeyN: ValueN' pair.
#
#				When multiple colons (:) is provided, the first
#				one from the left will be splitted into Key.
#	(5) HMAC Type		OPTIONAL.
#				The required HMAC Type value for rendering
#				'Method: ' header inside '[NAME] SIGNATURE'
#				block.
#
#				This function only renders the value; not
#				executing any hashing algorithm.
#
#				Error will be raised if either HMAC Type or
#				HMAC Value is missing. This only only accepts
#				both available or absent.
#	(6) HMAC Digest		OPTIONAL.
#				The required HMAC Digest value for rendering
#				the <HMAC digest> data inside '[NAME] SIGNATURE'
#				block.
#
#				This function only renders the value; not
#				executing any hashing algorithm.
#
#				Error will be raised if either HMAC Type or
#				HMAC Value is missing. This only only accepts
#				both available or absent.
# Outputs:
#	(1) Processed Output	The encapsulated output via the designated use.
#				It can be empty when any error occured.
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
#		*	means the given payload is empty or invalid (e.g. a
#			directory).
#	'7'
#		*	means the given headers are invalid (e.g. not a
#			'Key: Value' pair).
#	'8'
#		*	means the given hmac_type is missing of hmac_value and
#			vice versa.
#	'1'
#		*	means bad execution. The output path is removed during
#			cleanup if present.
NETCONTROL_interactors_libraries_cryptographies_encapsulate() {
	#____output_path="$1"
	#____name="$2"
	#____payload="$3"
	#____headers="$4"
	#____hmac_type="$5"
	#____hmac_digest="$6"


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
			return 6
		fi

		if [ -f "${3:-}" ] && [ ! -s "${3:-}" ]; then
			return 6
		fi
		;;
	esac

	while IFS="" read -r ____line || [ -n "$____line" ]; do
		case "$____line" in
		""|*": "*|*":	"*|*":"*)
			continue
			;;
		*)
			unset ____line
			return 7
			;;
		esac
	done<<EOF
${4:-}
EOF
	unset ____line

	if ( \
		([ ! "${5:-}" = "" ] && [ "${6:-}" = "" ]) || \
		([ "${5:-}" = "" ] && [ ! "${6:-}" = "" ]) \
	); then
		return 8
	fi


	# execute
	## output hash header first
	____output=""
	if [ ! "${5:-}" = "" ] && [ ! "${6:-}" = "" ]; then
		____output="\
-----BEGIN ${2:-} SIGNATURE-----
Method: ${5:-}


${6:-}
-----END ${2:-} SIGNATURE-----
"
	fi

	## output payload opener
	____output="\
${____output}-----BEGIN ${2:-}-----
"

	## output payload header
	while IFS="" read -r ____line || [ -n "$____line" ]; do
		if [ "$____line" = "" ]; then
			continue
		elif [ ! "${____line#*": "}" = "$____line" ]; then
			____output="\
${____output}${____line%%": "*}: ${____line#*": "}
"
		elif [ ! "${____line#*":	"}" = "$____line" ]; then
			____output="\
${____output}${____line%%":	"*}: ${____line#*":	"}
"
		else
			____output="\
${____output}${____line%%":"*}: ${____line#*":"}
"
		fi
	done<<EOF
${4:-}
EOF
	unset ____line

	## output payload content
	if [ ! "${1:-}" = "string" ]; then
		## file
		### create randomized temporary file for preventing symlink
		### exploitation vulnerability.
		____temp_file="$(mktemp "${1:-}.tmp.XXXXXXXX" 2> /dev/null)"
		if [ "$____temp_file" = "" ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"$____temp_file"
			unset ____output ____temp_file
			return 1
		fi

		### write existing output to file
		printf -- "%s\n\n" "$____output" > "$____temp_file"
		if [ $? -ne 0 ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"$____temp_file"
			unset ____output ____temp_file
			return 1
		fi
		unset ____output
	else
		## string
		____output="\
${____output}

"
	fi

	if [ -f "${3:-}" ]; then
		### load the content from the given payload as file
		____is_empty=true
		while IFS="" read -r ____line || [ -n "$____line" ]; do
			____is_empty=false
			if [ ! "${1:-}" = "string" ]; then
				## file
				printf -- "%s\n" "$____line" >> "$____temp_file"
				if [ $? -ne 0 ]; then
					NETCONTROL_interactors_libraries_fs_delete_node \
					"$____temp_file"
					unset ____line ____is_empty ____temp_file
					return 1
				fi
			else
				## string
				____output="\
${____output}${____line}
"
			fi
		done < "${3:-}"
		unset ____line

		if [ "$____is_empty" = "true" ]; then
			if [ ! "${1:-}" = "string" ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"$____temp_file"
			fi
			unset ____is_empty ____output ____temp_file
			return 6
		fi
		unset ____is_empty
	else
		### load the content from the given payload as string
		if [ ! "${1:-}" = "string" ]; then
			## file
			printf -- "%s\n" "${3:-}" >> "$____temp_file"
			if [ $? -ne 0 ]; then
				NETCONTROL_interactors_libraries_fs_delete_node \
					"$____temp_file"
				unset ____output ____temp_file
				return 1
			fi
		else
			## string
			____output="\
${____output}${3:-}
"
		fi
	fi

	## output payload closer
	if [ ! "${1:-}" = "string" ]; then
		printf -- "%s\n" "\
-----END ${2:-}-----" >> "$____temp_file"
		if [ $? -ne 0 ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"$____temp_file"
			unset ____temp_file
			return 1
		fi
	else
		____output="\
${____output}-----END ${2:-}-----
"
	fi

	## all good - export now
	if [ ! "${1:-}" = "string" ]; then
		sync "$____temp_file" > /dev/null 2> /dev/null
		mv -f "$____temp_file" "${1:-}"
		if [ $? -ne 0 ]; then
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${1:-}"
			NETCONTROL_interactors_libraries_fs_delete_node \
				"$____temp_file"
			unset ____temp_file
			return 1
		fi

		NETCONTROL_interactors_libraries_fs_delete_node \
			"$____temp_file"
		unset ____temp_file
	else
		printf -- "%s" "$____output"
		if [ $? -ne 0 ]; then
			unset ____output
			return 1
		fi
		unset ____output
	fi


	# report status
	return 0
}




# report import status
return 0
