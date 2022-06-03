


resource "aws_ecr_repository" "repository" {
  name = "assessmentecr"
  depends_on = [ aws_instance.dockerinstance ]
}


resource "docker_registry_image" "web" {
    count = var.enable_docker_provider ? 1 : 0
    name = "${local.aws_ecr_url}:${local.tag}"
    build {
        context = "../webapp"
        dockerfile = "Dockerfile"
    }  
}
