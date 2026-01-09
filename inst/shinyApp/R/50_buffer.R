buffer_ui <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    class = "tab-content",

    layout_columns(
      col_widths = c(6, 6),

      ## Period column ----
      card(
        card_header("Macro-Micro relation for a given period"),
        card_body(

          div(
            id = "id_buffer_period",
            p("Which period do you want to plot?"),
            selectInput("sel_period", label = NULL, choices = NULL)
          ),

          div(
            plotOutput(outputId = "out_period_gg")
          )

        )
      ),

      ## Energy column ----
      card(
        card_header("Microclimate energy dissipation"),
        card_body(
          div(
            plotOutput(outputId = "out_energy_gg")
          )
        )
      ),

    )
  )
}
