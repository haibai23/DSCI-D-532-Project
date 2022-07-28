#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(DT)
library(RMySQL)
library(config)
library(odbc)
library(shiny.router)

source("modal_dialog.R")

con <- RMySQL::dbConnect(
  RMySQL::MySQL(),
  user = 'root',
  password = 'Denver18',
  dbname = 'project',
  host = '127.0.0.1',
  port = 3306
)

options(mysql = list(
  "host" = "127.0.0.1",
  "port" = 3306,
  "user" = "root",
  "password" = "Denver18"
))
databaseName <- "project"

data <- con %>%
  dplyr::tbl("plays") %>%
  dplyr::collect()

create_btns <- function(x) {
  x %>%
    purrr::map_chr(~
                     paste0(
                       '<div class = "btn-group">
                   <button class="btn btn-default action-button btn-info action_button" id="edit_',
                       .x, '" type="button" onclick=get_id(this.id)><i class="fas fa-edit"></i></button>
                   <button class="btn btn-default action-button btn-danger action_button" id="delete_',
                       .x, '" type="button" onclick=get_id(this.id)><i class="fa fa-trash-alt"></i></button></div>'
                     ))
}

x <- create_btns(data$play_id)
data <- data %>%
  dplyr::bind_cols(tibble("Buttons" = x))

ui <- fluidPage(
  # div(style = "display: none;", icon("refresh")),
  tabsetPanel(
    tabPanel("Table",
      div(
    class = "container",
    div(
      style = "margin-top: 50px;",
      shiny::actionButton(
        inputId = "add_play",
        label = "Add Play",
        icon = shiny::icon("table"),
        class = "btn-success"
      )
    )
  ),
  div(
    class = "container",
    style = "margin-top: 50px;",
    DT::DTOutput(outputId = "dt_table", width = "100%")
  ),
  shiny::includeScript("script.js")
),
tabPanel("Histogram", selectInput(inputId = "variable",
                                  label = "Variable",
                                  choices = c("play_type_id", "yards_gained", "down", "qtr", "TimeSecs",
                                              "ydstogo", "posteam_id")),
         h3(""),
         plotOutput("plot"))))
