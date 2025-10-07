# VMSS Frontend
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                            = "${var.resource_name_prefix}-vmss"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku                             = "Standard_B1s"
  instances                       = 2
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  computer_name_prefix            = "frontendvm"
  disable_password_authentication = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = base64encode(<<-EOF
    #!/bin/bash
    set -e

    # Update system packages
    apt-get update -y
    apt-get upgrade -y

    # Install Docker
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io

    # Enable and start Docker
    systemctl enable docker
    systemctl start docker

    # Pull your custom Docker image
    docker pull ${var.docker_image}

    # Run the container
    docker run -d \
      --name my-nginx-container \
      -p 80:80 \
      -p 443:443 \
      -v /host/path:/container/path \
      ${var.docker_image}
  EOF
  )

  network_interface {
    name    = "frontend-nic"
    primary = true

    ip_configuration {
      name      = "ipconfig"
      primary   = true
      subnet_id = var.subnet_id
      # load_balancer_backend_address_pool_ids = [azurerm_lb.frontend-lb.backend_address_pool[0].id]
      application_gateway_backend_address_pool_ids = [var.application_gateway_backend_address_pool_ids]
    }
  }

  # health_probe_id = azurerm_lb_probe.frontend-health-probe.id

  tags = var.tags
}