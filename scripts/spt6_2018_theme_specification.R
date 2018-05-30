library(tidyverse)
library(forcats)
library(magrittr)
library(ggthemes)
library(viridis)
library(grid)
library(gridExtra)

theme_default = theme_light() +
    theme(text = element_text(size=9, color="black", face="plain"),
          axis.text = element_text(size=7, color="black", face="plain"),
          axis.text.x = element_text(margin=margin(1,0,0,0,"pt")),
          axis.text.y = element_text(margin=margin(0,0.5,0,0.5,"pt")),
          axis.title.x = element_text(size=7, margin=margin(1,0,0,0,"pt")),
          axis.title.y = element_text(size=7, margin=margin(0,1,0,0,"pt")),
          plot.title = element_text(size=9, color="black", face="plain", margin=margin(0,0,1,0,"pt")),
          plot.margin = margin(11/2, 11, 11/2, 11/2, "pt"),
          legend.title = element_blank(),
          legend.text = element_text(size=7),
          legend.justification = c(1,1),
          legend.key.height = unit(8, "pt"),
          legend.position = c(0.99, 0.99),
          legend.box.margin = margin(0,0,0,0,"pt"),
          legend.margin = margin(0,0,0,0,"pt"),
          strip.background = element_blank(),
          strip.text = element_blank())

theme_heatmap = theme_minimal() +
    theme(text = element_text(size=9, color="black", face="plain"),
          legend.position = "top",
          legend.justification = c(0.5, 0.5),
          legend.title = element_text(size=9, margin=margin(0,0,0,0,"pt")),
          legend.text = element_text(size=7, margin=margin(0,0,0,0,"pt")),
          legend.margin = margin(0,0,1,0,"pt"),
          legend.box.margin = margin(0,0,0,0,"pt"),
          legend.box.spacing = unit(0, "pt"),
          strip.text = element_blank(),
          strip.background = element_blank(),
          axis.text.x = element_text(size=7, color="black", margin=margin(t=0.5)),
          axis.text.y = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_text(size=7, margin=margin(r=0)),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.ticks.x = element_line(color="black"),
          axis.ticks.length = unit(0.5, "pt"),
          plot.margin = margin(0,0,0,0,"pt"))

add_label = function(grob, letter){
    return(arrangeGrob(grob,
                       top=textGrob(letter,
                                    x=unit(0, "npc"),
                                    y=unit(0, "npc"),
                                    just = c("left", "top"))))
}

wildtype_color = ptol_pal()(2)[1]