# Define server logic required to show table
server <- function(input, output, session) {
  rv <- shiny::reactiveValues(
    df = data %>%
      dplyr::select(-play_id),
    dt_row = NULL,
    add_or_edit = NULL,
    edit_button = NULL,
    keep_track_id = max(data$play_id) + 1
  )
  output$dt_table <- DT::renderDT(
    {
      shiny::isolate(rv$df)
    },
    escape = F,
    rownames = FALSE,
    options = list(processing = FALSE)
  )
  
  proxy <- DT::dataTableProxy("dt_table")
  shiny::observe({
    DT::replaceData(proxy, rv$df, resetPaging = FALSE, rownames = FALSE)
  })
  ### delete row
  shiny::observeEvent(input$current_id, {
    shiny::req(!is.null(input$current_id) &
                 stringr::str_detect(input$current_id,
                                     pattern = "delete"
                 ))
    rv$dt_row <- which(stringr::str_detect(rv$df$Buttons,
                                           pattern = paste0("\\b", input$current_id, "\\b")
    ))
    sql_id <- rv$df[rv$dt_row, ][["Buttons"]] %>%
      stringr::str_extract_all(pattern = "delete_[0-9]+") %>%
      unlist() %>%
      readr::parse_number()
    query <- stringr::str_glue("DELETE FROM plays WHERE play_id = {sql_id}")
    DBI::dbSendQuery(
      con,
      query
    )
    rv$df <- rv$df[-rv$dt_row, ]
  })
  # when edit button is clicked, modal dialog shows current editable row filled out
  shiny::observeEvent(input$current_id, {
    shiny::req(!is.null(input$current_id) &
                 stringr::str_detect(input$current_id,
                                     pattern = "edit"
                 ))
    rv$dt_row <- which(stringr::str_detect(rv$df$Buttons,
                                           pattern = paste0("\\b", input$current_id, "\\b")
    ))
    df <- rv$df[rv$dt_row, ]
    modal_dialog(
      play_type_id = df$play_type_id, game_id = df$game_id, yards_gained = df$yards_gained, 
      down = df$down, qtr = df$qtr, TimeSecs = df$TimeSecs,
      ydstogo = df$ydstogo, posteam_id = df$posteam_id, edit = TRUE
    )
    rv$add_or_edit <- NULL
  })
  # when final edit button is clicked, table will be changed
  shiny::observeEvent(input$final_edit, {
    shiny::req(!is.null(input$current_id) &
                 stringr::str_detect(input$current_id, pattern = "edit") &
                 is.null(rv$add_or_edit))
    rv$edited_row <- dplyr::tibble(
      play_type_id = input$play_type_id,
      game_id = input$game_id,
      yards_gained = input$yards_gained,
      down = input$down,
      qtr = input$qtr,
      TimeSecs = input$TimeSecs,
      ydstogo = input$ydstogo,
      posteam_id = input$posteam_id,
      Buttons = rv$df$Buttons[rv$dt_row]
    )
    sql_row <- rv$edited_row %>%
      dplyr::select(-Buttons)
    id <- rv$df[rv$dt_row, ][["Buttons"]] %>%
      stringr::str_extract_all(pattern = "delete_[0-9]+") %>%
      unlist() %>%
      readr::parse_number()
    query <- paste0(
      "UPDATE plays SET ",
      paste0(names(sql_row), "=", "'", unlist(c(sql_row)), "'", collapse = ", "),
      stringr::str_glue("WHERE play_id = {id}")
    )
    DBI::dbSendQuery(
      con,
      query
    )
    rv$df[rv$dt_row, ] <- rv$edited_row
  })
  shiny::observeEvent(input$add_play, {
    modal_dialog(
      play_type_id = "", game_id = "", yards_gained = "", down = "", qtr = "", TimeSecs = "",
      ydstogo = "", posteam_id = "",
      edit = FALSE
    )
    rv$add_or_edit <- 1
  })
  shiny::observeEvent(input$final_edit, {
    shiny::req(rv$add_or_edit == 1)
    add_row <- dplyr::tibble(
      play_type_id = input$play_type_id,
      game_id = input$game_id,
      yards_gained = input$yards_gained,
      down = input$down,
      qtr = input$qtr,
      TimeSecs = input$TimeSecs,
      ydstogo = input$ydstogo,
      posteam_id = input$posteam_id,
      Buttons = create_btns(rv$keep_track_id)
    )
    rv$df <- add_row %>%
      dplyr::bind_rows(rv$df)
    add_row <- add_row %>%
      dplyr::mutate(play_id = rv$keep_track_id) %>%
      dplyr::select(-Buttons)
    column_names <- paste0(c(names(add_row)), collapse = ", ") %>%
      paste0("(", ., ")")
    values <- paste0("'", unlist(c(add_row)), "'", collapse = ", ") %>%
      paste0("(", ., ")")
    query <- paste0(
      "INSERT INTO plays ",
      column_names,
      " VALUES ",
      values
    )
    DBI::dbSendQuery(
      con,
      query
    )
    rv$keep_track_id <- rv$keep_track_id + 1
  })
  ### remove edit modal when close button is clicked or submit button
  shiny::observeEvent(input$dismiss_modal, {
    shiny::removeModal()
  })
  shiny::observeEvent(input$final_edit, {
    shiny::removeModal()
  })
  
  output$plot <- renderPlot({
    req(input$variable)
    g <- ggplot(rv$df, aes(x = !!as.symbol(input$variable)))
    if (input$variable %in% c("play_type_id", "yards_gained", "down", "qtr", "TimeSecs",
                              "ydstogo", "posteam_id")) {
      # numeric
      g <- g + geom_histogram()
    } else {
      # categorical
      g <- g + geom_bar()
    }
    
    g
  })
}
onStop(function() {
  dbDisconnect(con)
})

# Run the application 
shinyApp(ui = ui, server = server)

