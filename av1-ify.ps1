$SourceDirectoryPath = $args[0]
if ($null -eq $SourceDirectoryPath) {
    $SourceDirectoryPath = Get-Location
}

foreach ($SourceFile in (Get-ChildItem -Path $SourceDirectoryPath)) {
    switch ($SourceFile.Extension) {
        {($_ -eq ".mp4")} {
            $NewName = $SourceFile.Name
            $NewName = $NewName + "_hb" + ".mp4"
            $Destination = "$Env:USERPROFILE\Videos\HandBrake"
            HandBrakeCLI.exe --input ($SourceFile.FullName) --output "$Destination\$NewName" --preset-import-file .\preset.json --preset sexiest
            Write-Host "Exiftooling"
            exiftool.exe -TagsFromFile ($SourceFile.FullName) "-all:all>all:all" "$Destination\$NewName"
        }
        {($_ -eq ".jpg") -or ($_ -eq ".jpeg") -or ($_ -eq ".png")} {
            $NewName = $SourceFile.Name
            $NewName = $NewName + "_magick" + ".avif"
            $Destination = "$Env:USERPROFILE\Pictures\magick"
            magick.exe convert ($SourceFile.FullName) -quality 90% "$Destination\$NewName"
            Write-Host "Exiftooling"
            exiftool.exe -TagsFromFile ($SourceFile.FullName) "-all:all>all:all" "$Destination\$NewName"
        }
        Default {
            Write-Warning -Message ($SourceFile.Name + "has no recognised extension")
        }
    }
}
