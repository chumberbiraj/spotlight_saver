::PROGRAMMER:)Ornage
@echo off
setlocal enabledelayedexpansion

echo script by Orange

::Check and make a directory "copy" to Temporary store image for processing and filtering
if not exist "C:\Users\%USER%\Desktop\copy" (
    mkdir "C:\Users\%USER%\Desktop\copy" & echo creating temp directory sucessfull
) 

::This the folder where spotlight stores its files
cd "C:\Users\%USER%\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"


::copy every file more the 200KB and add ".jpg" extension
if folder_status equ accupied (
    echo folder already accupied
) else (
    for %%p in (*) do (
    set folder_status=accupied
    if %%~zp gtr 204800 (
        copy "%%p" "C:\Users\%USER%\Desktop\copy"
        ren "C:\Users\%USER%\Desktop\copy\%%p" "s%%p%date%.jpg"
    ) else (
        echo "insficent size"
    )
)
)



cd "C:\Users\%USER%\Desktop\copy"

for %%i in (*.jpg) do (
    powershell -command ^
    "Add-Type -AssemblyName System.Drawing"; ^
    "$img=[system.drawing.image]::FromFile('%%~fi')"; ^
    "echo working_on_%%i"; ^
    "$img.height | Set-Content Height.txt -Encoding ascii"; ^
    "$img.width | Set-Content Width.txt -Encoding ascii";
     
    ::Get the Height and Width store by powershell 
    set /p h=<Height.txt
    echo Height:!h!
    set /p w=<Width.txt
    echo Width:!w!
    ::divide the both h and w by 9 and 16 to confirm the aspect ratio is 16:9
    set /a aspect_of_height=!h!/9
    set /a aspect_of_width=!w!/16

    if !aspect_of_height! neq !aspect_of_width! (
        del %%i
    )
)

start explorer.exe "C:\Users\%USER%\Desktop\copy"
set /p f="Please filter the image by your preference and press Enter"
::Copies the image(s) to pictures
for %%r in (*.jpg) do (copy "%%r" "C:\Users\%USER%\Pictures")
::deleting temp files
for %%d in (*) do (del %%d)

set folder_status=empty
endlocal

pause
