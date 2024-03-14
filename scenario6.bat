@echo off
cd /d "%~dp0\java-scenario"
call mvn clean install 
pause 