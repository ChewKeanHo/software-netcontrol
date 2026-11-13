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
${env:NETCONTROL_VERSION} = "0.0.1"
${env:NETCONTROL_LICENSE} = "BSD-3-Clause"




# locate NETCONTROL_DIRECTORY.
# This is already set by the scanner Start.sh.ps1 script. Hence, no additional
# work is required.
#
# If it is unset, this means the script is operating using invalid method to
# initialize so it **MUST** be failed at all time.
if ([string]::IsNullOrEmpty(${env:NETCONTROL_DIRECTORY})) {
	$null = Write-Host @"
E: '`$NETCONTROL_DIRECTORY' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
} elseif (-not (${env:NETCONTROL_DIRECTORY} -match "init\.ps1$")) {
	$null = Write-Host @"
'`$NETCONTROL_DIRECTORY' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
} elseif (-not (Test-Path -PathType Leaf -LiteralPath ${env:NETCONTROL_DIRECTORY})) {
	$null = Write-Host @"
'`$NETCONTROL_DIRECTORY' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
}




# locate the NETCONTROL_DIRECTORY_ROOT App directory
${env:NETCONTROL_DIRECTORY_ROOT} = ${env:NETCONTROL_DIRECTORY} -replace 'init\.ps1$'
${env:NETCONTROL_DIRECTORY_ROOT} = ${env:NETCONTROL_DIRECTORY_ROOT} -replace '\\$'
${env:NETCONTROL_DIRECTORY_ROOT} = ${env:NETCONTROL_DIRECTORY_ROOT} -replace 'presenters$'
${env:NETCONTROL_DIRECTORY_ROOT} = ${env:NETCONTROL_DIRECTORY_ROOT} -replace '\\$'




# import libraries
if (-not (Test-Path -PathType Leaf `
	-LiteralPath "${env:NETCONTROL_DIRECTORY_ROOT}\interactors\libraries\runtimes\load_modules.ps1" `
)) {
	$null = Write-Host @"
E: 'runtimes\load_modules' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
}

if (-not (Get-Command NETCONTROL_interactors_libraries_runtimes_load_modules `
	 -errorAction SilentlyContinue `
)) {
	$null = Write-Host @"
E: 'NETCONTROL_interactors_libraries_runtimes_load_modules' -> ?!?!  <- Dev!!!

"@
	$global:LASTEXITCODE = 1
	return
}

$null = NETCONTROL_interactors_libraries_runtimes_load_modules `
	"${env:NETCONTROL_DIRECTORY_ROOT}\entities"
$null = NETCONTROL_interactors_libraries_runtimes_load_modules `
	"${env:NETCONTROL_DIRECTORY_ROOT}\views"
$null = NETCONTROL_interactors_libraries_runtimes_load_modules `
	"${env:NETCONTROL_DIRECTORY_ROOT}\interactors"




# configure console colors
${env:NETCONTROL_COLOR_MODE} = NETCONTROL_interactors_libraries_os_read_terminal_color_mode




# save NETCONTROL_DIRECTORY_PWD current directory
${env:NETCONTROL_DIRECTORY_PWD} = (Get-Location).Path




# locate NETCONTROL_DIRECTORY_PROJECT directory
${env:NETCONTROL_DIRECTORY_PROJECT} = (Get-Location).Path
while ($true) {
	if (
		${env:NETCONTROL_DIRECTORY_PROJECT} -eq `
			[System.IO.Path]::GetPathRoot(${env:NETCONTROL_DIRECTORY_PROJECT})
	) {
		$null = NETCONTROL_interactors_libraries_os_print_error  @"
'`$NETCONTROL_DIRECTORY_PROJECT' -> ?!?!  <- Dev!!!

"@ ${env:NETCONTROL_COLOR_MODE}
		$global:LASTEXITCODE = 1
		return
	} elseif (
		Test-Path -PathType Container `
			-LiteralPath "${env:NETCONTROL_DIRECTORY_PROJECT}\.git" `
	) {
		break
	}

	${env:NETCONTROL_DIRECTORY_PROJECT} = `
		Split-Path -Parent ${env:NETCONTROL_DIRECTORY_PROJECT}
}




# execute by first parameter
switch -CaseSensitive ("$($args[1])") {
"add" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\add\start.ps1"
	$global:LASTEXITCODE = $global:LASTEXITCODE
	return
} "bootstrap" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\bootstrap\start.ps1"
	$global:LASTEXITCODE = $global:LASTEXITCODE
	return
} { $_ -in "-h", "help", "Help", "HELP" } {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\help\start.ps1"
	$global:LASTEXITCODE = 0
	return
} "license" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\license\start.ps1"
	$global:LASTEXITCODE = 0
	return
} "lock" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\lock\start.ps1"
	$global:LASTEXITCODE = 0
	return
} "remove" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\remove\start.ps1"
	$global:LASTEXITCODE = $global:LASTEXITCODE
	return
} "unlock" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\unlock\start.ps1"
	$global:LASTEXITCODE = $global:LASTEXITCODE
	return
} "version" {
	$null = . "${env:NETCONTROL_DIRECTORY_ROOT}\presenters\version\start.ps1"
	$global:LASTEXITCODE = 0
	return
} default {
	$null = NETCONTROL_interactors_libraries_os_print_error @"
'$($args[0])' => ???
"@ ${env:NETCONTROL_COLOR_MODE}
	$global:LASTEXITCODE = 1
	return
}}
