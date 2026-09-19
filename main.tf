resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = data.azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}

resource "null_resource" "provision_nginx" {
  triggers = {
    vm_id = data.azurerm_virtual_machine.main.id
  }

  connection {
    type     = "ssh"
    host     = data.azurerm_public_ip.main.ip_address
    user     = var.admin_username
    password = var.admin_password
    timeout  = "10m"
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nginx",
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo systemctl enable nginx",
      "sudo systemctl restart nginx"
    ]
  }

  depends_on = [
    azurerm_network_interface_security_group_association.main
  ]
}

output "public_ip_address" {
  description = "Public IP address of the Nginx virtual machine"
  value       = data.azurerm_public_ip.main.ip_address
}

output "virtual_network_id" {
  value = data.azurerm_virtual_network.main.id
}

output "subnet_id" {
  value = data.azurerm_subnet.internal.id
}

output "network_interface_id" {
  value = data.azurerm_network_interface.main.id
}

output "virtual_machine_id" {
  value = data.azurerm_virtual_machine.main.id
}
