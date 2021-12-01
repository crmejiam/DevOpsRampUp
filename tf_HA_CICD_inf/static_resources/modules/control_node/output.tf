output "private_ip" {
    description = "Private ip of control node, needed to make register requests"
    value = "${aws_instance.control_node.private_ip}"
}