fft_ui <- function(id) {
  ns <- NS(id)
  div(
    id = id,
    class = "tab-content",

    card(
      card_header("Fast Fourier Transform", class = "custom_card_header")
    ),
    # * continue button ----
    div(
      class = "text-center my-4",
      actionButton("btn_fft_done", strong("Continue"), class = "btn-lg btn-primary text-white")
    )

  )
}
