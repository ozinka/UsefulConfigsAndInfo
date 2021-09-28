;===================================================================
; Autohotkey Capslock Remapping Script
; - Deactivates capslock for normal (accidental) use.
; - Hold Capslock and drag anywhere in a window to move it (not just the title bar).
; - Access the following functions when pressing Capslock:
    ;Cursor keys        - h, j, k, l, w, b
    ;Page up,down       - i, o
    ;Home,End           - u, p
    ;Enter              - Space
    ;Esc                - CapsLock only
    ;Capslock           - Win

; Mouse (action to window under Mouse cursor)
; Forward           - Maximize/restore window
; Backward          - Minimize window
; Ctrl Forward      - Always on top
; Ctrl Backward     - Close application
; Capslokc + Drag windows anywhere with mouse

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
^xbutton2::
    MouseGetPos,,, WinUMID
    WinGetClass class, ahk_id %WinUMID%
    Winset, Alwaysontop, , ahk_id %WinUMID%
    WinGet, ExStyle, ExStyle, ahk_id %WinUMID%
    if (ExStyle & 0x8)  ; 0x8 is WS_EX_TOPMOST.
        TrayTip, ON, AHK Aloways on-top, 0, 17
    else
        TrayTip, OFF, AHK Aloways on-top, 0, 16
Return


; Ctrl+Backward to Close
^xbutton1::
    MouseGetPos,,, WinUMID
    WinGetClass class, ahk_id %WinUMID%
    WinClose ahk_id %WinUMID%
Return

; Drag window anywhere
Capslock & LButton::
    CoordMode, Mouse
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, % wTitle := "ahk_id " EWD_MouseWin
    mv_mode = mv
    SetTimer, EWD_WatchMouse, 10
return

; Resize window
Capslock & RButton::
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

; Capslock + Backspace (Ctrl+Backspace)
Capslock & BS::SendInput {Blind}{Del Down}

; Capslock + G (Ctrl+Backspace)
Capslock & g::SendInput {Blind}{Del Down}

; Capslock + hjkl (left, down, up, right)
Capslock & h::Send {Blind}{Left DownTemp}
Capslock & h up::Send {Blind}{Left Up}

Capslock & j::Send {Blind}{Down DownTemp}
Capslock & j up::Send {Blind}{Down Up}

Capslock & k::Send {Blind}{Up DownTemp}
Capslock & k up::Send {Blind}{Up Up}

Capslock & l::Send {Blind}{Right DownTemp}
Capslock & l up::Send {Blind}{Right Up}


; Capslock + w, b (Ctrl+Right, Ctrl+Left (vim w (word), b(back)))
CapsLock & w:: Send, {Blind}^{Right}
CapsLock & b:: Send, {Blind}^{Left}

; Capslock only, Send Escape
; CapsLock::Send, {ESC}

; Capslock + yuio (home, pgup, pgdown, end)
Capslock & u::SendInput {Blind}{Home Down}
Capslock & u up::SendInput {Blind}{Home Up}

Capslock & i::SendInput {Blind}{PgUp Down}
Capslock & i up::SendInput {Blind}{PgUp Up}

Capslock & o::SendInput {Blind}{PgDn Down}
Capslock & o up::SendInput {Blind}{PgDn Up}

Capslock & p::SendInput {Blind}{End Down}
Capslock & p up::SendInput {Blind}{End Up}


; Capslock + ,./ (undo/redo/redo)
Capslock & ,::SendInput {Ctrl Down}{z Down}
Capslock & , up::SendInput {Ctrl Up}{z Up}
Capslock & .::SendInput {Ctrl Down}{y Down}
Capslock & . up::SendInput {Ctrl Up}{y Up}
Capslock & /::SendInput {Ctrl Down}{Shift Down}{z Down}
Capslock & / up::SendInput {Ctrl Up}{Shift Up}{z Up}

; Capslock + asdf (select all, cut-copy-paste, ctrl+home, ctrl+end)
Capslock & a::SendInput {Ctrl Down}{a Down}
Capslock & a up::SendInput {Ctrl Up}{a Up}

Capslock & s::SendInput {Ctrl Down}{x Down}
Capslock & s up::SendInput {Ctrl Up}{x Up}

Capslock & d::SendInput {Ctrl Down}{c Down}
Capslock & d up::SendInput {Ctrl Up}{c Up}

Capslock & f::SendInput {Ctrl Down}{v Down}
Capslock & f up::SendInput {Ctrl Up}{v Up}

Capslock & q::SendInput {Ctrl Down}{Home Down}
Capslock & q up::SendInput {Ctrl Up}{Home Up}

Capslock & e::SendInput {Ctrl Down}{End Down}
Capslock & e up::SendInput {Ctrl Up}{End Up}

; Make Capslock & Enter equivalent to Control+Enter
Capslock & Enter::SendInput {Ctrl down}{Enter}{Ctrl up}

; Make Capslock+Space -> Enter, Capslock+Shit+Space -> RClick
Capslock & Space::
If GetKeyState("Shift","p")
    Send {Click Right}
else
    SendInput {Enter Down}
Return


; Make Win Key + Capslock work like Capslock (in case it's ever needed)
Capslock & LWin::
If GetKeyState("CapsLock", "T") = 1
    SetCapsLockState, AlwaysOff
Else
    SetCapsLockState, AlwaysOn
Return

; Media control
; play/pause, back, forward
Capslock & c:: SendInput {Media_Play_Pause}
Capslock & z:: SendInput {Media_Prev}
Capslock & x:: SendInput {Media_Next}

; Disable Capslock for any other keys combinations
CapsLock::return
CapsLock UP::return