home_ui <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    class = "tab-content",

    card(
      card_header("Welcome !", class = "custom_card_header"),
      card_body(
        markdown("
      To estimate the **microclimate buffer effect** of a forest inventory, **2 sources** are required:

      - The **macroclimatic data** representing temperature outside the forest or above the canopy surface
      - The **microclimatic data** representing temperature inside the forest for a given height

      For each dataset, **2 variables** are required:

      - The **datetime** giving the date and time of measurement
      - The **temperature** giving sensor or model estimated temperature
              ")
      )
    ),

    # * continue button ----
    div(
      class = "text-center my-4",
      actionButton("btn_home", strong("Continue"), class = "btn-lg btn-primary text-white")
    )
  )
}
