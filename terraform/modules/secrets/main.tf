resource "random_password" "app_token" {
  length  = 32
  special = false
}

resource "aws_secretsmanager_secret" "app" {
  name                    = "${var.name_prefix}/platform-app"
  description             = var.app_secret_description
  recovery_window_in_days = var.recovery_window_in_days

  tags = {
    Name = "${var.name_prefix}-secret-app"
  }
}

resource "aws_secretsmanager_secret_version" "app" {
  secret_id = aws_secretsmanager_secret.app.id
  secret_string = jsonencode({
    token = random_password.app_token.result
  })
}
