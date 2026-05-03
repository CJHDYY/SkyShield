@echo off
echo.
echo [信息] 清理 target 构建目录。
echo.

%~d0
cd %~dp0

cd ..
call mvn clean

pause
