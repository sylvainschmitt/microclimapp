#' run_app
#'
#' @description Runs the microclimr app
#'
#' @importFrom shiny runApp
#'
#' @export
#'
run_app <- function() {
  shiny::runApp(system.file("shinyApp",
                            package = "microclimapp"),
                launch.browser = T)
}
