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
#	`NETCONTROL_interactors_responses_trademarks_get_header` is to get
#	the current header printout.
# Parameters:
#	(1) Version Number	REQUIRED.
#				The version number.
#	(2) License SPDX	REQUIRED.
#				The license SPDX tag.
# Outputs:
#	(1) Header String	The rendered header string.
# Exit Codes:
#	'0' means ok; error or mismatched otherwise.
#	'0'
#		*	means ok.
#	'2'
#		*	means any of the given input is empty.
#	'1'
#		*	means bad execution.
function NETCONTROL_interactors_responses_trademarks_get_header {
	param (
		[string]____version_number,
		[string]____license_spdx
	)


	# validate input
	if ($____version_number -eq "") {
		Write-Output ""
		$global:LASTEXITCODE = 2
		return
	}

	if ($____license_spdx -eq "") {
		Write-Output ""
		$global:LASTEXITCODE = 2
		return
	}


	# execute
	Write-Output @"
$( `
	NETCONTROL_interactors_libraries_encodings_text_read_file_with_license_header `
		"${env:NETCONTROL_DIRECTORY_ROOT}\entities\brand\trademark.txt" `
)
${____version_number} | SPDX: ${____license_spdx}
"@


	# report status
	$global:LASTEXITCODE = 0
	return
}




# report import status
return 0
