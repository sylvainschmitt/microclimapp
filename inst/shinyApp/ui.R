# THEME ----
app_theme <- bs_theme(
  version = 5,
  preset = "bootstrap",
  primary = "#4b6285",
  secondary = "#2c3f66",
  base_font = font_google("Open Sans"),
  heading_font = font_google("Raleway"),
  code_font = font_google("Fira Code")
)

# PAGE ----
page <- page_sidebar(
  title = "microclimr Application",
  theme = app_theme,
  fillable = FALSE,

  # * sidebar ----
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

    # * navigation items ----
    div(class = "nav-item",
        tags$a(
          class = "nav-link-custom active",
          id = "nav_link_home",
          href = "#",
          onclick = "Shiny.setInputValue('selected_tab', 'tab_home', {priority: 'event'}); return false;",
          icon("house"), " Home"
        )
    ),
    div(
      class = "nav-item",
      id = "nav_item_macro",
      tags$a(
        class = "nav-link-custom",
        id = "nav_link_macro",
        href = "#",
        onclick = "Shiny.setInputValue('selected_tab', 'tab_macro', {priority: 'event'}); return false;",
        icon("earth-europe"), " Macroclimate"
      )
    ) %>% hidden(),
    div(
      class = "nav-item",
      id = "nav_item_micro",
      tags$a(
        class = "nav-link-custom",
        id = "nav_link_micro",
        href = "#",
        onclick = "Shiny.setInputValue('selected_tab', 'tab_micro', {priority: 'event'}); return false;",
        icon("tree"), " Microclimate"
      )
    ) %>% hidden(),
    div(
      class = "nav-item",
      id = "nav_item_fft",
      tags$a(
        class = "nav-link-custom",
        id = "nav_link_fft",
        href = "#",
        onclick = "Shiny.setInputValue('selected_tab', 'tab_fft', {priority: 'event'}); return false;",
        icon("wave-square"), " Fast Fourier Transform"
      )
    ) %>% hidden(),
    div(
      class = "nav-item",
      id = "nav_item_buffer",
      tags$a(
        class = "nav-link-custom",
        id = "nav_link_buffer",
        href = "#",
        onclick = "Shiny.setInputValue('selected_tab', 'tab_buffer', {priority: 'event'}); return false;",
        icon("tree"), " Microclimate buffer"
      )
    ) %>% hidden(),

    HTML('
         <div style="text-align: center;">
          <img src="logo/ia_logo.png" width="70%" height="auto" >
         </div>'),

    legalNoticeBslib(2025, "UR F&S")
  ),

  # MODULES ----
  home_ui("tab_home"),
  macro_ui("tab_macro") %>% hidden(),
  micro_ui("tab_micro") %>% hidden(),
  fft_ui("tab_fft") %>% hidden(),
  buffer_ui("tab_buffer") %>% hidden()
)
