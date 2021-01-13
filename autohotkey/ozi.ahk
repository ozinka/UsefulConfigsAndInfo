; press Mouse Forward to Maximize/Restore window
xbutton2::
    MouseGetPos,,, WinUMID
    WinGet MX, MinMax, ahk_id %WinUMID%
    WinGetClass class, ahk_id %WinUMID%
    If !(class="Shell_TrayWnd"||class="WorkerW")
    {
        If MX
            WinRestore, ahk_id %WinUMID%
        Else WinMaximize, ahk_id %WinUMID%
    }
    ; MsgBox, The active window's class is "%class%".
Return

; press Mouse Forward to Minimize window
xbutton1::
    MouseGetPos,,, WinUMID
    ; WinGet MX, MinMax, WinUMID
    WinGetClass class, ahk_id %WinUMID%
    If !(class="Shell_TrayWnd"||class="WorkerW")
    {
        PostMessage, 0x112, 0xF020,,, ahk_id %WinUMID%
        ; WinMinimize, ahk_id %WinUMID%
        ; WinWaitNotActive, ahk_id %WinUMID%
        ; WinActivate, A
    	; MouseGetPos,,, uid
    	; WinActivate, ahk_id %uid%
    }
Return

; Ctrl+XButton2 to set "always on top"
^xbutton2::
    MouseGetPos,,, WinUMID
    WinGetClass class, ahk_id %WinUMID%

    WinGetTitle, activeWindow, ahk_id %WinUMID%
    if IsWindowAlwaysOnTop(activeWindow) {
        notificationMessage := "The window """ . activeWindow . """ is now always on top."
        notificationIcon := 16 + 1
    }
    else {
        notificationMessage := "The window """ . activeWindow . """ is no longer always on top."
        notificationIcon := 16 + 2
    }
    Winset, Alwaysontop, , ahk_id %WinUMID%
    TrayTip, Always-on-top, %notificationMessage%, , %notificationIcon%

    IsWindowAlwaysOnTop(windowTitle) {
        WinGet, windowStyle, ExStyle, %windowTitle%
        isWindowAlwaysOnTop := if (windowStyle & 0x8) ? false : true
        return isWindowAlwaysOnTop
    }
Return

; Ctrl+XButton1 to set Close
^xbutton1::
    MouseGetPos,,, WinUMID
    WinGetClass class, ahk_id %WinUMID%
    WinClose ahk_id %WinUMID%

Return