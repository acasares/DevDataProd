library(MASS)

shinyServer(function(input, output) {
    trios <- data.frame(matrix(c(3,3,2,2,1,5,4,3,12,9,10,7,9,13,16,13,11,7,5,6,8,9,7,6),ncol=3))
    names(trios) <- c("AX","BX","CX")
    # print(head(trios,8))
    output$text1 <- renderText({
        param <- trios[input$parameters,]
        AX <- as.numeric(param[1])
        BX <- as.numeric(param[2])
        CX <- as.numeric(param[3])
        DX <- as.numeric(sqrt(BX^2+CX^2-AX^2))
        sprintf("You selected the distances: r = AX = %2.0f, BX = %2.0f, CX = %2.0f.<br>
                The distance from X to the fourth vertex, D, comes up since, from geometry:
                (DX)^2 = (BX)^2 + (CX)^2 - (AX)^2.<br>That is, DX = %3.0f.", AX,BX,CX,DX)
    })

    output$rectangle <- renderPlot({
        param <- trios[input$parameters,]
        r <- AX <- as.numeric(param[1])
        BX <- as.numeric(param[2])
        CX <- as.numeric(param[3])
        alfa <- input$alfa
        rad <- alfa * pi/180
        y <- r * sin(rad)
        x <- r * cos(rad)
        # Rectangle base:
        b <- sqrt(BX^2 - y ^ 2) + x
        # Rectangle height:
        h <- sqrt(CX^2 - x ^ 2) + y
        d <- sqrt(BX^2 + CX^2 - r^2)
        plot.new()
        eqscplot(c(-1, 16), c(-1, 16), type = "n", ratio = 1,
            xlab = paste("Base = ", sprintf("%5.3f", b)),
            ylab = paste("Heigth = ", sprintf("%5.3f", h)))
        area <- as.character(round(b * h,3))
        rect(0, 0, b, h, lwd = 1.5)
        points(x, y, pch = 19, col = "blue")
        text(b/2, h+1, paste("Angle BAX = ", alfa, " degrees"))
        lines(c(0,x,x,0,x,b),c(0,y,y,h,y,0),col="blue")
        lines(c(x,b),c(y,h),col="red")
        text(x+.1,y+.6,'X',col="red")
        text(-.4,.0,'A');text(b+.4,.0,'B')
        text(-.4,h,'C');text(b+.4,h,'D')
        leg.txt <- c("    Lengths:          ",
                     sprintf(" r = AX = %d",r),
                     sprintf(" BX = %d",BX),
                     sprintf(" CX = %d",CX),
                     sprintf(" DX = %d",d),
                     paste("Area =",area))
        legend(b+2,15,leg.txt)
        title(main = "See the problem you selected:")
    })
    output$curve <- renderPlot({
        param <- trios[input$parameters,]
        r <- AX <- as.numeric(param[1])
        BX <- as.numeric(param[2])
        CX <- as.numeric(param[3])
        alf <- seq(0,90,0.1)
        A <- sapply(alf, function(x){
                    rad <- x*pi/180
                    y <- r * sin(rad)
                    x <- r * cos(rad)
                    b <- sqrt(BX^2 - y ^ 2) + x
                    h <- sqrt(CX^2 - x ^ 2) + y
                    b*h
                 })
        mxA <- max(A); mnA <- min(A)
        ind_max <- which.max(A)
        ang_max <- alf[ind_max]
        rng <- mxA - mnA
        rad <- ang_max * pi/180
        y <- r * sin(rad)
        x <- r * cos(rad)
        lx <- round(sqrt(BX^2 - y ^ 2) + x,3)
        ly <- round(sqrt(CX^2 - x ^ 2) + y,3)
        plot(alf,A,type = 'l',col = 'blue',
             xlab = "Angle (degrees)", ylab = "Area (m^2)")
        grid(11,7)
        abline(v = input$alfa,col = "green")
        title(main = "Find the maximum possible area:")
        y1 <- mnA+rng/2; y2 <- y1-rng/10; y3 <- y2-rng/10
        text(50,y1,paste("Greatest Area = ",round(mxA,5)))
        text(50,y2,paste("At angle =", ang_max))
        text(50,y3,paste("(",lx,"x",ly,")"))
        text(12,mnA,paste("Shortest Area = ",round(mnA,5)))
    })
    output$deriv <- renderPlot({
        param <- trios[input$parameters,]
        param <- trios[input$parameters,]
        r <- AX <- as.numeric(param[1])
        BX <- as.numeric(param[2])
        CX <- as.numeric(param[3])
        dx <- 0.1;alf <- seq(0,90,dx)
        A <- sapply(alf, function(x){
            rad <- x*pi/180
            y <- r * sin(rad)
            x <- r * cos(rad)
            b <- sqrt(BX^2 - y ^ 2) + x
            h <- sqrt(CX^2 - x ^ 2) + y
            b*h
        })
        grad <- matrix(0,length(alf),ncol = 1)
        for (i in 2:(length(alf)-1)){
            grad[i,1] <- (A[i+1]-A[i-1])/(2*dx)
        }
        grad[1,1] <- grad[2,1]
        grad[length(alf),1] <- grad[length(alf)-1,1]
        mxG <- max(grad)
        datos <- data.frame(alf,grad); names(datos) <- c('alfa','deriv')
        plot(alf,grad, type = 'l',col = 'blue',
             xlab = "alpha", ylab = "y = d(Area)/d(alpha)")
        grid(11,7)
        abline(h = 0, col = "black")
        abline(v = input$alfa, col = "green")
        title(main = "Numerical derivative d(Area)/d(alpha) as function of alpha:")
        # Linear model fitting:
        recta <- lm(datos$deriv ~ datos$alfa)
        coeffic <- summary(recta)$coef
        allc <- summary(recta)
        preds <- predict.lm(recta)
        lines(alf,preds, type = 'l', col = 'magenta')
        root <- -coeffic[1,1]/coeffic[2,1]
        y1 <- .765*mxG; dy <- .12*mxG; y2 <- y1-dy; y3 <- y2-dy; y4 <- y3-1.4*dy
        text(69.5,y1,sprintf('Regression line: y = %7.5f alfa + %7.5f',coeffic[2,1],
                             coeffic[1,1]))
        text(63.3,y2,sprintf('Adjusted R-squared: %6.4f',allc$adj.r.squared))
        text(70,y3,sprintf('Root of d(Area)/d(alpha) = 0: %7.4f degrees',root))
        rad <- root*pi/180
        y <- r * sin(rad)
        x <- r * cos(rad)
        b <- sqrt(BX^2 - y ^ 2) + x
        h <- sqrt(CX^2 - x ^ 2) + y
        great <-b*h
        text(68.3,y4,sprintf('Greatest Area now computed: %10.5f\n',great))
    })
})
