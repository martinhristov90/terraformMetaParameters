## This reposistory is created with learning purposes for Terraform, focusing on Terraform meta-parameters and especially on `count` meta parameter.

## Purpose :

- The repository provides simple introduction to Terraform meta-parameters and demonstrating the usage of `count` meta parameter.

## How to install terraform : 

- The information about installing terraform can be found on the HashiCorp website 
[here](https://learn.hashicorp.com/terraform/getting-started/install.html)

## What is Terraform meta-parameter :

- Meta-parameters are used for higher level of control which is not the default one, they change the behavior of Terraform. Here are few :
    - `depends_on` - it is used to imply hidden dependencies between resources. For example if we want to create an instance profile for particular EC2 instance, the profile should be created before the EC2 instance. By using the meta-parameter `depends on` in the resource block for the EC2 instance and specifying that it depends on the instance profile, Terraform is going to create the profile first and then the EC2 instance.
    Using `depend_on` meta-parameter is not always necessary since Terraform is clever enough to figure out dependencies between the resources. Use this meta-parameter as last resort. Example :
        ```
        resource "aws_iam_instance_profile" "example" {
          role = aws_iam_role.example.name
        }
        resource "aws_instance" "example" {
          ami           = "ami-test"
          instance_type = "t2.micro"
          depends_on = [
            aws_iam_role_policy.example,
          ]
        }
        ```
    - `lifecycle` - This meta-parameter changes the default lifecycle behavior of a resource. Some resources cannot be update in-place, in order to change those resources, Terraform is going to destroy the resource and then create new one with the new configuration. To alter this behavior, Terraform might be told to create the new resource before destroy the old one, preventing downtime, the meta-argument for this is `create_before_destroy`, example :
        ```
        resource "aws_instance" "example" {
          ami           = "ami-test"
          instance_type = "t2.micro"
          lifecycle {
              create_before_destroy = true
          }
        }
        ```
    - `count` - `count` meta-parameter comes handy when more than one resource of same type should be created, it helps to reproduce the resources. Example: 
        ```
        resource "aws_instance" "web" {
            ami = "ami-0444fa3496fb4fab2"
            instance_type = "t2.micro"
            # Defining how many the resource to be reproduced. 
            count = 2
    
            tags {
                "name" = "MYMACHINE-${count.index + 1}"
    
            }
        }
        ```
    The `count` keywords is used to define how many `aws_instance` resources should be created.

## How to use this repository :

- In a directory of your choice, clone the github repository 
    ```
    git clone https://github.com/martinhristov90/terraformMetaParameters.git
    ```

- Change into the directory
    ```
    cd terraformMetaParameters
    ```

- It is good practice to have a separate user that Terraform is going to perform actions with, more information [how to create a user in AWS](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html)

- set AWS credentials as environemental variables, as decribed [here](https://www.terraform.io/docs/providers/aws/index.html#environment-variables)

    ```
    export AWS_ACCESS_KEY_ID="anaccesskey"
    export AWS_SECRET_ACCESS_KEY="asecretkey"
    ```

- Use your favorite text editor to modify the file `main.tf`. Set the following values :
    - `ami` - The AMI ID to be used.
    - `instance_type` - The size that you desire.
    - `subnet_id`  - Sets the subnet in which the instance is going to be attaced.
    - `vpc_security_group_ids` - Sets the ID of the security group.

- After all the values of the variables are set correctly, go ahead and execute `terraform init`. 
The output should look like this :

    ```shell
    --- SNIP ---

    * provider.aws: version = "~> 2.11"

    Terraform has been successfully initialized!

    --- SNIP ---
    ```

- Now, Terraform has downloaded the AWS provider for you automatically.

- To preview what is going to happen without actually performing any actions, execute `terraform plan`. You are goingto    be asked to enter value for `instanceCount` variable. The output should look like this : 

    ```

    An execution plan has been generated and is shown below.
    Resource actions are indicated with the following symbols:
      + create

    Terraform will perform the following actions:

      + aws_instance.web[0]
          ami:                               "ami-0444fa3496fb4fab2"
    --- SNIP ---
          tags.name:                         "MYMACHINE-1"
    --- SNIP ---

      + aws_instance.web[1]

          ami:                               "ami-0444fa3496fb4fab2"
    --- SNIP ---
          tags.name:                         "MYMACHINE-2"
    --- SNIP ---


    Plan: 2 to add, 0 to change, 0 to destroy.

    ------------------------------------------------------------------------
    ```
- Now `terraform apply` can be executed to created the desired number of instances in AWS.
