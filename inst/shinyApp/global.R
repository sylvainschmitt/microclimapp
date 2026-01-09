suppressPackageStartupMessages({
  library(shiny)
  library(bslib)
  library(shinyFeedback)
  library(shinyjs)
  library(shinyhelper)
  library(vroom)
  library(DT)
  library(ggplot2)
  library(microclimr)
  library(tidyr)
  library(dplyr)
  library(plotly)
})

source("legal_notice.R")

# set maximum input file size (here 30Mo)
options(shiny.maxRequestSize = 30 * 1024^2)

# SERVER auto close application when session ends
# only if run locally (ie not on a remote server)
autoCloseApp <- function(session=getDefaultReactiveDomain()) {
  isLocal <- Sys.getenv("SHINY_PORT") == ""
  if(isLocal) {
    session$onSessionEnded(function() {
      stopApp()
    })
  }
}
