home_ui <- function(id) {
  ns <- NS(id)

  div(
    id = id,
    class = "tab-content",

    card(
      card_header("Getting Started", class = "custom_card_header"),
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

    layout_columns(
      col_widths = c(6, 6),

      ## Macroclimate File Card ----
      card(
        width = 12,
        card_header("Macroclimate File", class = "custom_card_header"),
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

          p("Do you ", strong("need an example"), " of macroclimate data?"),
          p("Click the button below to download it."),
          downloadButton("dl_macro_ex", "Download Example", class = "btn-outline-primary") |>
            helper(colour = "#4b6285", content = "macro_example", size = "l")
        )
      ),

      ## Microclimate File Card ----
      card(
        width = 12,
        card_header("Microclimate File", class = "custom_card_header"),
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

          p("Do you ", strong("need an example"), " of microclimate data?"),
          p("Click the button below to download it."),
          downloadButton("dl_micro_ex", "Download Example", class = "btn-outline-primary") |>
            helper(colour = "#4b6285", content = "micro_example", size = "l")
        )
      ),

    ),

    # Continue Button
    div(
      class = "text-center my-4",
      actionButton("btn_DATASET_LOADED", strong("Continue"), class = "btn-lg btn-primary text-white")
    ),

    ## Data Preview Cards ----
    layout_columns(
      col_widths = c(6, 6),

      hidden(card(
        id = "box_macro_DATASET",
        card_header("Macroclimate Data Preview"),
        card_body(
          div(
            DT::DTOutput("macro_DATASET"),
            style = "max-height: 400px; overflow-y: auto;"
          )
        )
      )),

      hidden(card(
        id = "box_micro_DATASET",
        card_header("Microclimate Data Preview"),
        card_body(
          div(
            DT::DTOutput("micro_DATASET"),
            style = "max-height: 400px; overflow-y: auto;"
          )
        )
      ))

    ),

  )
}
