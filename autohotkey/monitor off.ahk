#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Sleep 3000 ; if you use this with a hotkey, not sleeping will make it so your keyboard input wakes up the monitor immediately

SendMessage,0x112,0xF170,2,,Program Manager ; send the monitor into standby (off) mode