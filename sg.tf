resource "aws_security_group" "http" {
  name        = "http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.example.id

  ingress {
    description = "TLS from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "vpc-endpoint-secrets-manager" {
  name        = "vpc-endpoint-secrets-manager"
  description = "Allow access to secrets manager from EC2"
  vpc_id      = aws_vpc.example.id

  ingress {
    description     = "TLS from http security group"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.http.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
