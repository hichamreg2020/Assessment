

resource "aws_ecr_repository" "repository" {
  name = "assessmentecr"
}


resource "docker_registry_image" "web" {
    name = "${local.aws_ecr_url}:${local.tag}"
    build {
        context = "../webapp"
        dockerfile = "Dockerfile"
    }  
}