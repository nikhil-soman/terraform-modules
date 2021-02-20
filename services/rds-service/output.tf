output "mysql_endpoint" {
    value = "${aws_db_instance.terraformdb.address}"
}

output "mysql_port" {
    value = "${aws_db_instance.terraformdb.port}"
}