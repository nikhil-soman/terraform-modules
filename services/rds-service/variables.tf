variable "db_instance_class" {
    description = "The instance type of the RDS instance"
}

variable "db_engine_type" {
    description = "The db engine to be used for the RDS instance"
}

variable "db_name" {
    description = "The name of the database"
}

variable "db_password" {
    description = "The password of the database"
}

variable "db_user" {
    description = "The name of the database user"
}

variable "env_name" {
    description = "The name of the environment in which the RDS instance is to be created"
}