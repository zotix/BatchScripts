@echo off
setlocal

echo "+------------------------------------------------+";
echo "| ____  _      __     ___     _                _ |";
echo "||  _ \| |     \ \   / (_) __| | ___  ___  ___| ||";
echo "|| | | | |      \ \ / /| |/ _` |/ _ \/ _ \/ __| ||";
echo "|| |_| | |___    \ V / | | (_| |  __/ (_) \__ \_||";
echo "||____/|_____|    \_/  |_|\__,_|\___|\___/|___(_)|";
echo "+------------------------------------------------+";

rem Define the paths and variables
set "apps_path=%USERPROFILE%\Documents\Downloads\Apps"

set "yt_dlp_path=%apps_path%\yt-dlp.exe"
set "yt_dlp_url=https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe"

set "ffmpeg_path=%apps_path%\ffmpeg-master-latest-win64-gpl"
set "ffmpeg_url=https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip"

rem Check if yt-dlp exists
if not exist "%yt_dlp_path%" (
    echo yt-dlp not found. Downloading the latest version...
    
    rem Create the apps directory if it doesn't exist
    if not exist "%apps_path%" mkdir "%apps_path%"
    
    rem Download the latest version of yt-dlp
    powershell -command "Invoke-WebRequest -Uri '%yt_dlp_url%' -OutFile '%yt_dlp_path%'"
    
    rem Verify download success
    if exist "%yt_dlp_path%" (
        echo yt-dlp downloaded successfully.
    ) else (
        echo Failed to download yt-dlp. Exiting.
        exit /b 1
    )
)

rem Check if ffmpeg exists
if not exist "%ffmpeg_path%" (
    echo FFmpeg not found. Downloading the latest version...
    
    rem Download the latest version of ffmpeg
    powershell -command "Invoke-WebRequest -Uri '%ffmpeg_url%' -OutFile '%apps_path%\ffmpeg-master-latest-win64-gpl.zip'"

    rem Extract the latest version of ffmpeg
    powershell -command "Expand-Archive -Path '%apps_path%\ffmpeg-master-latest-win64-gpl.zip' -DestinationPath '%apps_path%'"

    del "%apps_path%\ffmpeg-master-latest-win64-gpl.zip"

    rem Verify download success
    if exist "%ffmpeg_path%" (
        echo FFmpeg downloaded successfully.
	
    ) else (
        echo Failed to download FFmpeg. Exiting.
        exit /b 1
    )
)

rem Use PowerShell to get the clipboard content
for /f "delims=" %%A in ('powershell -command "Get-Clipboard"') do set clipboard=%%A

rem Check if the clipboard contains a URL
echo "%clipboard%" | findstr /r "https:// http://" >nul
if %errorlevel% equ 0 (
    echo URL detected: "%clipboard%"
    "%yt_dlp_path%" "%clipboard%" --ffmpeg-location %ffmpeg_path%\bin\
) else (
    echo No valid URL found in the clipboard.
)

endlocal

echo "+------------------------------------------------+";
timeout /t 5 /nobreak
