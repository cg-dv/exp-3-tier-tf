resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.bar.name
  alb_target_group_arn   = aws_lb_target_group.example-tg.arn
}

resource "aws_iam_instance_profile" "asg-secrets-manager-profile" {
  name = "asg-instance-profile"
  role = "EC2-Secrets-Manager-Read-Write"
}

resource "aws_launch_configuration" "example-lc" {
  name                        = "terraform-lc"
  image_id                    = "ami-0d382e80be7ffdae5"
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.asg-secrets-manager-profile.name
  associate_public_ip_address = true
  user_data                   = <<-EOF
    #!/usr/bin/env bash
    sudo apt-get update
    sudo apt-get -y upgrade
    sudo apt-get -y install nodejs npm git
    git clone https://github.com/cg-dv/express-js-3-tier.git
    cd express-js-3-tier/express_form
    sudo npm install
    sudo sed -i '' -e 's/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf 
    sudo sysctl -p /etc/sysctl.conf
    sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
    sudo iptables -A INPUT -p tcp -m tcp --sport 80 -j ACCEPT
    sudo iptables -A OUTPUT -p tcp -m tcp --dport 80 -j ACCEPT
    sudo npm install pm2 -g
    pm2 start app.js 
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
    name                    = "foobar"
    default_result          = "CONTINUE"
    heartbeat_timeout       = 30
    lifecycle_transition    = "autoscaling:EC2_INSTANCE_LAUNCHING"
    notification_target_arn = "arn:aws:sns:us-west-1:414402433373:autoscaling-group-notifications"
    role_arn                = "arn:aws:iam::414402433373:role/EC2-Notification-Access"
  }

  tag {
    key                 = "name"
    value               = "example-instance"
    propagate_at_launch = true
  }
}
