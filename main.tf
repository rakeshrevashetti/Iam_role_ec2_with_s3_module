
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = var.bucket_name
  tags = {
    Name        = "my-s3-bucket"
    Environment = "Dev"
  }
}

resource "aws_iam_role" "iam_role" {
  name = var.my_iam_role
  assume_role_policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement = [{

        Effect : "Allow",
        Principal : {
          Service : "ec2.amazonaws.com"
        }
        Action : "sts:AssumeRole"
      }]
  })
  tags = {
    Name = "my-iam-role"
  }
}

resource "aws_iam_policy" "iam_policy" {
  name        = "my-iam-policy"
  description = "My IAM policy"
  policy = jsonencode(
    {
      Version : "2012-10-17",
      Statement = [
        {
          Effect : "Allow",
          Action : [
            "s3:ListBucket",
            "s3:GetObject"
          ],
          "Resource" : "arn:aws:s3:::rakeshrrs3bucket/*"
        }
      ]
  })
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}
resource "aws_iam_instance_profile" "my_instance_profile" {
  name = "my-instance-profile"
  role = aws_iam_role.iam_role.name
}


resource "aws_security_group" "ec2_security_group" {
  name        = "ec2_sg"
  description = "Allow SSH and HTTP"
  vpc_id      = var.my_vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
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

resource "aws_instance" "my-instance" {
  ami                    = var.my_ami
  instance_type          = var.my_instnace_type
  subnet_id              = var.my_subnet_id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.my_instance_profile.name
  tags = {
    Name = "my-instance"
  }
}
