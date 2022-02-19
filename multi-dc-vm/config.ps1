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
$virtualDisks = Get-VirtualDisk |Where-Object FriendlyName -Like VirtualHD
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
$volume = Get-Volume | Where-Object DriveLetter -EQ F
if(!$volume){
  try {
    $diskNumber = (Get-VirtualDisk |Where-Object FriendlyName -Like VirtualHD | Get-Disk).Number
    Initialize-Disk -Number $diskNumber -PartitionStyle GPT
    $param = @{
    DiskNumber = $diskNumber
    UseMaximumSize = $true
    DriveLetter = 'F'
  }
    New-Partition @param
    $param = @{
      DriveLetter = 'F'
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
  $testPath = Test-Path -LiteralPath (Join-Path -Path F:\ -ChildPath $n)
  if(!$testPath){
    try {
      New-Item -Name $n -Path F:\ -ItemType Directory | ForEach-Object{$_.Attributes = 'hidden'}
    }
    catch {
      Write-Error -Message "Path Exists"
    }
  }else {
    Write-Verbose -Message "Path already Exists" -Verbose
  }
}
