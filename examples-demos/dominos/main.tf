terraform {
  required_providers {
    dominos = {
      source = "terraform.local/local/dominos"
      version = "1.0.0"
    }
  }
}

provider "dominos" {
  first_name    = "Tim"
  last_name     = "Olson"
  email_address = "dominos@example.com"
  phone_number  = "15555555555"

  credit_card {
    number = 0000000000000000
    cvv    = 999
    date   = "01/01"
    zip    = 55109
  }
}

data "dominos_address" "addr" {
  street = "Not Really Street"
  city   = "Saint Paul"
  state  = "MN"
  zip    = "55109"
}

data "dominos_store" "store" {
  address_url_object = data.dominos_address.addr.url_object
}

data "dominos_menu_item" "sprite" {
  store_id     = data.dominos_store.store.store_id
  query_string = ["sprite"]
}

data "dominos_menu_item" "coke" {
  store_id     = data.dominos_store.store.store_id
  query_string = ["coke"]
}

data "dominos_menu_item" "pizza" {
  store_id     = data.dominos_store.store.store_id
  query_string = ["medium", "pepperoni"]
}

resource "dominos_order" "order" {
  address_api_object = data.dominos_address.addr.api_object
  item_codes         = [data.dominos_menu_item.sprite.matches.0.code, data.dominos_menu_item.coke.matches.0.code, data.dominos_menu_item.pizza.matches.0.code]
  store_id           = data.dominos_store.store.store_id
}
