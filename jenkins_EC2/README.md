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
