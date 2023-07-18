resource "azurerm_cosmosdb_account" "cosmos-db" {
  name                      = var.cosmos_db_name
  location                  = azurerm_resource_group.resource.location
  resource_group_name       = azurerm_resource_group.resource.name
  offer_type                = var.cosmos_db_offer_type
  kind                      = var.cosmos_db_kind
  enable_automatic_failover = false
  enable_free_tier          = true

  geo_location {
    location          = azurerm_resource_group.resource.location
    failover_priority = 0
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  capabilities {
    name = "EnableMongo"
  }

  depends_on = [
    azurerm_resource_group.resource
  ]
}

resource "azurerm_cosmosdb_mongo_database" "main" {
  name                = var.cosmos_db_mongo_name
  resource_group_name = azurerm_resource_group.resource.name
  account_name        = azurerm_cosmosdb_account.cosmos-db.name
  throughput          = 400
}