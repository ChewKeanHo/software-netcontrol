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
NETCONTROL_interactors_libraries_os_print_info "\
$( \
	NETCONTROL_interactors_responses_trademarks_get_header \
		"$NETCONTROL_VERSION" \
		"$NETCONTROL_LICENSE" \
)

NETCONTROL_DIRECTORY_PWD:
${NETCONTROL_DIRECTORY_PWD}

NETCONTROL_DIRECTORY_PROJECT:
${NETCONTROL_DIRECTORY_PROJECT}

NETCONTROL_DIRECTORY_ROOT:
${NETCONTROL_DIRECTORY_ROOT}

NETCONTROL_COLOR_MODE:
${NETCONTROL_COLOR_MODE}
_________________________________________________________________________
Begin Data Module Unlocking Pipeline...

" "$NETCONTROL_COLOR_MODE"




# check _target
_target="${NETCONTROL_DIRECTORY_PROJECT}/etc"
NETCONTROL_interactors_libraries_os_print_info "\
Checking '${_target}'...
" "$NETCONTROL_COLOR_MODE"

if [ -d "$_target" ]; then
	NETCONTROL_interactors_libraries_os_print_error "\
There Is An Existing Opened Data Module (${_target}).
Please Lock and Archive It First Before Unlocking A New One.
Ensure '${_target}' Is Removed.
Cannot Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	unset _target
	return 1
fi




# check _source
NETCONTROL_interactors_libraries_os_print_info "\
Checking '${2:-}'...
" "$NETCONTROL_COLOR_MODE"

case "${2:-}" in
"")
	NETCONTROL_interactors_libraries_os_print_error "\
Please Provide An Locked Data Module File (e.g. 'network-data.tar.xz.enc').
Command: $ chewkeanho-openwrt unlock [FILENAME]
Cannot Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	unset _target
	return 1
	;;
*"/"*)
	NETCONTROL_interactors_libraries_os_print_error "\
Please Place the Locked Data Module File inside the Repository.
Then Please Provide Only The Filename (e.g. '${2##*/}').
Cannot Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	unset _target
	return 1
	;;
*)
	case "${2:-}" in
	*.tar.xz.enc)
		;;
	*)
		NETCONTROL_interactors_libraries_os_print_error "\
Please Ensure the Locked Data Module File Has '.tar.xz.enc' File Extension.
Example: '${2%%.*}.tar.xz.enc'
Then Try Again with the Corrected Filename:
	$ chewkeanho-openwrt unlock '${2%%.*}.tar.xz.enc'
Cannot Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
		unset _target
		return 1
		;;
	esac

	for __path in \
	"${NETCONTROL_DIRECTORY_PROJECT}/${2%.enc}" \
	"${NETCONTROL_DIRECTORY_PROJECT}/${2%.xz.enc}" \
	"${NETCONTROL_DIRECTORY_PROJECT}/${2%.tar.xz.enc}" \
	; do
		if [ -f "$__path" ]; then
			NETCONTROL_interactors_libraries_os_print_error "\
There Is An Existing Node: ${__path}
Please Archive or Remove It For Freeing the Path To Use.
Cannot Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
			unset _target __path
			return 1
		fi
	done
	unset __path
	;;
esac
_source="${NETCONTROL_DIRECTORY_PROJECT}/${2:-}"




# setup trap to prevent any data leak
__bail_out_cleanup_filepath="${_source%".tar.xz.enc"}"
__bail_out_cleanup() {
	case "${1:-}" in
	success)
		NETCONTROL_interactors_libraries_os_print_success "\
Wiping All Sensitive Runtime Data and Artifacts Before Exiting...
" "$NETCONTROL_COLOR_MODE"
		;;
	*)
		NETCONTROL_interactors_libraries_os_print_info "\
Wiping All Sensitive Runtime Data and Artifacts Before Exiting...
" "$NETCONTROL_COLOR_MODE"
		;;
	esac

	if [ ! "$__bail_out_cleanup_filepath" = "" ]; then
		for __extension in ".tar" ".tar.xz"; do
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${__bail_out_cleanup_filepath}${__extension}"
		done

		case "${1:-}" in
		success)
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${__bail_out_cleanup_filepath}.tar.xz.enc"
			;;
		*)
			NETCONTROL_interactors_libraries_fs_delete_node \
				"${__bail_out_cleanup_filepath%/*}/etc" \
				"true"
			;;
		esac

		sync "$NETCONTROL_DIRECTORY_PROJECT" > /dev/null 2> /dev/null
	fi

	unset ___path \
		_target \
		_source \
		__bail_out_cleanup_filepath \
		__bail_out_cleanup \
		_passphrase \
		_passphrase_confirm \
		__output \
		__position \
		__start_over \
		__line \
		_process

	case "${1:-}" in
	success)
		exit 0
		;;
	*)
		exit 1
		;;
	esac
}
trap '__bail_out_cleanup' INT TERM HUP




