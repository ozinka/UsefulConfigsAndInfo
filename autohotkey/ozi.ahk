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

; Ctrl+XButton1 to Close
^xbutton1::
    MouseGetPos,,, WinUMID
    WinGetClass class, ahk_id %WinUMID%
    WinClose ahk_id %WinUMID%

Return

; MButton1 to Enter
!xbutton1::Send {Enter}

Return

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

; Capslock + hjkl (left, down, up, right)
Capslock & h::Send {Blind}{Left DownTemp}
Capslock & h up::Send {Blind}{Left Up}

Capslock & j::Send {Blind}{Down DownTemp}
Capslock & j up::Send {Blind}{Down Up}

Capslock & k::Send {Blind}{Up DownTemp}
Capslock & k up::Send {Blind}{Up Up}

Capslock & l::Send {Blind}{Right DownTemp}
Capslock & l up::Send {Blind}{Right Up}

; Capslock + n (home, end)
Capslock & n::SendInput {Blind}{Home Down}
Capslock & n up::SendInput {Blind}{Home Up}

Capslock & `;::SendInput {Blind}{End Down}
Capslock & `; up::SendInput {Blind}{End Up}

Capslock & Space::
If GetKeyState("CapsLock", "T") = 1
    SetCapsLockState, AlwaysOff
Else
    SetCapsLockState, AlwaysOn
Return

; Capslock only, Send Escape
CapsLock::Send, {ESC}

; Cpaslock + -= ,send up,dowm
Capslock & =::SendInput {Blind}{PgDn Down}
Capslock & = up::SendInput {Blind}{PgDn Up}

Capslock & -::SendInput {Blind}{PgUp Down}
Capslock & - up::SendInput {Blind}{PgUp Up}

; Capslock + b, open the gitbash
; CapsLock & s::Send +{F10},Send s

;\ to |, <+\ to \
; \::+\
; Shift & \::Send {\}

; Capslock + w, run worktile
; CapsLock & w::
; Run https://worktile.com/project/4dbc6fdb5dfd49079da5c8c811b2cb8d/task
; return

; ^`::^/

; Capslock + G
; CapsLock & g::
; Run C:\Program Files\Google\Chrome\Application\chrome.exe
; return



;Caplock & p , Send click
; Capslock & p::Send +{Click 600, 200}

;Capslock & q ==> win  down
; Capslock & q::SendInput #{Down}

;Capslock & ` ==> win up
; Capslock & `::SendInput #{up}

;Capslock & Tab ==> Alt Tab
; Capslock & Tab::SendInput ^{Tab}

; ^0::#space))))
