#NoTrayIcon
#RequireAdmin
#region ;**** ?????????? ACNWrapper_GUI ****
#PRE_Icon=usb.ico
#PRE_Compression=4
#PRE_UseX64=n
#PRE_Res_Fileversion=0.0.0.101
#PRE_Res_Fileversion_AutoIncrement=y
#PRE_Res_requestedExecutionLevel=None
#endregion ;**** ?????????? ACNWrapper_GUI ****
#region ACN????????????(???????)
;#PRE_Res_Field=AutoIt Version|%AutoItVer%		;??????????
;#PRE_Run_Tidy=                   				;???????
;#PRE_Run_Obfuscator=      						;???????
;#PRE_Run_AU3Check= 							;?????
;#PRE_Run_Before= 								;?????
;#PRE_Run_After=								;?????
;#PRE_UseX64=n									;???64???????
;#PRE_Compile_Both								;???????????
#endregion ACN????????????(???????)
#cs ?????????????????????????????????????
	
	Au3 ??:
	???????:
	???????:
	QQ/TM:
	?????:
	???????:
	
#ce ???????????????????????????????
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPIFiles.au3>
#include <ComboConstants.au3>
#include <GUIListView.au3>
#include <ListViewConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <ProgressConstants.au3>
#include <GuiImageList.au3>
#include <Process.au3>
#include <String.au3>
#region ### START Koda GUI section ### Form=
$USBROM = GUICreate("USB Write VHD File Tools", 454, 210, 228, 114)
$Label1 = GUICtrlCreateLabel("Select Device:", 6, 16, 160, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Comment:", 6, 96, 160, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Boot Server IP:", 8, 56, 160, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
;$Label3 = GUICtrlCreateLabel("Boot Mode:", 8, 93, 160, 24)
GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("wait", 8, 185, 150, 24)
$UsbStorage = GUICtrlCreateButton("Start", 302, 170, 131, 33)
$update = GUICtrlCreateButton("Update BOOTLoader", 150, 170, 131, 33)
$Refresh = GUICtrlCreateButton("Refresh", 400, 8, 50, 24)
;$UsbHDStorage = GUICtrlCreateButton("USB HD Storage", 200, 150, 111, 33)
$IPAddress1 = GUICtrlCreateInput("192.168.8.35", 168, 56, 265, 25)
$Comment = GUICtrlCreateInput("", 168, 96, 265, 25)
$Combo2 = GUICtrlCreateCombo("", 168, 8, 225, 32, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
;$Combo3 = GUICtrlCreateCombo("Syslinux", 168, 93, 265, 32, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
$progressbar1 = GUICtrlCreateProgress(10, 140, 428, 20)
$tempdir = @TempDir & "\boot"
DirCreate($tempdir)
$tempy = $tempdir & "\1.txt"
$temp2 = $tempdir & "\2.txt"
$TempEfi = $tempdir & "\Tmp_Efi"
$FileTmp = $tempdir & "\disk_all.txt"
$FileTmppart = $tempdir & "\part.txt"
DirCreate($TempEfi)
DirCreate($TempEfi & "\EFI\")
DirCreate($TempEfi & "\EFI\boot")
FileInstall("wget.exe", $tempdir & "\wget.exe", 1)
FileInstall("bootia32.efi", $TempEfi & "/EFI/boot/bootia32.efi", 1)
;FileInstall("bootx64.cfg", $TempEfi & "/EFI/boot/bootx64.cfg", 1)
FileInstall("bootx64.efi", $TempEfi & "/EFI/boot/bootx64.efi", 1)
;FileInstall("bootx86.cfg", $TempEfi & "/EFI/boot/bootx86.cfg", 1)
FileInstall("bin.zip", $tempdir & "\bin.zip", 1)
FileInstall("7z.exe", $tempdir & "\7z.exe", 1)
FileInstall("7z.dll", $tempdir & "\7z.dll", 1)
FileInstall("pe.fba", $tempdir & "\pe.fba", 1)
;FileInstall("bootloader.lst", $tempdir & "\bootloader.lst", 1)
_RunDOS($tempdir & "\7z.exe x " & $tempdir & "\bin.zip -y -aos -o" & $tempdir)
Local $partassist = $tempdir & "\PartAssist.exe "
Local $fbinst = $tempdir & "\fbinst.exe "

Global $Vol = Null
Global 	$MenuFile = $tempdir & "\bootloader.lst"


GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

_GetDiskAll()


$guiserverip = RegRead("HKEY_CURRENT_USER\Software\osvusbbootloader", "serverip")
$guicmd = RegRead("HKEY_CURRENT_USER\Software\osvusbbootloader", "cmd")
If $guiserverip <> "" And $guiserverip <> "0" And StringInStr($guiserverip, ".") Then
	GUICtrlSetData($IPAddress1, $guiserverip)
	;GUICtrlSetData($Comment, $guicmd)
EndIf








While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			_WriteConfig()
			_exit()
			
		Case $UsbStorage
			_WriteConfig()
			_comment("")
			_Clean_And_Write()
		Case $update
			_WriteConfig()
			_comment(GUICtrlRead($Comment))
			update()
		Case $Refresh
			_GetDiskAll()
	EndSwitch
WEnd


Func GetLocalDisk()
	Global $Data, $Drive = DriveGetDrive('all')
	Global $List[10]
	For $i = 0 To UBound($Drive) - 1
		$List[$i] = ''
	Next
	If IsArray($Drive) Then
		For $i = 1 To $Drive[0]
			$Data = _WinAPI_GetDriveNumber($Drive[$i])
			If IsArray($Data) Then
				
				_ArrayDisplay($Data)
				_ArrayDisplay($List)
				$List[$Data[1]] &= StringUpper($Drive[$i]) & ' '
				
			EndIf
		Next
	EndIf
	For $i = 0 To UBound($Drive) - 1
		If $List[$i] Then
			GUICtrlSetData($Combo2, 'hd' & $i & ' => ' & $List[$i])
		EndIf
	Next
EndFunc   ;==>GetLocalDisk


Func _call($txt)
	GUICtrlSetData($Label2, $txt)
EndFunc   ;==>_call


Func _exit()
	DirRemove($tempdir, 1)
	FileDelete($tempy)
	FileDelete($temp2)
	ConsoleWrite(DirRemove($tempdir, 1))
	Exit
EndFunc   ;==>_exit


Func _Clean_And_Write()
	$ok = MsgBox(4, "Clean Disk?", "Clean disk and write to USB?", 0)
	If $ok = 6 Then
		GUICtrlSetData($progressbar1, 10)
		$serverip = GUICtrlRead($IPAddress1)
		DirCreate($tempdir & "\loader\")
		$id = GUICtrlRead($Combo2)
		$serverip = GUICtrlRead($IPAddress1)
		If $id = "" Then
			MsgBox(0, "Error", "No such USB Storage")
		Else
			$HD = StringReplace(StringReplace(StringReplace(StringLeft($id, 5), "(", ""), ")", ""), "hd", "")
			$aHD = StringReplace(StringReplace(StringLeft($id, 5), "(", ""), ")", "")
			$Vol = _ReadPartitioned($HD)
			If $Vol = Null Then
				MsgBox(0, "Error", "USB is not partitioned")
				Exit
			EndIf
			ConsoleWrite("aHD: " & $aHD & @CRLF)
			ConsoleWrite("HD: " & $HD & @CRLF)
			ConsoleWrite("VOL: " & $Vol & @CRLF)
			_call("fbinst reset (format --raw)")
			RunWait($fbinst & $Vol & " format --raw", $tempdir, @SW_HIDE)
			Do
				Sleep(1000)
			Until ProcessExists("fbinst.exe") = 0
			Sleep(2000)
			_call("Create UD (format --fat32)")
			RunWait($fbinst & $Vol & " format --fat32 --force --align --primary 8M --extended 512m", $tempdir, @SW_HIDE)
			ConsoleWrite($fbinst & $Vol & " format --fat32 --force --align --primary 8M --extended 512m" & @CRLF)
			Do
				Sleep(1000)
			Until ProcessExists("fbinst.exe") = 0
			Sleep(3000)
			GUICtrlSetData($progressbar1, 20)
			_call("Dwonloading BOOTLoader ...")
			;_RunDOS($tempdir & "\wget -t 1 http://" & $serverip & ":7012/core.gz  -O " & $tempdir & "\loader\" & "core.gz ")
			 FileCopy(@ScriptDir &"\data\bootloader\core.gz",$tempdir & "\loader\" & "core.gz ",1)
			 If FileGetSize($tempdir & "\loader\" & "core.gz") = 0 Then 
			 MsgBox (0,"Error","Downloading Error") 
			 Exit
			 EndIf
			;_RunDOS($tempdir & "\wget -t 1  http://" & $serverip & ":7012/vmlinuz  -O " & $tempdir & "\loader\" & "vmlinuz ")
			 FileCopy(@ScriptDir & "\data\bootloader\vmlinuz",$tempdir & "\loader\" & "vmlinuz ",1)
			;_RunDOS($tempdir & "\wget -t 1 http://" & $serverip & ":7012/corex64.gz  -O " & $tempdir & "\loader\" & "corex64.gz ")
			 FileCopy(@ScriptDir & "\data\bootloader\corex64.gz",$tempdir & "\loader\" & "corex64.gz ",1)
			;_RunDOS($tempdir & "\wget -t 1 http://" & $serverip & ":7012/vmlinuzx64  -O " & $tempdir & "\loader\" & "vmlinuzx64 ")
			FileCopy(@ScriptDir & "\data\bootloader\vmlinuzx64",$tempdir & "\loader\" & "vmlinuzx64 ",1)
			_call("Create DATA ")
			GUICtrlSetData($progressbar1, 30)
			_RunDOS($partassist & "/fmt:" & StringStripWS(StringReplace($Vol, ":", ""), 8) & " /fs:ntfs /label:Data")
			_call("Format UD ")
			_RunDOS($partassist & "/resize:" & StringStripWS(StringReplace($Vol, ":", ""), 8) & " /reduce-right:520")
			_call("Format EFI ")
			_RunDOS($partassist & " /hd:" & $HD & " /cre /pri /size:auto  /end /fs:fat16  /align /label:EFI")
			_RunDOS($partassist & " /setact:0 /hd:" & $HD)
			_call("Copy Files  ")
			GUICtrlSetData($progressbar1, 50)
			_RunDOS($fbinst & $Vol & " load " & $tempdir & "\pe.fba")
			_RunDOS($fbinst & $Vol & " add --extended " & $tempdir & "/EFI/core.gz" & "  EFI/core.gz")
			RunWait($fbinst & $Vol & " add --extended " & "loader/core.gz " & "  loader/core.gz", $tempdir, @SW_HIDE)
			RunWait($fbinst & $Vol & " add --extended " & "loader/corex64.gz " & "  loader/corex64.gz", $tempdir, @SW_HIDE)
			RunWait($fbinst & $Vol & " add --extended " & "loader/vmlinuz " & "  loader/vmlinuz", $tempdir, @SW_HIDE)
			RunWait($fbinst & $Vol & " add --extended " & "loader/vmlinuzx64 " & "  loader/vmlinuzx64", $tempdir, @SW_HIDE)
			RunWait($fbinst & $Vol & " add --extended " & "bootloader.lst " & "  bootloader.lst", $tempdir, @SW_HIDE)
			GUICtrlSetData($progressbar1, 80)
			FileMove($tempdir & "/loader/*", $TempEfi & "/EFI/", 8)
			_RunDOS($partassist & " /hd:" & $HD & " /whide:1 /src:" & $TempEfi)
			ConsoleWrite(DirCreate($Vol & "/BOOT") & @CRLF)
			ConsoleWrite(DirCreate($Vol & "/VHD") & @CRLF)
			ConsoleWrite($Vol & "/BOOT" & @CRLF)
			;_RunDOS($tempdir & "\wget -t 1  http://" & $serverip & ":7012/rom/disk.zip  -O " & $Vol & "/BOOT/disk.zip")
			FileCopy(@ScriptDir & "\data\menu\disk.zip",$Vol & "/BOOT/disk.zip",1)
			_call("Copy VHD Files ... ")
			;DirCopy(@ScriptDir & "\data\vhd",$Vol & "/VHD/",1)
			Run(@ComSpec & " /c " & 'xcopy /E /C /H /Y  ' & '"' & @ScriptDir & "\data\vhd"   & '"  ' &  '"' &$Vol & "/VHD" &  '"', "",@SW_HIDE)
			;MsgBox(0,"test",@ComSpec & " /c " & 'xcopy /E /C /H /Y ' & '"' & @ScriptDir & "\data\vhd"   & '"  ' &  '"' &$Vol & "/VHD/" &  '"')
			;FileWrite("c:\test.log",@ComSpec & " /c " & 'xcopy /E /C /H /Y  ' & '"' & @ScriptDir & "\data\vhd"   & '"  ' &  '"' &$Vol & "/VHD" &  '"')
			Do
				Sleep(1000)
			Until ProcessExists("xcopy.exe") = 0
			
			GUICtrlSetData($progressbar1, 100)
			_call("Complete ")
		EndIf
	EndIf
EndFunc   ;==>_Clean_And_Write






Func update()
	GUICtrlSetData($progressbar1, 10)
	$serverip = GUICtrlRead($IPAddress1)
	DirCreate($tempdir & "\loader\")
	$id = GUICtrlRead($Combo2)
	$serverip = GUICtrlRead($IPAddress1)
	If $id = "" Then
		MsgBox(0, "Error", "No such USB Storage")
	Else
		
		$HD = StringReplace(StringReplace(StringReplace(StringLeft($id, 5), "(", ""), ")", ""), "hd", "")
		$aHD = StringReplace(StringReplace(StringLeft($id, 5), "(", ""), ")", "")
		$Vol = _ReadPartitioned($HD)
		
		If $Vol = Null Then
			MsgBox(0, "Error", "USB is not partitioned")
			Exit
		EndIf
		
		ConsoleWrite("aHD: " & $aHD & @CRLF)
		ConsoleWrite("HD: " & $HD & @CRLF)
		ConsoleWrite("VOL: " & $Vol & @CRLF)
		_call("Dwonloading BOOTLoader ...")
		_RunDOS($tempdir & "\wget -t 1 http://" & $serverip & ":7012/core.gz  -O " & $tempdir & "\loader\" & "core.gz ")
			 If FileGetSize($tempdir & "\loader\" & "core.gz") = 0 Then 
			 MsgBox (0,"Error","Downloading Error") 
			 Exit
			 EndIf
		_RunDOS($tempdir & "\wget -t 1 http://" & $serverip & ":7012/vmlinuz  -O " & $tempdir & "\loader\" & "vmlinuz ")
		_RunDOS($tempdir & "\wget -t 1 http://" & $serverip & ":7012/corex64.gz  -O " & $tempdir & "\loader\" & "corex64.gz ")
		_RunDOS($tempdir & "\wget -t 1 http://" & $serverip & ":7012/vmlinuzx64  -O " & $tempdir & "\loader\" & "vmlinuzx64 ")
		GUICtrlSetData($progressbar1, 50)
		_RunDOS($fbinst & $Vol & " add --extended " & $tempdir & "/EFI/core.gz" & "  EFI/core.gz")
		RunWait($fbinst & $Vol & " add --extended " & "loader/core.gz " & "  loader/core.gz", $tempdir, @SW_HIDE)
		RunWait($fbinst & $Vol & " add --extended " & "loader/corex64.gz " & "  loader/corex64.gz", $tempdir, @SW_HIDE)
		RunWait($fbinst & $Vol & " add --extended " & "loader/vmlinuz " & "  loader/vmlinuz", $tempdir, @SW_HIDE)
		RunWait($fbinst & $Vol & " add --extended " & "loader/vmlinuzx64 " & "  loader/vmlinuzx64", $tempdir, @SW_HIDE)
		RunWait($fbinst & $Vol & " add --extended " & "bootloader.lst " & "  bootloader.lst", $tempdir, @SW_HIDE)
		GUICtrlSetData($progressbar1, 80)
		FileMove($tempdir & "/loader/*", $TempEfi & "/EFI/", 8)
		_RunDOS($partassist & " /hd:" & $HD & " /whide:1 /src:" & $TempEfi)
		ConsoleWrite(DirCreate($Vol & "/BOOT") & @CRLF)
		ConsoleWrite(DirCreate($Vol & "/VHD") & @CRLF)
		ConsoleWrite($Vol & "/BOOT" & @CRLF)
		_RunDOS($tempdir & "\wget -t 1 http://" & $serverip & ":7012/rom/disk.zip  -O " & $Vol & "/BOOT/disk.zip")
		GUICtrlSetData($progressbar1, 100)
		_call("Complete ")
	EndIf
	
EndFunc   ;==>update


Func _FbinstListLineDiskIndex($sLine)
	Local $a = StringRegExp(StringStripWS($sLine, 3), "^\(hd(\d+)\)", 1)
	If @error Then Return -1
	If UBound($a) < 1 Then Return -1
	Return Number($a[0])
EndFunc   ;==>_FbinstListLineDiskIndex


Func _UsbPhysicalDiskIndexMask()
	Local $s = "|"
	Local $oSvc = ObjGet("winmgmts:\\.\root\cimv2")
	If @error Or Not IsObj($oSvc) Then Return $s
	Local $oCol = $oSvc.ExecQuery("SELECT Index, InterfaceType, PNPDeviceID FROM Win32_DiskDrive")
	For $oItem In $oCol
		Local $sIf = StringUpper(StringStripWS($oItem.InterfaceType, 8))
		Local $sPnp = StringUpper(StringStripWS($oItem.PNPDeviceID, 8))
		If $sIf <> "USB" And StringLeft($sPnp, 7) <> "USBSTOR" Then ContinueLoop
		$s &= Number($oItem.Index) & "|"
	Next
	Return $s
EndFunc   ;==>_UsbPhysicalDiskIndexMask


Func _GetDiskAll()
	Global $aList
	If @error Then MsgBox(0, "Error", "Geting Local Disk Error ...")
	GUICtrlSetData($Combo2, "")
	Local $sUsbMask = _UsbPhysicalDiskIndexMask()
	RunWait("cmd /c " & $fbinst & " --list > " & $FileTmp, $tempdir, @SW_HIDE)
	If Not FileExists($FileTmp) Then Return
	Local $file_tmp = FileOpen($FileTmp, 0)
	If $file_tmp = -1 Then Return
	While 1
		Local $HDline = FileReadLine($file_tmp)
		If @error = -1 Then ExitLoop
		Local $iDisk = _FbinstListLineDiskIndex($HDline)
		If $iDisk < 0 Then ContinueLoop
		If Not StringInStr($sUsbMask, "|" & $iDisk & "|") Then ContinueLoop
		GUICtrlSetData($Combo2, $HDline)
	WEnd
	FileClose($file_tmp)
EndFunc   ;==>_GetDiskAll




Func _ReadPartitioned($hdName)
	_RunDOS($partassist & " /list:" & $hdName & " /out:" & $FileTmppart)
	$File_Tmppart = FileOpen($FileTmppart, 0)
	Global $Vol = Null
	While 1
		$partline = FileReadLine($File_Tmppart)
		If @error = -1 Then ExitLoop
		If $Vol <> Null Then ExitLoop
		If $partline <> StringInStr($partline, ":") Then
			If $partline = StringIsAlpha($partline) Then
				$partline = StringStripWS($partline, 8)
				$partline = StringSplit($partline, "|")
				;MsgBox (0,"test",$partline[2])
				$Vol = $partline[2]
			EndIf
		EndIf
	WEnd
	FileClose($File_Tmppart)
	
	ConsoleWrite("PartText:" & $Vol & @CRLF)
	If $Vol <> Null Then
		Return $Vol
	Else
		Return 0
	EndIf
EndFunc   ;==>_ReadPartitioned



Func _WriteConfig()
	$serverip = GUICtrlRead($IPAddress1)
	$cmd = GUICtrlRead($Comment)
	RegWrite("HKEY_CURRENT_USER\Software\osvusbbootloader", "serverip", "REG_SZ", $serverip)
	RegWrite("HKEY_CURRENT_USER\Software\osvusbbootloader", "cmd", "REG_SZ", $cmd)
EndFunc   ;==>_WriteConfig



Func _comment($cmdtext)
	Local $menufiletext[11]
	$menufiletext[0] = "pxe detect"
	$menufiletext[1] = "configfile"
	$menufiletext[2] = "default 1"
	$menufiletext[3] = "timeout 15"
	$menufiletext[4] = "title BOOTLoader ..."
	$menufiletext[5] = "kernel /loader/vmlinuz loglevel=3  vga=791 " & $cmdtext
	$menufiletext[6] = "initrd /loader/core.gz"
	$menufiletext[7] = " "
	$menufiletext[8] = "title BOOTLoaderX64 ..."
	$menufiletext[9] = "kernel /loader/vmlinuzx64 loglevel=3  vga=791 " & $cmdtext
	$menufiletext[10] = "initrd /loader/corex64.gz"
	_FileWriteFromArray($MenuFile, $menufiletext, 1)
	
	
	Local $menuefix86filetext[11]
	$menuefix86filetext[0] = "set timeout=0"
	$menuefix86filetext[1] = "set lang=zh_CN"
	$menuefix86filetext[2] = "set pager=0"
	$menuefix86filetext[3] = "insmod biosdisk"
	$menuefix86filetext[4] = "insmod ext2"
	$menuefix86filetext[5] = "insmod part_msdos"
	$menuefix86filetext[6] = "insmod all_video"
	$menuefix86filetext[7] = "menuentry 'UEFI BOOTLoaderIA32 ...' {"
	$menuefix86filetext[8] = "linux	/EFI/vmlinuz loglevel=3   boottype=efi  vga=791   " & $cmdtext
	$menuefix86filetext[9] = "initrd	/EFI/core.gz"
	$menuefix86filetext[10] = "}"
	_FileWriteFromArray($TempEfi & "/EFI/boot/bootx86.cfg", $menuefix86filetext, 1)
	
	
	Local $menuefix64filetext[11]
	$menuefix64filetext[0] = "set timeout=0"
	$menuefix64filetext[1] = "set lang=zh_CN"
	$menuefix64filetext[2] = "set pager=0"
	$menuefix64filetext[3] = "insmod biosdisk"
	$menuefix64filetext[4] = "insmod ext2"
	$menuefix64filetext[5] = "insmod part_msdos"
	$menuefix64filetext[6] = "insmod all_video"
	$menuefix64filetext[7] = "menuentry 'UEFI BOOTLoaderX64 ...' {"
	$menuefix64filetext[8] = "linux	/EFI/vmlinuzx64 loglevel=3   boottype=efi  vga=791   " & $cmdtext
	$menuefix64filetext[9] = "initrd	/EFI/corex64.gz"
	$menuefix64filetext[10] = "}"
	_FileWriteFromArray($TempEfi & "/EFI/boot/bootx64.cfg", $menuefix64filetext, 1)

	
EndFunc   ;==>_comment





