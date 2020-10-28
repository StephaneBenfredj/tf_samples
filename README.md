# Notes 

## Versions
```
% terraform version
Terraform v0.13.5
```

```
OSX 10.15.7
```


## Terraform 0.12 and 0.13 changes

### Providers (0.13+)
(from https://www.terraform.io/upgrade-guides/0-13.html) 
Prior to 0.13: automatic provider installation only for providers packaged and distributed by HashiCorp. 
Providers built by the community required manual installation by extracting their distribution packages into specific local filesystem locations.

Terraform 0.13+ : new hierarchical *namespace* for providers to separate HashiCorp and community providers

Terraform now requires explicit source information for any providers that are not HashiCorp-maintained, using a new syntax in the required_providers nested block inside the terraform configuration block

```
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.12.0"
    }
  }
}
```

`hashicorp` is the namespace for Hashicorp-maintained provider plugins
(note: HC namespace declaration is not mandatory while others are but cleaner syntax - `source = provider/name`) 


### Variables (0.12+)


#### Variable syntax pre-terraform 0.12

```
provider "aws" {
    access_key = "${var.access_key}"
    ...
}
```


#### Variable syntax with terraform 0.13

```
provider "aws" {
  access_key = var.aws_access_key
  ...
} 
```


### Managing values for module vars
(Ref: https://www.terraform.io/docs/configuration/variables.html)


#### Terraform Cloud 
TBD 


#### thru cli using -var
TBD
`terraform apply -var="image_id=ami-abc123"`


#### variable definition files (.tfvars)
TBD

#### use TF Environment variables
TF_VAR_ + name of the declared variable

`export TF_VAR_aws_access_key="xxxxxxxxxxxx"`

