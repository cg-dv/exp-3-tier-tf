# Express JS 3-Tier Architecture 

This repository is home to a Terraform configuration that defines a 3-tier
architecture running a simple JS app that queries a MySQL database.

## Diagram

<img src="diagram/AWS-express-3-tier.drawio.png?raw=true">

## Architecture

In this configuration, an application load balancer (ALB) distributes traffic amongst EC2 web servers running a very small Node JS app.  The EC2 web servers are in an auto scaling group (ASG) which launches instances in 2 public subnets in separate availability zones.  The EC2 web servers fetch RDS database credentials from AWS Secrets Manager via a VPC endpoint, and the Node JS app running on the EC2 instances queries for the records in the MySQL database running on RDS in two private subnets.  RDS runs on both a primary instance and a replica in two private subnets in two availability zones in a Multi-AZ configuration (if the primary instance terminates, the replica is promoted to a full DB instance that can accept write traffic).  The RDS instances can fetch software updates via the NAT Gateway in this VPC, and can only accept incoming traffic from the web servers running in the public subnets in this VPC.  The Terraform state file for this configuration is stored in S3. 


## Outputs

The Terraform config for this infrastructure outputs the URL of the ALB defined in this architecture.  The ALB points to the web servers hosting the Node JS app.

When the user connects to the ALB, the app fetches MySQL database records and returns them as a JSON object which displays in the browser.
