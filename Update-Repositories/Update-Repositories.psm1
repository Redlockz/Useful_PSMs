function Update-Repositories {

        <#
    .SYNOPSIS
        Updates all .git repositories at a given path by pulling the latest changes
        from the main/master branch.

    .DESCRIPTION
        Update-Repositories searches all directories at the given path (the first time
        the command is executed, it will save a config file called .ado_gitfolder.txt which contains the
        path to the folder containing your git repositories). If a .git folder is present in
        the directory, this command will commit any git changes, switch to the main/master branch,
        pull the latest changes from git, and revert back to the
        original git branch the repository was in before moving on to the next
        repository, unless it was already on main/master.

    .EXAMPLE
        Update-Repositories

    .INPUTS
        None

    #>

    $home_folder = $HOME

    # Check if config is present
    if (Test-Path $home_folder\.ado_gitfolder.txt) {

        Write-Warning "Getting content"
        $location = Get-Content "$home_folder\.ado_gitfolder.txt"

    } else {

        Write-Warning "File not found"
        [string]$location = Read-Host "Enter the path to your base git directory containing your git repositories, example C:\Users\User1\Projects"
        New-Item "$home_folder\.ado_gitfolder.txt"
        Set-Content "$home_folder\.ado_gitfolder.txt" "$location"

    }

    Write-Warning "Testing location"
    if (Test-Path $location) {

        Write-Warning "location exists"
        Set-Location $location

        $arr = Get-ChildItem $location |
            Where-Object {$_.PSIsContainer} |
            Foreach-Object {$_.Name}

        $is_git_installed = $ENV:path -match "Git"

        Write-Warning "Checking if git is installed:..."
        if ($is_git_installed) {

            forEach ($dir in $arr) {

                Set-Location $dir
                Write-Warning "Checking directory" 
                try {
                    $is_git_dir = ${Get-ChildItem -Path $dir -Directory -Hidden -Filter .git}
                }
                catch {
                    $_.Exception
                    $is_git_dir = $true
                }
                # Condition to negate most non git folders
                if (!(Get-ChildItem -Path "$location\$dir" -Directory -Hidden -Filter .git)){

                    Set-Location ..
                    Continue

                } else {

                    $status = git status
                    Write-Warning $status

                    $CurrentGitBranch = git branch --show-current
                    try {
                        $GitMainBranch = $(git branch --show-current| Where-Object {$_.EndsWith("main") -or $_.EndsWith("master")}).split("* ")
                    }
                    catch {
                        $_.Exception
                    }
                    Write-Warning "Fetching remote" $GitMainBranch "for" $location\$dir
                    # False sense of security, local branch only tracks local remote commit
                    if ($status -contains "nothing to commit, working tree clean") {

                        git checkout $GitMainBranch -q
                        git pull -q
                        if (!($currentGitBranch -eq $GitMainBranch)){
                            git checkout $currentGitBranch -q
                            Write-Warning "pulled newest" $GitMainBranch "from" $dir", going back to" $currentGitBranch
                            Set-Location ..
                        } else {
                            Write-Warning "pulled newest" $GitMainBranch "from" $dir
                            Set-Location ..
                        }

                    # Changes have been made on new branch, but not committed
                    } elseif ($status -contains "Changes not staged for commit:") {

                        Write-Warning "changed files not stashed for commit, do you want to commit your files for later use?"
                        [string]$stash_status = Read-Host 'Please enter "Y" for Yes, or "N" for No'

                        # commit edits to temp commit
                        if ($stash_status -eq "Y") {

                            if ($CurrentGitBranch -ne $GitMainBranch) {
                                git add .
                                git commit -m "automated git commit"
                            } elseif ($CurrentGitBranch -eq $GitMainBranch) {
                                Write-Warning "Not committing to $GitMainBranch, making temporary branch for commit"
                                git checkout -b automated/branch
                                git add .
                                git commit -m "automated branch creation + git commit"
                            }
                            Write-Warning "checking out" $GitMainBranch
                            git checkout $GitMainBranch -q
                            git pull -q
                            if (!($currentGitBranch -eq $GitMainBranch)){
                                git checkout $currentGitBranch -q
                                Write-Warning "pulled newest" $GitMainBranch "from" $dir", going back to" $currentGitBranch
                                Set-Location ..
                            } else {
                                Write-Warning "pulled newest" $GitMainBranch "from" $dir
                                Set-Location ..
                            }

                        # Abort commiting edits
                        } elseif ($stash_status -eq "N") {

                            Write-Warning "Skipped" $dir
                            Set-Location ..

                        }

                    } elseif ($status[1] -contains "Your branch is ahead of 'origin/$CurrentGitBranch' by 1 commit.") {

                        Write-Warning "Your branch is ahead of origin, push changes to $CurrentGitBranch"
                        [string]$stash_status = Read-Host 'Please enter "Y" for Yes, or "N" for No'

                        # commit edits to temp commit
                        if ($stash_status -eq "Y") {

                            if ($CurrentGitBranch -ne $GitMainBranch) {
                                git add .
                                git commit -m "automated git commit"
                            } elseif ($CurrentGitBranch -eq $GitMainBranch) {
                                Write-Warning "Not committing to $GitMainBranch, making temporary branch for commit"
                                git checkout -b automated/branch
                                git add .
                                git commit -m "automated branch creation + git commit"
                            }
                            git checkout $GitMainBranch -q
                            git pull -q
                            if (!($currentGitBranch -eq $GitMainBranch)){
                                git checkout $currentGitBranch -q
                                Write-Warning "pulled newest" $GitMainBranch "from" $dir", going back to" $currentGitBranch
                                Set-Location ..
                            } else {
                                Write-Warning "pulled newest" $GitMainBranch "from" $dir
                                Set-Location ..
                            }

                        # Abort commiting edits
                        } elseif ($stash_status -eq "N") {

                            Write-Warning "Skipped" $dir
                            Set-Location ..

                        }

                    # To catch most edge cases
                    } elseif ($status -contains "fatal:" -Or $status -contains "error:") {

                        Write-Warning $status
                        Set-Location ..

                    } elseif ($is_git_dir) {

                        git checkout $GitMainBranch[1] -q
                        git pull -q
                        if (!($currentGitBranch -eq $GitMainBranch[1])){
                            git checkout $currentGitBranch -q
                            Write-Warning "pulled newest" $GitMainBranch[1] "from" $dir", going back to" $currentGitBranch
                        }

                        Write-Warning "pulled newest" $GitMainBranch[1] "from" $dir
                        Set-Location ..

                    } else {
                        Write-Warning "Not a git dir"
                        Set-Location ..
                    }
                }
            }

        } else {

            Write-Warning "git not found"
            throw "git is not part of your environment, please add git to your env or install git"
            exit 1

        }
    } else {

        Write-Warning "location not found"
        throw "location not found, are you sure you entered the right directory?"
        exit 1

    }
    Write-Warning "Exit 0"
    exit 0
    }
