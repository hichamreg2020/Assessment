# Assessment
In this project we will provision a web server and database in AWS
# instructions
- Provision a web server and SQL database to the cloud using IaC
- The Application will be reachable from the internet 
- The database will be reachable only  from the Application 
- The deployment will be Highly Available in Multiple Zones

# Tools
- IaC : Terraform Cloud
- Webserver :  NGINX
- Database : postgresql
- Orchestration : Kubernetes
- containerization : Docker 

# Steps

- Step 1 : Creation of VPC  using Terraform Module ( terraform-aws-modules/vpc/aws )  
  The VPC contains : 
    3 availability zones
    , 3 Public Subnets
    , 3 private Subnets 
    , 3 database subnets 
    
 ![image](https://user-images.githubusercontent.com/65364422/171838894-f1af0360-6237-4282-b012-468647ac4d81.png)
 
 ![image](https://user-images.githubusercontent.com/65364422/171839034-5703d7be-8f0e-42df-ab88-d86f17a68213.png)

- Step 2 : Creation of Multi-AZ EKS using Terraform module ( terraform-aws-modules/eks/aws )
 it contains 3 worker nodes 
 
 ![image](https://user-images.githubusercontent.com/65364422/171842172-496d2f3d-ee8e-4ff6-a492-e8de534a352a.png)

 
- Step 3 : Creation of  Database 

Create a standby instance in a different Availability Zone (AZ) to provide data redundancy, eliminate I/O freezes, and minimize latency spikes during system backups.

![image](https://user-images.githubusercontent.com/65364422/171841155-22dffc30-996f-4911-9972-5a4dcea58646.png)

- Step 4 : Creation of the web server 





