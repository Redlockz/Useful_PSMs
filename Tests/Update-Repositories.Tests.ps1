BeforeAll {
    Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
}

Describe "Update-Repositories" {
    Context "Read-Host" {
        It "Should throw" {
            Update-Repositories
        }
    }
}
