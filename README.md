# Assessment
In this project we will provision a web server and database in AWS
# instructions
- Provision a web server and SQL database to the cloud using IaC
- The Application will be reachable from the internet 
- The database will be reachable only  from the Application 
- The deployment will be Highly Available in Multiple Zones

# Tools
- IaC : Terraform Cloud
- VCS : Github
- Webserver :  NGINX
- Database : postgresql
- Orchestration : Kubernetes
- containerization : Docker 

# Steps



- Step 0 : 

Configure a continuous integration and continuous delivery (CI/CD) workflow using GitHub and Terraform Cloud 

link the terraform cloud workspace to the GitHub repos : 
  

![image](https://user-images.githubusercontent.com/65364422/171991508-689702a5-977f-466a-a57b-66f8833d0d20.png)
  
  
Config AWS Credentials 

![image](https://user-images.githubusercontent.com/65364422/171991632-cd49d0c0-2a55-4482-a097-3195f29beab1.png)


- Step 1 : Creation of VPC  using Terraform Module ( terraform-aws-modules/vpc/aws )  
  The VPC contains : 
    3 availability zones
    , 3 Public Subnets
    , 3 private Subnets 
    , 3 database subnets 
    , NAT Gateway
    , Internet Gateway 
    
    
 ![image](https://user-images.githubusercontent.com/65364422/171838894-f1af0360-6237-4282-b012-468647ac4d81.png)
 
 ![image](https://user-images.githubusercontent.com/65364422/171839034-5703d7be-8f0e-42df-ab88-d86f17a68213.png)

- Step 2 : Creation of Multi-AZ EKS using Terraform module ( terraform-aws-modules/eks/aws )
 it contains 3 worker nodes 
 
 ![image](https://user-images.githubusercontent.com/65364422/171842172-496d2f3d-ee8e-4ff6-a492-e8de534a352a.png)

 
- Step 3 : Creation of RDS Postgres Database 

Create  additional standby instances in  different Availability Zones  to provide data redundancy.

![image](https://user-images.githubusercontent.com/65364422/171841155-22dffc30-996f-4911-9972-5a4dcea58646.png)

Export of the DB credentials to AWS sercets manager 

![image](https://user-images.githubusercontent.com/65364422/171952451-5d73d5d4-7ab9-4046-b86f-6d34218a162d.png)

- Step 4 : Configuration of Docker Provider

 An EC2 instance was provisionned in order to use Docker provider 
 
 ![image](https://user-images.githubusercontent.com/65364422/171954501-48065ada-2551-4301-8d16-8dc5269ae9de.png)

we faced an issue to configure the docker provider to use SSH because of a private key constraint, in fact the private key should be generated before because  Terraform checks providers block first then move to check other ressources including the private key creation 

![image](https://user-images.githubusercontent.com/65364422/171956083-4990a18d-f71a-43be-9625-1f2a4e741e6c.png)

To bypass this issue we swiched to Docker TCP socket to be able to connect to docker without the need to deal with SSH keys


- Step 5 : Creation of Docker Image

    => Using AWS provider : 
      Creation of the ECR 
   
 ![image](https://user-images.githubusercontent.com/65364422/171950519-e05dde93-6cc4-468b-a0ef-bff84d027ec6.png)

   => Using Docker provider ( kreuzwerker /docker ) : 
      Creation and upload the image to the private ECR 
 

      
   ![image](https://user-images.githubusercontent.com/65364422/171950921-43df3d8c-d7d9-45a0-8d68-71779c5cd97a.png)

      
  ![image](https://user-images.githubusercontent.com/65364422/171950768-120d4e72-e59d-4235-8dc9-7cda9e2b3765.png)

 

- Step 6 : Creation of the web server 

 Creation of kubernetes secret containing the db credentials 

![image](https://user-images.githubusercontent.com/65364422/171952751-3a1d7dd5-4180-4562-b44d-47f3d12ad42c.png)

 Creation of a kubernetes deployment using a customised Docker image 
 
 Mounting the db secret as environnement variable on the container 
 
 ![image](https://user-images.githubusercontent.com/65364422/171953117-c548ae68-99c4-49f4-8dde-df8137deee43.png)
 
 Expose the Application on a Loadbalancer service
 
 ![image](https://user-images.githubusercontent.com/65364422/171953830-e648df84-c782-4610-a11d-56e052e27834.png)
 
  - Step 7 : Terraform Apply
 
 because we are  using terraform cloud , for the first creation of terraform ressources  follow the 2 steps below 
   
  First run : rename the docker.tf file ( remove .tf ext ) to ignone it ,   because we have to provision first an EC2 that contains Docker
  Second Run : add the .tf extention to the file 
  
  NB : we tried to use the .terraformignore but it didn't work , so i renamed the file 
   
  
  at the and of the run we must have an output that displays the webserver URL
  
  ![image](https://user-images.githubusercontent.com/65364422/172028612-73760f09-d247-4851-beca-241b79d2f97c.png)

  
  final result : 
  
  ![image](https://user-images.githubusercontent.com/65364422/172052883-9428a21f-e5a1-4a90-a00d-4a2a649917cb.png)

  
  
  ## Conclusion 
  the challenge was to create both provisionning and CICD with Terraform tool only
  so actually with this terraform code we can do also the Continuous deployment without the need of other 3rd party tools 
  
 


 
 






