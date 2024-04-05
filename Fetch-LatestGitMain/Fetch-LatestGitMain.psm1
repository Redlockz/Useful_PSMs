function Fetch-LatestGitMain {

        <#
    .SYNOPSIS
        Updates all .git repositories at a given path by pulling the latest changes
        from the main branch.

    .DESCRIPTION
        Fetch-LatestGitMain searches all directories at the given path (the first time
        the command is executed, it will save a config file called .ado_gitfolder.txt which contains the
        path to the folder containing your git repositories) if the directory
        contains a git repository (.git folder). If a .git folder is present in
        the directory, this command will commit any git changes, switch to the main branch,
        pull the latest changes from git, and revert back to the
        original git branch the repository was in before moving on to the next
        repository, unless it was already on main.

    .EXAMPLE
        Fetch-LatestGitMain

    .INPUTS
        None

    #>
    $current_folder = "~\"

    if (Test-Path $current_folder\.ado_gitfolder.txt) {

        $location = Get-Content "$current_folder\.ado_gitfolder.txt"

    } else {

        [string]$location = Read-Host "Enter the path to your base git directory containing your git repositories, example C:\Users\User1\Projects"
        New-Item "$current_folder\.ado_gitfolder.txt"
        Set-Content "$current_folder\.ado_gitfolder.txt" "$location"

    }

    if (Test-Path $location) {

        Set-Location $location

        $arr = Get-ChildItem $location |
            Where-Object {$_.PSIsContainer} |
            Foreach-Object {$_.Name}

        $is_git_installed = $ENV:path -match "Git"

        if ($is_git_installed) {

            forEach ($dir in $arr) {

                Set-Location $dir

                # Condition to negate most non git folders
                if (!(Get-ChildItem -Path "$location\$dir" -Directory -Hidden -Filter .git)){

                    Set-Location ..
                    Continue

                } else {

                    $status = git status
                    Write-Verbose $status

                    $CurrentGitBranch = git branch --show-current
                    $GitMainBranch = $(git branch | Where-Object {$_.EndsWith("main") -or $_.EndsWith("master")}).split("* ")
                    Write-Host "Fetching remote" $GitMainBranch[1] "for" $location\$dir
                    # False sense of security, local branch only tracks local remote commit
                    if ($status -contains "nothing to commit, working tree clean") {

                        git checkout $GitMainBranch[1] -q
                        git pull -q
                        if (!($currentGitBranch -eq $GitMainBranch[1])){
                            git checkout $currentGitBranch
                            Write-Host "pulled newest" $GitMainBranch[1] "from" $dir ", going back to" $currentGitBranch
                        }
                        Write-Host "pulled newest" $GitMainBranch[1] "from" $dir
                        Set-Location ..

                    # Changes have been made on new branch, but not committed
                    } elseif ($status -contains "Changes not staged for commit:") {

                        Write-Host "changed files not stashed for commit, do you want to commit your files for later use?"
                        [string]$stash_status = Read-Host 'Please enter "Y" for Yes, or "N" for No'

                        # commit edits to temp commit
                        if ($stash_status -eq "Y") {

                            git add .
                            git commit -m "automated git stash"
                            git checkout $GitMainBranch[1] -q
                            git pull -q
                            if (!($currentGitBranch -eq $GitMainBranch[1])){
                                git checkout $currentGitBranch
                                Write-Host "pulled newest" $GitMainBranch[1] "from" $dir ", going back to" $currentGitBranch
                            }
                            Write-Host "pulled newest" $GitMainBranch[1] "from" $dir
                            Set-Location ..

                        # Abort commiting edits
                        } elseif ($stash_status -eq "N") {

                            Write-Host "Skipped" $dir
                            Set-Location ..

                        }

                    # To catch most edge cases
                    } elseif ($status -contains "fatal:" -Or $status -contains "error:") {

                        Set-Location ..

                    # Pull main from all folders containing hidden .git file
                    } elseif (Get-ChildItem -Path $dir -Directory -Hidden -Filter .git) {

                        git checkout $GitMainBranch[1] -q
                        git pull -q
                        if (!($currentGitBranch -eq $GitMainBranch[1])){
                            git checkout $currentGitBranch
                            Write-Host "pulled newest" $GitMainBranch[1] "from" $dir ", going back to" $currentGitBranch
                        }

                        Write-Host "pulled newest" $GitMainBranch[1] "from" $dir
                        Set-Location ..

                    }
                }
            }

        } else {

            throw "git is not part of your environment, please add git to your env or install git"
            exit 1

        }
    } else {

        Write-Host "location not found, are you sure you entered the right directory?"
        exit 1

    }

    exit 0
}
