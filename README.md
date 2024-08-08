# Terraform Project

This project sets up an AWS infrastructure using Terraform. It includes the creation of a VPC, subnets, an EC2 instance, an Elastic IP (EIP), and a Route 53 record. The project is modular and supports multiple environments (dev, staging, prod).

## Directory Structure
```
terraform/
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── backend.tf
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── eip/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── route53/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
```

## Setup

### Initialize Terraform
Navigate to the project directory and initialize Terraform:

```sh
cd /Users/sekharkhanal/Documents/projects/terraform
terraform init
```

### Create Workspaces
Create workspaces for `dev`, `staging`, and `prod`:

```sh
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

### Select Workspace
Select the desired workspace:

```sh
terraform workspace select dev
# or
terraform workspace select staging
# or
terraform workspace select prod
```

### Apply Configuration
Apply the Terraform configuration:

```sh
terraform apply
```

## Configuration Files

### `main.tf`
```hcl
provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

module "ec2" {
  source = "./modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  subnet_id = module.vpc.public_subnet_id
}

module "eip" {
  source = "./modules/eip"
  instance_id = module.ec2.instance_id
}

module "route53" {
  source = "./modules/route53"
  zone_id = var.zone_id
  record_name = var.record_name
  record_type = "A"
  record_value = module.eip.eip
}
```

### `variables.tf`
```hcl
variable "region" {
  description = "AWS region"
  type = string
  default = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type = string
  default = "10.0.1.0/24"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type = string
  default = "t2.micro"
}

variable "zone_id" {
  description = "Route 53 Hosted Zone ID"
  type = string
}

variable "record_name" {
  description = "Route 53 record name"
  type = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type = string
  default = "dev"
}
```

### `outputs.tf`
```hcl
output "instance_id" {
  value = module.ec2.instance_id
}

output "eip" {
  value = module.eip.eip
}

output "route53_record" {
  value = module.route53.record
}
```

### `provider.tf`
```hcl
provider "aws" {
  region = var.region
}
```

### `backend.tf`
```hcl
terraform {
  backend "local" {
    path = "terraform.tfstate"
  }

  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "path/to/my/key"
    region         = "us-west-2"
    dynamodb_table = "my-lock-table"
  }
}
```

## Modules

### VPC Module

#### `modules/vpc/main.tf`
```hcl
resource "aws_vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.main.id
}
```

#### `modules/vpc/variables.tf`
```hcl
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type = string
}
```

#### `modules/vpc/outputs.tf`
```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_id" {
  value = aws_subnet.main.id
}
```

### EC2 Module

#### `modules/ec2/main.tf`
```hcl
resource "aws_instance" {
  ami = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
}

output "instance_id" {
  value = aws_instance.main.id
}
```

#### `modules/ec2/variables.tf`
```hcl
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type = string
}

variable "subnet_id" {
  description = "Subnet ID for the EC2 instance"
  type = string
}
```

#### `modules/ec2/outputs.tf`
```hcl
output "instance_id" {
  value = aws_instance.main.id
}
```

### EIP Module

#### `modules/eip/main.tf`
```hcl
resource "aws_eip" {
  instance = var.instance_id
}

output "eip" {
  value = aws_eip.main.public_ip
}
```

#### `modules/eip/variables.tf`
```hcl
variable "instance_id" {
  description = "Instance ID to associate with the EIP"
  type = string
}
```

#### `modules/eip/outputs.tf`
```hcl
output "eip" {
  value = aws_eip.main.public_ip
}
```

### Route 53 Module

#### `modules/route53/main.tf`
```hcl
resource "aws_route53_record" {
  zone_id = var.zone_id
  name = var.record_name
  type = var.record_type
  ttl = 300
  records = [var.record_value]
}

output "record" {
  value = aws_route53_record.main.fqdn
}
```

#### `modules/route53/variables.tf`
```hcl
variable "zone_id" {
  description = "Route 53 Hosted Zone ID"
  type = string
}

variable "record_name" {
  description = "Route 53 record name"
  type = string
}

variable "record_type" {
  description = "Route 53 record type"
  type = string
}

variable "record_value" {
  description = "Route 53 record value"
  type = string
}
```

#### `modules/route53/outputs.tf`
```hcl
output "record" {
  value = aws_route53_record.main.fqdn
}
```

## Detailed Steps and Commands

### Initialize Terraform
Navigate to the project directory and initialize Terraform:

```sh
cd /Users/sekharkhanal/Documents/projects/terraform
terraform init
```

### Create Workspaces
Create workspaces for `dev`, `staging`, and `prod`:

```sh
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

### Select Workspace
Select the desired workspace:

```sh
terraform workspace select dev
# or
terraform workspace select staging
# or
terraform workspace select prod
```

### Apply Configuration
Apply the Terraform configuration:

```sh
terraform apply
```

### How Each Workspace Works

- **dev**: This workspace is used for development purposes. You can test and validate your Terraform configurations here before moving to staging or production.
- **staging**: This workspace is used for staging purposes. It is a pre-production environment where you can perform final tests before deploying to production.
- **prod**: This workspace is used for production purposes. It is the live environment where your actual infrastructure runs.

By using workspaces, you can manage multiple environments within the same Terraform configuration. Each workspace has its own state file, allowing you to isolate the state of each environment.

### Ensuring Isolation
- **State Files**: Each workspace has its own state file, ensuring that the state of resources in one environment does not interfere with another.
- **Resource Names**: If you use resource names or tags that include the workspace name (e.g., `dev-instance`, `staging-instance`), it further ensures that resources are easily identifiable and isolated by environment.

### Example of Isolated State Files
- `terraform.tfstate.d/dev/terraform.tfstate`
- `terraform.tfstate.d/staging/terraform.tfstate`
- `terraform.tfstate.d/prod/terraform.tfstate`

By using Terraform workspaces, you can manage multiple environments within the same configuration while keeping them isolated from each other.
