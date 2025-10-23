# CloudWatch Alarm for Idle CPU Usage 
resource "aws_cloudwatch_metric_alarm" "low_cpu_alarm" {
  alarm_name          = "LowCPUAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300               # 5 minutes
  statistic           = "Average"
  threshold           = 10.0               # CPU < 10%
  alarm_description   = "Triggers when instance CPU < 10% for 5 minutes"
  dimensions = {
    InstanceId = aws_instance.cost_opt.id
  }
  treat_missing_data = "notBreaching"
  alarm_actions      = [aws_sns_topic.idle_instance_topic.arn]
}
