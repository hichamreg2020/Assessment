
 module "eks" {
 
  source          = "terraform-aws-modules/eks/aws"
  version         = "17.24.0"
  cluster_name    = "kubeAssessment"
  cluster_version = "1.21"
  subnets         = module.vpc_assess.private_subnets
  vpc_id = module.vpc_assess.vpc_id
  cluster_endpoint_public_access       = true

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      asg_desired_capacity          = 3
    }
  ]
}


