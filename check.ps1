
---

## 🟢 ЭТАП 3. Скрипт сбора доказательств `check.ps1`

Этот скрипт студент запускает на VM. Он собирает всё, что нам нужно для проверки.

```powershell
# check.ps1 - Скрипт сбора доказательств для Лабораторной №2
# Запускать на Windows Server от имени администратора

$evidenceDir = "C:\evidence"
$evidenceFile = "$evidenceDir\evidence.txt"

if (-not (Test-Path $evidenceDir)) {
    New-Item -ItemType Directory -Path $evidenceDir | Out-Null
}

"=== LAB 2 EVIDENCE ===" | Out-File $evidenceFile -Encoding UTF8

# 1. Версия ОС
"`n=== OS VERSION ===" | Out-File $evidenceFile -Append -Encoding UTF8
(Get-CimInstance Win32_OperatingSystem).Caption | Out-File $evidenceFile -Append -Encoding UTF8
(Get-CimInstance Win32_OperatingSystem).Version | Out-File $evidenceFile -Append -Encoding UTF8

# 2. Имя компьютера
"`n=== COMPUTER NAME ===" | Out-File $evidenceFile -Append -Encoding UTF8
$env:COMPUTERNAME | Out-File $evidenceFile -Append -Encoding UTF8

# 3. IP-адрес
"`n=== IP CONFIGURATION ===" | Out-File $evidenceFile -Append -Encoding UTF8
Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne "127.0.0.1" } | Format-Table -AutoSize | Out-File $evidenceFile -Append -Encoding UTF8

# 4. Служба IIS (W3SVC)
"`n=== IIS STATUS ===" | Out-File $evidenceFile -Append -Encoding UTF8
$iis = Get-Service -Name W3SVC -ErrorAction SilentlyContinue
if ($iis) {
    "IIS (W3SVC): $($iis.Status)" | Out-File $evidenceFile -Append -Encoding UTF8
} else {
    "IIS: NOT INSTALLED" | Out-File $evidenceFile -Append -Encoding UTF8
}

# 5. Роль DNS
"`n=== DNS ROLE ===" | Out-File $evidenceFile -Append -Encoding UTF8
$dns = Get-WindowsFeature -Name DNS -ErrorAction SilentlyContinue
if ($dns) {
    "DNS Installed: $($dns.Installed)" | Out-File $evidenceFile -Append -Encoding UTF8
} else {
    "DNS: CHECK FAILED" | Out-File $evidenceFile -Append -Encoding UTF8
}

# 6. Содержимое index.html
"`n=== INDEX.HTML ===" | Out-File $evidenceFile -Append -Encoding UTF8
$indexPath = "C:\inetpub\wwwroot\index.html"
if (Test-Path $indexPath) {
    Get-Content $indexPath | Out-File $evidenceFile -Append -Encoding UTF8
} else {
    "index.html NOT FOUND" | Out-File $evidenceFile -Append -Encoding UTF8
}

# 7. Проверка localhost
"`n=== HTTP TEST (localhost) ===" | Out-File $evidenceFile -Append -Encoding UTF8
try {
    $response = Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing -TimeoutSec 5
    "HTTP Status: $($response.StatusCode)" | Out-File $evidenceFile -Append -Encoding UTF8
} catch {
    "HTTP TEST FAILED: $_" | Out-File $evidenceFile -Append -Encoding UTF8
}

# 8. Список установленных ролей
"`n=== INSTALLED ROLES ===" | Out-File $evidenceFile -Append -Encoding UTF8
Get-WindowsFeature | Where-Object { $_.Installed -eq $true } | Select-Object Name, DisplayName | Format-Table -AutoSize | Out-File $evidenceFile -Append -Encoding UTF8

"`n=== END OF EVIDENCE ===" | Out-File $evidenceFile -Append -Encoding UTF8

Write-Host "✅ Evidence собран: $evidenceFile" -ForegroundColor Green
Write-Host "Скопируйте его в репозиторий (папка evidence/)." -ForegroundColor Yellow