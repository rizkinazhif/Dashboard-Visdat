library(dplyr)                   # this packages is use for data preparation (edit, remove, mutate, etc)
library(stringr)                 # all functions deal with "NA"'s and zero length vectors
library(purrr)                   # requirement packages for Functional Programming Tools
library(rlang)                   # requirement packages for Rmarkdown
library(DT)                      # interface to the JavaScript library DataTables (https://datatables.net/)
library(r2d3)                    # D3 visualization
library(nycflights13)            # all flights that departed from NYC in 2013
library(shinydashboard)
library(shiny)

source("global.R", local = TRUE)

ui <- dashboardPage(title = "www.gombel.com",
                    
                    dashboardHeader(title = "IndoCrime-Dashboard"), 
                    
                    dashboardSidebar(
                      selectInput(
                        inputId = "airline",
                        label = "Airline:",
                        choices = airline_list,
                        selected = "DL",
                        selectize = F
                      ),
                      
                      sidebarMenu(
                        selectInput(
                          inputId = "month",
                          label = "Month:",
                          choices = month_list,
                          selected = 99,
                          size = 13,
                          selectize=F))
                    ), 
                    
                    dashboardBody(
                      tabsetPanel(id = "tabs",
                                  tabPanel(title = strong("Statistik Kejahatan"),
                                           value = "page1",
                                           icon = icon("chart-bar"),
                                           fluidRow(valueBoxOutput("total_flights"),
                                                    valueBoxOutput("per_day"),
                                                    valueBoxOutput("percent_delayed")),
                                           fluidRow(box(title = "Map of Indonesia",
                                                        status = "primary",
                                                        solidHeader = T,
                                                        #background = "light-blue",
                                                        width = 12,
                                                        d3Output("group_totals"))),
                                           br(),
                                           fluidRow(box(title = "Jumlah Kejahatan yang Dilaporkan per Provinsi (2019)",
                                                        status = "warning",
                                                        solidHeader = T,
                                                        width = 4,
                                                        d3Output("group_totals2")),
                                                    box(title = "Jumlah Kejahatan Berdasarkan Klasifikasi Kejahatan",
                                                        status = "success",
                                                        solidHeader = T,
                                                        width = 4,
                                                        d3Output("top_airports")),
                                                    box(title = "Perkembangan IPAK Tahun 2017-2019",
                                                        status = "danger",
                                                        solidHeader = T,
                                                        width = 4,
                                                        d3Output("group_totals3")))
                                  ),
                                  tabPanel(title = strong("Konflik Massal"),
                                           value = "page2",
                                           icon = icon("chart-bar"))
                      )
                    ))