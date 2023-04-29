packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "example" {
  ami_name      = "golden-image {{timestamp}}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami = "ami-02396cdd13e9a1257"
  ssh_username = "ec2-user"
  ssh_keypair_name = "packer"
  ssh_private_key_file = "/home/ec2-user/.ssh/id_rsa"
  run_tags = {
    Name = "Packer Golden Image"
  }
}

build {
  sources = ["source.amazon-ebs.example"]

  provisioner "shell" {
    script = "setup.sh"
  }

  provisioner "breakpoint" {
    note = "Please verify"
  }
}