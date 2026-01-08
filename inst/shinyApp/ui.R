# Modern BIOMASS Application UI with bslib

# Define theme
app_theme <- bs_theme(
  version = 5,
  preset = "bootstrap",
  primary = "#4b6285",
  secondary = "#2c3f66",
  base_font = font_google("Open Sans"),
  heading_font = font_google("Raleway"),
  code_font = font_google("Fira Code")
)

page <- page_sidebar(
  title = "microclimr Application",
  theme = app_theme,
  fillable = FALSE,

  # Sidebar with vertical navigation
  sidebar = sidebar(
    width = 250,
    bg = "#4b6285",

    tags$head(
      tags$style(HTML("
        /* background color of the main page */
        body, .bslib-page-sidebar {
          background-color: #f2f5f2 !important;
        }

        /* Title banner at the top */
        .navbar, .bslib-page-title {
          background-color: #2c3f66 !important;
          color: white !important;
        }

        /* sidebar styles */
        .bslib-sidebar-layout > .sidebar { color: white; }
        .bslib-sidebar-layout > .sidebar a { color: white; text-decoration: none; }
        .nav-item { margin-bottom: 8px; }
        .nav-link-custom {
          display: block;
          padding: 12px 15px;
          border-radius: 5px;
          transition: background-color 0.2s;
        }
        .nav-link-custom:hover {
          background-color: rgba(255,255,255,0.1);
        }
        .nav-link-custom.active {
          background-color: rgba(255,255,255,0.2);
          font-weight: bold;
        }
        .card {
          background-color: #f2f5f2 !important;
          overflow: visible !important; }
        .card-body {
          overflow: visible !important;
          max-height: none !important; }
        .custom_card_header {
          background-color: #4b6285;
          color: rgba(255,255,255,1);
          font-size: 20px; font-weight: bold; }

        .shiny-spinner > div > div {
          background-color: #459433 !important; }
      "))
    ),


    useShinyFeedback(),
    useShinyjs(),

    # Manage navigation items ----
    div(class = "nav-item",
        tags$a(
          class = "nav-link-custom active",
          id = "nav_link_load",
          href = "#",
          onclick = "Shiny.setInputValue('selected_tab', 'tab_LOAD', {priority: 'event'}); return false;",
          icon("upload"), " Load Dataset"
        )
    ),

    hidden(div(
      class = "nav-item",
      id = "nav_item_macro",
      tags$a(
        class = "nav-link-custom",
        id = "nav_link_macro",
        href = "#",
        onclick = "Shiny.setInputValue('selected_tab', 'tab_MACRO', {priority: 'event'}); return false;",
        icon("earth-europe"), " Macroclimate"
      )
    )),

    HTML('
         <div style="text-align: center;">
          <img src="logo/ia_logo.png" width="70%" height="auto" >
         </div>'),

    legalNoticeBslib(2025, "UR F&S")
  ),

  # Load dataset ----
  div(
    id = "tab_LOAD",
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

  ),

  # Macroclimate ----
  hidden(div(
    id = "tab_MACRO",
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

  )),

)
