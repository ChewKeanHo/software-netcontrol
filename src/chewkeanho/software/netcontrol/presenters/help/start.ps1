#requires -Version 5.1
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




# execute
switch -CaseSensitive ("$($args[2])") {
"add" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\add\start.ps1"
	$global:LASTEXITCODE = $global:LASTEXITCODE
	return
} "bootstrap" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\bootstrap\start.ps1"
	$global:LASTEXITCODE = $global:LASTEXITCODE
	return
} "cryptography" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\cryptography\start.ps1"
	$global:LASTEXITCODE = $global:LASTEXITCODE
	return
} "license" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\license\start.ps1"
	$global:LASTEXITCODE = 0
	return
} "lock" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\lock\start.ps1"
	$global:LASTEXITCODE = 0
	return
} "package" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\package\start.ps1"
	$global:LASTEXITCODE = $global:LASTEXITCODE
	return
} "remove" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\remove\start.ps1"
	$global:LASTEXITCODE = $global:LASTEXITCODE
	return
} "unlock" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\unlock\start.ps1"
	$global:LASTEXITCODE = 0
	return
} "version" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\version\start.ps1"
	$global:LASTEXITCODE = 0
	return
} default {
	$null = NETCONTROL_interactors_libraries_os_print_info @"
$( `
	NETCONTROL_interactors_responses_trademarks_get_header `
		"${env:NETCONTROL_VERSION}" `
		"${env:NETCONTROL_LICENSE}" `
)
$( `
	NETCONTROL_interactors_libraries_encodings_text_read_file_with_license_header `
		"${env:NETCONTROL_DIRECTORY_ROOT}\entities\i18n\help\en.txt" `
)

NETCONTROL_DIRECTORY_PWD:
${env:NETCONTROL_DIRECTORY_PWD}

NETCONTROL_DIRECTORY_PROJECT:
${env:NETCONTROL_DIRECTORY_PROJECT}

NETCONTROL_DIRECTORY_ROOT:
${env:NETCONTROL_DIRECTORY_ROOT}

NETCONTROL_COLOR_MODE:
${env:NETCONTROL_COLOR_MODE}
"@ ${env:NETCONTROL_COLOR_MODE}
	$global:LASTEXITCODE = 0
	return
}}
