macro_ui <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    class = "tab-content",

    card(
      card_header("Macroclimate", class = "custom_card_header"),
      card_body(
        div(
          plotOutput(outputId = "out_macro")
        )
      )
    ),

    card(
      card_header("Decomposition", class = "custom_card_header"),
      card_body(
        div(
          plotOutput(outputId = "out_macro_ps")
        )
      )
    )

  )
}
