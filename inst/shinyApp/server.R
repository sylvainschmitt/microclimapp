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
      time <- input$sel_macro_time
      tas <- input$sel_macro_tas
      rv$macro %>%
        ggplot(aes(time, tas)) +
        geom_line() +
        theme_bw()
    })
  })


  #
  # # LOAD MICRO ---------------------------------------------------------------
  #
  # ## microclimate file actions ----
  # observeEvent(input$micro_DATASET, ignoreInit = TRUE,  {
  #
  #   # Read microclimate upload
  #   rv$micro <- vroom(req(input$micro_DATASET)$datapath)
  #
  #   # show microclimate content
  #   output$micro_DATASET <- renderDT(rv$micro, options = list(scrollX = TRUE))
  #
  #   # show other hidden boxes
  #   showElement("box_micro_DATASET")
  # })
  #
  # # Download button for the microclimate example (HOBO Mormal)
  # output$dl_micro_ex <- downloadHandler(
  #   filename = "microclimate.csv",
  #   content = function(file) {
  #     file.copy("exemple_data/microclimate.csv", file)
  #   },
  #   contentType = "text/csv"
  # )
  #
  # ## Reaction to 'Continue' button ----
  # observeEvent(input$btn_DATASET_LOADED, ignoreInit = TRUE, {
  #   print("Reaction to btn_DATASET_LOADED")
  #   shinyjs::show("nav_item_macro")
  #   shinyjs::hide("tab_LOAD")
  #   shinyjs::show("tab_MACRO")
  #   shinyjs::removeClass("nav_link_load", "active")
  #   shinyjs::addClass("nav_link_taxo", "active")
  # }) # end of "reaction to 'Continue' button
  #
  # # MACROCLIMATE ---------------------------------------------------------------
  # observeEvent(input$btn_DATASET_LOADED, ignoreInit = TRUE, {
  #   output$out_macro <- renderPlot({
  #     rv$macro %>%
  #       ggplot(aes(time, tas)) +
  #       geom_line() +
  #       theme_bw()
  #   })
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
