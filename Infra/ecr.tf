
resource "aws_ecr_repository" "repository" {
  name = "assessmentecr"
  depends_on = [ aws_instance.dockerinstance ]
}
