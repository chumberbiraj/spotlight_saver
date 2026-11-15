::PROGRAMMER:)CHUMBERBIRAJ
@echo off
setlocal enabledelayedexpansion

echo script by CHUMBER

::Change the drive value to C:
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
    ren "C:\Users\%USERNAME%\Desktop\copy\%%p" "s%%p%date%_%time%.jpg"
) else (
    echo "insficent size"
    )
)
)


cd "C:\Users\%USERNAME%\Desktop\copy"

for %%i in (*.jpg) do (
    powershell -command ^
    "Add-Type -AssemblyName System.Drawing"; ^
    "$img=[system.drawing.image]::FromFile('%%~fi')"; ^
    "echo working on %%i"; ^
    "$img.height | Set-Content Height.txt -Encoding ascii"; ^
    "$img.width | Set-Content Width.txt -Encoding ascii";

    ::Get the Height and Width store by powershell
    set /p h=<Height.txt
    echo Height:!h!
    set /p w=<Width.txt
    echo Width:!w!
    ::divide the both h(height) and w(width) by 9 and 16 to confirm the aspect ratio is 16:9
    :: TO change the aspect ratio Edit the last number of lines below
    :: The logic: if (height / Y) == (width / X), the image is X:Y
    ::
    ::   | Ratio  | Height line       | Width line       |
    ::   |--------|-------------------|------------------|
    ::   | 16:9   | !h!/9            | !w!/16          |
    ::   | 4:3    | !h!/3            | !w!/4           |
    ::   | 21:9   | !h!/9            | !w!/21          |
    ::   | 1:1    | !h!/1            | !w!/1           |

    set /a aspect_of_height=!h!/9
    set /a aspect_of_width=!w!/16

    if !aspect_of_height! neq !aspect_of_width! (
        del %%i
    )
)

start explorer.exe "C:\Users\%USERNAME%\Desktop\copy"
set /p f="Please filter the Image by your preference and press Enter"

if not exist "C:\Users\%USERNAME%\Pictures\spotlight" (
    mkdir "C:\Users\%USERNAME%\Pictures\spotlight" && echo Pictures\spotlight Created
)

::Copies the image(s) to pictures
for %%r in (*.jpg) do (copy "%%r" "C:\Users\%USERNAME%\Pictures\spotlight")
::deleting temp files
for %%d in (*) do (del %%d)

endlocal

pause
