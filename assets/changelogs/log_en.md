## Current Version (0.5) - 08/05/2025
**New Additions**:
- You can now *remotely log out*. If you no longer have access to one of your devices and want to log out, simply log in from another device, long-press the one you want to disconnect, and tap `Unlink`.
- The scan can now be cancelled by tapping the `Cancel` button on the scanning screen.
- Added the option to **scan from a specific directory**: Users can now choose which folder to scan by tapping the `Scan a folder` button. No need to wait for the entire scanning process to reach the desired folder!

**Fixes**:
- **Parallel programming** has been implemented so the scan runs independently from the app.

## Previous Versions
### Version 0.4 - 02/02/2025
**New additions**:
- The option to **change color** has been added to the interface. *"That there was only one color seemed a bit boring, so now the user can choose between 14 different options: 7 colors alternating light and dark mode"*.

**Fixes**:
- Network functions should now work without any issues.

### Version 0.3 - 01/23/2025
**New additions**:
- **File analysis** has been implemented, tested on Windows and Android.
- Users can also **restore quarantined files**\
*"It seemed strange to me that the user could see the deleted files but couldn't do anything with them, so now they can restore them at their own risk"*
- When the computer detects a file with a virus, it sends a notification to the user's screen to inform them that it has quarantined said file

**Fixes**
- User and device access has been changed\
*"We found several problems with the databases, so, for now, we will work with an API service so that users can access their accounts and devices"*

To carry out any necessary tests, an emulation of a malicious file is provided by clicking [here](www.google.es)

The possible bad experience in file analysis is regretted, certain aspects still need to be improved.

### Version 0.2 - 15/01/2025
**New additions**:
- The "App Version" section has been added
- User accessibility features have been implemented
- A change in the navigation menu has been implemented on the main screen:
	- If the screen is the size of a mobile phone, it will be seen at the bottom
	- If the screen is excessively small or larger than that of a mobile phone, it will be seen on the left side.
- Analysis function in progress: Added background tour with MacOS\

**Fixes**:
- The user can no longer enter a prohibited file more than once

### Version 0.1 - 05/01/2025
***Application Start***\
**New additions***:
- The operation of local and network databases has been implemented
- Login and registration has been implemented
- You can add and remove prohibited folders from your computer
- You can change the user's profile photo by clicking on the photo in its respective menu
- Functional buttons, you can change username, password, etc.
- Analysis function in progress: The button currently scans the Android and Windows files, without analyzing due to lack of API or Hash Detection Resource.
- User preferences are saved in a local database so that they load as soon as the application is opened.
- The user can see the devices linked to their account
- Quarantined file list concept created. Current result is not known because there is no analysis function avaliable
- Added light and dark modes and language support.