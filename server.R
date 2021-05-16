server <- function(input, output){
  base_flights <- reactive({
    res <- flights %>%
      filter(carrier == input$airline) %>%
      left_join(airlines, by = "carrier") %>%
      rename(airline = name) %>%
      left_join(airports, by = c("origin" = "faa")) %>%
      rename(origin_name = name) %>%
      select(-lat, -lon, -alt, -tz, -dst) %>%
      left_join(airports, by = c("dest" = "faa")) %>%
      rename(dest_name = name)
    if (input$month != 99) res <- filter(res, month == input$month)
    res
  })
  
  output$total_flights <- renderValueBox({
    # The following code runs inside the database.
    # pull() bring the results into R, which then
    # it's piped directly to a valueBox()
    base_flights() %>%
      tally() %>%
      pull() %>%
      as.integer() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(icon = icon("chart-bar"), color = "purple",subtitle = "Jumlah Kejahatan 2019")
  })
  
  output$per_day <- renderValueBox({
    # The following code runs inside the database
    base_flights() %>%
      group_by(day, month) %>%
      tally() %>%
      ungroup() %>%
      summarise(avg = mean(n)) %>%
      pull(avg) %>%
      round() %>%
      prettyNum(big.mark = ",") %>%
      valueBox(icon = icon("balance-scale"), color = "fuchsia",subtitle = "Provinsi dengan Kasus Kejahatan Tertinggi") 
  })
  
  output$percent_delayed <- renderValueBox({
    base_flights() %>%
      filter(!is.na(dep_delay)) %>%
      mutate(delayed = ifelse(dep_delay >= 15, 1, 0)) %>%
      summarise(
        delays = sum(delayed),
        total = n()
      ) %>%
      mutate(percent = (delays / total) * 100) %>%
      pull() %>%
      round() %>%
      paste0(" |") %>%
      paste(input$airline) %>% 
      valueBox(icon = icon("bluetooth"), color = "teal", subtitle = "Jenis Kejahatan Paling Sering Terjadi")
  })
  
  output$group_totals <- renderD3({
    grouped <- ifelse(input$month != 99, expr(day), expr(month))
    
    res <- base_flights() %>%
      group_by(!!grouped) %>%
      tally() %>%
      collect() %>%
      mutate(
        y = n,
        x = !!grouped
      ) %>%
      select(x, y)
    
    if (input$month == 99) {
      res <- res %>%
        inner_join(
          tibble(x = 1:12, label = substr(month.name, 1, 3)),
          by = "x"
        )
    } else {
      res <- res %>%
        mutate(label = x)
    }
    r2d3(res, "col_plot.js")
  })
  
  output$group_totals2 <- renderD3({
    grouped <- ifelse(input$month != 99, expr(day), expr(month))
    
    res <- base_flights() %>%
      group_by(!!grouped) %>%
      tally() %>%
      collect() %>%
      mutate(
        y = n,
        x = !!grouped
      ) %>%
      select(x, y)
    
    if (input$month == 99) {
      res <- res %>%
        inner_join(
          tibble(x = 1:12, label = substr(month.name, 1, 3)),
          by = "x"
        )
    } else {
      res <- res %>%
        mutate(label = x)
    }
    r2d3(res, "col_plot.js")
  })
  
  output$group_totals3 <- renderD3({
    grouped <- ifelse(input$month != 99, expr(day), expr(month))
    
    res <- base_flights() %>%
      group_by(!!grouped) %>%
      tally() %>%
      collect() %>%
      mutate(
        y = n,
        x = !!grouped
      ) %>%
      select(x, y)
    
    if (input$month == 99) {
      res <- res %>%
        inner_join(
          tibble(x = 1:12, label = substr(month.name, 1, 3)),
          by = "x"
        )
    } else {
      res <- res %>%
        mutate(label = x)
    }
    r2d3(res, "col_plot.js")
  })
  
  # Top airports (server) -------------------------------------------
  output$top_airports <- renderD3({
    # The following code runs inside the database
    base_flights() %>%
      group_by(dest, dest_name) %>%
      tally() %>%
      collect() %>%
      arrange(desc(n)) %>%
      head(10) %>%
      arrange(dest_name) %>%
      mutate(dest_name = str_sub(dest_name, 1, 30)) %>%
      rename(
        x = dest,
        y = n,
        label = dest_name
      ) %>%
      r2d3("bar_plot.js")
  })
  
}