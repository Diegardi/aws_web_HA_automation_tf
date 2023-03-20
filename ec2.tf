resource "aws_instance" "instance" {
  count           = length(aws_subnet.public_subnet.*.id)
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.public_subnet.*.id, count.index)
  security_groups = [aws_security_group.instances_security_group.id, ]

  user_data = <<EOF
#!/bin/bash
sudo su
yum update -y
echo "Installing HTTPD..."
yum install httpd -y
systemctl start httpd
systemctl enable httpd
echo "<html><body><h1> Hola! this is WEB instance # ${count.index + 1} </h1></body></html>" >> /var/www/html/index.html
EOF

  tags = {
    "Name"        = "web-instance-${count.index}"
    "Environment" = "Sandbox-POC"
  }

  timeouts {
    create = "10m"
  }

}
