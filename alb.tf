
#Initialization of application load balancer

resource "aws_lb" "webserver" {
  name            = "webserver-alb"
  subnets         = aws_subnet.public_subnets[*].id
  security_groups = [aws_security_group.alb.id]
}


resource "aws_lb_target_group" "webserver" {
  name        = "webservers-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.demoecs_vpc.id
  target_type = "instance"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

}

resource "aws_lb_target_group_attachment" "webservers" {
  count            = length(aws_instance.web_server[*].id)
  target_group_arn = aws_lb_target_group.webserver.id
  target_id        = element(aws_instance.web_server[*].id, count.index)
  port             = 80
}


resource "aws_lb_listener" "webserver" {
  load_balancer_arn = aws_lb.webserver.id
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.webserver.id
    type             = "forward"
  }
}
