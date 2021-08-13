resource "aws_ecs_cluster" "app_cluster" {
  name = "App_cluster"

}


data "template_file" "ecs_task_definition_template" {
  template = file(var.taskdef_template)

  vars = {
    task_definition_name = var.ecs_service_name
    ecs_service_name     = var.ecs_service_name
    docker_image_url     = var.docker_image_url
    memory               = var.fargate_memory
    cpu                  = var.fargate_cpu
    region               = var.aws_region
    app_port             = var.app_port


  }
}

resource "aws_ecs_task_definition" "test-nginx" {
  container_definitions    = data.template_file.ecs_task_definition_template.rendered
  family                   = var.ecs_service_name
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.fargate_iam_role.arn
  task_role_arn            = aws_iam_role.ecs_cluster_role.arn

}


resource "aws_ecs_service" "ecs_service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.app_cluster.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.test-nginx.arn

  network_configuration {
    subnets          = aws_subnet.private_subnets[*].id
    security_groups  = [aws_security_group.app_security_group.id]
    assign_public_ip = true

  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_cluster_alb.arn
    container_name   = var.ecs_service_name
    container_port   = var.app_port
  }

  depends_on = [aws_ecs_task_definition.test-nginx, aws_lb_listener.ecs_cluster_alb, aws_iam_role_policy.fargate_iam_role_policy]


}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "${var.ecs_service_name}-LogGroup"

}
