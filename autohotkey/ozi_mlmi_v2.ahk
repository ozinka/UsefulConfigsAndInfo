Persistent
#Requires AutoHotkey v2.0

; SetTimer(() => CheckActiveWindow(), 100)  ; Check every 100 ms
; return

SetTimer CheckActiveWindow, 1000

CheckActiveWindow() {
    if WinActive("ahk_exe overwatch.exe") {
        Suspend(True)  ; Suspend the script if Overwatch is active
    } else {
        Suspend(False)  ; Resume the script if Overwatch is not active
    }
}

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

; Ctrl+Forward to set "always on top"
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