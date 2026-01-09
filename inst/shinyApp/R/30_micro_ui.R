micro_ui <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    class = "tab-content",

    card(
      card_header("Microclimate", class = "custom_card_header")
    ),
    # * continue button ----
    div(
      class = "text-center my-4",
      actionButton("btn_micro_loaded", strong("Continue"), class = "btn-lg btn-primary text-white")
    )
  )
}

#       ## Microclimate File Card ----
#       card(
#         width = 12,
#         card_header("Microclimate File", class = "custom_card_header"),
#         card_body(
#           fileInput(
#             "micro_DATASET",
#             "Choose a CSV file",
#             accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv"),
#             buttonLabel = "Browse...",
#             placeholder = "No file selected",
#             multiple = FALSE
#           ) |> helper(colour = "#4b6285", content = "micro_dataset"),
#
#           hr(),
#
#           p("Do you ", strong("need an example"), " of microclimate data?"),
#           p("Click the button below to download it."),
#           downloadButton("dl_micro_ex", "Download Example", class = "btn-outline-primary") |>
#             helper(colour = "#4b6285", content = "micro_example", size = "l")
#         )
#       ),
#
#     ),

#     ## Data Preview Cards ----
#       hidden(card(
#         id = "box_micro_DATASET",
#         card_header("Microclimate Data Preview"),
#         card_body(
#           div(
#             DT::DTOutput("micro_DATASET"),
#             style = "max-height: 400px; overflow-y: auto;"
#           )
#         )
#       ))
#
#     ),
#
#   )
# }
