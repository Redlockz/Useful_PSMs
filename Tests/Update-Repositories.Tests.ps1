BeforeAll {
    Import-Module -Name /home/runner/work/Useful_PSMs/Useful_PSMs/Update-Repositories/Update-Repositories.psm1 -Verbose -Force
}

Describe "Update-Repositories" {
    # Import-Module -Name Update-Repositories -Force
    # It "Returns nothing to commit, working tree clean" {
    #     Update-Repositories | Should -BeLike "On branch main Your branch is up to date with 'origin/main'.  nothing to commit, working tree clean"
    # }
    It "Should invoke Read-Host" {
        Update-Repositories | Should -Invoke -CommandName Read-Host
    }
}
