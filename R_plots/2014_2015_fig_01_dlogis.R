file_name <- "2014_2015_fig_01_dlogis"

### setup

library(tikzDevice)
library(azbuka) # devtoools::install_github("bdemeshev/azbuka")
tikzsetup()

tikz_full <- paste0("auto_figures_tikz/", file_name, ".tex")
png_full <- paste0("auto_figures_png/", file_name, ".png")

library(tidyverse)

### create plot 

x <- seq(-4, 4, length = 50)
y <- dlogis(x)
p <- qplot(x, y, geom = "line", xlab = "x", ylab = "f(x)") + theme_bw()


### save plot in png and tikz

ggsave(filename = png_full, device = "png", dpi = 200)

tikz(standAlone = TRUE, file = tikz_full)
print(p)
dev.off()




