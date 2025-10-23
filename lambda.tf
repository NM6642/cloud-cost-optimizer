# IAM Role for Lambda 
resource "aws_iam_role" "lambda_ec2_role" {
  name = "LambdaEC2StopRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach policy to allow Lambda to stop EC2 and write logs
resource "aws_iam_role_policy_attachment" "lambda_ec2_policy" {
  role       = aws_iam_role.lambda_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_logs_policy" {
  role       = aws_iam_role.lambda_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function 
resource "aws_lambda_function" "stop_ec2" {
  function_name = "StopIdleEC2"
  role          = aws_iam_role.lambda_ec2_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.11"

  # Inline code for simplicity
  filename      = "lambda.zip"  
}

# Lambda Permission to be triggered by SNS 
resource "aws_lambda_permission" "allow_sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.stop_ec2.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.idle_instance_topic.arn
}

# Subscribe Lambda to SNS Topic
resource "aws_sns_topic_subscription" "lambda_subscription" {
  topic_arn = aws_sns_topic.idle_instance_topic.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.stop_ec2.arn
}
