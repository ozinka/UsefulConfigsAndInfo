;==================== AHK v2 ===================================
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

Persistent
#Requires AutoHotkey v2.0

; Prevent CapsLock from changing its state
SetCapsLockState "AlwaysOff"

SetTimer CheckActiveWindow, 1000

CheckActiveWindow() {
    if WinActive("ahk_exe overwatch.exe") {
        Suspend(True)  ; Suspend the script if Overwatch is active
    } else {
        Suspend(False)  ; Resume the script if Overwatch is not active
    }
}


;======= ChatGPT =======
#HotIf WinActive("ahk_exe chrome.exe")   ; Limit hotkeys to Chrome only
; Grammar check template
::!gr::Check the grammar of this sentence, provide explanation for each correction using bullets list:

; Translation template English -> Ukrainian
::!tr-eu::Translate this from English to Ukrainian:

; Translation template Uktrainian -> English
::!tr-ue::Translate this from Ukrainianian to English:
#HotIf  
; End restriction (hotkeys will work in all windows after this point)

;====== Mouse =======
; Mouse Forward to Maximize/Restore window
xbutton2:: {
    MouseGetPos(, , &WinUMID)
    MX := WinGetMinMax("ahk_id " WinUMID)
    class := WinGetClass("ahk_id " WinUMID)
    if !(class == "Shell_TrayWnd" || class == "WorkerW") {
        if MX
            WinRestore("ahk_id " WinUMID)
        else 
            WinMaximize("ahk_id " WinUMID)
    }
}

; Mouse Backward to Minimize window
xbutton1:: {
    MouseGetPos(, , &WinUMID)
    class := WinGetClass("ahk_id " WinUMID)
    if !(class == "Shell_TrayWnd" || class == "WorkerW") {
        PostMessage(0x112, 0xF020, , , "ahk_id " WinUMID)
    }
}

; "Ctrl+Forward", "Shift+Ctrl+Alt+=" to set "always on top"
F18::
^XButton2:: {
    MouseGetPos(, , &WinUMID)
    ProcessName := WinGetProcessName("ahk_id " WinUMID)
    ExStyle := WinGetExStyle("ahk_id " WinUMID)
    if (ExStyle & 0x8) { ; 0x8 is WS_EX_TOPMOST.
        WinSetAlwaysOnTop(0, "ahk_id " WinUMID) ; Turn off always on top
        TrayTip("Always on Top", "Disabled: " ProcessName)
    } else {
        WinSetAlwaysOnTop(1, "ahk_id " WinUMID) ; Turn on always on top
        TrayTip("Always on Top", "Enabled: " ProcessName)
    }
    Sleep 2000 ; Wait for 2 seconds
    TrayTip("") ; Clear the TrayTip
}

; Ctrl+Backward to Close
^xbutton1:: {
    MouseGetPos(, , &WinUMID)
    WinClose("ahk_id " WinUMID)
}

; Global variables
global EWD_MouseStartX := 0
global EWD_MouseStartY := 0
global EWD_MouseWin := 0
global EWD_OriginalPosX := 0
global EWD_OriginalPosY := 0
global mv_mode := ""

; Drag window with LWin + Left Mouse Button
LWin & LButton:: {
    global EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin, EWD_OriginalPosX, EWD_OriginalPosY, mv_mode
    CoordMode("Mouse")
    MouseGetPos(&EWD_MouseStartX, &EWD_MouseStartY, &win)
    if !WinExist(win) {
        return
    }
    EWD_MouseWin := win
    WinGetPos(&EWD_OriginalPosX, &EWD_OriginalPosY, , , EWD_MouseWin)
    mv_mode := "move"
    SetTimer(EWD_WatchMouse, 10)
}

; Resize window with LWin + Right Mouse Button
LWin & RButton:: {
    global EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin, EWD_OriginalPosX, EWD_OriginalPosY, mv_mode
    CoordMode("Mouse")
    MouseGetPos(&EWD_MouseStartX, &EWD_MouseStartY, &win)
    if !WinExist(win) {
        return
    }
    EWD_MouseWin := win
    WinGetPos(, , &EWD_OriginalPosX, &EWD_OriginalPosY, EWD_MouseWin)
    mv_mode := "resize"
    SetTimer(EWD_WatchMouse, 10)
}

; Function to handle window movement and resizing
EWD_WatchMouse() {
    global EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin, mv_mode
    if !WinExist(EWD_MouseWin) {
        SetTimer(EWD_WatchMouse, 0)
        return
    }
    CoordMode("Mouse")
    MouseGetPos(&EWD_MouseX, &EWD_MouseY)
    SetWinDelay(-1)  ; Makes the movement faster/smoother

    if mv_mode == "move" {
        if GetKeyState("LButton", "P") {
            WinGetPos(&EWD_WinX, &EWD_WinY, , , EWD_MouseWin)
            try {
                WinMove(EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY, , , EWD_MouseWin)
            }
        }
    } else if mv_mode == "resize" {
        if GetKeyState("RButton", "P") {
            WinGetPos(, , &Width, &Height, EWD_MouseWin)
            try {
                WinMove(, , Width + EWD_MouseX - EWD_MouseStartX, Height + EWD_MouseY - EWD_MouseStartY, EWD_MouseWin)
            }
        }
    }

    if !GetKeyState("LButton", "P") && !GetKeyState("RButton", "P") {
        SetTimer(EWD_WatchMouse, 0)
        return
    }

    EWD_MouseStartX := EWD_MouseX
    EWD_MouseStartY := EWD_MouseY
}

