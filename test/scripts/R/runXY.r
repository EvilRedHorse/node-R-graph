#!/usr/bin/env Rscript

# Fedora Requires: 
# system("sudo dnf install R-jsonlite")

# R/runXY.r [folder/file_name.ps] [XY_matrix.json]
args <- commandArgs(TRUE)

# announce "Rscript running..."
sayAnnounce <- function(){
    cat("Rscript running...", args[1],sep=" ",fill=TRUE)
}
sayAnnounce()

# Launch GUI
#openGUI <- function(){
#    library(tcltk)
    #windows() # Windows         
#    X11(width=20, height=16, title="Graph") # Linux
    #X11(display = "", width, height, pointsize, gamma, bg, canvas, fonts, family, xpos, ypos, title, type, antialias)
    #quartz() #Mac
#}
#openGUI()

# save graph to ps
saveGraph <- function(){
    postscript(args[1], paper="executive")
}
saveGraph()

xyJSON <- function(json_url) {
    # JSON Data handling library
    library(jsonlite)
    # take in JSON as a matrix
    XY <- fromJSON(json_url)
    # stop if above 2 rows
    stopifnot(exprs = { nrow(XY) == 2 })
    # extract first 2 rows
    x <<- (XY[1, ])
    y <<- (XY[2, ])
}
xyJSON(args[2])

### Main Plotting Function ###
plotXY <- function(time, value){
        
    ### Plot Style Settings ###
    plot_title <- ""
    # margin size vector c(bottom, left, top, right) in lines. default = c(5, 4, 4, 2) + 0.1
#    par(mar=c(12, 25, 4, 6) + 0.2)
    par(mar=c(5, 4, 4, 4) + 0.1)
    xlabel <- ""
    ylabel <- ""
    label_colour <- "black"
    label_scale <- 2
    ### default bg is white 
    background <- "white"
    ### default col.axis is black
    axis_colour <- "white"
    axis_scale <- 2
    symbol_scale <- 1
    title_scale <- 2
    subtitle_scale <- 2
    # line type
    line_type <- 1
    # line width
    line_width <- 4
    # point style 16 is a large black dot, 1 is an empty circle
    point <- 16
    # p - points, l - line, b - both
    plot_type <- "l"
    tick_length <- -0.06
    plot(time, value, main=plot_title, cex=symbol_scale, cex.lab=label_scale, cex.axis=axis_scale, cex.main=title_scale, cex.sub=subtitle_scale, xlab=xlabel, ylab=ylabel, col.lab=label_colour, col.axis=axis_colour, bg=background, lty=line_type, lwd=line_width, pch=point, type=plot_type, tck=tick_length)
    axis(1, at=time, labels=as.POSIXct(as.numeric(time), origin="1970-01-01", tz="UTC"), col.axis="black", cex.axis=1.25, tick=FALSE, las=0, line=1.6 )
    axis(2, at=value, labels=value, cex.axis=1, tick=FALSE, col.axis="black", las=0, line=2.3 )
    title("", xlab="Time", line=4.3, cex.lab=1.75)
}
plotXY(x, y)

# Launch GUI Close Prompt
#openPrompt <- function(){
#    h1 <- "Close"
#    button <- "ok" 
#    ico <- "question"
#    prompt  <- "Exit?"
#    extra   <- ""
#    capture <- tk_messageBox(title = h1, type= button, icon = ico, message = prompt, detail = extra)
#}
#openPrompt()
