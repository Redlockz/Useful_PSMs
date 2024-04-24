BeforeAll {
    Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
}

Describe "Update-Repositories failing" {
    Context "Update-Repositories failing" {
        It "Should throw" {
            {Update-Repositories} | Should -Throw "*location not found*"
        }
    }
}

Describe "Update-Repositories passing" {
    Context "Update-Repositories passing" {
        It "Create Test File" {
            {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'} | Should -Not -Throw
        }
        It "Success" {
            Mock -ModuleName Update-Repositories Update-Repositories {}
            # Assert-MockCalled Write-Host -Exactly 3 -Scope It
            Assert-MockCalled Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "testing location" }
            Assert-MockCalled Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Updated all repositories" }
            Assert-MockCalled Write-Host -Exactly 1 -Scope It -ParameterFilter { $Object -eq "Updated all Updated git workspace" }
        }
    }
}
