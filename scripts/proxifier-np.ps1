function install([string]$dir) {
    Remove-Item -LiteralPath "$dir\Proxifier.exe"
    Remove-Item -LiteralPath "$dir\Proxifier,1.exe"
    Rename-Item -LiteralPath "$dir\Proxifier,2.exe" -NewName Proxifier.exe
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,1.cat"
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,3.cat"
    Rename-Item -LiteralPath "$dir\driver\ProxifierDrv,2.cat" -NewName ProxifierDrv.cat
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,1.inf"
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,1.sys"
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,2.inf"
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,2.sys"
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,3.inf"
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,3.sys"
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,5.inf"
    Remove-Item -LiteralPath "$dir\driver\ProxifierDrv,5.sys"
    Rename-Item -LiteralPath "$dir\driver\ProxifierDrv,4.inf" -NewName ProxifierDrv.inf
    Rename-Item -LiteralPath "$dir\driver\ProxifierDrv,4.sys" -NewName ProxifierDrv.sys
    Remove-Item -LiteralPath "$dir\ProxifierShellExt,1.dll"
    Rename-Item -LiteralPath "$dir\ProxifierShellExt,2.dll" -NewName ProxifierShellExt.dll
}

function sys_install([string]$dir) {
    NET.EXE stop ProxifierDrv > $nul 2> $nul
    RUNDLL32.EXE "SETUPAPI.DLL,InstallHinfSection" DefaultInstall 128 "$dir\Driver\ProxifierDrv.inf"
    # & $dir/ServiceManager.exe silent-uninstall
    # & $dir/ServiceManager.exe install
    # & $dir/ServiceManager.exe start
}

function sys_uninstall([string]$dir) {
    NET.EXE stop ProxifierDrv > $nul 2> $nul
    RUNDLL32.EXE "SETUPAPI.DLL,InstallHinfSection" DefaultUninstall 128 "$dir\Driver\ProxifierDrv.inf"
    & $dir/ServiceManager.exe silent-uninstall
    $sysDir = (Get-Item $env:ComSpec).DirectoryName
    Remove-Item -LiteralPath $sysDir/ProxifierShellExt.dll -Force -ErrorAction SilentlyContinue
}

Invoke-Expression ($args -Join " ")
