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
if (-not (Test-Path -PathType Container -Path ".\.internals\automaton")) {
	$null = Write-Host @"
E: Are You in the Repository's Root Directory?
"@
	$global:LASTEXITCODE = 1
	return 1
}
${env:PROJECT_DIRECTORY_ROOT} = Get-Location
${env:PROJECT_DIRECTORY_PKG} = "${env:PROJECT_DIRECTORY_ROOT}\pkg"




## all good -begin mission
${env:VERSION} = [string](& "${env:PROJECT_DIRECTORY_ROOT}\bin\chewkeanho-netcontrol" version)
${env:VERSION} = ${env:VERSION} -replace "`n$", ""
$null = Write-Host @"
_______ _     _ _______  _____  _______ _______ _______  _____  __   __
|_____| |     |    |    |     | |  |  | |_____|    |    |     | | \\  |
|     | |_____|    |    |_____| |  |  | |     |    |    |_____| |  \\_|
-----------------------------------------------------------------------
"@




# checking dependencies
$null = Write-Host @"

I: Checking Dependencies Now...
"@
foreach ($____command in @("git", "gpg")) {
	if (Get-Command $____command -errorAction SilentlyContinue) {
		$null = Write-Host @"
I: '${____command}' = OK

"@
	} else {
		$null = Write-Host @"
E: '${____command}' = MISSING
E: Unable to Proceed.
E: Bailing Out...

"@
		$global:LASTEXITCODE = 1
		return 1
	}
}




# checking GPG key availability
$null = Write-Host @"

I: Checking GPG Signing Key...
"@
$____can_gpg = $true
try {
	$null = gpg --list-secret-keys 49B7878749107ED9C456267ACFD3316C29873FB5
} catch {
	# do nothing
}
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
I: GPG Signing Is Not Possible.

"@
	$____can_gpg = $false
}




# remove existing output directories
$null = Write-Host @"

I: Purging Package Workspace Now...
"@
$null  = Remove-Item -Recurse `
	-Force `
	-LiteralPath ${env:PROJECT_DIRECTORY_PKG} `
	-ErrorAction SilentlyContinue
$null = New-Item -ItemType Directory -Force -Path ${env:PROJECT_DIRECTORY_PKG}




# package the source file now
$null = Write-Host @"

I: Packaging the Main Branch Git Repository...
"@
git archive `
	--format=tar.gz `
	-o "${env:PROJECT_DIRECTORY_PKG}\chewkeanho_netcontrol_${env:VERSION}.tar.gz" `
	HEAD
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$null  = Remove-Item -Recurse `
			-Force `
			-LiteralPath "${env:PROJECT_DIRECTORY_PKG}" `
			-ErrorAction SilentlyContinue
	$global:LASTEXITCODE = 1
	return 1
}


git archive `
	--format=zip `
	-o "${env:PROJECT_DIRECTORY_PKG}\chewkeanho_netcontrol_${env:VERSION}.zip" `
	HEAD
if ($LASTEXITCODE -ne 0) {
	$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...
"@
	$null  = Remove-Item -Recurse `
			-Force `
			-LiteralPath "${env:PROJECT_DIRECTORY_PKG}" `
			-ErrorAction SilentlyContinue
	$global:LASTEXITCODE = 1
	return 1
}




# package the documentation now
foreach ($____item in @(
	"${env:PROJECT_DIRECTORY_ROOT}\README.md",
	"${env:PROJECT_DIRECTORY_ROOT}\REFERENCES.md",
	"${env:PROJECT_DIRECTORY_ROOT}\CRYPTOGRAPHY.md",
	"${env:PROJECT_DIRECTORY_ROOT}\LICENSE.txt",
	"${env:PROJECT_DIRECTORY_ROOT}\CREATORS.txt",
	"${env:PROJECT_DIRECTORY_ROOT}\CONTRIBUTORS.txt",
	"${env:PROJECT_DIRECTORY_ROOT}\CITATION.cff",
	"${env:PROJECT_DIRECTORY_ROOT}\AI_DECREES.md",
	"${env:PROJECT_DIRECTORY_ROOT}\SECURITY.md"
)) {
	if (-not (Test-Path -PathType Leaf -LiteralPath $____item)) {
		$null = Write-Host @"
E: Missing Documentation Source: '${____item}'
E: Unable to Proceed.
E: Bailing Out...

"@
		$global:LASTEXITCODE = 1
		return 1
	}

	## filter all trademark banner off downstream
	$null = Write-Host @"

I: Packing '${____item}'...
"@
	foreach($____line in Get-Content $____item) {
		if ($____line -match [regex]::Escape('.internals/trademarks/banner_1200x100.svg')) {
			continue
		}

		$____item = $____item -replace "^$([regex]::Escape(${env:PROJECT_DIRECTORY_ROOT}))", ''
		$____item = $____item -replace '^\\', ''

		$null = Add-Content -NoNewline `
			-Encoding utf8NoBOM `
			-LiteralPath "${env:PROJECT_DIRECTORY_PKG}\$($____item -replace '\.[^.]*$', '')_${env:VERSION}.$($____item -replace '^[^.]*\.', '')" `
			-Value "${____line}`n"
		if ($LASTEXITCODE -ne 0) {
			$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
			$global:LASTEXITCODE = 1
			return 1
		}
	}
}




if ($____can_gpg -eq $true) {
	# signing artifacts
	foreach ($____item in (Get-ChildItem -Path ${env:PROJECT_DIRECTORY_PKG} -File -Recurse)) {
		if (-not (Test-Path -PathType Leaf -LiteralPath $____item)) {
			continue
		}

		## gpg-sign artifact item
		$null = Write-Host @"

I: GPG-Signing '${____item}'...
"@
		gpg --armor --detach-sign $____item
		if ($LASTEXITCODE -ne 0) {
			$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
			$global:LASTEXITCODE = 1
			return 1
		}
	}


	# export public key
	$null = Write-Host @"

I: Exporting GPG Public Key to '${env:PROJECT_DIRECTORY_PKG}\public-key.gpg'...
"@
	gpg --export 49B7878749107ED9C456267ACFD3316C29873FB5 `
		> "${env:PROJECT_DIRECTORY_PKG}\public-key.gpg"
	if ($LASTEXITCODE -ne 0) {
		$null = Write-Host @"
E: Execution Failed.
E: Unable to Proceed.
E: Bailing Out...

"@
		$global:LASTEXITCODE = 1
		return 1
	}
}




# clean up
$null = Write-Host @"

I: Cleaning Up...
"@




# report status
$null = Write-Host @"


S: Package Successful!
"@



# report status
$global:LASTEXITCODE = 0
return 0
