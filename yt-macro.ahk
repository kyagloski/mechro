SendMode Input ;Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ;Ensures a consistent starting directory.

#Persistent
#NoEnv
#SingleInstance, Force
DetectHiddenWindows, On
SetTitleMatchMode, 2
controlID 		:= 0
SetTitleMatchMode, Slow
return

#IfWinNotActive, ahk_exe chrome.exe

; HOTKEY FOR PAUSING
ctrl & /::
	ControlGet, controlID, Hwnd,,Chrome_RenderWidgetHostHWND1, Google Chrome
	
	ControlFocus,,ahk_id %controlID%
	
	IfWinExist, YouTube
	{
		ControlSend, Chrome_RenderWidgetHostHWND1, k , Google Chrome
		return
	}
	
	ControlSend, , ^1, Google Chrome
	
	Loop
	{
		IfWinExist, YouTube
		{
			break
		}
		
		ControlSend, ,{Control Down}{Tab}{Control Up}, Google Chrome
		
		Sleep, 500
	}

	Sleep, 50

	ControlSend, Chrome_RenderWidgetHostHWND1, k , Google Chrome
return

#IfWinNotActive

#IfWinNotActive, ahk_exe chrome.exe
; HOTKEY FOR NEXT VIDEO
ctrl & .::
	ControlGet, controlID, Hwnd,,Chrome_RenderWidgetHostHWND1, Google Chrome
	
	ControlFocus,,ahk_id %controlID%
	
	IfWinExist, YouTube
	{
		ControlSend, Chrome_RenderWidgetHostHWND1, {Shift Down}n{Shift Up}, Google Chrome
		return
	}
	
	ControlSend, , ^1, Google Chrome
	
	Loop
	{
		IfWinExist, YouTube
		{
			break
		}
		
		ControlSend, ,{Control Down}{Tab}{Control Up}, Google Chrome
		
		Sleep, 500
	}

	Sleep, 50

	ControlSend, Chrome_RenderWidgetHostHWND1,  {Shift Down}n{Shift Up}, Google Chrome
return

#IfWinNotActive

#IfWinNotActive, ahk_exe chrome.exe
; HOTKEY FOR PREVIOUS VIDEO
ctrl & ,::
	ControlGet, controlID, Hwnd,,Chrome_RenderWidgetHostHWND1, Google Chrome
	
	ControlFocus,,ahk_id %controlID%
	
	IfWinExist, YouTube
	{
		ControlSend, Chrome_RenderWidgetHostHWND1, {Shift Down}p{Shift Up}, Google Chrome
		return
	}
	
	ControlSend, , ^1, Google Chrome
	
	Loop
	{
		IfWinExist, YouTube
		{
			break
		}
		
		ControlSend, ,{Control Down}{Tab}{Control Up}, Google Chrome
		
		Sleep, 500
	}

	Sleep, 50

	ControlSend, Chrome_RenderWidgetHostHWND1,  {Shift Down}p{Shift Up}, Google Chrome
return

#IfWinNotActive