function Get-DirectoryTree {
    param(
        [string]$Path = ".",
        [string]$Indent = "",
        [bool]$IsLast = $true
    )
    
    $items = Get-ChildItem -Path $Path | Sort-Object Name
    $output = @()
    
    for ($i = 0; $i -lt $items.Count; $i++) {
        $item = $items[$i]
        $isLastItem = ($i -eq ($items.Count - 1))
        
        if ($item.PSIsContainer) {
            if ($isLastItem) {
                $output += "$Indent└── $($item.Name)/"
                $newIndent = "$Indent    "
            } else {
                $output += "$Indent├── $($item.Name)/"
                $newIndent = "$Indent│   "
            }
            $output += Get-DirectoryTree -Path $item.FullName -Indent $newIndent -IsLast $isLastItem
        } else {
            if ($isLastItem) {
                $output += "$Indent└── $($item.Name)"
            } else {
                $output += "$Indent├── $($item.Name)"
            }
        }
    }
    
    return $output
}

$currentDir = Split-Path -Leaf (Get-Location)
$treeOutput = @("$currentDir/")
$treeOutput += Get-DirectoryTree

$treeOutput | Out-File -FilePath "file_list.txt" -Encoding UTF8
Write-Host "file_list.txt saved"

dont reply
