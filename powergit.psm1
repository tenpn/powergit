
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

Function Get-GitUnusedRemoteBranches
{
    (git branch -r --merged develop) `
        | %{$_.trim()} `
        | select  `
            @{n='Branch';e={$_}}, `
            @{n='LastCommit';e={[datetime](git log $_ -1 --pretty=format:%ci)}}  `
        | sort LastCommit
}

Function Remove-GitRemoteBranch($remote, $branch)
{
    (git push $remote $branch)
}

export-modulemember -function Get-GitLog

new-alias -name gs -value Get-GitFileStatus
export-modulemember -function Get-GitFileStatus -alias gs

export-modulemember -function Get-GitUnusedRemoteBranches

export-modulemember -function Remove-GitRemoteBranch