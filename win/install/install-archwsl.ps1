$USR_BIN = "$Env:USERPROFILE\bin"
$DOTFILES_PATH_DEFAULT = "$Env:USERPROFILE\.dotfiles";
$GITHUB_DOTFILES_BASENAME = 'filipealvesdef/dotfiles'
$SCOOP_PKG_LIST_DEFAULT = "https://raw.githubusercontent.com/filipealvesdef/dotfiles/master/win/install/package-list";
$SYNC_LINKS_SCRIPT_URL = "https://raw.githubusercontent.com/filipealvesdef/dotfiles/master/win/scripts/sync-links.bat";
# $ARCHWSL_CER = https://github.com/yuk7/ArchWSL/releases/download/21.7.16.0/ArchWSL-AppX_21.7.16.0_x64.cer
$SCOOP_PATH = "$Env:USERPROFILE\scoop\apps"

### Setting up powershell permissions
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

### Scoop (package manager)
try {
    scoop > $null
} catch {
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

### Custom buckets
scoop bucket add extras
scoop bucket add nerd-fonts
scoop bucket add lomeli-bucket https://github.com/Lomeli12/ScoopBucket

$SCOOP_PKG_LIST_URL = Read-Host -Prompt "If you want to use a custom package list, enter the URL.`
Otherwise, just press Enter"
if ("$SCOOP_PKG_LIST_URL" -eq '') {
    $SCOOP_PKG_LIST_URL = $SCOOP_PKG_LIST_DEFAULT;
}
$SCOOP_PKG_LIST = (New-Object System.Net.WebClient).DownloadString($SCOOP_PKG_LIST_URL);

## Download packages
foreach ($pkg in (($SCOOP_PKG_LIST -split '\r?\n').Trim())) {
    if ($pkg -ne 'firacode-nf') {
        scoop install $pkg;
    }
}

sudo scoop install 'firacode-nf'

### Dotfiles setup ###
$DOTFILES_PATH = Read-Host -Prompt "Choose your dotfiles directory. If it already`
exists in your system, it will be used. Otherwise, a new one will be cloned`
into this directory (default: $DOTFILES_PATH_DEFAULT)";

if ("$DOTFILES_PATH" -eq '') {
    $DOTFILES_PATH = "$DOTFILES_PATH_DEFAULT";
}

if ("$DOTFILES_PATH" -ne "$Env:DOTFILES_PATH") {
    setx DOTFILES_PATH $DOTFILES_PATH > $null;
}

if (!(Test-Path "$DOTFILES_PATH")) {
    $DOTFILES_BASENAME = Read-Host -Prompt "Enter the basename of your dotfiles`
on github (default: $GITHUB_DOTFILES_BASENAME)"
    if ($DOTFILES_BASENAME -ne "") {
        $GITHUB_DOTFILES_BASENAME = $DOTFILES_BASENAME;
    }
    git config --global core.autocrlf false
    git clone "https://github.com/$GITHUB_DOTFILES_BASENAME.git" "$DOTFILES_PATH"
}

### User scripts setup ###
if (!(Test-Path "$USR_BIN")) {
    New-Item "$USR_BIN" -Type Directory
}

if (!"$Env:USR_BIN") {
    setx USR_BIN "$USR_BIN" > $null;
}

$IS_USR_BIN_SET = $False;
foreach ($p in $Env:Path.Split(';')) {
    if ($p -eq $USR_BIN) {
        $IS_USR_BIN_SET = $True;
        break;
    }
}

if (!$IS_USR_BIN_SET) {
    setx PATH "$Env:PATH;$USR_BIN" > $null;
}

### Symbolic links to Windows dotfiles ###
$SYNC_LINKS_SCRIPT_FILENAME = $SYNC_LINKS_SCRIPT_URL.Split('/')[-1]
$SYNC_LINKS_SCRIPT_PATH = "$Env:Temp\$SYNC_LINKS_SCRIPT_FILENAME"
curl $SYNC_LINKS_SCRIPT_URL -o "$SYNC_LINKS_SCRIPT_PATH"
$CMD = $SYNC_LINKS_SCRIPT_PATH

# Add rules for vcxsrv and pulseaudio on windows firewall
$TARGETS = ("vcxsrv", "pulseaudio")
foreach ($target in $TARGETS) {
    # "current" scoop directory is a windows "junction", a kind of hard link
    # to the real directory. And the windows firewall do not work well with
    # junctions, therefore I am getting the real paths here
    $TARGET_PATH = (Get-Item "$SCOOP_PATH\$target\current").Target

    # Remove pre existing rules
    $CMD += " & netsh advfirewall firewall delete rule name=`"$target.exe`" & "

    if ($target -eq 'pulseaudio') {
        # Fix the target path for pulseaudio (do not try using += here!)
        $TARGET_PATH = "$TARGET_PATH\bin"

        # And install the pulse service with NSSM
        $PULSEARGS = "-F $TARGET_PATH\config.pa --exit-idle-time=-1"
        $CMD += " nssm remove PulseAudio confirm & " +
            "nssm install PulseAudio $TARGET_PATH\pulseaudio.exe $PULSEARGS & " +
            "nssm start PulseAudio & "
    }

    # Create a new rule allowing public and private network access
    $CMD += "netsh advfirewall firewall add rule name=`"$target.exe`" dir=in " +
    "action=allow profile=public,private protocol=tcp edge=deferuser " +
    "program=`"$TARGET_PATH\$target.exe`""
}

# Open cmd with admin privilages a single time and execute the payload in $CMD.
Start-Process -FilePath "cmd.exe" -Verb RunAs -ArgumentList "/c", $CMD

### Arch Installation ###
$USERNAME = Read-Host -Prompt 'Enter your WSL username';
setx WSL_USER "$USERNAME" > $null;

$DOTFILES_PATH_WSL="`$(wslpath -u $($DOTFILES_PATH.replace('\', '\\')))"
arch -c /usr/bin/bash -c "$DOTFILES_PATH_WSL/install/preinstall-archwsl $USERNAME"
arch config --default-user $USERNAME
arch -c /usr/bin/bash -c "$DOTFILES_PATH_WSL/install/install-arch $DOTFILES_PATH_WSL"
wt
exit
