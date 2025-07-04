resource "azurerm_communication_service" "communication-service" {
  name                = var.communication_service_name
  resource_group_name = azurerm_resource_group.resource.name
  data_location       = var.communication_service_data_location
}