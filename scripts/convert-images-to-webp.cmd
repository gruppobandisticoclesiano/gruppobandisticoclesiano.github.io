@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Convert-ImagesToWebP.ps1" %*
