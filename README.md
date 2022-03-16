# cpe-terraform

Terraform repository for CPE classes

## Introduction

For all modules below, here are the first steps:
1) Start the sandbox environment (and not a Lab environment).
2) Create an AWS Cloud9 environment from the AWS Console.
3) Once in the Cloud9 environment, you can checkout the code:
```bash
git clone https://github.com/taufort/cpe-terraform.git
```

## Module 4 - AWS Cloud Security

1) After you have cloned the git repository, you can go into the module:
```bash
cd cpe-terraform/04_cloud_security/
```
2) And start working with Terraform:
```bash
# Init the Terraform layer and download required providers
terraform init

# Take a look at what Terraform will do on AWS
terraform plan

# Create/update resources on AWS
terraform apply
```
3) Go look into the AWS Console that an SNS topic was created after you ran `terraform apply`. 
4) Try to update the "Display name" through the AWS console and re-run `terraform apply` afterwards and see what
happens.
5) Check that you can send a message into the topic with the "Publish message" button in the console.
6) Take a look in the AWS console at the generated SNS policy in the "Access policy" tab. This policy 
was auto-generated and does not respect least privilege at the moment.
7) Now, you need to add an SNS policy on that topic with some Terraform code in `sns.tf` file to block the 
IAM role `voclabs` from publishing any SNS message in the topic. The `voclabs` IAM role is the role you
are assuming when you are using the AWS Console.
8) Once the policy has been modified with Terraform. Check that you cannot publish anymore an event in the topic
through the AWS console.
9) Once you have succeeded the previous steps, authorize the `voclabs` role to publish messages but block
every other IAM user/role from doing so (always with Terraform). Check that you can now publish again a message
into the topic.
10) Activate the encryption on the SNS topic with KMS (and Terraform) to respect the security pillars of AWS. 

### Module 4 - AWS Cloud Security - Solution

You'll find two solutions for this module:
* The first solution is to use an inlined JSON AWS IAM policy in the `aws_sns_topic` resource directly. This solution
works fine but is not very easy to maintain because you're manipulating JSON directly. This solution can be found
in `04_cloud_security/solution_1` directory.
* The second solution is to use the `aws_iam_policy_document` datasource instead on an inline IAM policy. This solution 
is more user-friendly because you do not have to manipulate JSON directly (the JSON is generated thanks
to the `aws_iam_policy_document` datasource). This solution can be found in `04_cloud_security/solution_2` directory.
* The third solution is to use the `aws_sns_topic_policy` resource and the `aws_iam_policy_document` datasource. 
This solution can be found in `04_cloud_security/solution_3` directory. 

### Go further

Terraform offers other useful commands such as:
 * `terraform state` to look into the state of your infrastructure (to read it or to update it for instance).
 * `terraform import` to include an already existing resource into the state.
 * `terraform destroy` to destroy the infrastructure you created.
 * ...

Check out the Terraform documentation and try out a few of these commands to get used to using Terraform. 

In this Terraform code example, we are using a Terraform local backend, which is not a good practice for
production. When working with AWS, it's strongly recommended to use 
the [S3 backend](https://www.terraform.io/language/settings/backends/s3). Try to set it up in place of the local
backend.

## Module 5 - Networking

1) After you have cloned the git repository, you can go into the module:
```bash
cd cpe-terraform/05_networking/
```

2) And start working with Terraform:
```bash
terraform init
terraform apply
```

3) Go look into the AWS Console that new resources have just been created:
* a VPC named `05_networking-vpc` with CIDR block `10.1.0.0/21`;
* an Internet gateway `05_networking-internet-gateway`;
* 2 route tables: one public and one private;
* Check the public route table: there should be one route towards the internet gateway. That route will help us later
to make public subnets.

4) Now, it's your turn to work! You will have to first create 2 subnets within the newly created VPC:
* 1 public subnet with CIDR `10.1.0.0/24`;
* 1 private subnet with CIDR `10.1.4.0/24`.
Both subnets should be created in Availability zone A. Beware, public subnets should have `map_public_ip_on_launch`
parameter set to `true` so that instances started in these subnets get a public IP. You can check `aws_subnet`
resource in [Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet).
5) Once the subnets are created, you will have to associate them to the Route tables to allow internet access. 
Else, if you start an instance, you won't be able to access internet resources.
Use `aws_route_table_association` resources to associate the public subnet to the public route table and private
subnet to the private route table.

6) Now we have 2 subnets, in AZ a: one public and one private. But it's not highly available at the moment. If AZ a
would come to fail, our applications deployed in those subnets would not be able to recover. Let's now create 4 new
subnets:
* 2 new public subnets in AZ b and AZ c;
* 2 new private subnets in AZ b and AZ c as well.
Each of these subnets should have 256 IP addresses each. The public subnets IP addresses should be within 
`10.1.0.0/22` CIDR block and the private subnets should be within `10.1.4.0/22` CIDR block.

> Note: a `/22` contains 1,024 IP addresses. You can use this [IP address website](https://www.ipaddressguide.com/cidr) 
to help you set up your subnet's CIDR blocks.

7) (optional) Start an EC2 instance by hand within the AWS Console in one of your public subnet. 
Try to connect through SSH to this instance and verify that you can access internet through a curl command. 
You can check that `curl http://ifconfig.io` returns the public IP address of your EC2 instance.
