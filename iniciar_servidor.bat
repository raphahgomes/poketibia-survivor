@echo off
title Poketestes by Raph - Servidor Oficial
echo ========================================================
echo   Poketestes by Raph - Servidor Oficial
echo ========================================================
echo.

echo [1/3] Verificando Banco de Dados MariaDB...
tasklist /FI "IMAGENAME eq mysqld.exe" 2>NUL | find /I /N "mysqld.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo [OK] MariaDB ja esta em execucao!
) else (
    echo Iniciando MariaDB em segundo plano...
    start "" /B "C:\Program Files\MariaDB 13.0\bin\mysqld.exe" --datadir="%~dp0db_data" --console
    ping 127.0.0.1 -n 5 >nul
)

echo [2/3] Verificando Database "poketestes"...
"C:\Program Files\MariaDB 13.0\bin\mysql.exe" -u root -e "CREATE DATABASE IF NOT EXISTS poketestes;" 2>NUL
"C:\Program Files\MariaDB 13.0\bin\mysql.exe" -u root poketestes -e "SELECT 1 FROM server_config LIMIT 1;" >NUL 2>NUL
if not "%ERRORLEVEL%"=="0" (
    echo Inicializando estrutura limpa na database "poketestes"...
    "C:\Program Files\MariaDB 13.0\bin\mysql.exe" -u root poketestes < "%~dp0pokedashpota1.02_release\pokedashpota1.02_server\schema.sql" 2>NUL
    "C:\Program Files\MariaDB 13.0\bin\mysql.exe" -u root poketestes -e "SET FOREIGN_KEY_CHECKS=0; DELETE FROM players; DELETE FROM accounts; SET FOREIGN_KEY_CHECKS=1;" 2>NUL
    echo [OK] Database "poketestes" criada e configurada com sucesso!
) else (
    echo [OK] Database "poketestes" ativa e integra!
)

echo [3/3] Iniciando Servidor Poketestes by Raph (Win64)...
cd /d "%~dp0pokedashpota1.02_release\pokedashpota1.02_server"
start "" pokedashpota_win64.exe

echo.
echo ========================================================
echo   Poketestes by Raph Online! Pronto para conectar!
echo ========================================================
ping 127.0.0.1 -n 3 >nul
