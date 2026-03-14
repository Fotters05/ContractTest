# PostgreSQL Database Backup Script
# Creates backup of MPT2512 database

$ErrorActionPreference = "Stop"

# Connection parameters
$DB_HOST = "26.242.232.93"
$DB_PORT = "5432"
$DB_NAME = "MPT2512"
$DB_USER = "postgres"
$DB_PASSWORD = "1"

# Backup filename with timestamp
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = "backup_${DB_NAME}_${timestamp}.sql"

Write-Host "Creating database backup..." -ForegroundColor Cyan
Write-Host "Database: $DB_NAME" -ForegroundColor Yellow
Write-Host "Host: $DB_HOST" -ForegroundColor Yellow
Write-Host "File: $backupFile" -ForegroundColor Yellow
Write-Host ""

# Set password environment variable
$env:PGPASSWORD = $DB_PASSWORD

try {
    # Check if pg_dump exists
    $pgDump = Get-Command pg_dump -ErrorAction SilentlyContinue
    
    if (-not $pgDump) {
        Write-Host "ERROR: pg_dump not found!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Install PostgreSQL client:" -ForegroundColor Yellow
        Write-Host "1. Download from https://www.postgresql.org/download/windows/" -ForegroundColor White
        Write-Host "2. Or install via Chocolatey: choco install postgresql" -ForegroundColor White
        Write-Host "3. Add pg_dump to PATH (usually C:\Program Files\PostgreSQL\16\bin)" -ForegroundColor White
        exit 1
    }

    # Create backup
    & pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -F p -f $backupFile

    if ($LASTEXITCODE -eq 0) {
        $fileSize = (Get-Item $backupFile).Length / 1MB
        Write-Host ""
        Write-Host "Backup created successfully!" -ForegroundColor Green
        Write-Host "File: $backupFile" -ForegroundColor Cyan
        Write-Host "Size: $([math]::Round($fileSize, 2)) MB" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "To restore use:" -ForegroundColor Yellow
        Write-Host "psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -f $backupFile" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "Error creating backup!" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host ""
    Write-Host "Error: $_" -ForegroundColor Red
    exit 1
}
finally {
    # Clean up password environment variable
    Remove-Item Env:\PGPASSWORD -ErrorAction SilentlyContinue
}
