::PROGRAMMER:)BIRAJ_CHUMBER
@echo off
setlocal enabledelayedexpansion

echo script by Biraj Chumber

::This the folder where spotlight stores its files
cd "C:\Users\omsai\AppData\Local\Packages\Microsoft.Windows.ContentDeliveryManager_cw5n1h2txyewy\LocalState\Assets"

::copy every file more the 200KB and add ".jpg" extension
if folder_status equ accupied (
    echo folder already accupied
) else (
    for %%p in (*) do (
    set folder_status=accupied
    if %%~zp gtr 204800 (
        copy "%%p" "C:\Users\omsai\Desktop\copy"
        ren "C:\Users\omsai\Desktop\copy\%%p" "s%%p%date%.jpg"
    ) else (
        echo "insficent size"
    )
)
)


cd "C:\Users\omsai\Desktop\copy"

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

start explorer.exe "C:\Users\omsai\Desktop\copy"
set /p f="Please filter the image by your preference and press Enter"
::Copies the image(s) to pictures
for %%r in (*.jpg) do (copy "%%r" "C:\Users\omsai\Pictures")
::deleting temp files
for %%d in (*) do (del %%d)

set folder_status=empty
endlocal
pause