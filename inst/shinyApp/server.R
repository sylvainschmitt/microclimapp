function(input, output, session) {

  # INIT ----

  # stop the serveur at the end of the session
  autoCloseApp() # version compatible local/server
  observe_helpers(help_dir = "helpfiles")
  legalNoticeHandler(includeMarkdown("helpfiles/legal_notice.md"), size = "l")

  # Legal notice
  legal_content <- shiny::includeMarkdown("helpfiles/legal_notice.md")
  legalNoticeBslib(2026, "UR F&S")

  observeEvent(input$selected_tab, {
    # Hide all nav items
    shinyjs::hide("tab_home")
    shinyjs::hide("tab_macro")
    shinyjs::hide("tab_micro")
    shinyjs::hide("tab_fft")
    shinyjs::hide("tab_buffer")

    # remove the active class of all links
    shinyjs::removeClass("nav_link_home", "active")
    shinyjs::removeClass("nav_link_macro", "active")
    shinyjs::removeClass("nav_link_micro", "active")
    shinyjs::removeClass("nav_link_fft", "active")
    shinyjs::removeClass("nav_link_buffer", "active")

    # Display the selected item and active the link
    shinyjs::show(input$selected_tab)
    link_id <- switch(input$selected_tab,
                      "tab_home" = "nav_link_home",
                      "tab_macro" = "nav_link_macro",
                      "tab_micro" = "nav_link_micro",
                      "tab_fft" = "nav_link_fft",
                      "tab_buffer" = "nav_link_buffer"
    )
    shinyjs::addClass(link_id, "active")
  })

  ## Reactive values:  ----
  rv <- reactiveValues(
    macro = NULL, # macroclimate dataframe
    micro = NULL, # microclimate dataframe
    data = NULL # whole dataset
  )

  ## Buttons ----
  observeEvent(input$btn_home, ignoreInit = TRUE, {
    print("Reaction to btn_home")
    shinyjs::show("nav_item_macro")
    shinyjs::hide("tab_home")
    shinyjs::show("tab_macro")
    shinyjs::removeClass("nav_link_home", "active")
    shinyjs::addClass("nav_link_macro", "active")
  })
  observeEvent(input$btn_macro_loaded, ignoreInit = TRUE, {
    print("Reaction to btn_macro_loaded")
    shinyjs::show("nav_item_micro")
    shinyjs::hide("tab_macro")
    shinyjs::show("tab_micro")
    shinyjs::removeClass("nav_link_macro", "active")
    shinyjs::addClass("nav_link_micro", "active")
  })
  observeEvent(input$btn_micro_loaded, ignoreInit = TRUE, {
    print("Reaction to btn_micro_loaded")
    shinyjs::show("nav_item_fft")
    shinyjs::hide("tab_micro")
    shinyjs::show("tab_fft")
    shinyjs::removeClass("nav_link_micro", "active")
    shinyjs::addClass("nav_link_fft", "active")
  })
  observeEvent(input$btn_fft_done, ignoreInit = TRUE, {
    print("Reaction to btn_fft_done")
    shinyjs::show("nav_item_buffer")
    shinyjs::hide("tab_fft")
    shinyjs::show("tab_buffer")
    shinyjs::removeClass("nav_link_fft", "active")
    shinyjs::addClass("nav_link_buffer", "active")
  })

  # MACRO ----

  ## Load ----
  observeEvent(input$macro_DATASET, ignoreInit = TRUE,  {
    rv$macro <- vroom(req(input$macro_DATASET)$datapath)
    updateSelectInput(session, "sel_macro_time",
                      choices = c("<unselected>", names(rv$macro)))
    updateSelectInput(session, "sel_macro_tas",
                      choices = c("<unselected>", names(rv$macro)))
    showElement("id_macro_time")
    showElement("id_macro_tas")
    showElement("btn_load_macro")
  })

  ## Download --
  output$dl_macro_ex <- downloadHandler(
    filename = "macroclimate.csv",
    content = function(file) {
      file.copy("exemple_data/macroclimate.csv", file)
    },
    contentType = "text/csv"
  )

  ## Preview ----
  observeEvent(input$btn_load_macro, ignoreInit = TRUE, {
    output$out_macro_gg <- renderPlot({
      rv$macro %>%
        ggplot(aes(.data[[input$sel_macro_time]],
                   .data[[input$sel_macro_tas]])) +
        geom_line() +
        theme_bw()
    })
  })

  # MICRO ----

  ## Load ----
  observeEvent(input$micro_DATASET, ignoreInit = TRUE,  {
    rv$micro <- vroom(req(input$micro_DATASET)$datapath)
    updateSelectInput(session, "sel_micro_time",
                      choices = c("<unselected>", names(rv$micro)))
    updateSelectInput(session, "sel_micro_tas",
                      choices = c("<unselected>", names(rv$micro)))
    showElement("id_micro_time")
    showElement("id_micro_tas")
    showElement("btn_load_micro")
  })

  ## Download --
  output$dl_micro_ex <- downloadHandler(
    filename = "microclimate.csv",
    content = function(file) {
      file.copy("exemple_data/microclimate.csv", file)
    },
    contentType = "text/csv"
  )

  ## Preview ----
  observeEvent(input$btn_load_micro, ignoreInit = TRUE, {
    output$out_micro_gg <- renderPlot({
      rv$data <- rv$micro %>%
        select(.data[[input$sel_micro_time]], .data[[input$sel_micro_tas]]) %>%
        rename(time = .data[[input$sel_micro_time]],
               tas_micro = .data[[input$sel_micro_tas]]) %>%
        left_join(
          rv$macro %>%
            select(.data[[input$sel_macro_time]],
                   .data[[input$sel_macro_tas]]) %>%
            rename(time = .data[[input$sel_macro_time]],
                 tas_macro = .data[[input$sel_macro_tas]])
        )
      summary(rv$data)
      rv$data %>%
        gather(source, tas, -time) %>%
        mutate(source = gsub("tas_", "", source)) %>%
        ggplot(aes(time, tas, col = source)) +
        geom_line() +
        theme_bw()
    })
  })

  # # MACROCLIMATE ---------------------------------------------------------------
  # observeEvent(input$btn_DATASET_LOADED, ignoreInit = TRUE, {
  #   rv$macro_f <- rv$macro %>%
  #     do(fft = fft_roll(., 24 * 5, "time", "tas")) %>%
  #     unnest(fft)
  #   output$out_macro_ps <- renderPlot({
  #     rv$macro_f %>%
  #       group_by(frequency, period) %>%
  #       summarise(sd = sd(power), power = mean(power)) %>%
  #       ggplot(aes(frequency, power+1)) +
  #       geom_col() +
  #       geom_linerange(aes(ymin = power+1-sd, ymax = power+1+sd)) +
  #       theme_bw() +
  #       xlab("Period [h]") +
  #       ylab("Power") +
  #       scale_x_continuous(
  #         breaks = c(0, 1 / 24, 1 / 12, 1 / 8, 1 / 6, 1 / 3),
  #         labels = c("0", "24", "12", "8", "6", "3")
  #       ) +
  #       theme(legend.position.inside = c(0.8, 0.8)) +
  #       scale_y_log10()
  #   })
  # })

}
