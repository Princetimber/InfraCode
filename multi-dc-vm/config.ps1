$storagePool = Get-StoragePool | Where-Object FriendlyName -NotLike Primordial
if(!$storagePool){
  try {
    $physicalDisks = Get-PhysicalDisk -CanPool $true
    $storageSubSystemFriendlyName = (Get-StorageSubSystem).FriendlyName
    $FriendlyName = 'LUN1'
    $param = @{
      FriendlyName = $FriendlyName
      StorageSubSystemFriendlyName = $storageSubSystemFriendlyName
      PhysicalDisks = $physicalDisks
    }
    New-StoragePool @param
  }
  catch {
     Write-Error "No physical disk available"
  }
}else {
  Write-Verbose -Message "StoragePool already exists." -Verbose
}
$virtualDisks = Get-VirtualDisk |? FriendlyName -Like VirtualHD
if(!$virtualDisks){
  try {
    $vhdFriendlyName = 'VIRTUALHD'
    $storagePoolFriendlyName = 'LUN1'
    $sizeGB = 60GB
    $provisioningtype = 'Thin'
    $resiliencySettingName = 'Simple'
    $param = @{
      FriendlyName = $vhdFriendlyName
      StoragePoolFriendlyName = $storagePoolFriendlyName
      Size = $sizeGB
      ProvisioningType = $provisioningtype
      ResiliencySettingName = $resiliencySettingName
    }
    New-VirtualDisk @param
  }
  catch {
    write-error "disk exists."
  }
}else {
  Write-Verbose -Message "virtualDisk already exists." -Verbose
}
$volume = Get-Volume | ? DriveLetter -EQ E
if(!$volume){
  try {
    $diskNumber = (Get-VirtualDisk |? FriendlyName -Like VirtualHD | Get-Disk).Number
    Initialize-Disk -Number $diskNumber -PartitionStyle GPT
    $param = @{
    DiskNumber = $diskNumber
    UseMaximumSize = $true
    DriveLetter = 'e'
  }
    New-Partition @param
    $param = @{
      DriveLetter = 'e'
      Filesystem = 'NTFS'
      NewFileSystemLabel = 'Database'
    }
    Format-Volume @param
  }
  catch {

  }
}else {
  Write-Verbose -Message "Volume already exists."
}
$names = @('Logs','NTDS','SYSVOL')
foreach($n in $names){
  $testPath = Test-Path -LiteralPath (Join-Path -Path E:\ -ChildPath $n)
  if($testPath){
    try {
      New-Item -Name $n -Path E:\ -ItemType Directory | %{$_.Attributes = 'hidden'}
    }
    catch {
      Write-Error -Message "Path Exists"
    }
  }else {
    Write-Verbose -Message "Path already Exists" -Verbose
  }
}
