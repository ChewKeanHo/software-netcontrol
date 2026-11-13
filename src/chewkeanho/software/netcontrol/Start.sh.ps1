echo \" <<'RUN_AS_BATCH' >/dev/null ">NUL "\" \`" <#"
@ECHO OFF
REM ----------------------------------------------------------------------------
REM Copyright 2026 The (Holloway) Chew, Kean Ho's NetControl Project Team (https://github.com/ChewKeanHo/software-netcontrol)
REM
REM The above unified aliases have one or more actual legal entities listed
REM outside of this document: (1) 'CREATORS.txt' or 'AUTHORS.txt'; and (2)
REM 'CONTRIBUTORS.txt'. They are usually placed next to this document in their
REM respective project repository. Please refer to them for compiling the complete
REM list accordingly.
REM
REM
REM Redistribution and use in source and binary forms, with or without
REM modification, are permitted provided that the following conditions are met:
REM
REM 1. Redistributions of source code must retain the above copyright notice,
REM    this list of conditions and the following disclaimer.
REM
REM 2. Redistributions in binary form must reproduce the above copyright notice,
REM    this list of conditions and the following disclaimer in the documentation
REM    and/or other materials provided with the distribution.
REM
REM 3. Neither the name of the copyright holder nor the names of its
REM    contributors may be used to endorse or promote products derived from this
REM    software without specific prior written permission.
REM
REM THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
REM AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
REM IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
REM ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
REM LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
REM CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
REM SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
REM INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
REM CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
REM ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
REM POSSIBILITY OF SUCH DAMAGE.
REM ----------------------------------------------------------------------------




REM ############################################################################
REM # Windows BATCH Codes                                                      #
REM ############################################################################
SETLOCAL enabledelayedexpansion




REM configure
WHERE powershell >nul 2>&1
IF %ERRORLEVEL% neq 0 (
        ECHO E: PowerShell -> ???
        EXIT /b 1
)
SET "base_name=%~n0"
SET "source_file=%~f0"
SET "destination_file=%~dp0%base_name%.sh.ps1"




REM execute
IF exist "%destination_file%" GOTO :run_ps1
COPY /y "%source_file%" "%destination_file%" >nul
IF %ERRORLEVEL% neq 0 (
    ECHO E: Failed to create %destination_file%.
    EXIT /b 1
)


:run_ps1
powershell -NoProfile -ExecutionPolicy RemoteSigned -File "%destination_file%" %*
set "EXIT_CODE=!ERRORLEVEL!"

IF EXIST "%source_file%" (
        START /B "" cmd /c DEL "%source_file%" >nul 2>&1
)

EXIT /B %EXIT_CODE%
REM ############################################################################
REM # Windows BATCH Codes                                                      #
REM ############################################################################
EXIT /b 1
RUN_AS_BATCH
#> | Out-Null




echo \" <<'RUN_AS_POWERSHELL' >/dev/null # " | Out-Null
################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
# IMPORTANT NOTICE
# 1. Downstream ${____init_file} **MUST STRICTLY** 'return 0' (number 0) to
#    indicate a successful happy path. Anything else including missing is
#    failed.




# configure
${____init_file} = "init.ps1"
${____init_directory} ="chewkeanho\software\netcontrol\presenters"

${____init_package_name} = "ChewKeanHo-NetControl"




# scan
# Current directory - user-customized application
${env:NETCONTROL_DIRECTORY} = "$(Get-Location)\.internals\chewkeanho-netcontrol\presenters\${____init_file}"
if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native User Rootless Software Directory
        ${env:NETCONTROL_DIRECTORY} = "$(Get-Location)\lib\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native User Rootless Software Directory
        ${env:NETCONTROL_DIRECTORY} = "$(Get-Location)\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native User Rootless Software Directory
        ${env:NETCONTROL_DIRECTORY} = "$(Get-Location)\presenters\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native User Rootless Software Directory
        ${env:NETCONTROL_DIRECTORY} = "${env:LOCALAPPDATA}\Programs\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native User Chocolatey Software Directory
        ${env:NETCONTROL_DIRECTORY} = "${env:CHOCOLATEYINSTALL}\lib\${____init_package_name}\tools\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native User Scoop Custom Software Directory
        ${env:NETCONTROL_DIRECTORY} = "${env:SCOOP}\apps\${____init_package_name}\current\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native OS Chocolatey Software Directory
        ${env:NETCONTROL_DIRECTORY} = "${env:PROGRAMDATA}\chocolatey\lib\${____init_package_name}\tools\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native User Scoop Software Directory
        ${env:NETCONTROL_DIRECTORY} = "${env:USERPROFILE}\scoop\apps\${____init_package_name}\current\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native OS Scoop Software Directory
        ${env:NETCONTROL_DIRECTORY} = "${env:SCOOP_GLOBAL}\apps\${____init_package_name}\current\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native OS Program Files
        ${env:NETCONTROL_DIRECTORY} = "${env:PROGRAMFILES}\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        # Native OS Program Files (x86)
        ${env:NETCONTROL_DIRECTORY} = "${env:PROGRAMFILES(x86)}\${____init_directory}\${____init_file}"
}

