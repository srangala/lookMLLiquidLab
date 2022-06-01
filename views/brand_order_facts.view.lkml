# If necessary, uncomment the line below to include explore_source.
# include: "liquidlab_srangala.model.lkml"

view: brand_order_facts {
  derived_table: {
    explore_source: order_items {
      column: brand { field: products.brand }
      column: total_sale_price {}
      derived_column: brand_rank {sql: row_number() over (order by total_sale_price desc) ;;}
      #bind_filters: {
      #  from_field: orders.created_date
      #  to_field: orders.created_date
      #}
      bind_all_filters: yes
    }
  }
  dimension: brand_rank {
    type: number
    hidden: yes
  }
  dimension: brand {
    primary_key: yes
  }

  dimension: total_sale_price {
    type: number
    value_format_name: usd
  }
  dimension: brand_rank_concat {
    type: string
    sql: ${brand_rank} || ') ' || ${brand} ;;
  }
  dimension: brand_rank_top_5 {
    hidden: yes
    type: yesno
    sql: ${brand_rank} <= 5 ;;
  }
  dimension: brand_rank_grouped {
    label: "Brand Name Grouped"
    type: string
    sql: case when ${brand_rank_top_5} then ${brand_rank_concat} else '6) Other' end ;;
  }
}
