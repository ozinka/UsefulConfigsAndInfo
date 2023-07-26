;===================================================================
; Mouse (action to window under Mouse cursor)
; Forward           - Maximize/restore window
; Backward          - Minimize window
; Ctrl Forward      - Always on top
; Ctrl Backward     - Close application
; Win + Drag windows anywhere with mouse

; sources   https://gist.github.com/scottming/5405b12eb2c69a4e0e54
;           https://gist.github.com/Danik/5808330

#Persistent
SetCapsLockState, AlwaysOff

;====== Mouse =======

; Mouse Forward to Maximize/Restore window
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
    ;Sleep 100
Return

; Mouse Backward to Minimize window
xbutton1::
    MouseGetPos,,, WinUMID
    WinGetClass class, ahk_id %WinUMID%
    If !(class="Shell_TrayWnd"||class="WorkerW")
    {
        PostMessage, 0x112, 0xF020,,, ahk_id %WinUMID%
    }
Return

; Ctrl+Forward to set "always on top"
;^xbutton2::
^!+=::
    MouseGetPos,,, WinUMID
    WinGetClass class, ahk_id %WinUMID%
    Winset, Alwaysontop, , ahk_id %WinUMID%
    WinGet, ExStyle, ExStyle, ahk_id %WinUMID%
    if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
        TrayTip, ON, AHK Always on-top, 0, 17
    else
        TrayTip, OFF, AHK Always on-top, 0, 16
    ;Sleep 100
Return


; Ctrl+Backward to Close
^xbutton1::
    MouseGetPos,,, WinUMID
    WinGetClass class, ahk_id %WinUMID%
    WinClose ahk_id %WinUMID%
Return

; Drag window anywhere
LWin & LButton::
    CoordMode, Mouse
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, % wTitle := "ahk_id " EWD_MouseWin
    mv_mode = mv
    SetTimer, EWD_WatchMouse, 10
return

; Resize window
LWin & RButton::
    CoordMode, Mouse
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, ,, EWD_OriginalPosX, EWD_OriginalPosY, % wTitle := "ahk_id " EWD_MouseWin
    mv_mode = sz
    SetTimer, EWD_WatchMouse, 10
return

; Drag window if LButton+RButton
#If GetKeyState("LButton", "P")
RButton::
    CoordMode, Mouse
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    While GetKeyState("RButton", "P") {
        WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, % wTitle := "ahk_id " EWD_MouseWin
        mv_mode = mv
        SetTimer, EWD_WatchMouse, 10
        Send {Esc}
    }
return
#If

; Resize window if RButton+LButton
#If GetKeyState("RButton", "P")
LButton::
    CoordMode, Mouse
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    While GetKeyState("LButton", "P") {
        WinGetPos, ,, EWD_OriginalPosX, EWD_OriginalPosY, % wTitle := "ahk_id " EWD_MouseWin
        mv_mode = sz
        SetTimer, EWD_WatchMouse, 10
        KeyWait, Rbutton ;As soon as RButton is released...
        SendInput {Esc}  ;... kill the context menu
    }
return
#If

; Function for move and resize windows
EWD_WatchMouse:
    CoordMode, Mouse
    MouseGetPos, EWD_MouseX, EWD_MouseY
    SetWinDelay, -1   ; Makes the below move faster/smoother.
    if mv_mode = mv
    {
        GetKeyState, EWD_MButtonState, LButton, P
        WinGetPos, EWD_WinX, EWD_WinY,,, %wTitle%
        WinMove, %wTitle%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
    }
    if mv_mode = sz
    {
        GetKeyState, EWD_MButtonState, RButton, P
        WinGetPos, ,, Width, Height, %wTitle%
        WinMove, %wTitle%,,,, Width + EWD_MouseX - EWD_MouseStartX, Height + EWD_MouseY - EWD_MouseStartY
    }
    if EWD_MButtonState = U
    {
        SetTimer, EWD_WatchMouse, off
        return
    }
    EWD_MouseStartX := EWD_MouseX
    EWD_MouseStartY := EWD_MouseY
    WinActivate %wTitle%
return
