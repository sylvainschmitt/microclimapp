buffer_ui <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    class = "tab-content",

    card(
      card_header("Microclimate buffer", class = "custom_card_header")
    )

  )
}
