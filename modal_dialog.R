modal_dialog <- function(play_type_id, game_id, yards_gained, down, qtr, TimeSecs,
                         ydstogo, posteam_id, edit) {
  
  if(edit) {
    x <- "Submit Edits"
  } else {
    x <- "Add New Play"
  }
  
  shiny::modalDialog(
    title = "Edit Play",
    div(
      class = "text-center",
      div(
        style = "display: inline-block;",
        shiny::numericInput(inputId = "play_type_id",
                         label = "Play Type",
                         value = play_type_id,
                         width = "200px")
      ),
      div(
        style = "display: inline-block;",
        shiny::numericInput(inputId = "game_id",
                            label = "Game ID",
                            value = game_id, 
                            width = "200px")
      ),
      div(
        style = "display: inline-block;",
        shiny::numericInput(inputId = "yards_gained",
                            label = "Yards Gained",
                            value = yards_gained, 
                            width = "200px")
      ),
      div(
        style = "display: inline-block;",
        shiny::numericInput(inputId = "down",
                            label = "Down",
                            value = down, 
                            width = "200px")
      ),
      div(
        style = "display: inline-block;",
        shiny::numericInput(inputId = "qtr",
                            label = "Quarter",
                            value = qtr, 
                            width = "200px")
      ),
      div(
        style = "display: inline-block;",
        shiny::numericInput(inputId = "TimeSecs",
                            label = "Time Left in Game (in Seconds)",
                            value = TimeSecs, 
                            width = "200px")
      ),
      div(
        style = "display: inline-block;",
        shiny::numericInput(inputId = "ydstogo",
                            label = "Yards to Go",
                            value = ydstogo, 
                            width = "200px")
      ),
      div(
        style = "display: inline-block;",
        shiny::numericInput(inputId = "posteam_id",
                            label = "Possessing Team ID",
                            value = posteam_id, 
                            width = "200px")
      )
      
    ),
    size = 'm',
    easyClose = TRUE,
    footer = div(
      class = "pull-right container",
      shiny::actionButton(inputId = "final_edit",
                          label   = x,
                          icon = shiny::icon("edit"),
                          class = "btn-info"),
      shiny::actionButton(inputId = "dismiss_modal",
                          label   = "Close",
                          class   = "btn-danger")
    )
    
    
  ) %>% shiny::showModal()
  
}