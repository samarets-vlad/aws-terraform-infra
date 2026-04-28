resource "aws_security_group" "app" {
  name        = "${var.name_prefix}-app-sg"
  description = "App security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [var.alb_security_group]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict in production
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app" {
  count                       = length(var.subnet_ids)
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_ids[count.index]
  vpc_security_group_ids      = [aws_security_group.app.id]
  associate_public_ip_address = false
  key_name                    = var.ssh_key_name
  user_data                   = file(var.user_data_file_path)

  tags = {
    Name = "${var.name_prefix}-app-${count.index + 1}"
    Role = "application"
  }
}

resource "aws_lb_target_group_attachment" "app" {
  count            = length(aws_instance.app)
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.app[count.index].id
  port             = var.app_port
}
