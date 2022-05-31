view: user_facts {
  derived_table: {
    sql: SELECT
          "orders"."user_id" AS "user_id"
          ,COUNT(DISTINCT orders.id ) AS "lifetime_order_count"
          ,SUM(order_items.sale_price) AS "lifetime_revenue"
          ,MIN(orders.created_at) AS "first_order_date"
          ,MAX(orders.created_at) AS "latest_order_date"
      FROM
          "public"."order_items" AS "order_items"
          LEFT JOIN "public"."orders" AS "orders" ON "order_items"."order_id" = "orders"."id"
      GROUP BY
          1
       ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: lifetime_order_count {
    type: number
    sql: ${TABLE}.lifetime_order_count ;;
  }

  dimension: lifetime_revenue {
    type: number
    sql: ${TABLE}.lifetime_revenue ;;
  }

  dimension_group: first_order_date {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order_date {
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  set: detail {
    fields: [user_id, lifetime_order_count, lifetime_revenue, first_order_date_time, latest_order_date_time]
  }
}
