#!/bin/sh
# Copyright 2026 The Automaton Project Team (https://github.com/ChewKeanHo/software-automaton)
#
# The above unified aliases have one or more actual legal entities listed
# outside of this document: (1) 'CREATORS.txt' or 'AUTHORS.txt'; and
# (2) 'CONTRIBUTORS.txt'. They are located usually placed next to this document
# in their respective project repository. Please refer to them for compiling the
# complete list accordingly.
#
#
# Zero-Clause BSD
# ===============
#
# Permission to use, copy, modify, and/or distribute this software for
# any purpose with or without fee is hereby granted.
#
# THE SOFTWARE IS PROVIDED “AS IS” AND THE AUTHOR DISCLAIMS ALL
# WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE
# FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
# DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
# AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
# OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.




# make sure we are at the right location
if [ ! -d ".internals/automaton" ]; then
	1>&2 printf -- "%s" "\
E: Are You in the Repository's Root Directory?
"
	exit 1
fi
PROJECT_DIRECTORY_ROOT="$PWD"
PROJECT_DIRECTORY_PKG="${PROJECT_DIRECTORY_ROOT}/pkg"




# all good - begin mission
VERSION="$(${PROJECT_DIRECTORY_ROOT}/bin/chewkeanho-netcontrol version)"
VERSION="${VERSION%"
"}"
printf -- "%s" "\
_______ _     _ _______  _____  _______ _______ _______  _____  __   __
|_____| |     |    |    |     | |  |  | |_____|    |    |     | | \\\\  |
|     | |_____|    |    |_____| |  |  | |     |    |    |_____| |  \\\\_|
-----------------------------------------------------------------------
"




# checking dependencies
1>&2 printf -- "%s" "\

I: Checking Dependencies Now...
"
for ____command in "tar" "zip" "gpg" "rm" "sync" "mkdir" "cp" "git"; do
	command -v "$____command" > /dev/null 2> /dev/null
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: '${____command}' = MISSING
E: Unable to Proceed.
E: Bailing Out...

"
		exit 1
	else
		1>&2 printf -- "%s" "\
I: '${____command}' = OK
"
	fi
done




# checking GPG key availability
1>&2 printf -- "%s" "\

I: Checking GPG Signing Key...
"
____can_gpg=true
gpg --list-secret-keys 49B7878749107ED9C456267ACFD3316C29873FB5 \
	> /dev/null \
	2> /dev/null
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
I: GPG Signing Is Not Possible.

"
	____can_gpg=false
fi




# remove existing output directories
1>&2 printf -- "%s" "\

I: Purging Package Workspace Now...
"
rm -rf "$PROJECT_DIRECTORY_PKG" > /dev/null 2> /dev/null
sync "$PROJECT_DIRECTORY_ROOT" > /dev/null 2> /dev/null
mkdir -p "$PROJECT_DIRECTORY_PKG"




# package the source file now
1>&2 printf -- "%s" "\

I: Packaging the Main Branch Git Repository...
"
git archive \
	--format=tar.gz \
	-o "${PROJECT_DIRECTORY_PKG}/chewkeanho_netcontrol_${VERSION}.tar.gz" \
	HEAD
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	rm -rf "$PROJECT_DIRECTORY_PKG" > /dev/null 2> /dev/null
	return 1
fi


git archive \
	--format=zip \
	-o "${PROJECT_DIRECTORY_PKG}/chewkeanho_netcontrol_${VERSION}.zip" \
	HEAD
if [ $? -ne 0 ]; then
	1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"
	rm -rf "$PROJECT_DIRECTORY_PKG" > /dev/null 2> /dev/null
	return 1
fi




# package the documentation now
for ____item in "${PROJECT_DIRECTORY_ROOT}/README.md" \
"${PROJECT_DIRECTORY_ROOT}/REFERENCES.md" \
"${PROJECT_DIRECTORY_ROOT}/CRYPTOGRAPHY.md" \
"${PROJECT_DIRECTORY_ROOT}/LICENSE.txt" \
"${PROJECT_DIRECTORY_ROOT}/CREATORS.txt" \
"${PROJECT_DIRECTORY_ROOT}/CONTRIBUTORS.txt" \
"${PROJECT_DIRECTORY_ROOT}/CITATION.cff" \
"${PROJECT_DIRECTORY_ROOT}/AI_DECREES.md" \
"${PROJECT_DIRECTORY_ROOT}/SECURITY.md"; do
	if [ ! -f "$____item" ]; then
		1>&2 printf -- "%s" "\
E: Missing Documentation Source: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"
		exit 1
	fi

	## filter all trademark banner off downstream
1>&2 printf -- "%s" "\

I: Packing '${____item}'...
"
	while IFS="" read -r ____line || [ -n "$____line" ]; do
		if [ ! "${____line%%".internals/trademarks/banner_1200x100.svg"*}" = "$____line" ]; then
			continue
		fi

		____item="${____item##*"$PROJECT_DIRECTORY_ROOT"}"
		____item="${____item="/"}"
		printf -- "%s\n" "$____line" \
			>> "${PROJECT_DIRECTORY_PKG%/}/${____item%"."*}_${VERSION}.${____item#*"."}"
		if [ $? -ne 0 ]; then
			1>&2 printf -- "%s" "\
E: Failed to Package: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"
			exit 1
		fi
	done < "$____item"
done
unset ____item




# cryptographically sign each payload
if [ "$____can_gpg" = "true" ]; then
	# signing artifacts
	for ____item in "${PROJECT_DIRECTORY_PKG}/"*; do
		if [ ! -e "$____item" ]; then
			continue
		fi

		## gpg-sign artifact item
		1>&2 printf -- "%s" "\

I: GPG-Signing '${____item}'...
"
		gpg --armor --detach-sign "$____item"
		if [ $? -ne 0 ]; then
			1>&2 printf -- "%s" "\
E: Execution Failed.
E: Failed To GPG Sign: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"
		fi
	done


	# export public key
	1>&2 printf -- "%s" "\

I: Exporting GPG Public Key to '${PROJECT_DIRECTORY_PKG}/public-key.gpg'...
"
	gpg --export 49B7878749107ED9C456267ACFD3316C29873FB5 \
		> "${PROJECT_DIRECTORY_PKG}/public-key.gpg"
	if [ $? -ne 0 ]; then
		1>&2 printf -- "%s" "\
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"
		return 1
	fi
fi




# clean up
1>&2 printf -- "%s" "\

I: Cleaning Up...
"




# report status
1>&2 printf -- "%s" "\


S: Package Successful!
"
return 0
