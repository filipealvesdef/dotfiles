@echo off
arch -c "tmux kill-session -t i3"
taskkill.exe /IM "vcxsrv.exe" /F
