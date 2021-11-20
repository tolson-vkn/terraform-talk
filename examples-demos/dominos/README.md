# Dominos

This is a really neat provider to show that terraform works with APIs - NOT exclusively cloud providers.

What I find really interesting is the demonstration that data lookups can be used to find non-human readable components:

```
data "dominos_menu_item" "pizza" {
  store_id     = data.dominos_store.store.store_id
  query_string = ["medium", "pepperoni"]
}
```

Shows up as: `12SCPFEAST`

```
terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated
with the following symbols:
  + create

Terraform will perform the following actions:

  # dominos_order.order will be created
  + resource "dominos_order" "order" {
      + address_api_object = jsonencode(
            {
              + City       = "Saint Paul"
              + PostalCode = "55109"
              + Region     = "MN"
              + Street     = "Not Really Street"
              + Type       = "House"
            }
        )
      + id                 = (known after apply)
      + item_codes         = [
          + "20BSPRITE",
          + "20BCOKE",
          + "12SCPFEAST",
        ]
      + store_id           = "1948"
    }

Plan: 1 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────
```

Note, this provider's tracking is bugged. So it will probably bomb out if it's successful. So be careful it's about $30 everytime you run it.
