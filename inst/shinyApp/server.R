function(input, output, session) {

  # Initialisation ----

  # stop the serveur at the end of the session
  autoCloseApp() # version compatible local/server
  observe_helpers(help_dir = "helpfiles")
  legalNoticeHandler(includeMarkdown("helpfiles/legal_notice.md"), size = "l")

  # Legal notice
  legal_content <- shiny::includeMarkdown("helpfiles/legal_notice.md")
  legalNoticeBslib(2026, "UR F&S")

  observeEvent(input$selected_tab, {
    # Hide all nav items
    shinyjs::hide("tab_LOAD")
    shinyjs::hide("tab_MACRO")

    # remove the active class of all links
    shinyjs::removeClass("nav_link_load", "active")
    shinyjs::removeClass("nav_link_macro", "active")

    # Display the selected item and active the link
    shinyjs::show(input$selected_tab)
    link_id <- switch(input$selected_tab,
                      "tab_LOAD" = "nav_link_load",
                      "tab_MACRO" = "nav_link_macro"
    )
    shinyjs::addClass(link_id, "active")
  })

  ## Reactive values:  ----
  rv <- reactiveValues(
    macro = NULL, # macroclimate dataframe
    micro = NULL, # microclimate dataframe
    macro_f = NULL, # macroclimate Fourier coefficients
    gg_macro = NULL # the microclimate figure
  )

  # LOAD MACRO ---------------------------------------------------------------

  ## macroclimate file actions ----
  observeEvent(input$macro_DATASET, ignoreInit = TRUE,  {

    # Read macroclimate upload
    rv$macro <- vroom(req(input$macro_DATASET)$datapath)

    # show macroclimate content
    output$macro_DATASET <- renderDT(rv$macro, options = list(scrollX = TRUE))

    # show other hidden boxes
    showElement("box_macro_DATASET")
  })

  # Download button for the macroclimate example (ERA5-land Mormal)
  output$dl_macro_ex <- downloadHandler(
    filename = "macroclimate.csv",
    content = function(file) {
      file.copy("exemple_data/macroclimate.csv", file)
    },
    contentType = "text/csv"
  )

  # LOAD MICRO ---------------------------------------------------------------

  ## microclimate file actions ----
  observeEvent(input$micro_DATASET, ignoreInit = TRUE,  {

    # Read microclimate upload
    rv$micro <- vroom(req(input$micro_DATASET)$datapath)

    # show microclimate content
    output$micro_DATASET <- renderDT(rv$micro, options = list(scrollX = TRUE))

    # show other hidden boxes
    showElement("box_micro_DATASET")
  })

  # Download button for the microclimate example (HOBO Mormal)
  output$dl_micro_ex <- downloadHandler(
    filename = "microclimate.csv",
    content = function(file) {
      file.copy("exemple_data/microclimate.csv", file)
    },
    contentType = "text/csv"
  )

  ## Reaction to 'Continue' button ----
  observeEvent(input$btn_DATASET_LOADED, ignoreInit = TRUE, {
    print("Reaction to btn_DATASET_LOADED")
    shinyjs::show("nav_item_macro")
    shinyjs::hide("tab_LOAD")
    shinyjs::show("tab_MACRO")
    shinyjs::removeClass("nav_link_load", "active")
    shinyjs::addClass("nav_link_taxo", "active")
  }) # end of "reaction to 'Continue' button

  # MACROCLIMATE ---------------------------------------------------------------
  observeEvent(input$btn_DATASET_LOADED, ignoreInit = TRUE, {
    output$out_macro <- renderPlot({
      rv$macro %>%
        ggplot(aes(time, tas)) +
        geom_line() +
        theme_bw()
    })
    rv$macro_f <- rv$macro %>%
      do(fft = fft_roll(., 24 * 5, "time", "tas")) %>%
      unnest(fft)
    output$out_macro_ps <- renderPlot({
      rv$macro_f %>%
        group_by(frequency, period) %>%
        summarise(sd = sd(power), power = mean(power)) %>%
        ggplot(aes(frequency, power+1)) +
        geom_col() +
        geom_linerange(aes(ymin = power+1-sd, ymax = power+1+sd)) +
        theme_bw() +
        xlab("Period [h]") +
        ylab("Power") +
        scale_x_continuous(
          breaks = c(0, 1 / 24, 1 / 12, 1 / 8, 1 / 6, 1 / 3),
          labels = c("0", "24", "12", "8", "6", "3")
        ) +
        theme(legend.position.inside = c(0.8, 0.8)) +
        scale_y_log10()
    })
  })

}
