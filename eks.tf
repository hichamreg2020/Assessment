module "eks_cluser" {
  create_eks                           = var.create_eks
  source                               = "terraform-aws-modules/eks/aws"
  version                              = "17.1.0"
  cluster_name                         = "kubeAssess"
  cluster_version                      = "1.21"
  subnets                              = module.vpc_assess.public_subnets
  vpc_id                               = module.vpc_assess.vpc_id
  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  #manage_aws_auth                      = true
  #map_roles                            = [ { "groups" = [ "system:masters" ], "rolearn" = var.iam_role_arn, "username" = "system:node:{{EC2PrivateDNSName}}" } ]
  }
