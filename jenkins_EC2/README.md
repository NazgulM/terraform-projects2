# Infrastructure Automation: Deploying an EC2 Jenkins Server with Terraform

## What is Terraform

Terraform is an open-source infrastructure as code (IaC) tool that allows developers to define and manage cloud infrastructure resources in a declarative way.

Declarative is a programming concept where a program describes what should be accomplished, rather than how to accomplish it. In the context of Terraform, a declarative approach means that you define the desired state of your infrastructure and Terraform takes care of figuring out the necessary actions to achieve that state.

In Terraform, you define the desired state of your infrastructure using a configuration file, which specifies the resources you want to create, their properties and any dependencies between them. You do not need to write procedural code that specifies how to create and manage those resources. Instead, Terraform compares the desired state with the current state of the infrastructure and determines the necessary actions to achieve the desired state.

Terraform is also cloud agnostic. This means it supports multiple cloud providers such as Amazon Web Services (AWS), Microsoft Azure, and Google Cloud Platform (GCP), as well as various other services, such as databases, DNS, and monitoring tools.

### Benefits of using Terraform

Infrastructure as code: Terraform provides a way to define infrastructure as code, which means you can version control and manage your infrastructure just like you would with application code.
Reusability: Terraform allows you to reuse infrastructure code across different environments, making it easier to manage and deploy consistent infrastructure.
Cloud-agnostic: Terraform can manage resources across multiple cloud providers and services, making it a great tool for multi-cloud deployments.
Consistency: Terraform ensures that the infrastructure deployed is consistent across all environments, making it easier to manage and maintain.

Terraform Providers
A provider is a plugin that enables Terraform to interact with a particular infrastructure platform, service, or system. Providers are responsible for translating Terraform configuration files into API calls to create and manage resources.

Resources
Resources are the most basic building blocks that represent a piece of infrastructure that you want to manage and can represent a wide variety of infrastructure components, such as virtual machines, databases, load balancers, DNS records, or any other resource that can be created or managed by a particular provider.

Resource Type
A resource type is a category or class of infrastructure resources that can be created, updated, or destroyed using Terraform.

Resource Name
A resource name is a unique identifier assigned to a specific resource within a given Terraform configuration.

Resource Arguments
Resource arguments are the parameters or attributes that are passed to a resource block in Terraform. They provide the necessary information for Terraform to provision and manage a specific resource.

Variables
Variables are used to define values that can be passed into a Terraform configuration at runtime. These variables can be easily changed or customized in your configurations to make them more dynamic and reusable.

### Jenkins

Jenkins is a powerful and popular open-source automation tool that helps software developers and engineers automate their development processes to build, test and deploy software projects.

Objectives
Deploy an EC2 Instances in the Default VPC.
Bootstrap the EC2 instance with a script that will install and start Jenkins.
Create and assign a Security Group to the Jenkins EC2 serve which allows traffic on port 22 for SSH, port 443 for HTTPS and traffic from port 8080, which is the default port the Jenkins service uses.
Create an private S3 bucket for the Jenkins Artifacts.
Verify that you can reach the Jenkins install via port 8080 in a browser.
Create an IAM Role that allows S3 read/write access for the Jenkins Server and assign the role to the Jenkins server.
Verify functionality by connecting into your instance and archiving access to the S3 bucket using AWS CLI commands without leveraging your credentials.

```
# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}
```

This code configures the AWS provider with a specific region. The provider block is used to define the details of the AWS provider and inside the block contains its configuration options.

The region argument is set to the value of the variable var.aws_region.By using this syntax, Terraform will look for a variable named aws_region in the current workspace.

Step 2: Create Jenkins server’s security group Terraform configuration file
To fulfill our objectives, we need to create a security group for the Jenkins EC2 server and allow the appropriate ports so we can connect to the server over the internet.

Terraform code for Jenkins Security Group acts as a virtual firewall that controls inbound and outbound traffic to and from the EC2 instance.

The resource block defines the resource type aws_security_group and its name jenkins-sg. The description field provides a brief description of the security group.

The ingress blocks specify the inbound traffic rules for the security group. There are three ingress blocks, each allowing traffic on different ports (22, 443, and 8080) using the TCP protocol. The cidr_blocks argument specifies the IP address of range 0.0.0.0/0 to have access the Jenkins server, therefore allowing traffic from any IP address.

The egress block specifies the outbound traffic rules for the security group. In this case, all outbound traffic is allowed. The from_port and to_port arguments are set to 0 and the protocol argument is set to -1 to allow any outbound traffic.

Step 3 — Creating an IAM role to allow the Jenkins server read/write access to the S3 bucket.

Step 3: Create IAM role that allows Jenkins server read/write access to S3 bucket
We need an IAM Role to be assumed by the Jenkins server with a policy that allows S3 read/write access.

This can be accomplished by creating a separate Terraform file called s3-iam-role.tf.

The aws_iam_role resource defines a new IAM role called s3-jenkins_role that can be assumed by Jenkins EC2 instance. The assume_role_policy argument specifies a JSON-encoded policy that will allow the Jenkins EC2 instance to assume the role.

The aws_iam_policy resource defines a new IAM policy called s3-jenkins-rw-policy that allows read and write access to the S3 bucket. The policy argument specifies the policy document in JSON format.

The aws_iam_role_policy_attachment resource attaches the IAM policy to the IAM role by specifying the policy ARN and the role name.

The aws_iam_instance_profile resource creates an IAM instance profile called s3-jenkins-profile and associates it with the IAM role. The instance profile will be used to launch the Jenkins EC2 instance with the IAM role and associated permissions.

This bash script installs and starts Jenkins on the EC2 instance. Let’s go through what each command does:

sudo yum update -y: This updates the package manager and all installed packages to their latest version.
sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo: This downloads the Jenkins repository file and saves it to /etc/yum.repos.d/ directory.
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key: This imports the Jenkins GPG key to verify package integrity.
sudo yum upgrade -y: This command upgrades all installed packages to their latest version.
sudo amazon-linux-extras install java-openjdk11 -y: This command installs Java 11 from the Amazon Linux Extras repository.
sudo yum install jenkins -y: This installs the Jenkins package from the Jenkins repository.
sudo systemctl enable jenkins: This command enables the Jenkins service to start automatically on boot.
sudo systemctl start jenkins: This command starts the Jenkins service.

The terraform block declares aws as the required provider and specifies the source and version. The provider is responsible for managing and interacting with resources in AWS.

The resource block defines an EC2 instance resource with the name jenkins. It defines attributes like the Amazon Machine Image (AMI) to use, the instance type, the security group and tags. The user_data attribute specifies the install_jenkins.sh script to run when the instance is launched.

The aws_s3_bucket resource block defines an S3 bucket, and aws_s3_bucket_acl block sets the access control list (ACL) for the S3 bucket.

This Terraform code defines an output named instance_public_ip that will expose the public IP address of an AWS EC2 instance running the Jenkins server.

The value attribute is set to aws_instance.jenkins.public_ip, which means that the output value will be the public IP address of the aws_instance resource named jenkins.


