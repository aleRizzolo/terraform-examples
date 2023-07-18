resource "azurerm_servicebus_namespace" "namespace-queue" {
  name                = var.service_bus_namespace_name
  location            = azurerm_resource_group.resource.location
  resource_group_name = azurerm_resource_group.resource.name
  sku                 = "Basic"
}

resource "azurerm_servicebus_queue" "queue" {
  name         = var.service_bus_queue_name
  namespace_id = azurerm_servicebus_namespace.namespace-queue.id
}