# request passphrase for decryption
while true; do
	## get passphrase from user
	NETCONTROL_interactors_libraries_os_print_info "\
Please Enter A Strong Passphrase:
	* Minimum characters: 32
	* Must have at least one(1) 'A-Z'
	* Must have at least one(1) 'a-z'
	* Must have at least one(1) '0-9'
	* Must have at least one(1) '#$%&@^\`~/\\|_-'
	* Use A Password Bank (e.g. KeepassXC) to Create One Easily.
	* Type 'cancel' to Bail Out.
	* The prompt will not print anything. Press ENTER once you are done.
" "$NETCONTROL_COLOR_MODE"
	_passphrase=""
	_passphrase="$( \
		NETCONTROL_interactors_libraries_cryptographies_read_password_from_terminal \
	)"
	case "$_passphrase" in
	"")
		unset _passphrase
		NETCONTROL_interactors_libraries_os_print_error "\
Empty Passphrase!
" "$NETCONTROL_COLOR_MODE"
		continue
		;;
	cancel)
		NETCONTROL_interactors_libraries_os_print_error "\
Aborting...
" "$NETCONTROL_COLOR_MODE"
		NETCONTROL_interactors_libraries_fs_delete_node "$_target"
		__bail_out_cleanup
		return 2
		;;
	*)
		;;
	esac


	## get passphrase confirmation from user
	NETCONTROL_interactors_libraries_os_print_info "\
Confirm Passphrase:
" "$NETCONTROL_COLOR_MODE"
	_passphrase_confirm=""
	_passphrase_confirm="$( \
		NETCONTROL_interactors_libraries_cryptographies_read_password_from_terminal \
	)"
	if [ ! "$_passphrase" = "$_passphrase_confirm" ]; then
		unset _passphrase _passphrase_confirm
		NETCONTROL_interactors_libraries_os_print_error "\
Passphrase Mismatched!
" "$NETCONTROL_COLOR_MODE"
		continue
	fi
	unset _passphrase_confirm


	## check passphrase quality
	__output="$( \
		NETCONTROL_interactors_libraries_cryptographies_is_password_compliant \
			"$_passphrase" \
			"32" \
			"1|::|abcdefghijklmnopqrstuvwxyz" \
			"1|::|ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
			"1|::|0123456789" \
			"1|::|#$%\\\&@^\\\`~\\\\/\\|_-]"
	)"
	if [ "$__output" = "" ]; then
		NETCONTROL_interactors_libraries_os_print_error "\
Unable to Process This Password. Make A New One!
" "$NETCONTROL_COLOR_MODE"
		unset __output _passphrase
		continue
	fi

	__position=0
	__start_over=false
	while IFS="" read -r __line || [ -n "$__line" ]; do
		__position="$(( $__position + 1 ))"
		case "$__line" in
		""|0)
			continue
			;;
		*)
			__start_over=true
			unset _passphrase
			case "$__position" in
			1)
				NETCONTROL_interactors_libraries_os_print_error "\
Password Too Short (Minimum 32 Characters)!
" "$NETCONTROL_COLOR_MODE"
				;;
			2)
				NETCONTROL_interactors_libraries_os_print_error "\
Password Does Not Contain 'a-z' (Minimum 1 Character)!
" "$NETCONTROL_COLOR_MODE"
				;;
			3)
				NETCONTROL_interactors_libraries_os_print_error "\
Password Does Not Contain 'A-Z' (Minimum 1 Character)!
" "$NETCONTROL_COLOR_MODE"
				;;
			4)
				NETCONTROL_interactors_libraries_os_print_error "\
Password Does Not Contain '0-9' (Minimum 1 Character)!
" "$NETCONTROL_COLOR_MODE"
				;;
			5)
				NETCONTROL_interactors_libraries_os_print_error "\
Password Does Not Contain '#$%&@^\`~/\\|_-' (Minimum 1 Character)!
" "$NETCONTROL_COLOR_MODE"
				;;
			*)
				NETCONTROL_interactors_libraries_os_print_error "\
Unable to Process This Password. Make A New One!
" "$NETCONTROL_COLOR_MODE"
				;;
			esac
			;;
		esac
	done<<EOF
${__output}
EOF
	unset __line __position __output

	if [ "$__start_over" = "true" ]; then
		unset __start_over
		continue
	fi
	unset __start_over


	## we arrived here at the end of the happy path - move on
	break
done




# decrypt the payload
NETCONTROL_interactors_libraries_os_print_info "\
Decrypting '${_source}'...
" "$NETCONTROL_COLOR_MODE"

NETCONTROL_interactors_libraries_cryptographies_openssl_decrypt_using_passphrase \
	"$_source" \
	"$_passphrase"
