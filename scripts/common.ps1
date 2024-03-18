function New-PersistFile([string]$path) {
    if (!(Test-Path $path) -or !(Get-Item $path).Length) {
        New-Item $path -ItemType File -Force | Out-Null
    }
}

function Update-Timestamp([string]$path) {
    $rootDirectory = [System.IO.DirectoryInfo]::new($path);
    $lastWriteTime = [System.DateTime].MinValue;
    $directories = $rootDirectory.GetDirectories();
    $directories | foreach-object {
        $result = Update-Timestamp($_.FullName)
        if ($lastWriteTime -lt $result) {
            $lastWriteTime = $result;
        }
        if ($_.CreationTime -gt $_.LastWriteTime) {
            $_.CreationTime = $_.LastWriteTime;
        }
        $_.LastAccessTime = $_.LastWriteTime;
    }
    $files = $rootDirectory.GetFiles();
    $files | foreach-object {
        if ($lastWriteTime -lt $_.LastWriteTime) {
            $lastWriteTime = $_.LastWriteTime;
        }
        if ($_.CreationTime -gt $_.LastWriteTime) {
            $_.CreationTime = $_.LastWriteTime;
        }
        $_.LastAccessTime = $_.LastWriteTime;
    }

    if ($lastWriteTime.Equals([System.DateTime].MinValue)) {
        $lastWriteTime = [System.DateTimeOffset]::FromUnixTimeMilliseconds(0).DateTime;
    }

    $rootDirectory.LastWriteTime = $lastWriteTime;
    if ($rootDirectory.CreationTime -gt $lastWriteTime) {
        $rootDirectory.CreationTime = $lastWriteTime;
    }
    $rootDirectory.LastAccessTime = $lastWriteTime;
    return $lastWriteTime;
}

function Remove-EmptyDirectory([string]$path) {
    do {
        $dirs = Get-Childitem -LiteralPath $path -Directory -Force -Recurse | Where-Object {
            (Get-ChildItem -LiteralPath $_.FullName -Force).Count -eq 0
        } | Select-Object -ExpandProperty FullName
        $dirs | Foreach-Object { Remove-Item -LiteralPath $_ }
    }
    while ($dirs.Count -gt 0)
}
