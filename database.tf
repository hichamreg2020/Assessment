

resource "random_string" "Assessment-db-password" {
	  length  = 32
	  upper   = true
	  number  = true
	  special = false
}

resource "aws_security_group" "AssessmentSG" {
  name        = "AssessmentSG"
  description = "An ingress for to the db from kubernetes only"
  vpc_id      = module.vpc_assess.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [
      module.eks.cluster_security_group_id,
	  module.eks.worker_security_group_id
	]
    self = false
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

}

resource "aws_db_subnet_group" "assessment" {
  name       = "assessment"
  subnet_ids = module.vpc_assess.private_subnets

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "assessment-db" {
  identifier             = "assessment-db"
  name                   = "assessmentdb"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "13.4"
  skip_final_snapshot    = true
  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.AssessmentSG.id]
  username               = var.db_username
  password               = "${random_string.Assessment-db-password.result}"
  db_subnet_group_name   = aws_db_subnet_group.assessment.name
}


resource "aws_secretsmanager_secret" "Assessment-db_secret" {
  name = "Assessment-db-credentials"
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.Assessment-db_secret.id
  secret_string = <<EOF
{
  "PASSWORD": "${random_string.Assessment-db-password.result}"
  "USERNAME": var.db_username
 }
EOF

}