;==== Keyboard ======
; Capslock + Backspace (Ctrl+Backspace)
Capslock & BS::SendInput("{Blind}{Del Down}")

; Capslock + g (Ctrl+Backspace)
Capslock & g::SendInput("{Blind}{Del Down}")

; Capslock + hjkl (left, down, up, right)
Capslock & h::Send("{Blind}{Left DownTemp}")
Capslock & h up::Send("{Blind}{Left Up}")

Capslock & j::Send("{Blind}{Down DownTemp}")
Capslock & j up::Send("{Blind}{Down Up}")

Capslock & k::Send("{Blind}{Up DownTemp}")
Capslock & k up::Send("{Blind}{Up Up}")

Capslock & l::Send("{Blind}{Right DownTemp}")
Capslock & l up::Send("{Blind}{Right Up}")

; Capslock + w, b (Ctrl+Right, Ctrl+Left (vim w (word), b(back)))
Capslock & w::Send("{Blind}^{Right}")
Capslock & b::Send("{Blind}^{Left}")

; Capslock only, Send Escape
; Capslock::Send("{ESC}")

; Capslock + yuio (home, pgup, pgdown, end)
Capslock & u::SendInput("{Blind}{Home Down}")
Capslock & u up::SendInput("{Blind}{Home Up}")

Capslock & i::SendInput("{Blind}{PgUp Down}")
Capslock & i up::SendInput("{Blind}{PgUp Up}")

Capslock & o::SendInput("{Blind}{PgDn Down}")
Capslock & o up::SendInput("{Blind}{PgDn Up}")

Capslock & p::SendInput("{Blind}{End Down}")
Capslock & p up::SendInput("{Blind}{End Up}")

; Capslock + ,./ (undo/redo/redo)
Capslock & ,::SendInput("{Ctrl Down}{z Down}")
Capslock & , up::SendInput("{Ctrl Up}{z Up}")
Capslock & .::SendInput("{Ctrl Down}{y Down}")
Capslock & . up::SendInput("{Ctrl Up}{y Up}")
Capslock & /::SendInput("{Ctrl Down}{Shift Down}{z Down}")
Capslock & / up::SendInput("{Ctrl Up}{Shift Up}{z Up}")

; Capslock + asdfeq (select all, cut-copy-paste, ctrl+home, ctrl+end)
Capslock & a::SendInput("{Ctrl Down}{a Down}")
Capslock & a up::SendInput("{Ctrl Up}{a Up}")

Capslock & s::SendInput("{Ctrl Down}{x Down}")
Capslock & s up::SendInput("{Ctrl Up}{x Up}")

Capslock & d::SendInput("{Ctrl Down}{c Down}")
Capslock & d up::SendInput("{Ctrl Up}{c Up}")

Capslock & f::SendInput("{Ctrl Down}{v Down}")
Capslock & f up::SendInput("{Ctrl Up}{v Up}")

Capslock & q::SendInput("{Ctrl Down}{Home Down}")
Capslock & q up::SendInput("{Ctrl Up}{Home Up}")

Capslock & e::SendInput("{Ctrl Down}{End Down}")
Capslock & e up::SendInput("{Ctrl Up}{End Up}")

; Virtual Desktop
Capslock & 7::SendInput("{Ctrl Down}{LWin Down}{Right Down}")
Capslock & 7 up::SendInput("{Ctrl Up}{LWin Up}{Right Up}")

Capslock & 8::SendInput("{Ctrl Down}{LWin Down}{Left Down}")
Capslock & 8 up::SendInput("{Ctrl Up}{LWin Up}{Left Up}")

; Make Capslock & Enter equivalent to Control+Enter
Capslock & Enter::SendInput("{Ctrl down}{Enter}{Ctrl up}")

; Make Capslock+Space -> Enter, Capslock+Shift+Space -> RClick
Capslock & Space:: {
    if GetKeyState("Shift", "P") {
        Send("{Click Right}")
    } else {
        SendInput("{Enter Down}")
    }
}

; Make Win Key + Capslock work like Capslock (in case it's ever needed)
Capslock & LWin:: {
    if GetKeyState("CapsLock", "T") == 1 {
        SetCapsLockState "Off"
    } else {
        SetCapsLockState "On"
    }
}

; Media control
; play/pause, back, forward
Capslock & c::SendInput("{Media_Play_Pause}")
Capslock & z::SendInput("{Media_Prev}")
Capslock & x::SendInput("{Media_Next}")

; Disable Capslock for any other key combinations
CapsLock::Return
CapsLock UP::Return


; Block all other Capslock combinations
#HotIf GetKeyState("CapsLock", "P")
*::return
#HotIf