micro_ui <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    class = "tab-content",
    layout_columns(
      col_widths = c(4, 8),

      ## Load column ----
      card(
        card_header("Microclimate loader", class = "custom_card_header"),
        card_body(
          fileInput(
            "micro_DATASET",
            "Choose a CSV file",
            accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv"),
            buttonLabel = "Browse...",
            placeholder = "No file selected",
            multiple = FALSE
          ) |> helper(colour = "#4b6285", content = "micro_dataset"),

          hr(),

          div(
            id = "id_micro_time",
            p("Which column contains the time?"),
            selectInput("sel_micro_time", label = NULL, choices = NULL)
          ) %>% hidden(),

          div(
            id = "id_micro_tas",
            p("Which column contains the temperature?"),
            selectInput("sel_micro_tas", label = NULL, choices = NULL)
          ) %>% hidden(),
          actionButton("btn_load_micro", strong("Load"),
                       class = "btn-lg btn-primary text-white") %>% hidden(),
          hr(),


          p("Do you ", strong("need an example"), " of microclimate data?"),
          p("Click the button below to download it."),
          downloadButton("dl_micro_ex", "Download Example", class = "btn-outline-primary") |>
            helper(colour = "#4b6285", content = "micro_example", size = "l")
        )
      ),

      ## Preview column ----
      card(
        card_header("Macro- and micro-climate preview"),
        card_body(
          div(
            plotOutput(outputId = "out_micro_gg")
          )
        )
      ),

    ),

    # * continue button ----
    div(
      class = "text-center my-4",
      actionButton("btn_micro_loaded", strong("Continue"), class = "btn-lg btn-primary text-white")
    )
  )
}

