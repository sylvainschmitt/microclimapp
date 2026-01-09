macro_ui <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    class = "tab-content",
    layout_columns(
      col_widths = c(4, 8),

      ## Load column ----
      card(
        card_header("Macroclimate loader", class = "custom_card_header"),
        card_body(
          fileInput(
            "macro_DATASET",
            "Choose a CSV file",
            accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv"),
            buttonLabel = "Browse...",
            placeholder = "No file selected",
            multiple = FALSE
          ) |> helper(colour = "#4b6285", content = "macro_dataset"),

          hr(),

          div(
            id = "id_macro_time",
            p("Which column contains the time?"),
            selectInput("sel_macro_time", label = NULL, choices = NULL)
          ) %>% hidden(),

          div(
            id = "id_macro_tas",
            p("Which column contains the temperature?"),
            selectInput("sel_macro_tas", label = NULL, choices = NULL)
          ) %>% hidden(),
          actionButton("btn_load_macro", strong("Load"),
                         class = "btn-lg btn-primary text-white") %>% hidden(),
          hr(),


          p("Do you ", strong("need an example"), " of macroclimate data?"),
          p("Click the button below to download it."),
          downloadButton("dl_macro_ex", "Download Example", class = "btn-outline-primary") |>
            helper(colour = "#4b6285", content = "macro_example", size = "l")
        )
      ),

      ## Preview column ----
      card(
        card_header("Macroclimate preview"),
        card_body(
          div(
            plotOutput(outputId = "out_macro_gg")
          )
        )
      ),

    ),

    ## Continue button ----
    div(
      class = "text-center my-4",
      actionButton("btn_macro_loaded", strong("Continue"), class = "btn-lg btn-primary text-white")
    )
  )
}
