Add-type -assembly “Microsoft.Office.Interop.Outlook” | out-null

$olFolders = “Microsoft.Office.Interop.Outlook.OlDefaultFolders” -as [type]

$outlook = new-object -comobject outlook.application

$namespace = $outlook.GetNameSpace(“MAPI”)

$folder = $namespace.getDefaultFolder($olFolders::olFolderCalendar)

#$folder.items

#Select-Object -Property Subject, Start, Duration, Location

$today = Get-Date -Format "dd-MM-yyyy"

foreach($item in $folder.items) {
   $check = $item.Start[1]
   if ($item.Start -eq $today) {
       Select-Object -Property Subject, Start, Duration, Location
      }
}