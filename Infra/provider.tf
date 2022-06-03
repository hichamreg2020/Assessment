terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.16.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


#dynamic "dockerprovider" {
 #   for_each = var.enable_docker_provider == true ? [1] : []
  #  content {
			provider "docker" {
			  registry_auth {
				address  = "${data.aws_ecr_authorization_token.token.proxy_endpoint }"
				username = "${data.aws_ecr_authorization_token.token.user_name}"
				password = "${data.aws_ecr_authorization_token.token.password}"
			  }
			  host       = "tcp://${local.dockerinstanceip}:2375"
			}
#    }
 # }

