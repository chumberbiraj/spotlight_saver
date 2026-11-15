# Spotlight Image Filter

A Windows batch script by **CHUMEBR** that extracts high-quality 16:9 images from the Windows Spotlight (lock screen / desktop background) cache, lets you manually select your favourites, and saves them to your Pictures\spotlight folder.

## Usage

1. Double-click the `.bat` file (or run it from an elevated Command Prompt if you hit permission issues).
2. Wait for the filtering to complete.
3. When Explorer opens, **delete the images you don't like**.
4. Press **Enter** in the terminal.
5. Your selected wallpapers will appear in **Pictures\spotlight**.

## How It Works

1. **Creates a temp folder** – `C:\Users\<You>\Desktop\copy` is created if it doesn't already exist.
2. **Copies large assets** – Files in the Windows Spotlight `Assets` folder that are **larger than 200 KB** are copied to the temp folder and renamed with a date stamp + `.jpg` extension.
3. **Filters by aspect ratio** – Each image's dimensions are read via PowerShell. Any image that is **not 16:9** is deleted.
4. **Manual selection** – File Explorer opens on the temp folder. Browse through the remaining images and delete the ones you don't want.
5. Create a **Pictures\spotlight** folder if not exists
6. **Saves to Pictures** – All remaining `.jpg` files are copied to `C:\Users\<You>\Pictures\spotlight`.
7. **Cleanup** – The temp folder is emptied and the script exits.

## Requirements

- Windows 10 / 11
- No external dependencies (uses built-in `cmd` and `powershell`)
- Windows spotlight must be enabled

## CHANGE THE ASPECT RATIO:
Find the two lines in the script (search for "aspect_of_height"):
Change the last integer 

       set /a aspect_of_height=!h!/9
       set /a aspect_of_width=!w!/16

   The logic: if (height / Y) == (width / X), the image is X:Y

   | Ratio  | Height line       | Width line       |
   |--------|-------------------|------------------|
   | 16:9   | !h!/9            | !w!/16          |
   | 4:3    | !h!/3            | !w!/4           |
   | 21:9   | !h!/9            | !w!/21          |
   | 1:1    | !h!/1            | !w!/1           |

   Example - to use 4:3 instead of 16:9:
       set /a aspect_of_height=!h!/3
       set /a aspect_of_width=!w!/4

NOTE: Uses integer division. Images that are close but
not exact (e.g. 1920x1082) will still be deleted.

## Notes

- The Spotlight `Assets` folder contains the high-res backgrounds Windows downloads for lock screen / desktop.
- Only images with a **16:9** aspect ratio survive the automatic filter.
- If you want a different aspect ratio, edit the `set /a aspect_of_height` / `aspect_of_width` lines, Full guide above.

## Files Modified

|     Path      |  Action                          |
|---------------|----------------------------------|
| `Desktop\copy\` | Created / cleaned |
| `Pictures\spotlight\` | Created / Receives selected images |
| Spotlight `Assets` folder | Read-only (source) |   
