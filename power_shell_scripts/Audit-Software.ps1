# Audit-Software.ps1
# Скрипт для сравнения установленного ПО со списком разрешенного

param(
    [string]$AllowedListPath = ".\allowed.txt",
    [string]$ReportPath = ".\SoftwareAuditReport.csv"
)

# Кодировка для русского языка
chcp 65001 | Out-Null

Write-Host "=== Аудит установленного программного обеспечения ===" -ForegroundColor Cyan

# 1. Функция получения списка установленных программ (из реестра)
function Get-InstalledSoftware {
    $installed = @()
    
    # Пути реестра, где хранятся данные об установленных программах
    $paths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    
    foreach ($path in $paths) {
        try {
            $items = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
            foreach ($item in $items) {
                # Фильтруем: берем только программы с DisplayName и не системные обновления
                if ($item.DisplayName -and $item.DisplayName -notmatch "Update for|Security Update|Hotfix|KB\d+") {
                    $installed += [PSCustomObject]@{
                        DisplayName    = $item.DisplayName.Trim()
                        DisplayVersion = $item.DisplayVersion
                        Publisher      = $item.Publisher
                        UninstallString = $item.UninstallString
                    }
                }
            }
        }
        catch {}
    }
    
    # Убираем дубликаты по имени
    return $installed | Group-Object DisplayName | ForEach-Object { $_.Group[0] }
}

# 2. Загрузка разрешенного списка из текстового файла
function Load-AllowedList {
    if (-not (Test-Path $AllowedListPath)) {
        Write-Error "Файл с разрешенным ПО не найден: $AllowedListPath"
        exit 1
    }
    
    $allowed = Get-Content $AllowedListPath -Encoding UTF8 | Where-Object { $_.Trim() -ne "" } | ForEach-Object { $_.Trim() }
    Write-Host "Загружено разрешенных записей: $($allowed.Count)" -ForegroundColor Green
    return $allowed
}

# 3. Функция проверки, входит ли программа в разрешенный список
function Test-IsAllowed {
    param(
        [string]$ProgramName,
        [string[]]$AllowedList
    )
    
    $normalizedName = $ProgramName -replace "™|®|\(.*?\)|\[.*?\]", "" -replace "\s+", " " -replace " 64-bit| 32-bit", "" -replace " x64| x86", "" -replace " for Windows", ""
    $normalizedName = $normalizedName.Trim()
    
    foreach ($allowed in $AllowedList) {
        # Проверяем точное совпадение или вхождение
        if ($normalizedName -eq $allowed) {
            return $true
        }
        if ($normalizedName -like "*$allowed*" -and $allowed.Length -gt 5) {
            return $true
        }
        if ($allowed -like "*$normalizedName*" -and $normalizedName.Length -gt 5) {
            return $true
        }
    }
    return $false
}

# 4. Основная логика
Write-Host "`n[1/4] Получение списка установленного ПО..." -ForegroundColor Yellow
$installed = Get-InstalledSoftware
Write-Host "Найдено программ: $($installed.Count)" -ForegroundColor Green

Write-Host "`n[2/4] Загрузка разрешенного списка..." -ForegroundColor Yellow
$allowedList = Load-AllowedList

Write-Host "`n[3/4] Сравнение и анализ..." -ForegroundColor Yellow

$allowedSet = [System.Collections.Generic.HashSet[string]]::new([StringComparer]::OrdinalIgnoreCase)
foreach ($a in $allowedList) { $allowedSet.Add($a) | Out-Null }

$results = @()
$toRemove = @()

foreach ($program in $installed) {
    $name = $program.DisplayName
    $isAllowed = Test-IsAllowed -ProgramName $name -AllowedList $allowedList
    
    $results += [PSCustomObject]@{
        "Программа"     = $name
        "Версия"        = $program.DisplayVersion
        "Издатель"      = $program.Publisher
        "Разрешена?"    = $(if ($isAllowed) { "ДА" } else { "НЕТ - УДАЛИТЬ" })
    }
    
    if (-not $isAllowed) {
        $toRemove += $program
    }
}

Write-Host "`n[4/4] Сохранение отчета..." -ForegroundColor Yellow
$results | Export-Csv -Path $ReportPath -Encoding UTF8 -NoTypeInformation -UseCulture
Write-Host "Отчет сохранен: $ReportPath" -ForegroundColor Green

# 5. Вывод на экран
Write-Host "`n=== РЕЗУЛЬТАТЫ АУДИТА ===" -ForegroundColor Cyan
Write-Host "Всего установлено: $($installed.Count)"
Write-Host "Разрешено: $(($results | Where-Object { $_.'Разрешена?' -eq 'ДА' }).Count)"
Write-Host "НЕ РАЗРЕШЕНО (требует удаления): $($toRemove.Count)" -ForegroundColor Red

if ($toRemove.Count -gt 0) {
    Write-Host "`n=== СПИСОК ПРОГРАММ ДЛЯ УДАЛЕНИЯ ===" -ForegroundColor Red
    $toRemove | ForEach-Object { Write-Host "  - $($_.DisplayName)" }
    
    # Дополнительно сохраняем список на удаление
    $toRemove | Select-Object DisplayName, DisplayVersion, UninstallString | 
        Export-Csv -Path ".\ToUninstallList.csv" -Encoding UTF8 -NoTypeInformation -UseCulture
    Write-Host "`nСписок для удаления сохранен в .\ToUninstallList.csv" -ForegroundColor Yellow
}
else {
    Write-Host "`nОтлично! Неразрешенное ПО не найдено." -ForegroundColor Green
}

Write-Host "`nСкрипт завершен." -ForegroundColor Cyan