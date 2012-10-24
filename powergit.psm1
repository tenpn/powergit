
Function Get-GitFileStatus
{
    (git status -s)
}

Function Get-GitLog($branch)
{
    (git log $branch --format="%h {%an} {%ai} %s") `
        | ?{$_ -match "([a-f0-9]+)\s{([^}]*)}\s{([^}]*)}\s(.*)$"} `
        | select @{n='SHA';e={$matches[1]}}, `
                 @{n='Author';e={$matches[2]}}, `
                 @{n='Date';e={[datetime]$matches[3]}}, `
                 @{n='Subject';e={$matches[4]}}
}

export-modulemember -function Get-GitLog

new-alias -name gs -value Get-GitFileStatus
export-modulemember -function Get-GitFileStatus -alias gs

