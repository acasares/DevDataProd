library(shiny)
# A geometric problem. Maximize an area.
shinyUI(fluidPage(
  # Application title
  headerPanel("Given the distances from an interior point of a rectangle to three vertices,
              find the distance to the fourth, the dimensions of the figure and the maximum
              and minimum possible areas:"),

  sidebarPanel(
      helpText(a("(Read the user's documentation here)", href="https://acasares.github.io/DevDataProd/", 
                 target="_blank")),
      h5('Choose 3 distances configuring the problem:'),
      column(12,
             selectInput("parameters", label = h4("Select box"),
                         choices = list("AX=3, BX=12, CX=11" = 1, "AX=3, BX=9, CX=7" = 2,
                                        "AX=2, BX=10, CX=5" = 3, "AX=2, BX=7, CX=6" = 4,
                                        "AX=1, BX=9, CX=8" = 5, "AX=5, BX=13, CX=9" = 6,
                                        "AX=4, BX=16, CX=7" = 7, "AX=3, BX=13, CX=6" = 8),
                         selected = 1)),

    h5('See how changing the BAX angle the dimensions of rectangle also change:'),
    sliderInput('alfa', 'Pick BAX angle (0 to 90 degrees)',value = 47.5,
                 min = 0, max = 90, step = 0.1),
    h5('For each angle, the distances from X to the vertices of the rectangle keep their values,
        but the area does change.'),
    h5('We will be interested in finding out the maximum possible area, and the position of X that
       produces that area, given by its polar coordinates (r, angle).'),
    h5('==========================================='),
    br(),
    br(),
    h4('Empirical procedure:'),
    h5('From a sample uniformly spaced of 901 angles in {0,90}, the area has been computed in each
       point.'),
    h5('Finding its maximum value from those results is a good empirical estimation of the desired
       maximum.'),
    h5('See the maximum value and its corresponding angle in the right figure, together with the base
       and heigth of that rectangle.'),
    h5('You can find the minimum value of the area as a global minimum, in the left extreme of the
      curve, at BAX = alpha = 0 degrees.'),
    h5('The green vertical line stands on the angle you chose.'),
    h5('==========================================='),
    br(),
    br(),
    br(),
    br(),
    h4('Numerical procedure:'),
    h5("To find the greatest surface analytically means to find the area's derivative
       as a function of the angle, and to solve the equation resulting from equating it
       to zero."),
    h5("But that's cumbersome, as can be seen in the documentation. So, let's implement a numerical
       procedure, finding firstly the (approximate) derivatives at each point of the sample. This
       plot shows their values as a blue line."),
    h5('As you can see, the plotted points show an almost perfect linear pattern. So we can
       fit a linear model on them and obtain the equation of the regression line (magenta).Realize that
       the intersection of both lines with the x axis is practically the same.'),
    h5("The comparison with the empirical method's results shows a fair approximation
       to the former angle, and even more to the greatest area.")
  ),
  mainPanel(
    htmlOutput('text1'),
    plotOutput('rectangle'),
    plotOutput('curve'),
    plotOutput('deriv')
  )
 )
)
