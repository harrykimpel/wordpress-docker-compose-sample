terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
    }
  }
}

provider "newrelic" {
  api_key    = var.NEW_RELIC_API_KEY
  account_id = var.NEW_RELIC_ACCOUNT_ID
  region     = var.NEW_RELIC_REGION
}

# Create Workload

resource "newrelic_workload" "ms-demo-workload" {
  name       = "WordPress Workload"
  account_id = var.NEW_RELIC_ACCOUNT_ID
  entity_search_query {
    query = "(name like '%')"
  }

  scope_account_ids = [var.NEW_RELIC_ACCOUNT_ID]
}

# Create Dashboard

resource "newrelic_one_dashboard_json" "dashboard-wordpress" {
  json = file("${path.module}/dashboard-wordpress.json")
}

resource "newrelic_entity_tags" "dashboard-wordpress" {
  guid = newrelic_one_dashboard_json.dashboard-wordpress.guid
  tag {
    key    = "terraform"
    values = [true]
  }
}

output "dashboard-wordpress" {
  value = newrelic_one_dashboard_json.dashboard-wordpress.permalink
}

resource "newrelic_one_dashboard_json" "dashboard-wordpress-fullstack" {
  json = file("${path.module}/dashboard-wordpress-fullstack.json")
}

resource "newrelic_entity_tags" "dashboard-wordpress-fullstack" {
  guid = newrelic_one_dashboard_json.dashboard-wordpress-fullstack.guid
  tag {
    key    = "terraform"
    values = [true]
  }
}

output "dashboard-wordpress-fullstack" {
  value = newrelic_one_dashboard_json.dashboard-wordpress-fullstack.permalink
}
