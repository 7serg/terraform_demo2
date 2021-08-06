#Security group for load balancer

resource "aws_security_group" "alb" {

  description = "comtrols connection to alb"
  vpc_id      = aws_vpc.demoecs_vpc.id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "load-balancer-sg"
  }
}

resource "aws_security_group" "bastion" {

  description = "controll connections from bastion servers"
  vpc_id      = aws_vpc.demoecs_vpc.id


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_subnets_cidr

  }

  tags = {
    Name = "bastion-sg"
  }
}


resource "aws_security_group" "webserver" {

  description = "controls access to web-servers"
  vpc_id      = aws_vpc.demoecs_vpc.id

  /*  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port       = ingress.value
      to_port         = ingress.value
      protocol        = "tcp"
      security_groups = ["aws_security_group.alb.id"]
    }
  }
*/
  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb.id]
  }


  ingress {
    protocol        = "tcp"
    from_port       = 22
    to_port         = 22
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "webserver-sg"
  }
}
