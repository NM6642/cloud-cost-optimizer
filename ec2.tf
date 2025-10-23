# EC2 instance for Cloud Cost Optimization 

resource "aws_instance" "cost_opt" {
  ami           = "ami-0914547665e6a707c"
  instance_type = "t3.micro"

  tags = {
    Name    = "CostOptimization"
    Project = "CloudCostOptimizer"
  }
}
