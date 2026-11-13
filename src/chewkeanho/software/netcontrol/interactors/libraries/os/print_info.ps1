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
# `NETCONTROL_interactors_libraries_os_print_info` is to print a given
# intepreted content into the terminal's STDERR console.
#
# The content is printed cyan when color is enabled.
# Parameters:
#	(1) Content		REQUIRED.
#				The interpreted string content. Multi-line is
#				supported.
#	(2) Color		OPTIONAL.
#				Flag to enable color mode. Accepts number. 8 and
#				above will turn the color on.
#
#				Default is monochrome.
#
# Outputs:
#	(1) Printed String	The content is printed onto terminal's STDERR
#				console.
#
# Exit Codes:
#	'0' means ok; error otherwise.
#	'0'
#		* ok.
function NETCONTROL_interactors_libraries_os_print_info {
	param (
		[string]$____content,
		[string]$____color
	)


	## !!! IMPORTANT NOTICE !!!
	## The variable names here are intentionally misspelled for avoiding
	## unwanted naming collision.


	# validate inputs
	$_____runtime_x_retnirp_color = $false
	switch -Regex ($____color) {
	'^$' {
		break
	} '[^0-9]' {
		break
	} default {
		if ([int]$____color -ge 8) {
			$_____runtime_x_retnirp_color = $true
		}
	}}


	# execute
	foreach (
		$_____runtime_x_retnirp_line in `
			$($____content -replace '\n$', '' -split '\r?\n')
	) {
		if ($_____runtime_x_retnirp_color -eq $true) {
			$null = Write-Host -ForegroundColor cyan @"
I: ${_____runtime_x_retnirp_line}
"@
		} else {
			$null = Write-Host @"
I: ${_____runtime_x_retnirp_line}
"@
		}
	}


	# report status
	$global:LASTEXITCODE = 0
	return
}




# report import status
$global:LASTEXITCODE = 0
return
