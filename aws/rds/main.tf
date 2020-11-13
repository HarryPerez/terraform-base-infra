# Create the database
# TODO: Remove hardcoded parameters
resource "aws_db_instance" "default" {
  allocated_storage = 30 #Allocated storage (GB)

  #Amazon RDS provides three storage types: General Purpose SSD (also known as gp2), Provisioned IOPS SSD (also known as io1), and magnetic (also known as standard).
  #General Purpose SSD – General Purpose SSD volumes offer cost-effective storage that is ideal for a broad range of workloads. These volumes deliver single-digit millisecond latencies and the ability to burst to 3,000 IOPS for extended periods of time. Baseline performance for these volumes is determined by the volume's size.
  #Provisioned IOPS – Provisioned IOPS storage is designed to meet the needs of I/O-intensive workloads, particularly database workloads, that require low I/O latency and consistent I/O throughput.
  #Magnetic – Amazon RDS also supports magnetic storage for backward compatibility. We recommend that you use General Purpose SSD or Provisioned IOPS for any new storage needs. The maximum amount of storage allowed for DB instances on magnetic storage is less than that of the other storage types.
  storage_type = "gp2"

  engine                  = "${var.engine}"                         #Database engine - MySql/Amazon Aurora/PostgreSQL/Oracle/Etc
  engine_version          = "${var.engine_version}"                 #Database engine version
  instance_class          = "${var.instance_type}"                  #db.t2.large
  name                    = "${var.db_name}"                        #ZerfDB
  username                = "${var.username}"                       #ZerfUser
  password                = "${var.password}"                       #Zerfassword2020
  availability_zone       = "${var.azs[0]}"                         #The Availability Zone of the RDS instance - Example: us-east-1a
  db_subnet_group_name    = "${aws_db_subnet_group.default.id}"     #Subnets - Check VPC/Etc - Networking
  vpc_security_group_ids  = ["${var.security_group}"]               #Security Groups - Something About VPC and networking
  skip_final_snapshot     = true                                    #Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier
  identifier              = "${var.application}-${var.environment}" #The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier
  backup_retention_period = 7                                       #The days to retain backups for
  apply_immediately       = true                                    #Subnets - Check VPC/Etc - Networking
  vpc_security_group_ids  = ["${var.security_group}"]               #Security Groups - Something About VPC and networking
  skip_final_snapshot     = true                                    #Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier
  identifier              = "${var.application}-${var.environment}" #The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier
  backup_retention_period = 7                                       #The days to retain backups for
  apply_immediately       = true                                    #Specifies whether any database modifications are applied immediately, or during the next maintenance window
  multi_az                = "${var.multi_az}"                       #Specifies if the RDS instance is multi-AZ
}
