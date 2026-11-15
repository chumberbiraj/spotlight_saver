::PROGRAMMER:)CHUMBERBIRAJ
::Version=1.2
@echo off
setlocal enabledelayedexpansion

echo Script by CHUMBER
::Changing to C drive in the case of script located in another drive
C:

::Check and make a directory "copy" to Temporary store image for processing and filtering
if not exist "C:\Users\%USERNAME%\Desktop\copy" (
    mkdir "C:\Users\%USERNAME%\Desktop\copy" & echo creating temp directory sucessfull
)

::This the folder where spotlight stores its files
cd "C:\Users\%USERNAME%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"

::copy every file more the 200KB and add ".jpg" extension along with current date and time to the filename
for %%p in (*) do (
    if %%~zp gtr 204800 (
        copy "%%p" "C:\Users\%USERNAME%\Desktop\copy"
        ren "C:\Users\%USERNAME%\Desktop\copy\%%p" "s%%p_%date%.jpg"
    ) else (
        echo insufficient size
        )
)

cd "C:\Users\%USERNAME%\Desktop\copy"

::copy every file more the 200KB and add ".jpg" extension along with current date and time to the filename
for %%i in (*.jpg) do (
    powershell -NoProfile -Command ^
    "Add-Type -AssemblyName System.Drawing"; ^
    "$img=[system.drawing.image]::FromFile('%%~fi')"; ^
    "echo working_on_%%i"; ^
    "$img.height | Set-Content Height.txt -Encoding ascii"; ^
    "$img.width | Set-Content Width.txt -Encoding ascii";

    REM Get the Height and Width store by powershell
    set /p h=<Height.txt
    echo Height:!h!
    set /p w=<Width.txt
    echo Width:!w!

    REM Determine the aspect ratio
    REM check README.md for guide to Change aspect ratio
    set /a "aspect_of_height=!h!/9"
    set /a "aspect_of_width=!w!/16"

    if !aspect_of_height! neq !aspect_of_width! (
        del %%i
    )
)

start explorer.exe "C:\Users\%USERNAME%\Desktop\copy"
set /p f="Please filter the Image by your preference and press Enter"

if not exist "C:\Users\%USERNAME%\Pictures\spotlight" (
    mkdir "C:\Users\%USERNAME%\Pictures\spotlight" && echo Pictures\spotlight directory Created
)

::Copies the image(s) to pictures
for %%r in (*.jpg) do (copy "%%r" "C:\Users\%USERNAME%\Pictures\spotlight")
::deleting temp files
for %%d in (*) do (del %%d)

endlocal

pause
