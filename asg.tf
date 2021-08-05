resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.bar.name
  alb_target_group_arn   = aws_lb_target_group.example-tg.arn
}

resource "aws_launch_configuration" "example-lc" {
  name                        = "terraform-lc"
  image_id                    = "ami-0d382e80be7ffdae5"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  user_data                   = <<EOF
    #!/usr/bin/env bash
    sudo apt-get update
    sudo apt-get -y install npm git
    git clone git@github.com:cg-dv/express-js-3-tier.git
    cd express-js-3-tier/express_form
    npm install
    npm start
    EOF
  security_groups             = [aws_security_group.http.id]
  key_name                    = "tf_ca"
}

resource "aws_autoscaling_group" "bar" {
  name                      = "foobar3-terraform-test"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 300
  desired_capacity          = 1
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.example-lc.name
  target_group_arns         = [aws_lb_target_group.example-tg.arn]
  vpc_zone_identifier       = [aws_subnet.example_subnet_1.id, aws_subnet.example_subnet_2.id]

  initial_lifecycle_hook {
    name                 = "foobar"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 30
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }

  tag {
    key                 = "name"
    value               = "example-instance"
    propagate_at_launch = true
  }
}
