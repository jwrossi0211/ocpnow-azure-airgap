# Resource-1: Create Public IP Address
resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vm_name}-pip"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku = "Standard"
}

# Resource-2: Create Network Interface
resource "azurerm_network_interface" "linuxvm_nic" {
  name                = "${var.vm_name}-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "host-ip-1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.public_ip.id 
  }
}

# Resource-3: Azure Linux Virtual Machine 
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name = var.vm_name
  resource_group_name = var.resource_group_name
  location = var.resource_group_location
  size = var.vm_size
  admin_username = var.vm_admin_username
  network_interface_ids = [azurerm_network_interface.linuxvm_nic.id]

  #admin_ssh_key {
  #  username = var.vm_admin_username
  #  public_key = var.vm_ssh_pub_key
  #}
  
  admin_password = var.vm_admin_password
  disable_password_authentication = false
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "8"
    version   = "latest"
  }
}