if (-not (Test-Path ${env:NETCONTROL_DIRECTORY})) {
        Write-Error @"
E: Failed to Locate Init File. Bailing Out...

"@
        exit 1
}




# execute
$____process = . ${env:NETCONTROL_DIRECTORY} @args
if ($____process -eq "0") {
        exit 0
}
################################################################################
# Windows POWERSHELL Codes                                                     #
################################################################################
exit 1
<#
RUN_AS_POWERSHELL




################################################################################
# Unix Main Codes                                                              #
################################################################################
# configure
____init_file="init.sh"
____init_directory="chewkeanho/software/netcontrol/presenters"

____init_package_name="ChewKeanHo-NetControl"

____init_macos_bundle_name="${____init_package_name}.app"
____init_macos_directory="chewkeanho"




# scan
# Native User Current Directory - User-Customized Application
NETCONTROL_DIRECTORY="${PWD%/}/.internals/chewkeanho-netcontrol/presenters/${____init_file}"
if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        NETCONTROL_DIRECTORY="${PWD%/}/lib/${____init_directory}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        NETCONTROL_DIRECTORY="${PWD%/}/${____init_directory}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        NETCONTROL_DIRECTORY="${PWD%/}/presenters/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        # Native User - Linux 2nd-Generation Package
        if ([ -d "/app" ] && [ -f "/.flatpak-info" ]); then
                # Flatpak
                NETCONTROL_DIRECTORY="/app/${____init_directory%/}/${____init_file}"
        elif [ ! "$APPDIR" = "" ]; then
                # AppImage
                NETCONTROL_DIRECTORY="${APPDIR%/}/${____init_directory%/}/${____init_file}"
        elif [ ! "$SNAP" = "" ]; then
                # Snapcraft
                NETCONTROL_DIRECTORY="${SNAP%/}/${____init_directory%/}/${____init_file}"
        fi
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        # Native User Rootless Local Directory
        NETCONTROL_DIRECTORY="${HOME%/}/.local/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        # Homebrew (Apple Silicon MacOS)
        NETCONTROL_DIRECTORY="/opt/homebrew/${____init_directory}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        # Linuxbrew (Homebrew on Linux)
        NETCONTROL_DIRECTORY="/home/linuxbrew/.linuxbrew/${____init_directory}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        # Native User Rootless OPT Directory
        NETCONTROL_DIRECTORY="/opt/${____init_package_name}/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ] &&
[ ! "${____init_macos_bundle_name%/}" = "" ] &&
[ ! "${____init_macos_directory%/}" = "" ]; then
        # MacOS User Rootless Local Application
        NETCONTROL_DIRECTORY="${HOME}/Applications/${____init_macos_bundle_name%/}/Contents/Resources/${____init_macos_directory%/}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ] &&
[ ! "${____init_macos_bundle_name%/}" = "" ] &&
[ ! "${____init_macos_directory%/}" = "" ]; then
        # MacOS OS Application
        NETCONTROL_DIRECTORY="/Applications/${____init_macos_bundle_name%/}/Contents/Resources/${____init_macos_directory%/}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        # Native OS Machine-Specific & Homebrew (Intel MacOS)
        NETCONTROL_DIRECTORY="/usr/local/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        # Native OS Distributor
        NETCONTROL_DIRECTORY="/usr/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        # Native OS Root
        NETCONTROL_DIRECTORY="/${____init_directory%/}/${____init_file}"
fi

if [ ! -f "$NETCONTROL_DIRECTORY" ]; then
        1>&2 printf "%s" "\
E: Failed to Locate Init File. Bailing Out...

"
        exit 1
fi




# execute
. "$NETCONTROL_DIRECTORY" "$@"
exit $?
################################################################################
# Unix Main Codes                                                              #
################################################################################
exit 1
#>
