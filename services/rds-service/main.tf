resource "aws_db_instance" "terraformdb" {
    identifier_prefix = "${var.env_name}"
    engine = "${var.db_engine_type}"
    allocated_storage = 10
    instance_class = "${var.db_instance_class}"
    skip_final_snapshot = true
    backup_retention_period = 0
    apply_immediately = true
    name = "${var.db_name}"
    username = "${var.db_user}"
    password = "${var.db_password}"
}