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
          plot.margin = margin(11/2, 11, 11/2, 0, "pt"),
          legend.title = element_blank(),
          legend.text = element_text(size=7),
          legend.justification = c(1,1),
          legend.key.height = unit(10, "pt"),
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
          legend.text = element_text(size=7, margin=margin(-40,0,0,0,"pt"), vjust=1),
          # legend.margin = margin(0,0,2,0,"pt"),
          legend.margin = margin(0,0,5,0,"pt"),
          legend.box.margin = margin(0,0,0,0,"pt"),
          legend.box.spacing = unit(0, "pt"),
          strip.text = element_blank(),
          strip.background = element_blank(),
          axis.text.x = element_text(size=7, color="black", margin=margin(t=1, unit="pt")),
          axis.text.y = element_blank(),
          axis.title.x = element_blank(),
          axis.title.y = element_text(size=9, margin=margin(r=0)),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          axis.ticks.x = element_line(color="black"),
          axis.ticks.length = unit(0.5, "pt"),
          # plot.margin = margin(0,4,-8,0,"pt"))
          plot.margin = margin(0,4,-6,0,"pt"))

add_label = function(grob, letter, x_pos=0, y_pos=0){
    return(arrangeGrob(grob,
                       top=textGrob(letter,
                                    x=unit(x_pos, "npc"),
                                    y=unit(y_pos, "npc"),
                                    just = c("left", "top"))))
}

wildtype_color = ptol_pal()(2)[1]

coolwarm = c("#3B4CC0","#3D50C3","#4054C7","#4359CA","#465DCE","#4961D1","#4B66D5","#4E6AD8","#526EDB","#5572DE","#5877E1","#5C7BE4","#5F7FE7","#6383EA","#6687ED","#6A8BEF","#6D8FF1","#7192F2","#7496F4","#789AF6","#7B9EF7","#7FA2F9","#82A5FA","#86A8FB","#89ACFB","#8DAFFC","#90B2FD","#94B5FE","#97B9FE","#9BBBFE","#9FBEFE","#A2C0FD","#A6C2FC","#A9C5FC","#ADC7FB","#B0CAFB","#B4CCF9","#B7CDF8","#BACFF6","#BDD1F4","#C1D2F3","#C4D4F1","#C7D6EF","#CAD7ED","#CDD8EB","#D0D9E8","#D3DAE5","#D5DAE3","#D8DBE0","#DBDCDE","#DEDCDB","#E0DAD7","#E2D8D3","#E4D7CF","#E7D5CB","#E9D3C7","#EBD1C3","#EDCFBF","#EECDBB","#F0CAB7","#F1C7B3","#F2C5AF","#F3C2AB","#F5BFA7","#F6BCA3","#F6B99F","#F6B69B","#F6B397","#F6AF93","#F6AC8F","#F6A98A","#F6A586","#F5A183","#F49D7F","#F3997B","#F29677","#F19273","#F08E6F","#EF896C","#ED8568","#EB8064","#E97B61","#E7765D","#E57159","#E36D56","#E16852","#DE624E","#DB5D4B","#D85847","#D55244","#D24D40","#CF473D","#CC4239","#C93936","#C53034","#C22731","#BE1E2E","#BB152B","#B70C28","#B40426")

