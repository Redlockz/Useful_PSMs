BeforeAll {
    Import-Module -Name D:\a\Useful_PSMs\Useful_PSMs\Update-Repositories\Update-Repositories.psm1 -Verbose -Force
}

Describe "Update-Repositories" {
    Context "Read-Host" {
        # It "Should invoke Read-Host" {
        #     Update-Repositories | Should -Invoke -CommandName Read-Host
        # }
        It "Hidden is replaced with our implementation" {
            Update-Repositories | Should -Invoke -CommandName Read-Host
        }
    }
}

# Import-Module -Name "c:\LocationOfModules\Pester"

# Function Test-Foo {
#     $filePath = Read-Host "Tell me a file path"
#     $filePath
# }
# Describe "Test-Foo" {
#   Context "When something" {
#         Mock Read-Host {return "c:\example"}

#         $result = Test-Foo

#         It "Returns correct result" { # should work
#             $result | Should Be "c:\example"
#         }
#          It "Returns correct result" { # should not work
#             $result | Should Be "SomeThingWrong"
#         }
#     }
# }
