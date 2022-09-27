# create ssh key and upload to azure key vault using azure cli
# Genrate ssh key
#
ssh-keygen -m PEM -t rsa -b 4096 -C "zadmin@azubuntu2204"
az keyvault secret set --name SSHPublicKey --vault-name azuksengrrgkv --file "C:\Users\olamide\.ssh\id_rsa.pub" --encoding ascii
