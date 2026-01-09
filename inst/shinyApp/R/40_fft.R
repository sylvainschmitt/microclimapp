fft_ui <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    class = "tab-content",

    layout_columns(
      col_widths = c(3, 9),

      ## Load column ----
      card(
        card_header("Fast Fourier Transform Parameters",
                    class = "custom_card_header"),

        card_body(

          div(
            id = "id_fft_windows",
            p("Which rolling window size do you want to use (in days)?"),
            sliderInput("sel_windows_d", label = "", min = 2, max = 100, value = 5)
          ),

          div(
            id = "id_fft_slide",
            p("Which rolling window slide do you want to use (in days)?"),
            sliderInput("sel_slide_d", label = "", min = 1, max = 100, value = 3)
          ),

          actionButton("btn_run_fft", strong("Run"),
                       class = "btn-lg btn-primary text-white"),

        )

      ),

      ## Power spectrum column ----
      card(
        card_header("Macro- and micro-climate preview"),
        card_body(
          div(
            plotOutput(outputId = "out_fft_gg")
          )
        )
      ),

    ),

    # * continue button ----
    div(
      class = "text-center my-4",
      actionButton("btn_fft_done", strong("Continue"), class = "btn-lg btn-primary text-white")
    )

  )
}
