library(tidyverse)
library(ggthemes)

theme_default = theme_light() +
    theme(text = element_text(size=9, color="black", face="plain"),
          axis.text = element_text(size=7, color="black", face="plain"),
          axis.text.x = element_text(margin=margin(0,0,0,0,"pt")),
          axis.text.y = element_text(margin=margin(0,0.5,0,0,"pt")),
          plot.title = element_text(size=9, color="black", face="plain", margin=margin(0,0,1,0,"pt")))

wildtype_color = ptol_pal()(2)[1]
