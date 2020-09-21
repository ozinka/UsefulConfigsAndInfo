; press Mouse Forward to Maximize window Minimize
$xbutton2::
    MouseGetPos,,, WinUMID
    If !WinActive("ahk_id" WinUMID)
    WinActivate, ahk_id %WinUMID%

    WinGet MX, MinMax, A
    WingetClass, myClass, A
    except_classes := "Chrome_WidgetWin_1"

    if myClass not in %except_classes%
        If MX
            WinRestore A
        Else WinMaximize A

    ; TrayTip, %myClass%, "hey"
    ; MsgBox, Hello
Return

; press Mouse Forward to Minimize window
$xbutton1::
    MouseGetPos,,, WinUMID
    If !WinActive("ahk_id" WinUMID)
    WinActivate, ahk_id %WinUMID%

    WingetClass, myClass, A
    WinGet MX, MinMax, A
    except_classes := "Chrome_WidgetWin_1"

    if myClass not in %except_classes%
        WinMinimize A

Return

; Press Ctrl+XButton2 to set any currently active window to be always on top
^xbutton2::
    MouseGetPos,,, WinUMID
    If !WinActive("ahk_id" WinUMID)
    WinActivate, ahk_id %WinUMID%

    WinGetTitle, activeWindow, A
    if IsWindowAlwaysOnTop(activeWindow) {
        notificationMessage := "The window """ . activeWindow . """ is now always on top."
        notificationIcon := 16 + 1 ; No notification sound (16) + Info icon (1)
    }
    else {
        notificationMessage := "The window """ . activeWindow . """ is no longer always on top."
        notificationIcon := 16 + 2 ; No notification sound (16) + Warning icon (2)
    }
    Winset, Alwaysontop, , A
    TrayTip, Always-on-top, %notificationMessage%, , %notificationIcon%
    ;Sleep 3000 ; Let it display for 3 seconds.
    ; HideTrayTip()

    IsWindowAlwaysOnTop(windowTitle) {
        WinGet, windowStyle, ExStyle, %windowTitle%
        isWindowAlwaysOnTop := if (windowStyle & 0x8) ? false : true ; 0x8 is WS_EX_TOPMOST.
        return isWindowAlwaysOnTop
    }

    ; HideTrayTip() {
    ;     TrayTip  ; Attempt to hide it the normal way.
    ;     if SubStr(A_OSVersion,1,3) = "10." {
    ;         Menu Tray, NoIcon
    ;         Sleep 200  ; It may be necessary to adjust this sleep.
    ;         Menu Tray, Icon
    ;     }
    ; }
Return