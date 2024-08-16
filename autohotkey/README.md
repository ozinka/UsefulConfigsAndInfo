# AutoHotkey Script for Window Management

This AutoHotkey script provides various utilities for managing windows in the Windows operating system. The script includes features such as window maximization, minimization, "Always on Top" toggle, and the ability to drag and resize windows using specific mouse and keyboard combinations.

## Features

### Suspend Script When Overwatch is Active
The script automatically suspends itself when the game `Overwatch` is active to avoid interference with the gameplay.

- **Functionality**: 
  - When `Overwatch.exe` is active, the script is suspended.
  - When `Overwatch.exe` is not active, the script resumes.

### Mouse Forward Button Actions
- **Maximize/Restore Window**:
  - **Hotkey**: `Mouse Forward (XButton2)`
  - **Description**: Maximizes the window under the mouse cursor if it is not already maximized. If it is maximized, it restores the window to its original size.

### Mouse Backward Button Actions
- **Minimize Window**:
  - **Hotkey**: `Mouse Backward (XButton1)`
  - **Description**: Minimizes the window under the mouse cursor.

### Toggle "Always on Top"
- **Hotkeys**: 
  - `Ctrl + Mouse Forward (XButton2)`
  - `Ctrl + Shift + Alt + = (F18)`
- **Description**: Toggles the "Always on Top" status of the window under the mouse cursor. A notification is displayed indicating whether the status was enabled or disabled.

### Close Window
- **Hotkey**: `Ctrl + Mouse Backward (XButton1)`
- **Description**: Closes the window under the mouse cursor.

### Drag and Resize Windows
- **Drag Window**:
  - **Hotkey**: `LWin + Left Mouse Button`
  - **Description**: Allows you to drag the window under the mouse cursor.
- **Resize Window**:
  - **Hotkey**: `LWin + Right Mouse Button`
  - **Description**: Allows you to resize the window under the mouse cursor.

## Usage

1. **Install AutoHotkey v2.0**: This script requires AutoHotkey version 2.0 or later. You can download and install it from [AutoHotkey's official website](https://www.autohotkey.com/).
2. **Run the Script**: After installing AutoHotkey, save the script to a `.ahk` file and run it. The script will run in the background and can be managed from the system tray.

## Customization

You can customize the hotkeys and functions by editing the script. For example, you can change the hotkeys for toggling "Always on Top" or adjust the timing for the `SetTimer` function.

## License

This script is provided as-is without any warranty. You are free to modify and distribute it as you see fit.

