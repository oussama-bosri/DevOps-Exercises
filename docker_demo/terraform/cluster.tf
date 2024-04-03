resource "aws_kms_key" "log_group_key" {
  description             = "log_group_key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_cloudwatch_log_group" "cluster_logs" {
  name = "ecs-cluster-logs-${var.environment}"
}

resource "aws_ecs_cluster" "main_cluster" {
  name = "ecs-cluster-${var.environment}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.log_group_key.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.cluster_logs.name
      }
    }
  }
}
