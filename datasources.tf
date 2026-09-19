data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subnet" "internal" {
  name                 = "internal"
  virtual_network_name = data.azurerm_virtual_network.main.name
  resource_group_name  = data.azurerm_resource_group.main.name
}

data "azurerm_public_ip" "main" {
  name                = "${var.prefix}-pip"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_virtual_machine" "main" {
  name                = "${var.prefix}-vm"
  resource_group_name = data.azurerm_resource_group.main.name
}
