@echo off
set WIN_ROOT=%DOTFILES_PATH%\win
set SCRIPTS_PATH=%WIN_ROOT%\scripts

:::: Scripts ::::
::
:: Creates Sym links of scripts in <dotfiles_path>\win\scripts to
:: <usr_bin_path>
for %%s in ("%SCRIPTS_PATH%\"*) do (
    del "%USR_BIN%\%%~nxs"
    mklink "%USR_BIN%\%%~nxs" "%%s"
)

:::: Special config files ::::
::
set SCOOP_APPS_PATH=%USERPROFILE%\scoop\apps

:: Windows terminal
set WT_PATH=%LocalAppData%\Microsoft\Windows^ Terminal
set WT_SETTINGS_FILE=settings.json
del "%WT_PATH%\%WT_SETTINGS_FILE%"
mklink "%WT_PATH%\%WT_SETTINGS_FILE%" "%WIN_ROOT%\wt\%WT_SETTINGS_FILE%"

:: PulseAudio
set PULSE_PATH="%SCOOP_APPS_PATH%\pulseaudio\current\bin"
set PULSE_CONFIG_FILE=config.pa
del "%PULSE_PATH%\%PULSE_CONFIG_FILE%"
mklink "%PULSE_PATH%\%PULSE_CONFIG_FILE%" "%WIN_ROOT%\pulse\%PULSE_CONFIG_FILE%"
