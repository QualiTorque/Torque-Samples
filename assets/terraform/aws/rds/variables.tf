variable "env_id" {
  description = "Environment unique id"
}

variable "db_name" {
  description = "Database Engine name"
}

variable "username" {
  description = "Database Engine Username"
}

variable "region" {
  description = "Region of RDS"
  default = "eu-west-1"
}

variable "engine" {
    description = "Database Engine type, default is MySQL"
    type = string
    default = "mysql"

    validation {
      condition = contains(["aurora", "aurora-mysql", "aurora-postgresql", "custom-oracle-ee", "mariadb", "mysql", "oracle-ee", "postgres", "sqlserver-ee", "sqlserver-se", "sqlserver-ex", "sqlserver-web"], lower(var.engine))
      error_message = "Engine not recognized. See CreateDBInstance documentation for list of available engines: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html ."
    }
    
}

variable "engine_version" {
  description = "Version of RDS Engine. Default is 8.0.32"
  default = "8.0.32"
}
variable "storage_type" {
  description = "One of standard (magnetic), gp2 (general purpose SSD), or io1 (provisioned IOPS SSD). Default is gp2"
  default = "gp3"
  type = string

  validation {
    condition = contains(["standard", "gp2", "gp3", "io1"], lower(var.storage_type))
    error_message = "Storage Type not recognized. Options: standard, gp2, gp3, io1."
  }
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  default = 20
  type = number
}

variable "size" {
  description = "The instance type of the RDS instance. Small, medium, or large. Default: db.t2.medium (medium)"
  default = "medium"
  type = string

  validation {
    condition = contains(["small", "medium", "large"], lower(var.size))
    error_message = "Invalid database size. Options are: small, medium, or large."
  }
}