_process=$?
if [ $_process -ne 0 ]; then
	NETCONTROL_interactors_libraries_fs_delete_node "${_source%.enc}"
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed (${_process}).
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	__bail_out_cleanup
	return 1
fi
unset _process _passphrase


NETCONTROL_interactors_libraries_os_print_info "\
Verifying '${_source%.enc}'...
" "$NETCONTROL_COLOR_MODE"

NETCONTROL_interactors_libraries_compress_xz_read "${_source%.enc}"
_process=$?
if [ $_process -ne 0 ]; then
	NETCONTROL_interactors_libraries_fs_delete_node "${_source%.enc}"
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed (${_process}).
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	__bail_out_cleanup
	return 1
fi
unset _process




# decompressing archive file
_source="${_source%.enc}"
NETCONTROL_interactors_libraries_os_print_info "\
Decompressing '${_source}'...
" "$NETCONTROL_COLOR_MODE"

NETCONTROL_interactors_libraries_compress_xz_decompress \
	"${_source%.xz}" \
	"$_source"
_process=$?
if [ $_process -ne 0 ]; then
	NETCONTROL_interactors_libraries_fs_delete_node "${_source%.xz}"
	NETCONTROL_interactors_libraries_fs_delete_node "$_source"
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed (${_process}).
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	__bail_out_cleanup
	return 1
fi
unset _process


NETCONTROL_interactors_libraries_os_print_info "\
Verifying '${_source%.xz}'...
" "$NETCONTROL_COLOR_MODE"

NETCONTROL_interactors_libraries_archive_tar_read "${_source%.xz}"
_process=$?
if [ $_process -ne 0 ]; then
	NETCONTROL_interactors_libraries_fs_delete_node "${_source%.xz}"
	NETCONTROL_interactors_libraries_fs_delete_node "$_source"
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed (${_process}).
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	__bail_out_cleanup
	return 1
fi
unset _process


NETCONTROL_interactors_libraries_os_print_info "\
Removing '$_source'...
" "$NETCONTROL_COLOR_MODE"

NETCONTROL_interactors_libraries_fs_delete_node "$_source"
_process=$?
if [ $_process -ne 0 ]; then
	NETCONTROL_interactors_libraries_fs_delete_node "${_source%.xz}"
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed (${_process}).
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	__bail_out_cleanup
	return 1
fi
unset _process




# create output directory
_source="${_source%.xz}"
NETCONTROL_interactors_libraries_os_print_info "\
Creating '${_target}'...
" "$NETCONTROL_COLOR_MODE"

mkdir -p "$_target" > /dev/null 2> /dev/null
_process=$?
if [ $_process -ne 0 ]; then
	NETCONTROL_interactors_libraries_fs_delete_node "$_source"
	NETCONTROL_interactors_libraries_fs_delete_node "$_target" "true"
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed (${_process}).
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	__bail_out_cleanup
	return 1
fi




## unpack output directory
NETCONTROL_interactors_libraries_os_print_info "\
Unpacking '${_source}'...
" "$NETCONTROL_COLOR_MODE"

NETCONTROL_interactors_libraries_archive_tar_unpack "$_target" "$_source"
_process=$?
if [ $_process -ne 0 ]; then
	NETCONTROL_interactors_libraries_fs_delete_node "$_source"
	NETCONTROL_interactors_libraries_fs_delete_node "$_target" "true"
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed (${_process}).
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	__bail_out_cleanup
	return 1
fi
unset _process


NETCONTROL_interactors_libraries_os_print_info "\
Removing '$_source'...
" "$NETCONTROL_COLOR_MODE"

NETCONTROL_interactors_libraries_fs_delete_node "$_source"
_process=$?
if [ $_process -ne 0 ]; then
	NETCONTROL_interactors_libraries_fs_delete_node "$_target" "true"
	NETCONTROL_interactors_libraries_os_print_error "\
Execution Failed (${_process}).
Unable to Proceed.
Bailing Out...
" "$NETCONTROL_COLOR_MODE"
	__bail_out_cleanup
	return 1
fi
unset _process




## all good - clean up artifacts
NETCONTROL_interactors_libraries_os_print_info "\
Cleaning Up...
" "$NETCONTROL_COLOR_MODE"

NETCONTROL_interactors_libraries_fs_delete_node "$_source"
NETCONTROL_interactors_libraries_fs_delete_node "${_source}.xz"
NETCONTROL_interactors_libraries_fs_delete_node "${_source}.xz.enc"
unset _source




# report status
NETCONTROL_interactors_libraries_os_print_success "\
SUCCESS!
  -> ${_target}
" "$NETCONTROL_COLOR_MODE"
__bail_out_cleanup "success"
return 0
