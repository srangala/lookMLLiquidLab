# Define the database connection to be used for this model.
connection: "thelook"

# include all the views
include: "/views/**/*.view"

# Datagroups define a caching policy for an Explore. To learn more,
# use the Quick Help panel on the right to see documentation.

datagroup: liquidlab_srangala_default_datagroup {
  #everyday at 6am
  sql_trigger: SELECT FLOOR((EXTRACT(epoch from GETDATE()) - 60*60*6)/(60*60*24));;
  max_cache_age: "1 hour"
}

persist_with: liquidlab_srangala_default_datagroup

# Explores allow you to join together different views (database tables) based on the
# relationships between fields. By joining a view into an Explore, you make those
# fields available to users for data analysis.
# Explores should be purpose-built for specific use cases.

# To see the Explore you’re building, navigate to the Explore menu and select an Explore under "Liquidlab Srangala"

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: user_facts {
    type: left_outer
    sql_on: ${orders.user_id} = ${user_facts.user_id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
  join: brand_order_facts {
    type: left_outer
    sql_on: ${products.brand} = ${brand_order_facts.brand};;
    relationship: many_to_one
  }
}

explore: orders {
  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
  join: user_facts {
    type: left_outer
    sql_on: ${orders.user_id} = ${user_facts.user_id} ;;
    relationship: many_to_one
  }
}

explore: product_facts {
  description: "Start here for product facts"
  fields: [ALL_FIELDS*]
  from: product_facts
  view_name: product_facts
  extends: [base_products]
}

explore: base_products {
extension: required
  join: products {
    type: left_outer
    sql_on: ${product_facts.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}


# To create more sophisticated Explores that involve multiple views, you can use the join parameter.
# Typically, join parameters require that you define the join type, join relationship, and a sql_on clause.
# Each joined view also needs to define a primary key.

explore: products {}

explore: users {}
