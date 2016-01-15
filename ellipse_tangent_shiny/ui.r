shinyUI(pageWithSidebar(  
  #first argument: header
  headerPanel("Ellipse tangent"), 
  #second argument: sidebar
  sidebarPanel(
    h4('Please select the width-to-height ratio of the ellipse (a) and the angle of the tangent (theta).'), 
    sliderInput('a', 'width of the ellipse',value = 1.5, min = 1, max = 4, step = 0.1,), 
    sliderInput('theta', 'angle of the tangent',value = 45, min = 1, max = 89, step = 1,)
    ),
  #second argument: main panel
  mainPanel(    
    plotOutput('newHist')  
  )
)
)