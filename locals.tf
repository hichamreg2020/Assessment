resource "random_uuid" "tag" {
}

locals {
  aws_ecr_url = aws_ecr_repository.repository.repository_url
  tag = random_uuid.tag.result
  dockerinstanceip = aws_instance.dockerinstance.public_eip[0]
  private_key = "${path.root}/dockerinstancesshkey.pem"
}