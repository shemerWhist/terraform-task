
data "local_file" "template_file" {
    filename = "${path.module}/container-config.json"
}


# create cluster
resource "aws_ecs_cluster" "cluster-main" {
  name = "terraform-task"
}

# capacity provider association
resource "aws_ecs_cluster_capacity_providers" "cluster-cp" {
    cluster_name = aws_ecs_cluster.cluster-main.name
    capacity_providers = [ aws_ecs_capacity_provider.main-capacity-provider.name ]
}

# create a service
resource "aws_ecs_service" "task-service" {
  name            = "task-service"
  cluster         = aws_ecs_cluster.cluster-main.id
  task_definition = aws_ecs_task_definition.terraform-task.arn
  desired_count   = 2

}

# create task definitions
resource "aws_ecs_task_definition" "terraform-task" {
  family             = "worker"
  network_mode       = "bridge"
  cpu                = "1vcpu"
  memory             = "500"

  container_definitions =  data.local_file.template_file.content

}

# create capacity provider
resource "aws_ecs_capacity_provider" "main-capacity-provider" {
  name = "main-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.asg-arn
    managed_termination_protection = "DISABLED"
    managed_scaling {
        maximum_scaling_step_size = 4
        minimum_scaling_step_size = 2
        status = "ENABLED"
        target_capacity = 100
    }

  }
}
