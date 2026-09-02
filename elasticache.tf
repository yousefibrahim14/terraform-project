resource "aws_elasticache_subnet_group" "redis" {
  name = "devops-redis-subnet-group"

  subnet_ids = [
    aws_subnet.private.id,
    aws_subnet.private_2.id
  ]

  tags = {
    Name = "devops-redis-subnet-group"
  }
}
resource "aws_security_group" "redis" {
  name        = "redis-sg"
  description = "Allow Redis access from application server"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Redis from application"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.application.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg"
  }
}
resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "devops-redis"
  description          = "Redis cache for DevOps project"

  engine             = "redis"
  node_type          = "cache.t3.micro"
  num_cache_clusters = 1

  port = 6379

  subnet_group_name  = aws_elasticache_subnet_group.redis.name
  security_group_ids = [aws_security_group.redis.id]

  automatic_failover_enabled = false

  tags = {
    Name = "devops-redis"
  }
}
