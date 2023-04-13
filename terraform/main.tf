# Security group rule for ROR application
resource "aws_security_group" "allow_ror" {
  name_prefix = "allow_ror_port"
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

# Common security group rule to allow ssh
resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow_ssh_port"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

# Security group rule for postgresql
resource "aws_security_group" "postgres_db_sg" {
  name_prefix = "postgres_db_sg"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-02eb7a4783e7e9317"
  instance_type = "t2.micro"
  key_name      = "practice"
  vpc_security_group_ids = [aws_security_group.allow_ror.id, aws_security_group.allow_ssh.id ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/Users/vedikad/Documents/ved-workspace-main 2/terraform/practice.pem")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y build-essential",
      "sudo apt-get install -y libssl-dev zlib1g-dev sqlite3 libsqlite3-dev",
      "sudo apt install -y postgresql postgresql-contrib libpq-dev",
      "sudo apt-get install -y git curl",
      "sudo curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash",
      "export PATH=\"$HOME/.rbenv/bin:$PATH\"",
      "eval \"$(rbenv init - bash)\"",
      "curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-doctor | bash",
      "rbenv install 3.0.2 -v",
      "rbenv global 3.0.2",
      "ruby -v && gem install bundler && gem install rails",
      "cd /home/ubuntu",
      "git clone https://github.com/vijayprabhu04/ved-workspace.git"
    ]
  }

  tags = {
    Name = "My-ROR-SERVER"
  }
}

# Define EC2 Instance for Postgres Database
resource "aws_instance" "postgres_db" {
  ami           = "ami-02eb7a4783e7e9317"
  instance_type = "t2.micro"
  key_name      = "practice"
  vpc_security_group_ids = [aws_security_group.postgres_db_sg.id, aws_security_group.allow_ssh.id]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("/Users/vedikad/Documents/ved-workspace-main 2/terraform/practice.pem")
    host        = self.public_ip
  }

  # Copy postgres config files

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y git curl",
      "sudo apt install -y postgresql postgresql-contrib libpq-dev",
      "cd /home/ubuntu",
      "git clone https://github.com/vijayprabhu04/ved-workspace.git"
    ]
  }

  tags = {
    Name = "POSTGRES-DATABASE-SERVER"
  }
}
