;full recoil control +
;generic recoil control +
;pistol autofire & recoil control
;Brusk Recoil HF

#NoEnv
SendMode Input
#singleInstance, force

SetTitleMatchMode, 3
#IfWinActive Counter-Strike: Global Offensive

;--------------
;-----EDIT-----
;--------------

;modify true/false ONLY
show_tooltip := true
show_gui := true
only_norecoil_when_crouched := false
invert_y_axis := false

;camping triggerbot
;offset pixels for triggerbot color search (1 pixel because awp scope takes up 1 pixel)
offsetX := 1
offsetY := 1
;delay for triggerbot
trigger_delay := 20
;triggerbot color tolerance
tolerance := 10

;keybinds (leave the quotes (") there)
;Keys to toggle Recoil 
key_crouch := "LCtrl"
key_shoot := "LButton"
key_pause_script := "RCtrl"
key_generic_norecoil := "f3"
key_ak47_norecoil := "]"
key_m4a4_norecoil := "["
key_m4a1s_norecoil := ";"
key_galil_norecoil := "'" 
key_famas_norecoil := "."
key_ump45_norecoil := "/"
key_toggle_norecoil := "f4"
key_toggle_autofire := "f5"
;for generic norecoil ONLY
key_increase_norecoil_amount := "Up"
key_decrease_norecoil_amount := "Down"
;for camping triggerbot (hold) FOR THE AWP
key_hold_trigger := "r"

;--------------
;-----EDIT-----
;--------------

FileRead, tempSaveText, %A_WorkingDir%\script_save.txt
If ErrorLevel = 1
{
	FileAppend, 2, %A_WorkingDir%\script_save.txt
	FileRead, tempSaveText, %A_WorkingDir%\script_save.txt
}

sensitivity := tempSaveText + 0

;f2 = toggle noRecoil
noRecoil := false
;f3 = toggle autofire
autofire := false

;special generic recoil stuff
firstShotRecoilTimeMax := 15
firstShotRecoilTime := 0

firstShotRestTimeMax := 5
firstShotRestTime := 0

weapon := 0
;Gun name
;0 = none
;1 = ak
;2 = m4
;3 = m4a1s
;4 = galil
;5 = famas
;6 = ump45

;recoil patterns
ak47_pattern_str := "-4,7;4,19;-3,29;-1,31;13,31;8,28;13,21;-17,12;-42,3;-21,2;12,11;-15,7;-26,-8;-3,4;40,1;19,7;14,10;27,0;33,-10;-21,-2;7,3;-7,9;-8,4;19,-3;5,6;-20,-1;-33,-4;-45,-21;-14,1"
ak47_offset := 3.8
ak47_waitoffset := 4.7

m4_pattern_str := "20,7;0,9;-6,16;7,21;-9,23;-5,27;16,15;11,13;22,5;-4,11;-18,6;-30,-4;-24,0;-25,-6;0,4;8,4;-11,1;-13,-2;2,2;33,-1;10,6;27,3;10,2;11,0;-12,0;6,5;4,5;3,1;4,-1"
m4_offset := 3.64
m4_waitoffset := 4.13
m4_offset2 := 3.65
m4_waitoffset2 := 4.17

m4a1s_pattern_str := "1,6;0,4;-4,14;4,18;-6,21;-4,24;14,14;8,12;18,5;-4,10;-14,5;-25,-3;-19,0;-22,-3;1,3;8,3;-9,1;-13,-2;3,2;1,1"
m4a1s_offset := 3.9
m4a1s_waitoffset := 4.7
m4a1s_point_offset := ""

galil_pattern_str := "4,4;-2,5;6,10;12,20;-1,25;2,24;6,18;11,10;-4,14;-22,8;-30,-10;-29,-13;-9,8;-12,2;-7,1;0,1;4,7;25,7;14,4;25,-3;31,-9;6,3;-12,3;10,-1;10,-1;10,-4;-9,5;-32,-5;-24,-3;-15,5;6,8;-14,-3;-24,-5;-13,-1"
galil_offset := 3.65
galil_waitoffset := 4.28

famas_pattern_str := "-4,5;1,4;-6,10;-1,17;0,20;14,20;16,20;-6,12;-20,8;-16,5;-13,2;4,5;23,4;12,6;20,-3;5,0;15,0;3,5;-4,3;-25,-1;-3,2;11,0;15,-7;15,-10"
famas_offset := 3.6
famas_waitoffset := 4.15

ump45_pattern_str := "-1,6;-4,8;-2,18;-4,23;-9,23;-3,26;11,17;-4,12;9,13;18,8;15,5;-1,3;5,6;0,6;9,-3;5,-1;-12,4;-19,1;-1,-2;15,-5;17,-2;-6,3;-20,-2;-3,-1"
ump45_offset := 3.65
ump45_waitoffset := 4.2
ump45_offset2 := 3.45
ump45_waitoffset2 := 4.2
StringSplit, ak_pattern, ak47_pattern_str, `;
StringSplit, m4_pattern, m4_pattern_str, `;
StringSplit, m4a1s_pattern, m4a1s_pattern_str, `;
StringSplit, galil_pattern, galil_pattern_str, `;
StringSplit, famas_pattern, famas_pattern_str, `;
StringSplit, ump45_pattern, ump45_pattern_str, `;

if(show_gui){
	;GUI
	Gui, Show, w200 h250, Script :D
	;No Recoil
	Gui, Add, GroupBox, x10 y10 w170 h90, No Recoil
	Gui, Add, Text, x20 y30 vNORECOILTEXT cRed, %key_toggle_norecoil% - toggle: Off
	Gui, Add, Text, x20 y50 cBlack, Amount:
	Gui, Add, Edit, x70 y45 w55
	Gui, Add, UpDown, vNORECOILAMT Range1-20, 1
	Gui, Add, Text, x20 y70 w100 vWEAPONRECOILTEXT cBlue, %key_generic_norecoil% - %key_ump45_norecoil%: Default

	;Autofire
	Gui, Add, GroupBox, x10 y110 w170 h50, Auto Fire
	Gui, Add, Text, x20 y130 vAUTOFIRETEXT cRed, %key_toggle_autofire% - toggle: Off
	;Sensitivity
	Gui, Add, GroupBox, x10 y170 w170 h50, Sensitivity
	Gui, Add, Text, x20 y190 cBlack, Sensitivity:
	Gui, Add, Edit, x80 y185 w30 vSENSITIVITY gSENSCHANGED, %sensitivity%
}

modifier := 2.52 / sensitivity

previouslyCrouched := false

previouslyTrigger := false
lastColor := 0x000000

OnExit, GuiClose

HotKey, *%key_shoot%, shoot
HotKey, *%key_pause_script%, pause_script
HotKey, *%key_generic_norecoil%, generic_norecoil
HotKey, *%key_ak47_norecoil%, ak47_norecoil
HotKey, *%key_m4a4_norecoil%, m4a4_norecoil
HotKey, *%key_m4a1s_norecoil%, m4a1s_norecoil
HotKey, *%key_galil_norecoil%, galil_norecoil
HotKey, *%key_famas_norecoil%, famas_norecoil
HotKey, *%key_ump45_norecoil%, ump45_norecoil
HotKey, *%key_toggle_norecoil%, toggle_norecoil
HotKey, *%key_toggle_autofire%, toggle_autofire
HotKey, *%key_increase_norecoil_amount%, increase_norecoil_amount
HotKey, *%key_decrease_norecoil_amount%, decrease_norecoil_amount
HotKey, *%key_hold_trigger%, hold_trigger

return

SENSCHANGED:

GuiControlGet, SENSITIVITY
sensitivity := SENSITIVITY
modifier := 2.52 / sensitivity

return

hold_trigger:

MouseGetPos, spotX, spotY
spotX := spotX + offsetX
spotY := spotY + offsetY

While GetKeyState(key_hold_trigger, "P"){
	if(previouslyTrigger){
		PixelGetColor, color, %spotX%, %spotY%, RGB
		splitColor(color, r1, g1, b1)
		splitColor(lastColor, r2, g2, b2)
		if((r1 > r2 + tolerance || r1 < r2 - tolerance) || (g1 > g2 + tolerance || g1 < g2 - tolerance) || (b1 > b2 + tolerance || b1 < b2 - tolerance)){
			Sleep %trigger_delay%
			Random, tempRand, 30, 50
			Click down
			Sleep %tempRand%
			Click up
		}
		lastColor := color
	}else{
		PixelGetColor, lastColor, %spotX%, %spotY%, RGB
		previouslyTrigger := true
	}
	Sleep 20
}
previouslyTrigger := false

return

shoot:

GuiControlGet, NORECOILAMT
if(noRecoil && autofire){
	While GetKeyState(key_shoot, "P"){
		Random, tempRand, 30, 50
		Click down
		Sleep %tempRand%
		Click up
		if(firstShotRestTime > firstShotRestTimeMax){
			mouseXY(0, NORECOILAMT)
			Random, tempRand, 10, 20
			Sleep %tempRand%
		}else{
			firstShotRestTime += 1
			Random, tempRand, 10, 20
			Sleep %tempRand%
		}
	}
}else if(noRecoil){
	Click down
	if(weapon == 1)
		Sleep 50
	if(weapon == 2)
		Sleep 15
	if(weapon == 3)
		Sleep 15
	if(weapon == 4)
		Sleep 10
	if(weapon == 5)
		Sleep 30
	if(weapon == 6)
		Sleep 15
	previouslyCrouched := GetKeyState(key_crouch, "P")
	While GetKeyState(key_shoot, "P"){
		if((only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P"))){
		}
		if((GetKeyState(key_crouch, "P") && only_norecoil_when_crouched) || (!only_norecoil_when_crouched)){
			if(weapon == 1)
			{ ; For AK-47
				pattern_current_xy := ak_pattern%A_Index%
				StringSplit, current_xy, pattern_current_xy, `,
				current_xy1 := current_xy1 / ak47_offset * modifier
				current_xy2 := current_xy2 / ak47_offset * modifier
				
				;average current and next points
				;middlePointX := current_xy1 / 4
				;middlePointY := current_xy2 / 4
				
				if(29 == A_Index){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
				}else{
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / ak47_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / ak47_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / ak47_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / ak47_waitoffset
				}
			}else if(weapon == 2)
			{ ; For M4A4
				pattern_current_xy := m4_pattern%A_Index%
				StringSplit, current_xy, pattern_current_xy, `,
				if(InStr("1;7;8;9;10;11;12;13;14;19;20;21;22;23;24", A_Index)){
					current_xy1 := current_xy1 / m4_offset2 * modifier
					current_xy2 := current_xy2 / m4_offset2 * modifier
				}else{
					current_xy1 := current_xy1 / m4_offset * modifier
					current_xy2 := current_xy2 / m4_offset * modifier
				}
				
				;average current and next points
				;middlePointX := current_xy1 / 3
				;middlePointY := current_xy2 / 3
				
				if(InStr("1;7;8;9;10;11;12;13;14;19;20;21;22;23;24", A_Index)){
					waitTime := 88 / m4_waitoffset2
				}else{
					waitTime := 87 / m4_waitoffset
				}
				
				if(InStr("4", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 + 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 + 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 + 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 + 5)
					Sleep %waitTime%
				}else if(InStr("7", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("8", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 3, current_xy2 - 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("9", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
				}else if(InStr("10", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2 - 10)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("11", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("13", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("14", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
				}else if(InStr("15", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 10, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("16", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 10, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("17", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 3, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("18", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 10, current_xy2)
					Sleep %waitTime%
				}else if(InStr("19", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 10, current_xy2 + 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 10, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("23", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 20, current_xy2 + 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("24", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 10, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("29", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
				}else{
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}
			}else if(weapon == 3){ ;M4A1-S
				pattern_current_xy := m4a1s_pattern%A_Index%
				StringSplit, current_xy, pattern_current_xy, `,
				current_xy1 := current_xy1 / m4a1s_offset * modifier
				current_xy2 := current_xy2 / m4a1s_offset * modifier
				
				;average current and next points
				;middlePointX := current_xy1 / 3
				;middlePointY := current_xy2 / 3
				
				if(InStr("1", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 3)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 2)
					Sleep 99 / m4a1s_waitoffset
				}else if(InStr("6", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
				}else if(InStr("7", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 2)
					Sleep 99 / m4a1s_waitoffset
				}else if(InStr("9", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
				}else if(InStr("11;13", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
				}else if(InStr("14", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 2, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 2, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
				}else{
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep 99 / m4a1s_waitoffset
				}
			}else if(weapon == 4){ ;GALIL AR
				pattern_current_xy := galil_pattern%A_Index%
				StringSplit, current_xy, pattern_current_xy, `,
				current_xy1 := current_xy1 / galil_waitoffset * modifier
				current_xy2 := current_xy2 / galil_waitoffset * modifier
				
				;average current and next points
				;middlePointX := current_xy1 / 3
				;middlePointY := current_xy2 / 3
				
				if(16 == A_Index){
					waitTime := 50 / galil_waitoffset
				}else{
					waitTime := 90 / galil_waitoffset
				}
				
				if(InStr("4", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 + 2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 + 2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 + 2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("9", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 7, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 7, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 7, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 7, current_xy2)
					Sleep %waitTime%
				}else if(InStr("10", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("11", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 3)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 3)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 3)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 - 3)
					Sleep %waitTime%
				}else if(InStr("15", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2 + 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
				}else if(InStr("16", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2 + 10)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("17;18", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 + 3, current_xy2)
					Sleep %waitTime%
				}else if(InStr("19", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2 + 5)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("20;21", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}else if(InStr("25;26", A_Index)){
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 8, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 8, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1 - 5, current_xy2)
					Sleep %waitTime%
				}else{
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
					if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
						mouseXY(current_xy1, current_xy2)
					Sleep %waitTime%
				}
			}else if(weapon == 5){ ;FAMAS
				pattern_current_xy := famas_pattern%A_Index%
				StringSplit, current_xy, pattern_current_xy, `,
				current_xy1 := current_xy1 / famas_waitoffset * modifier
				current_xy2 := current_xy2 / famas_waitoffset * modifier
				
				;average current and next points
				;middlePointX := current_xy1 / 3
				;middlePointY := current_xy2 / 3
				
				if(InStr("12", A_Index)){
					waitTime := 87 / famas_waitoffset
				}if(InStr("18;20;22", A_Index)){
					waitTime := 80 / famas_waitoffset
				}if(InStr("21", A_Index)){
					waitTime := 84 / famas_waitoffset
				}else{
					waitTime := 88 / famas_waitoffset
				}
				
				if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
					mouseXY(current_xy1, current_xy2)
				Sleep %waitTime%
				if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
					mouseXY(current_xy1, current_xy2)
				Sleep %waitTime%
				if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
					mouseXY(current_xy1, current_xy2)
				Sleep %waitTime%
				if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
					mouseXY(current_xy1, current_xy2)
				Sleep %waitTime%
			}else if(weapon == 6){ ;UMP-45
				pattern_current_xy := ump45_pattern%A_Index%
				StringSplit, current_xy, pattern_current_xy, `,
				if(InStr("18;21", A_Index)){
					current_xy1 := current_xy1 / ump45_offset2 * modifier
					current_xy2 := current_xy2 / ump45_offset2 * modifier
				}else{
					current_xy1 := current_xy1 / ump45_offset * modifier
					current_xy2 := current_xy2 / ump45_offset * modifier
				}
				
				;average current and next points
				;middlePointX := current_xy1 / 3
				;middlePointY := current_xy2 / 3
				
				if(InStr("18;21", A_Index)){
					waitTime := 85 / ump45_waitoffset2
				}else{
					waitTime := 90 / ump45_waitoffset
				}
				
				if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
					mouseXY(current_xy1, current_xy2)
				Sleep %waitTime%
				if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
					mouseXY(current_xy1, current_xy2)
				Sleep %waitTime%
				if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
					mouseXY(current_xy1, current_xy2)
				Sleep %waitTime%
				if(!(only_norecoil_when_crouched && !previouslyCrouched && GetKeyState(key_crouch, "P")))
					mouseXY(current_xy1, current_xy2)
				Sleep %waitTime%
			}else if(weapon == 0){ ;Generic
				if(firstShotRestTime > firstShotRestTimeMax){
					if(firstShotRecoilTime > firstShotRecoilTimeMax){
						mouseXY(0, NORECOILAMT)
						Random, tempRand, 200, 220
						Sleep %tempRand%
					}else{
						firstShotRecoilTime += 1
						mouseXY(0, NORECOILAMT * 2)
						Random, tempRand, 20, 40
						Sleep %tempRand%
					}
				}else{
					firstShotRestTime += 1
					Random, tempRand, 20, 40
					Sleep %tempRand%
				}
			}
		}
	}
	Click up
}else if(autofire){
	While GetKeyState(key_shoot, "P"){
		Random, tempRand, 30, 50
		Click down
		Sleep %tempRand%
		Click up
		Sleep %tempRand%
	}
}else{
	Click down
	KeyWait, %key_shoot%
	Click up
}

firstShotRecoilTime := 0
firstShotRestTime := 0

return

pause_script:

Suspend

return

generic_norecoil:

weapon := 0
if(show_gui)
	GuiControl, , WEAPONRECOILTEXT, %key_generic_norecoil% - %key_ump45_norecoil%: Default
if(show_tooltip){
	Tooltip, Default
	SetTimer, ResetTooltip, 500
}

return

ak47_norecoil:

weapon := 1
if(show_gui)
	GuiControl, , WEAPONRECOILTEXT, %key_generic_norecoil% - %key_ump45_norecoil%: AK-47
if(show_tooltip){
	Tooltip, AK-47
	SetTimer, ResetTooltip, 500
}

return


m4a4_norecoil:

weapon := 2
if(show_gui)
	GuiControl, , WEAPONRECOILTEXT, %key_generic_norecoil% - %key_ump45_norecoil%: M4A4
if(show_tooltip){
	Tooltip, M4A4
	SetTimer, ResetTooltip, 500
}

return

m4a1s_norecoil:

weapon := 3
if(show_gui)
	GuiControl, , WEAPONRECOILTEXT, %key_generic_norecoil% - %key_ump45_norecoil%: M4A1-S
if(show_tooltip){
	Tooltip, M4A1-S
	SetTimer, ResetTooltip, 500
}

return

galil_norecoil:

weapon := 4
if(show_gui)
	GuiControl, , WEAPONRECOILTEXT, %key_generic_norecoil% - %key_ump45_norecoil%: Galil AR
if(show_tooltip){
	Tooltip, Galil AR
	SetTimer, ResetTooltip, 500
}

return

famas_norecoil:

weapon := 5
if(show_gui)
	GuiControl, , WEAPONRECOILTEXT, %key_generic_norecoil% - %key_ump45_norecoil%: FAMAS
if(show_tooltip){
	Tooltip, FAMAS
	SetTimer, ResetTooltip, 500
}

return

ump45_norecoil:

weapon := 6
if(show_gui)
	GuiControl, , WEAPONRECOILTEXT, %key_generic_norecoil% - %key_ump45_norecoil%: Ump-45
if(show_tooltip){
	Tooltip, Ump-45
	SetTimer, ResetTooltip, 500
}

return

increase_norecoil_amount:

if(show_gui){
	GuiControlGet, NORECOILAMT
	NORECOILAMT := NORECOILAMT + 1
	GuiControl, , NORECOILAMT, %NORECOILAMT%
}
if(show_tooltip){
	Tooltip, Amount: %NORECOILAMT%
	SetTimer, ResetTooltip, 500
}

return

decrease_norecoil_amount:

if(show_gui){
	GuiControlGet, NORECOILAMT
	NORECOILAMT := NORECOILAMT - 1
	GuiControl, , NORECOILAMT, %NORECOILAMT%
}
if(show_tooltip){
	Tooltip, Amount: %NORECOILAMT%
	SetTimer, ResetTooltip, 500
}

return

toggle_norecoil:

noRecoil := !noRecoil
if(noRecoil){
	if(show_gui){
		GuiControl, , NORECOILTEXT, %key_toggle_norecoil% - toggle: On
		Gui, Font, cGreen
		GuiControl, Font, NORECOILTEXT
	}
	if(show_tooltip){
		Tooltip, No Recoil On
		SetTimer, ResetTooltip, 500
	}
}else{
	if(show_gui){
		GuiControl, , NORECOILTEXT, %key_toggle_norecoil% - toggle: Off
		Gui, Font, cRed
		GuiControl, Font, NORECOILTEXT
	}
	if(show_tooltip){
		Tooltip, No Recoil Off
		SetTimer, ResetTooltip, 500
	}
}

return

toggle_autofire:

autofire := !autofire
if(autofire){
	if(show_gui){
		GuiControl, , AUTOFIRETEXT, %key_toggle_autofire% - toggle: On
		Gui, Font, cGreen
		GuiControl, Font, AUTOFIRETEXT
	}
	if(show_tooltip){
		Tooltip, Autofire On
		SetTimer, ResetTooltip, 500
	}
}else{
	GuiControl, , AUTOFIRETEXT, %key_toggle_autofire% - toggle: Off
	Gui, Font, cRed
	GuiControl, Font, AUTOFIRETEXT
	if(show_tooltip){
		Tooltip, Autofire Off
		SetTimer, ResetTooltip, 500
	}
}

return

;Functions

ResetTooltip:

Tooltip,

return

mouseXY(x, y)
{
	if(invert_y_axis)
		DllCall("mouse_event",uint,1,int,x,int,-y,uint,0,int,0)
	else
		DllCall("mouse_event",uint,1,int,x,int,y,uint,0,int,0)
}

splitColor(color, ByRef r, ByRef g, ByRef b)
{
    r := color >> 16 & 0xFF
    g := color >> 8 & 0xFF
    b := color & 0xFF
}

GuiClose:

FileDelete, %A_WorkingDir%\script_save.txt
FileAppend, %sensitivity%, %A_WorkingDir%\script_save.txt

ExitApp

return