resource "null_resource" "record_create_time" {

  depends_on = [
    module.hostBastion,
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = aws_eip.hostBastion_eip.public_dns
    private_key = file(var.key_pair_path)
  }

  provisioner "file" {
    source      = var.key_pair_path
    destination = "/tmp/${var.key_pair_name}.pem"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/${var.key_pair_name}.pem",
    ]
  }
}

