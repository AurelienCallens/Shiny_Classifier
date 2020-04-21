
shinyServer(function(input, output) {
    
    # Load and read csv file 
    my_data <- reactive({read_csv(input$file$datapath)})
    
    # When loaded, ask  to choose the column with filepath
    observeEvent(input$file,{
        output$var_fp <- renderUI({
            tagList(
                radioButtons("var_fp", "Variable containing filepath:",
                             choiceNames = names(my_data()),
                             choiceValues = 1:length(names(my_data())),
                             selected=character(0))
            )
            
        })
    })
    
    # After choosing filepath column, ask if we start a new classification or 
    # resume a new one (if so, select the column)
    
    observeEvent(input$var_fp ,{
        output$var_cla <- renderUI({
            tagList(
                radioButtons("var_cla", "Variable containing previous classification:",
                             choiceNames = c("Start new classification (create new column)", names(my_data())),
                             choiceValues = c(0, 1:length(names(my_data()))),
                             selected=character(0))
            )
        })
    })
    
    #Reactive indexes (depends if we resume or start a classification)
    
    ind <-  eventReactive(input$var_cla, { 
        if(input$var_cla == 0){
            seq.int(from = 1, to = nrow(my_data()), by = 1)
        }else{
            which(is.na(my_data()[, as.numeric(input$var_cla)]))
        }
    })
    
    #When choice about classification is made, plot the image and start classifying
    # Each time a button is pressed, save the result in reactive vector and display 
    # following image
    
    observeEvent(input$var_cla, {
        
        #Reactive counter that changes each time a button is pressed
        counter <- reactiveValues(countervalue = 1)
        
        #Reactive classification result
        res <- reactiveValues(data = NULL)
        
        #Plot the image reactively
        output$imgPlot <- renderPlot({
            
            plot(readImage(unlist(my_data()[ind()[counter$countervalue], as.numeric(input$var_fp)])))
            
        })
        
        # Observe Event for the 5 classes : when a button is pressed save the results in 
        # reactive vector and add one to the reactive counter to display following image
        # You can change the class name depending on your needs
        
        observeEvent(input$Class_1, {
            res$data <- c(res$data, "Class_1")
            counter$countervalue <- counter$countervalue + 1  
            
        })
        
        observeEvent(input$Class_2, {
            res$data <- c(res$data, "Class_2")
            counter$countervalue <- counter$countervalue + 1  
            
        })
        
        observeEvent(input$Class_3, {
            res$data <- c(res$data, "Class_3")
            counter$countervalue <- counter$countervalue + 1  
            
        })
        
        observeEvent(input$Class_4, {
            res$data <- c(res$data, "Class_4")
            counter$countervalue <- counter$countervalue + 1  
        })
        
        observeEvent(input$Class_5, {
            res$data <- c(res$data, "Class_5")
            counter$countervalue <- counter$countervalue + 1  
        })
        
        
        #Button save : depends if we start or resume classification,
        # In both cases, overwrite the original file 
        
        observeEvent(input$Save, {
            if(as.numeric(input$var_cla) == 0){
                
                save_data <- data.frame(my_data(),
                                        "class" = c(res$data, rep(NA, nrow(my_data())))[1:nrow(my_data())])
                write_csv(x = save_data, path = input$file$name)
                
            }else{
                
                save_data <- data.frame(my_data())
                save_data[ind(), as.numeric(input$var_cla)] <- c(res$data, rep(NA, nrow(my_data())))[1:nrow(my_data()[ind(),])]
                
                write_csv(x = save_data, path = input$file$name)
            }
            
        })
        
        # Percentage counter, usefull when classifying large dataset.
        output$test <- renderText({
            paste0(round((ind()[1]+counter$countervalue)/nrow(my_data())*100, digits = 3), "%")
        })
        
        
    })
})


