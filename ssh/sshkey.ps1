# create ssh key and upload to azure key vault using azure cli
# Genrate ssh key
#
ssh-keygen -m PEM -t rsa -b 4096
az keyvault secret set --name sshkeys --vault-name labuksrgkeystore --file "C:\Users\Olamide\.ssh\id_rsa.pub" --encoding ascii
