# SNS Topic for Notifications 
resource "aws_sns_topic" "idle_instance_topic" {
  name = "IdleInstanceTopic"
}

# SNS Subscription ( email alert)
resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.idle_instance_topic.arn
  protocol  = "email"
  endpoint  = "you can use your mail id here :)"  
}
