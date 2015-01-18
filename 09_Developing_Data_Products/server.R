# server.R
#
# Electronic implementation of the WHO 2006 Growth Standard, for infants aged 0 - 24 months
#
# - Joseph Chou
# - January 17, 2015
#

library(shiny)
library(ggplot2)
library(reshape2)

##############################################################################################################
#
# Data tables of WHO 0 - 2 month growth standards from: http://www.cdc.gov/growthcharts/who_charts.htm
#
#   lmsData <- read.csv("WHOlong.csv") # for when the source parameter file needs to be adjusted
#   save(lmsData, file = "lmsData")
#   load("lmsData") # restore the R object of LMS parameters, in dataframe "lmsData"
#
# The following parameter data table would normally live in an external file to be read in (as above), but for the
# Coursera course assignment, will be embedded within the server.R code to reduce external dependencies

lmsData = read.csv( text = "Chart,Age,Gender,Measure,Units,L,M,S
WHOinfant,0,M,Wt,kg,0.3487,3.3464,0.14602
WHOinfant,1,M,Wt,kg,0.2297,4.4709,0.13395
WHOinfant,2,M,Wt,kg,0.197,5.5675,0.12385
WHOinfant,3,M,Wt,kg,0.1738,6.3762,0.11727
WHOinfant,4,M,Wt,kg,0.1553,7.0023,0.11316
WHOinfant,5,M,Wt,kg,0.1395,7.5105,0.1108
WHOinfant,6,M,Wt,kg,0.1257,7.934,0.10958
WHOinfant,7,M,Wt,kg,0.1134,8.297,0.10902
WHOinfant,8,M,Wt,kg,0.1021,8.6151,0.10882
WHOinfant,9,M,Wt,kg,0.0917,8.9014,0.10881
WHOinfant,10,M,Wt,kg,0.082,9.1649,0.10891
WHOinfant,11,M,Wt,kg,0.073,9.4122,0.10906
WHOinfant,12,M,Wt,kg,0.0644,9.6479,0.10925
WHOinfant,13,M,Wt,kg,0.0563,9.8749,0.10949
WHOinfant,14,M,Wt,kg,0.0487,10.0953,0.10976
WHOinfant,15,M,Wt,kg,0.0413,10.3108,0.11007
WHOinfant,16,M,Wt,kg,0.0343,10.5228,0.11041
WHOinfant,17,M,Wt,kg,0.0275,10.7319,0.11079
WHOinfant,18,M,Wt,kg,0.0211,10.9385,0.11119
WHOinfant,19,M,Wt,kg,0.0148,11.143,0.11164
WHOinfant,20,M,Wt,kg,0.0087,11.3462,0.11211
WHOinfant,21,M,Wt,kg,0.0029,11.5486,0.11261
WHOinfant,22,M,Wt,kg,-0.0028,11.7504,0.11314
WHOinfant,23,M,Wt,kg,-0.0083,11.9514,0.11369
WHOinfant,24,M,Wt,kg,-0.0137,12.1515,0.11426
WHOinfant,0,F,Wt,kg,0.3809,3.2322,0.14171
WHOinfant,1,F,Wt,kg,0.1714,4.1873,0.13724
WHOinfant,2,F,Wt,kg,0.0962,5.1282,0.13
WHOinfant,3,F,Wt,kg,0.0402,5.8458,0.12619
WHOinfant,4,F,Wt,kg,-0.005,6.4237,0.12402
WHOinfant,5,F,Wt,kg,-0.043,6.8985,0.12274
WHOinfant,6,F,Wt,kg,-0.0756,7.297,0.12204
WHOinfant,7,F,Wt,kg,-0.1039,7.6422,0.12178
WHOinfant,8,F,Wt,kg,-0.1288,7.9487,0.12181
WHOinfant,9,F,Wt,kg,-0.1507,8.2254,0.12199
WHOinfant,10,F,Wt,kg,-0.17,8.48,0.12223
WHOinfant,11,F,Wt,kg,-0.1872,8.7192,0.12247
WHOinfant,12,F,Wt,kg,-0.2024,8.9481,0.12268
WHOinfant,13,F,Wt,kg,-0.2158,9.1699,0.12283
WHOinfant,14,F,Wt,kg,-0.2278,9.387,0.12294
WHOinfant,15,F,Wt,kg,-0.2384,9.6008,0.12299
WHOinfant,16,F,Wt,kg,-0.2478,9.8124,0.12303
WHOinfant,17,F,Wt,kg,-0.2562,10.0226,0.12306
WHOinfant,18,F,Wt,kg,-0.2637,10.2315,0.12309
WHOinfant,19,F,Wt,kg,-0.2703,10.4393,0.12315
WHOinfant,20,F,Wt,kg,-0.2762,10.6464,0.12323
WHOinfant,21,F,Wt,kg,-0.2815,10.8534,0.12335
WHOinfant,22,F,Wt,kg,-0.2862,11.0608,0.1235
WHOinfant,23,F,Wt,kg,-0.2903,11.2688,0.12369
WHOinfant,24,F,Wt,kg,-0.2941,11.4775,0.1239
WHOinfant,0,M,HC,cm,1,34.4618,0.03686
WHOinfant,1,M,HC,cm,1,37.2759,0.03133
WHOinfant,2,M,HC,cm,1,39.1285,0.02997
WHOinfant,3,M,HC,cm,1,40.5135,0.02918
WHOinfant,4,M,HC,cm,1,41.6317,0.02868
WHOinfant,5,M,HC,cm,1,42.5576,0.02837
WHOinfant,6,M,HC,cm,1,43.3306,0.02817
WHOinfant,7,M,HC,cm,1,43.9803,0.02804
WHOinfant,8,M,HC,cm,1,44.53,0.02796
WHOinfant,9,M,HC,cm,1,44.9998,0.02792
WHOinfant,10,M,HC,cm,1,45.4051,0.0279
WHOinfant,11,M,HC,cm,1,45.7573,0.02789
WHOinfant,12,M,HC,cm,1,46.0661,0.02789
WHOinfant,13,M,HC,cm,1,46.3395,0.02789
WHOinfant,14,M,HC,cm,1,46.5844,0.02791
WHOinfant,15,M,HC,cm,1,46.806,0.02792
WHOinfant,16,M,HC,cm,1,47.0088,0.02795
WHOinfant,17,M,HC,cm,1,47.1962,0.02797
WHOinfant,18,M,HC,cm,1,47.3711,0.028
WHOinfant,19,M,HC,cm,1,47.5357,0.02803
WHOinfant,20,M,HC,cm,1,47.6919,0.02806
WHOinfant,21,M,HC,cm,1,47.8408,0.0281
WHOinfant,22,M,HC,cm,1,47.9833,0.02813
WHOinfant,23,M,HC,cm,1,48.1201,0.02817
WHOinfant,24,M,HC,cm,1,48.2515,0.02821
WHOinfant,0,F,HC,cm,1,33.8787,0.03496
WHOinfant,1,F,HC,cm,1,36.5463,0.0321
WHOinfant,2,F,HC,cm,1,38.2521,0.03168
WHOinfant,3,F,HC,cm,1,39.5328,0.0314
WHOinfant,4,F,HC,cm,1,40.5817,0.03119
WHOinfant,5,F,HC,cm,1,41.459,0.03102
WHOinfant,6,F,HC,cm,1,42.1995,0.03087
WHOinfant,7,F,HC,cm,1,42.829,0.03075
WHOinfant,8,F,HC,cm,1,43.3671,0.03063
WHOinfant,9,F,HC,cm,1,43.83,0.03053
WHOinfant,10,F,HC,cm,1,44.2319,0.03044
WHOinfant,11,F,HC,cm,1,44.5844,0.03035
WHOinfant,12,F,HC,cm,1,44.8965,0.03027
WHOinfant,13,F,HC,cm,1,45.1752,0.03019
WHOinfant,14,F,HC,cm,1,45.4265,0.03012
WHOinfant,15,F,HC,cm,1,45.6551,0.03006
WHOinfant,16,F,HC,cm,1,45.865,0.02999
WHOinfant,17,F,HC,cm,1,46.0598,0.02993
WHOinfant,18,F,HC,cm,1,46.2424,0.02987
WHOinfant,19,F,HC,cm,1,46.4152,0.02982
WHOinfant,20,F,HC,cm,1,46.5801,0.02977
WHOinfant,21,F,HC,cm,1,46.7384,0.02972
WHOinfant,22,F,HC,cm,1,46.8913,0.02967
WHOinfant,23,F,HC,cm,1,47.0391,0.02962
WHOinfant,24,F,HC,cm,1,47.1822,0.02957
WHOinfant,0,M,Len,cm,1,49.8842,0.03795
WHOinfant,1,M,Len,cm,1,54.7244,0.03557
WHOinfant,2,M,Len,cm,1,58.4249,0.03424
WHOinfant,3,M,Len,cm,1,61.4292,0.03328
WHOinfant,4,M,Len,cm,1,63.886,0.03257
WHOinfant,5,M,Len,cm,1,65.9026,0.03204
WHOinfant,6,M,Len,cm,1,67.6236,0.03165
WHOinfant,7,M,Len,cm,1,69.1645,0.03139
WHOinfant,8,M,Len,cm,1,70.5994,0.03124
WHOinfant,9,M,Len,cm,1,71.9687,0.03117
WHOinfant,10,M,Len,cm,1,73.2812,0.03118
WHOinfant,11,M,Len,cm,1,74.5388,0.03125
WHOinfant,12,M,Len,cm,1,75.7488,0.03137
WHOinfant,13,M,Len,cm,1,76.9186,0.03154
WHOinfant,14,M,Len,cm,1,78.0497,0.03174
WHOinfant,15,M,Len,cm,1,79.1458,0.03197
WHOinfant,16,M,Len,cm,1,80.2113,0.03222
WHOinfant,17,M,Len,cm,1,81.2487,0.0325
WHOinfant,18,M,Len,cm,1,82.2587,0.03279
WHOinfant,19,M,Len,cm,1,83.2418,0.0331
WHOinfant,20,M,Len,cm,1,84.1996,0.03342
WHOinfant,21,M,Len,cm,1,85.1348,0.03376
WHOinfant,22,M,Len,cm,1,86.0477,0.0341
WHOinfant,23,M,Len,cm,1,86.941,0.03445
WHOinfant,24,M,Len,cm,1,87.8161,0.03479
WHOinfant,0,F,Len,cm,1,49.1477,0.0379
WHOinfant,1,F,Len,cm,1,53.6872,0.0364
WHOinfant,2,F,Len,cm,1,57.0673,0.03568
WHOinfant,3,F,Len,cm,1,59.8029,0.0352
WHOinfant,4,F,Len,cm,1,62.0899,0.03486
WHOinfant,5,F,Len,cm,1,64.0301,0.03463
WHOinfant,6,F,Len,cm,1,65.7311,0.03448
WHOinfant,7,F,Len,cm,1,67.2873,0.03441
WHOinfant,8,F,Len,cm,1,68.7498,0.0344
WHOinfant,9,F,Len,cm,1,70.1435,0.03444
WHOinfant,10,F,Len,cm,1,71.4818,0.03452
WHOinfant,11,F,Len,cm,1,72.771,0.03464
WHOinfant,12,F,Len,cm,1,74.015,0.03479
WHOinfant,13,F,Len,cm,1,75.2176,0.03496
WHOinfant,14,F,Len,cm,1,76.3817,0.03514
WHOinfant,15,F,Len,cm,1,77.5099,0.03534
WHOinfant,16,F,Len,cm,1,78.6055,0.03555
WHOinfant,17,F,Len,cm,1,79.671,0.03576
WHOinfant,18,F,Len,cm,1,80.7079,0.03598
WHOinfant,19,F,Len,cm,1,81.7182,0.0362
WHOinfant,20,F,Len,cm,1,82.7036,0.03643
WHOinfant,21,F,Len,cm,1,83.6654,0.03666
WHOinfant,22,F,Len,cm,1,84.604,0.03688
WHOinfant,23,F,Len,cm,1,85.5202,0.03711
WHOinfant,24,F,Len,cm,1,86.4153,0.03734")

lmsToValue <- function( L, M, S, Z ) { # convert Z using Lambda / Mu / Sigma parameters to a measurement
    # reference explaining LMS parameters: http://www.cdc.gov/growthcharts/percentile_data_files.htm
    # To do: this function is NOT properly vectorized (because of the if L != 0 portion?) -- fix this
    if ( L != 0 ) { # usual case, L != 0
        M * ( 1 + L * S * Z ) ** ( 1 / L)
    } else { # L == 0
        M * exp( S * Z )
    }
}

shinyServer( function(input, output, session) {
    
    gender <- reactive({ input$gender })
    measure <- reactive({ input$measure })
    percentilelist <- reactive({ as.numeric( unlist( strsplit( input$percentiles, split="," ) ) ) })

    displayMeasure <- reactive({
        if ( measure() == "Wt" ) {
            displayMeasure <- paste( "Weight (",lms()$Units[1],")", sep = "" )
        } else if ( measure() == "HC" ) {
            displayMeasure <- paste( "Head circumference (",lms()$Units[1],")", sep = "" )
        } else if ( measure() == "Len" ) {
            displayMeasure <- paste( "Length (",lms()$Units[1],")", sep = "" )
        }
        displayMeasure
    })
    
    output$title <- renderText({
        if ( gender() == "M" ) {
            "WHO Growth Standard for Males, Aged 0 - 24 months"
        } else {
            "WHO Growth Standard for Females, Aged 0 - 24 months"
        }
    })
    
    lms <- reactive({ # filter the LMS parameter list to the gender and measure of interest
        if ( !is.null( gender() ) & !is.null( measure() ) ) {
            lms <- lmsData[ ( lmsData$Gender == gender()) & (lmsData$Measure == measure() ) ,] 
            # To do: for safety and robustness, should sort the parameter dataframe by Age
            updateSliderInput(session, "xlimits", value = c( min(lms$Age), max(lms$Age) )) # update X axis to show full range of ages
            # update the input sliders for the Y axis graph limits to reasonable numbers; reactive to changes in measure
            temp <- lms[ lms$Age == min(lms$Age), ]
            lowerLimit <- lmsToValue( temp$L, temp$M, temp$S, qnorm(0.005) )
            temp <- lms[ lms$Age == max(lms$Age), ]
            upperLimit <- lmsToValue( temp$L, temp$M, temp$S, qnorm(0.995) )
            updateSliderInput(session, "ylimits", value = c( lowerLimit, upperLimit ))
            lms
        } else {
            NULL
        }
    })
    
    output$growthchart <- renderPlot({
        if ( !is.null( gender() ) & !is.null( measure() ) ) {
            # To do: change to use APPROXFUN and calculate the ages via interpolation, rather than relying on available ages
            temp <- lms()$Age # iteratively build a data frame, starting with one common X-axis source
            for (z in qnorm(percentilelist() / 100.0)) { # convert the list of percentiles into a vector of Z scores
                temp <- cbind( temp, lms()$M * ( 1 + lms()$L * lms()$S * z ) ** ( 1 / lms()$L)) # iteratively add on columns of measures at each Z score
            } # need to vectorize the lmsToValue function to be able to use it above
            temp <- as.data.frame(temp)
            names(temp) <- c("Age", percentilelist() )
            temp2 <- melt(temp, id.vars="Age") # convert to tall format, by repeating the X times repeatedly and creating a factor variable for each percentile
            names(temp2)[2] = "Percentiles" # the factor variables
            names(temp2)[3] = "Measure" # the measures
            g <- ggplot() + geom_line(data = temp2, aes(Age, Measure, col = Percentiles) )
            g <- g + xlab( "Age (months)" ) + ylab( displayMeasure() )
            g <- g + coord_cartesian(xlim = input$xlimits, ylim = input$ylimits) # change displayed area of the graph
    #         g <- g + geom_point( data = growthdata(), aes(Age, Measurement) ) # placeholder for plotting actual patient data points
            g
        } else {
            NULL
        }
    })

})