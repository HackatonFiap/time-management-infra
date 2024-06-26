# variables.tf

variable "aws_region" {
  description = "The AWS region things are created in"
  default     = "us-east-1"
}

variable "app_name" {
  default = "time-management"
  type    = string
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "myEcsTaskExecutionRole"
}

variable "az_count" {
  description = "Number of AZs to cover in a given region"
  default     = "2"
}

variable "dict_app_image" {
  description = "Docker image to run in the ECS cluster"
  default = {
    time_management = "516194196157.dkr.ecr.us-east-1.amazonaws.com/time-management-app:latest"
  }
  type = map(string)
}

variable "dict_port_app" {
  description = "Port exposed by the docker image to redirect traffic to"
  default = {
    time_management = 8080
  }
  type = map(number)
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "health_check_path" {
  default = "/actuator/health"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "512"
  type        = number
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "1024"
  type        = number
}

