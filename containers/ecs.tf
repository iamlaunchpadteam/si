module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "ecs-fargate"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = {
    Environment = "Development"
    Project     = "EcsEc2"
  }
}



resource "aws_ecs_task_definition" "ol_task" {
  family                   = "ol_task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "ol_task",
      "image": "public.ecr.aws/docker/library/open-liberty:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 9080,
          "hostPort": 9080
        }, 
        {
          "containerPort": 9443,
          "hostPort": 9443
        }
      ],
      "memory": 1024,
      "cpu": 512
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"] # Stating that we are using ECS Fargate
  network_mode             = "awsvpc"    # Using awsvpc as our network mode as this is required for Fargate
  memory                   = 1024         # Specifying the memory our container requires
  cpu                      = 512         # Specifying the CPU our container requires
  execution_role_arn       = "${aws_iam_role.ecsTaskExecutionRole.arn}"
}

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = "${aws_iam_role.ecsTaskExecutionRole.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_ecs_service" "ol_service" {
  name            = "ol-service"                             # Naming our first service
  cluster         = module.ecs.cluster_id//"${aws_ecs_cluster.my_cluster.id}"             # Referencing our created Cluster
  task_definition = "${aws_ecs_task_definition.ol_task.arn}" # Referencing the task our service will spin up
  launch_type     = "FARGATE"
  
  desired_count   = 3 # Setting the number of containers we want deployed to 3
  network_configuration {
    subnets = var.subnets
    security_groups = var.security_groups
    assign_public_ip = true
  }
}

resource "aws_alb" "application_load_balancer" {
  name               = "ol-lb-tf" # Naming our load balancer
  load_balancer_type = "application"
  subnets = var.subnets
  
  # Referencing the security group
  //security_groups = [aws_security_group.load_balancer_security_group.id]
  security_groups = var.security_groups
}

# # Creating a security group for the load balancer:
# resource "aws_security_group" "load_balancer_security_group" {
#   vpc_id = var.vpc_id
#   ingress {
#     from_port   = 9080 # Allowing traffic in from port 80
#     to_port     = 9080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
#   }

#   ingress {
#     from_port   = 9443 # Allowing traffic in from port 80
#     to_port     = 9443
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] # Allowing traffic in from all sources
#   }

#   egress {
#     from_port   = 0 # Allowing any incoming port
#     to_port     = 0 # Allowing any outgoing port
#     protocol    = "-1" # Allowing any outgoing protocol 
#     cidr_blocks = ["0.0.0.0/0"] # Allowing traffic out to all IP addresses
#   }
# }



resource "aws_lb_target_group" "target_group" {
  name        = "target-group"
  port        = 9080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id # Referencing the default VPC
  health_check {
    matcher = "200,301,302"
    path = "/"
  }
}

# resource "aws_lb_target_group" "target_group_a" {
#   name        = "target-group-a"
#   port        = 9443
#   protocol    = "HTTPS"
#   target_type = "ip"
#   vpc_id      = var.vpc_id # Referencing the default VPC
#   health_check {
#     matcher = "200,301,302"
#     path = "/"
#   }
# }


resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_alb.application_load_balancer.arn}" # Referencing our load balancer
  port              = "9080"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.target_group.arn}" # Referencing our tagrte group
  }
}

# resource "aws_lb_listener" "listener_a" {
#   load_balancer_arn = "${aws_alb.application_load_balancer.arn}" # Referencing our load balancer
#   port              = "9443"
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = "${aws_lb_target_group.target_group_a.arn}" # Referencing our tagrte group
#   }
# }