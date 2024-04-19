BeforeAll {
    Import-Module Update-Repositories/Update-Repositories.psm1 -Force
}

Describe "Update-Repositories" {
    # Import-Module -Name Update-Repositories -Force
    It "Returns nothing to commit, working tree clean" {
        Update-Repositories | Should -BeLike "On branch main Your branch is up to date with 'origin/main'.  nothing to commit, working tree clean"
    }
}
