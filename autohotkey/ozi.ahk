;===================================================================
; Autohotkey Capslock Remapping Script
; - Deactivates capslock for normal (accidental) use.
; - Hold Capslock and drag anywhere in a window to move it (not just the title bar).
; - Access the following functions when pressing Capslock:
    ;Cursor keys        - h, j, k, l
    ;Home,End           - N, ;
    ;Page up,down       - - =
    ;Esc                - CapsLock only
    ;CapsLock           - Space
; source https://gist.github.com/scottming/5405b12eb2c69a4e0e54

#Persistent
SetCapsLockState, AlwaysOff

;====== Mouse =======

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
Return

; press Mouse Backward to Minimize window
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
Return

; Ctrl+Backward to Close
^xbutton1::
    MouseGetPos,,, WinUMID
    WinGetClass class, ahk_id %WinUMID%
    WinClose ahk_id %WinUMID%
Return

; Alt+Backward to Enter
!xbutton1::SendInput {Enter}{Alt up}

; Drag windows anywhere
; Taken from https://gist.github.com/Danik/5808330

Capslock & LButton::
CoordMode, Mouse  ; Switch to screen/absolute coordinates.
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
if EWD_WinState = 0  ; Only if the window isn't maximized
    SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; Button has been released, so drag is complete.
{
    SetTimer, EWD_WatchMouse, off
    return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
{
    SetTimer, EWD_WatchMouse, off
    WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
    return
}
; Otherwise, reposition the window to match the change in mouse coordinates
; caused by the user having dragged the mouse:
CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1   ; Makes the below move faster/smoother.
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
EWD_MouseStartY := EWD_MouseY
return

;====== Keyboard =======

; Capslock + Backspace (Ctrl+Backspace)
Capslock & BS::SendInput {Blind}{Del Down}

; Capslock + hjkl (left, down, up, right)
Capslock & h::Send {Blind}{Left DownTemp}
Capslock & h up::Send {Blind}{Left Up}

Capslock & j::Send {Blind}{Down DownTemp}
Capslock & j up::Send {Blind}{Down Up}

Capslock & k::Send {Blind}{Up DownTemp}
Capslock & k up::Send {Blind}{Up Up}

Capslock & l::Send {Blind}{Right DownTemp}
Capslock & l up::Send {Blind}{Right Up}

; Capslock & Space::
; If GetKeyState("CapsLock", "T") = 1
;     SetCapsLockState, AlwaysOff
; Else
;     SetCapsLockState, AlwaysOn
; Return

; Capslock only, Send Escape
CapsLock::Send, {ESC}

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

; Capslock + asdf (select all, cut-copy-paste)
Capslock & a::SendInput {Ctrl Down}{a Down}
Capslock & a up::SendInput {Ctrl Up}{a Up}

Capslock & s::SendInput {Ctrl Down}{x Down}
Capslock & s up::SendInput {Ctrl Up}{x Up}

Capslock & d::SendInput {Ctrl Down}{c Down}
Capslock & d up::SendInput {Ctrl Up}{c Up}

Capslock & f::SendInput {Ctrl Down}{v Down}
Capslock & f up::SendInput {Ctrl Up}{v Up}

; Make Capslock & Enter equivalent to Control+Enter
Capslock & Enter::SendInput {Ctrl down}{Enter}{Ctrl up}

; Make Capslock+Space -> Enter
Capslock & Space::SendInput {Enter Down}
