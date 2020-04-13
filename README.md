# nursing_capstone
IT Capstone Project - Bluetooth Stethescope



### Backend

Helpful

* https://github.com/byu-oit/awslogin - How to use BYU awslogin CLI tool: 
* https://www.terraform.io/intro/index.html - What is Terraform
* https://learn.hashicorp.com/terraform/getting-started/install.html - Install Terraform

To get started make sure you are logged into the proper AWS account. Once you have cloned the directory to your local compupter, cd into the backend-ENV (dev or prd) and run ```terraform init```.

Once the init is done you can make changes to terraform and the lambda code and then run ```terraform apply``` to see all the changes that will occure.

Type ```yes``` or ```no``` to commit these changes to the AWS account that you are logged into.