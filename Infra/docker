
provider "docker" {
  registry_auth {
	address  = "${data.aws_ecr_authorization_token.token.proxy_endpoint }"
	username = "${data.aws_ecr_authorization_token.token.user_name}"
	password = "${data.aws_ecr_authorization_token.token.password}"
  }
  host       = "tcp://${aws_instance.dockerinstance.public_ip}:2375"
}


resource "docker_registry_image" "web" {
    name = "${local.aws_ecr_url}:${local.tag}"
    build {
        context = "../webapp"
        dockerfile = "Dockerfile"
    }  
}
