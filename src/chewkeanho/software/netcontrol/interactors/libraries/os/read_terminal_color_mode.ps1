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
function NETCONTROL_interactors_libraries_os_read_terminal_color_mode {
	# execute
	## try parse from $COLORTERM environment variable.
	if (${env:COLORTERM} -in 'truecolor', '24bit', '24-bit') {
		$global:LASTEXITCODE = 0
		return '24'
	}

	## try prse from WT_SESSION environment variable.
	if (-not [string]::IsNullOrEmpty(${env:WT_SESSION})) {
		$global:LASTEXITCODE = 0
		return '24'
	}

	## try parse from VS code integrated terminal.
	if (${env:ConEmuANSI} -eq "ON") {
		$global:LASTEXITCODE = 0
		return '24'
	}

	## try prase from ANSI shim for legacy console.
	if (-not [string]::IsNullOrEmpty(${env:ANSICON})) {
		$global:LASTEXITCODE = 0
		return '4'
	}

	## try parse from $TERM environment variable.
	switch -Regex (${env:TERM}) {
	'24bit|truecolor|direct' {
		$global:LASTEXITCODE = 0
		return '24'
	} '256color' {
		$global:LASTEXITCODE = 0
		return '8'
	} 'dumb' {
		$global:LASTEXITCODE = 0
		return '1'
	} default {
		$global:LASTEXITCODE = 0
		return '1'
	}}


	# report status
	$global:LASTEXITCODE = 0
	return 0
}




# report import status
$global:LASTEXITCODE = 0
return
