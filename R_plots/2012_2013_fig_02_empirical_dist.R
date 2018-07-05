file_name <- "2012_2013_fig_02_empirical_dist"

### setup

library(tikzDevice)
library(azbuka) # devtoools::install_github("bdemeshev/azbuka")
tikzsetup()

tikz_full <- paste0("auto_figures_tikz/", file_name, ".tex")
png_full <- paste0("auto_figures_png/", file_name, ".png")

library(tidyverse)

### create plot

df <- tibble(x = c(8, 5, 6, 7, 3, 9))
df <- df %>% arrange(x)
ecdfmass <- ecdf(df$x)
df <- df %>% mutate(y = ecdfmass(x), xend = c(tail(x, -1), Inf))


p <- ggplot(data = df) + geom_segment(aes(x = x, xend = xend, y = y, yend = y),
                arrow = arrow(ends = "last"))  + geom_point(aes(x = x, y = y)) + theme_bw()


### save plot in png and tikz

ggsave(filename = png_full, device = "png", dpi = 200)

tikz(standAlone = TRUE, file = tikz_full)
print(p)
dev.off()
