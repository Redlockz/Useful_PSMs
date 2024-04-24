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

InModuleScope {
    Describe "Update-Repositories passing" {
        Context "Update-Repositories passing" {
            BeforeAll {
                Write-Verbose "Creating test file"
                {Set-Content -Path "$HOME\.ado_gitfolder.txt" -Value 'D:\a\Useful_PSMs\Useful_PSMs'} | Should -Not -Throw
            }
            It "Success" {
                Mock Update-Repositories { }
                Update-Repositories
                Should -Invoke Write-Host
            }
        }
    }
}
