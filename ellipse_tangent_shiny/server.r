#setwd(file.path('C:', 'data science', 'data_products', 'project', 'ellipse_tangent_shiny'))
#importing libraries
library(UsingR)
library(aspace)
library(dplyr)
library(shiny)
library(tools)
library(rsconnect)
ellipse_y <- function(a, x) {
  #calculates the y coordinate on an ellipse.  Will only give the positive part
  #a is the width to height ratio of the ellipse.  
  #x is the absice for which to calculate y.  
  #returns the y coordinate corresponding to x
  sqrt(1-(x/a)**2)
}
x_y_from_angle <- function(a, theta) {
  #calculates the x and y coordinate, in the first quadran, of the tangent to an ellipse.  
  #a is the width to height ratio of the ellipse
  #theta is the angle of the tangent.
  x <- tan(as_radians(theta))*a*((1/a**2)+(tan(as_radians(theta)))**2)**-.5
  y <- ellipse_y(a, x)
  return(list(x = x, y = y))
}
intercepts <- function(a, theta) {
  #Calculates where the tangent of an ellipse intercepts the x and y axis. 
  x_y <- x_y_from_angle(a, theta)
  x <- c(0, x_y$x, x_y$x + x_y$y/tan(as_radians(theta)))
  y <- c(x_y$y + x_y$x*tan(as_radians(theta)), x_y$y, 0)
  return(data.frame(x, y))
}
ellipse <- function(a) {
  #builds the points on an ellipse of width-to-ratio a.  
  nb_points <- 1000
  df1 <- data.frame(list(x = seq(-a, a, a/nb_points)))
  df1 <- mutate(df1, y = ellipse_y(a, x))
  df2 <- data.frame(list(x = seq(-a, a, a/nb_points)))
  df2 <- mutate(df2, y = -ellipse_y(a, x))
  df <- rbind(df1, df2)
  return(df)
}
ellipse_with_tangent <- function(a, theta) {
  #plots the ellipse and a tangent.  
  ellipse_points <- ellipse(a)
  intercept <- intercepts(a, theta)
  max_y = intercept[1, 'y']*1.05
  plot(ellipse_points, type = 'l', asp = 1, 
       xlab = '', 
       ylab = '', 
       xlim = c(-max_a, max_a), 
       ylim = c(-max_y, max_y), 
       axes = TRUE)
  lines(intercept)
  lines(intercept[c(1,2,2),'x'], intercept[c(2,2,3),'y'])
  lines(c(-max_a, max_a), c(0,0))
  lines(c(0,0), c(-max_y, max_y))
  title('An ellipse and its tangent')
}
max_a = 4.
shinyServer(  
  function(input, output) {    
    output$newHist <- renderPlot({
      a <- input$a
      theta <- input$theta
      ellipse_with_tangent(a, theta)
    })      }
)