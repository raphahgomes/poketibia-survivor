@echo off
title Servidor PokeTibia - PokeDungeon Survivor
echo ========================================================
echo   PokeTibia Baiak - Modo PokeDungeon Survivor
echo ========================================================
echo.

echo [1/2] Verificando Banco de Dados MariaDB...
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [OK] MariaDB ja esta em execucao!
) else (
    echo Iniciando MariaDB em segundo plano...
    start "" /B "C:\Program Files\MariaDB 13.0\bin\mysqld.exe" --datadir="%~dp0db_data" --console
    timeout /t 3 /nobreak >nul
)

echo [2/2] Iniciando Servidor PokeDash Pota (Win64)...
cd /d "%~dp0pokedashpota1.02_release\pokedashpota1.02_server"
start "" pokedashpota_win64.exe

echo.
echo ========================================================
echo   Servidor Online! Pronto para conectar no Client!
echo ========================================================
timeout /t 5
