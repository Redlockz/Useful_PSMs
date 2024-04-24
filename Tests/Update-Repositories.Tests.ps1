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
        BeforeAll {
            Write-Verbose "Creating test file"
            {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'} | Should -Not -Throw
            Mock Write-Host { }
        }
        It "Success" {
            Update-Repositories
            Assert-MockCalled -CommandName Write-Host -ModuleName Update-Repositories -Exactly 3 -Scope Context
            Assert-MockCalled -CommandName Write-Host -ModuleName Update-Repositories -Exactly 1 -Scope Context -ParameterFilter { $Object -eq "testing location" }
            Assert-MockCalled -CommandName Write-Host -ModuleName Update-Repositories -Exactly 1 -Scope Context -ParameterFilter { $Object -eq "Updated all repositories" }
            Assert-MockCalled -CommandName Write-Host -ModuleName Update-Repositories -Exactly 1 -Scope Context -ParameterFilter { $Object -eq "Updated all Updated git workspace" }
        }
    }
}
