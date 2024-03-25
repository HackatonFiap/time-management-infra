# ecs.tf

resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-cluster"
}

#-----------------------------------------------------------
# Fiap-lanches-Conta-api
#-----------------------------------------------------------
resource "aws_ecs_task_definition" "time-management-task-app" {
  family                   = "${var.app_name}-app-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = jsonencode([
    {
      "name" : "${var.app_name}",
      "image" : var.dict_app_image["time_management"],
      "cpu" : var.fargate_cpu,
      "memory" : var.fargate_memory,
      "networkMode" : "awsvpc",
      "portMappings" : [
        {
          "containerPort" : var.dict_port_app["time_management"],
          "hostPort" : var.dict_port_app["time_management"],
          "protocol" : "tcp"
        }
      ],
      "essential" : true,
      "environment" : [
        {
          "name" : "SPRING_DATASOURCE_USERNAME",
          "value" : "postgres"
        },
        {
          "name" : "SPRING_DATASOURCE_PASSWORD",
          "value" : "postgres"
        },
        {
          "name" : "SPRING_DATASOURCE_URL",
          "value" : "jdbc:postgresql://${aws_db_instance.db_instance.endpoint}/timemgm"
        },
        {
          "name" : "SPRING_JPA_HIBERNATE_DDL_AUTO",
          "value" : "create"
        }
      ],
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "/ecs/${var.app_name}",
          "awslogs-region" : "${var.aws_region}",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
  depends_on = [aws_alb.main]
}

resource "aws_ecs_service" "time-management-service-main" {
  name            = "${var.app_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.time-management-task-app.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.conta_app.id
    container_name   = var.app_name
    container_port   = var.dict_port_app["time_management"]
  }

  depends_on = [aws_alb_listener.conta_app, aws_iam_role_policy_attachment.ecs_task_execution_role, aws_alb.main, aws_db_instance.db_instance]
}
