param name string
param location string = resourceGroup().location
resource sshkeys 'Microsoft.Compute/sshPublicKeys@2021-07-01' = {
  name: name
  location: location
  tags:{
    DisplayName: 'SSH Key'
  }
  properties:{
    publicKey: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzH+R+UcZevFLUm/tF6Z3j+MY/GzHGtIuDNS7Mg0WVLvovUfQNLghQzfzdKQdMt9KHJkENu+BrkxuB7ZuI1mIzKrNmYvRbGXjNzSgqZEe32IYlzZh9oAqYkUq+Bfqfh2VVDkTqNn6yPwcKxCEBuLwzO2RnYcYf+cLOKCM0yICsSrJ1u4LtD/5LqHnNnNpkdQX8iLqk6e9Yh+8QRQk6+rP3kYnj6dNdD6tqacSHfGgKH8XJpL9ES7gcrBJXBoYVDX/y/NX8OaZZroXuYwh3uhaYvRC8dWULwul0s8UQnTdMvZ7rWhwpOVUOWHRGiXaMZW8mOLP/7gECAwEAAaOBgTB/MB0GA1UdDgQWBBS0sK1jBXQmKJ+q9DfF0XVzHjzCBkQYDVR0jBIGJMIGGgBS0sK1jBXQmKJ+q9DfF0XVzHj6FzpHsxGzAZBgNVBAMTElByb2R1Y3Rpb24gUm9vdCBDQYIKYQgMBAAGgYDVR0gAQH/BBgwFgYFQgIBADBYBgNVHSABAf8EgdowgZEGCCsGAQUFBwICMIG2DIGzUmVsaWFuY2Ugb24gdGhpcyBjZX'
  }
}
