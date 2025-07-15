# PowerShell script to keep only Support Squad AI files
# This script will delete everything except the files listed in support_squad_ai_files.txt

Write-Host "Starting cleanup - keeping only Support Squad AI files..." -ForegroundColor Yellow

# Read the list of files to keep
$keepFiles = Get-Content "support_squad_ai_files.txt" | Where-Object { $_ -notmatch "^#" -and $_ -notmatch "^$" }

Write-Host "Files to keep:" -ForegroundColor Green
$keepFiles | ForEach-Object { Write-Host "  $_" -ForegroundColor Green }

# Get all files in the current directory and subdirectories
$allFiles = Get-ChildItem -Recurse -File | Where-Object { $_.Name -ne "support_squad_ai_files.txt" -and $_.Name -ne "cleanup_support_squad_ai.ps1" } | ForEach-Object { $_.FullName.Replace((Get-Location).Path + "\", "") }

Write-Host "`nFiles to delete:" -ForegroundColor Red
$toDelete = $allFiles | Where-Object { $keepFiles -notcontains $_ }
$toDelete | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }

# Get all directories
$allDirs = Get-ChildItem -Recurse -Directory | ForEach-Object { $_.FullName.Replace((Get-Location).Path + "\", "") }

Write-Host "`nDirectories to delete:" -ForegroundColor Red
$dirsToDelete = $allDirs | Where-Object { 
    $dir = $_
    $hasKeepFiles = $keepFiles | Where-Object { $_ -like "$dir\*" -or $_ -eq $dir }
    $hasKeepFiles.Count -eq 0
}
$dirsToDelete | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }

# Ask for confirmation
Write-Host "`nWARNING: This will delete all files and directories except those listed above!" -ForegroundColor Red
$confirmation = Read-Host "Are you sure you want to proceed? (yes/no)"

if ($confirmation -eq "yes") {
    Write-Host "`nDeleting files..." -ForegroundColor Yellow
    $toDelete | ForEach-Object { 
        try {
            Remove-Item $_ -Force -ErrorAction Stop
            Write-Host "Deleted: $_" -ForegroundColor Gray
        }
        catch {
            Write-Host "Failed to delete: $_" -ForegroundColor Red
        }
    }
    
    Write-Host "`nDeleting empty directories..." -ForegroundColor Yellow
    $dirsToDelete | Sort-Object -Descending | ForEach-Object {
        try {
            if (Test-Path $_) {
                Remove-Item $_ -Force -Recurse -ErrorAction Stop
                Write-Host "Deleted directory: $_" -ForegroundColor Gray
            }
        }
        catch {
            Write-Host "Failed to delete directory: $_" -ForegroundColor Red
        }
    }
    
    Write-Host "`nCleanup completed!" -ForegroundColor Green
    Write-Host "Only Support Squad AI files remain." -ForegroundColor Green
} else {
    Write-Host "`nCleanup cancelled." -ForegroundColor Yellow
} 