# misc.r
# Time-stamp: <15 Jul 2016 17:44:08 c:/x/rpack/corrgram/tests/misc.R>

if(FALSE){ # No need to test automatically

# ----------------------------------------------------------------------------

# Crude way to add labels along the axes

corrgram(x = iris, labels = NULL, lower.panel = panel.pts,
         upper.panel = panel.conf, diag.panel = panel.density)
# Draw the axes and note the position of the scales
axis(1)
axis(2)
# Add labels in outer margins
text(x = seq(from = 0, to = 2.6, length = 4), y = 0.01,
     labels = names(iris[, -5]), pos = 3, cex = 0.5)
text(x = -0.5, y = seq(from = 0.1, to=.45, length = 4),
     labels = rev(names(iris[, -5])), srt=90, pos = 3, cex = 0.5)

# ----------------------------------------------------------------------------

  # Test all the panel functions
  
  # Off-diagonal panels
  corrgram(auto, panel=panel.bar)
  corrgram(auto, panel=panel.conf)
  corrgram(auto, panel=panel.cor)
  corrgram(auto, panel=panel.ellipse) # note: latticeExtra also has panel.ellipse
  corrgram(auto, panel=panel.pie)
  corrgram(auto, panel=panel.pts)
  corrgram(auto, panel=panel.shade)
  # All text/diag panels
  corrgram(auto, text.panel=NULL, diag.panel=panel.density)
  corrgram(auto, text.panel=panel.txt, diag.panel=panel.minmax)
  
# ----------------------------------------------------------------------------

# Test the diagonal direction.  Reverse diagonal, use points in lower part
corrgram(auto, order=TRUE, dir="right",
         upper.panel=panel.ellipse, lower.panel=panel.pts, diag.panel=panel.minmax)
corrgram(auto, order=TRUE, dir="/",
         upper.panel=panel.ellipse, lower.panel=panel.pts, diag.panel=panel.minmax)

# ----------------------------------------------------------------------------

# Region colors used to default to the function "col.corrgram", but when the namespace
# was forced on this package, the panel functions would look for "col.corrgram" inside
# the namespace first, and never look in the global environment.
# Bug report by Rob Kabacoff.

# Use green -> brown colors
col.earth <- colorRampPalette(c("darkgoldenrod4", "burlywood1", "darkkhaki", "darkgreen"))
corrgram(mtcars, order=TRUE, lower.panel=panel.shade, upper.panel=panel.pie,
         text.panel=panel.txt, main="A Corrgram of a Different Color",
         col.regions=col.earth)

# ----------------------------------------------------------------------------

# Test 'order' argument

corrgram(mtcars)
corrgram(mtcars, order=NULL)
corrgram(mtcars, order=FALSE)
corrgram(mtcars, order=TRUE)
corrgram(mtcars, order="PC")
corrgram(mtcars, order="OLO")
corrgram(mtcars, order="PC", abs=TRUE)
corrgram(mtcars, order="OLO", abs=TRUE)

# ----------------------------------------------------------------------------

# Test "labels" argument

corrgram(mtcars[2:6], order=TRUE,
         labels=c('Axle ratio','Weight','Displacement','Cylinders','Horsepower'),
         cex.labels=1.5,
         upper.panel=panel.conf, lower.panel=panel.pie,
         diag.panel=panel.minmax, text.panel=panel.txt)

# Split long variable names on two lines
corrgram(mtcars[2:6], order=TRUE, upper.panel=NULL,
         lower.panel=panel.pie,
         text.panel=panel.txt,
         labels=rep('A very long \n variable name',4))
# ----------------------------------------------------------------------------

# Bug with negative correlation

set.seed(123)
a = seq(1,100)
b = jitter(seq(1,100), 80)
cor(a,b) # r about .95
ab=as.data.frame(cbind(a,b))
ab$c = -1 * ab$b # flip direction of correlation
cor(ab$a, ab$c) # r now about -.95
corrgram(ab, order=NULL, lower.panel=panel.pie, upper.panel=NULL,
         text.panel=panel.txt)

corrgram(ab)

# ----------------------------------------------------------------------------

# Test 'type'
corrgram(vote)
corrgram(vote, type='corr')
corrgram(vote, type='data') # Warn user
corrgram(vote, lower.panel=panel.conf)

corrgram(auto)
corrgram(auto, type='data')
# corrgram(auto, type='corr') # Generates error

# ----------------------------------------------------------------------------

  # Test that non-numeric columns in data.frame are ignored.

  corrgram(iris)

# ----------------------------------------------------------------------------

# Missing value in a correlation matrix.
# Use white (transparent?) color for the shading

vote2 <- vote
vote2[2:6,2:6] <- NA
corrgram(vote2)

# ----------------------------------------------------------------------------

# Missing combinations of data could cause cor( , use="pair") to
# give NAs

dat <- data.frame(E1=c(NA,NA,NA,NA,NA,6,7,8,9,10),
                  E2=c(1,2,3,4,5,NA,NA,NA,NA,NA),
                  E3=c(1,2,3,4,5,6,7,8,9,10)+.1,
                  E4=c(2,1,5,6,8,7,9,4,5,3))
cor(dat, use="pair")
corrgram(dat)

# ----------------------------------------------------------------------------

# Print diagonal text unclipped.
# This has a slight quirk...the red box is only drawn the first time.  Calling
# corrgram a 2nd time doesn't draw the red box.
require('grid')
require('gridBase')
unclipped.txt <- function(x=0.2, y=0.5, txt, cex, font, srt){
  vps <- baseViewports()
  vps$figure$clip <- NA # Hack. Do NOT clip text that falls outside the ploting region
  pushViewport(vps$inner) # Figure region
  grid.rect(gp=gpar(lwd=3, col="red"))
  pushViewport(vps$figure) # The diagonal box region
  grid.rect(gp=gpar(lwd=3, col="blue"))
  grid.text(txt, x=0.1,y=y, just='left', gp=gpar(cex=cex))
  popViewport(2)
}
corrgram(mtcars[2:6], order=TRUE,
         labels=c('Axle ratio','Weight','Displacement','Cylinders','Horsepower'),
         cex.labels=2, adj=0,
         upper.panel=NULL, lower.panel=panel.pie,
         diag.panel=panel.minmax, text.panel=unclipped.txt)

# ----------------------------------------------------------------------------

# Print diagonal text unclipped, with no upper panel
require('grid')
require('gridBase')
unclipped.txt <- function(x=0.5, y=0.5, txt, cex, font, srt){
  vps <- baseViewports()
  vps$figure$clip <- NA # Hack. Do NOT clip text that falls outside the ploting region
  pushViewport(vps$inner) # Figure region
  #grid.rect(gp=gpar(lwd=3, col="red"))
  pushViewport(vps$figure) # The diagonal box region
  #grid.rect(gp=gpar(lwd=3, col="blue"))
  grid.text(txt, x=0,y=y, just='left', gp=gpar(cex=cex))
  popViewport(2)
}
corrgram(mtcars[2:6], order=TRUE,
         labels=c('Axle ratio','Weight','Displacement','Cylinders','Horsepower'),
         cex.labels=2,
         upper.panel=NULL, lower.panel=panel.pie,
         text.panel=unclipped.txt)

# ----------------------------------------------------------------------------

# Diagonal labels

panel.txt45 <- function(x=0.5, y=0.5, txt, cex, font, srt){
  text(x, y, txt, cex=cex, font=font, srt= -45)
}
corrgram(auto, text.panel=panel.txt45, diag.panel=panel.minmax)

# Test label.pos
corrgram(auto, label.srt=45, label.pos=c(.75,.75), cex.labels=2.5, upper=NULL)

# ----------------------------------------------------------------------------

# Manually add a legend for coloring points

panel.colpts <- function(x, y, corr=NULL, col.regions, ...){
  # For correlation matrix, do nothing
  if(!is.null(corr)) return()
  plot.xy(xy.coords(x, y), type="p", ..., col=1:2)
  box(col="lightgray")
}
corrgram(auto, lower.panel=panel.conf, upper.panel=panel.colpts)

require(grid)
grid.clip()
pushViewport(viewport(.5, .95, width=stringWidth("Group1"),
                      height=unit(2,"lines"),
                      name="pagenum", gp=gpar(fontsize=8)))
grid.legend(pch=1:2, labels=c("Group1","Group2"), gp=gpar(col=c('red')))
popViewport()

# ----------------------------------------------------------------------------

# Test pearson vs spearman.

corrgram(auto)
corrgram(auto, cor.method="pearson")
corrgram(auto, cor.method="spearman") # Slight change in colors

# ----------------------------------------------------------------------------

  # Example in which one pair of variables had no complete observations
  dati <- iris[1:50,]
  dati[seq(from=2, to=50, by=2),1] <- NA
  dati[seq(from=1, to=49, by=2),2] <- NA

  # Off-diagonal panels
  corrgram(dati, panel=panel.bar)
  corrgram(dati, panel=panel.conf)
  corrgram(dati, panel=panel.cor)
  corrgram(dati, panel=panel.ellipse)
  corrgram(dati, panel=panel.pie)
  corrgram(dati, panel=panel.pts)
  corrgram(dati, panel=panel.shade)
  # All text/diag panels
  corrgram(dati, text.panel=NULL, diag.panel=panel.density)
  corrgram(dati, text.panel=NULL, diag.panel=panel.minmax)
  
# ----------------------------------------------------------------------------
  
} # end if

