resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "cryptern-redis-${var.env}"
  engine               = "redis"
  node_type            = var.redisNodeType
  num_cache_nodes      = 1
  parameter_group_name = "default.redis5.0"
  engine_version       = "5.0.6"
  port                 = 6379
  security_group_ids   = [var.securityGroupId]
  subnet_group_name    = aws_elasticache_subnet_group.redis-subnet-group.name
  tags = {
    "name"      = "cryptern-redis-${var.env}"
    "terraform" = "true"
  }
}
resource "aws_elasticache_subnet_group" "redis-subnet-group" {
  name       = "cryptern-redis-subnet-group-${var.env}"
  subnet_ids = [element(var.privateSubnet, 0).id]
  tags = {
    "name"      = "cryptern-redis-subnet-group-${var.env}"
    "terraform" = "true"
  }
}
