#clear environment
rm(list=ls())

#packages
#install.packages("packcircles")
library("packcircles")
#install.packages("ggplot2")
library("ggplot2")
library("stringr")

#data
data <-read.csv("bubbleplot_input.csv")

#text for data
data$text <- paste(data$Tag)

#generate layout, gives bubbles centre and radius (proportional to value)
packing <-circleProgressiveLayout(data$age_weighted_citations, sizetype='area')
packing$radius <- packing$radius/1.05

#add packing info to initial data fram
data<-cbind(data, packing)

#check radius proportional to value (not linear)
plot(data$radius, data$age_weighted_citations)

#gp from one centre +radius to coordinates
dat.gg <-circleLayoutVertices(packing, npoints=50)

#interactive packages
#install.packages("viridis")
library(viridis)
#install.packages("ggiraph")
library(ggiraph)

# Convert 'id' to a factor
dat.gg$id <- as.factor(dat.gg$id)

# Ensure that 'id' in 'dat.gg' is a factor so that 'scale_fill_manual' works correctly
num_colors <- length(unique(dat.gg$id)) # Number of unique groups
orange_palette <- colorRampPalette(c("#FFE6D7", "#E97132", "#C9002F"))  # Light to dark orange
custom_orange_colors <- orange_palette(num_colors)

# Wrap the text based on the proportional width
data$wrapped_Tag <- mapply(str_wrap, data$Tag, data$radius)
data$dynamic_text_size <- data$radius *10

# Create the interactive plot
interactive <- ggplot() + 
  geom_polygon_interactive(data = dat.gg, aes(x, y, group = id, fill = id, tooltip = data$text[as.numeric(id)], data_id = id), colour = "black", alpha = 0.6) +
  scale_fill_manual(values = custom_orange_colors) +
  #geom_text(data=data, aes(x,y, label=wrapped_Tag, size = age_weighted_citations*5)) +
  theme_void() + 
  theme(legend.position = "none", plot.margin = unit(c(0, 0, 0, 0), "cm")) + 
  coord_equal()

# Turn it interactive with adjusted zoom
#widg <- girafe(ggobj = interactive, width_svg = 5, height_svg = 5, sizingPolicy(defaultWidth = "100%")) 
widg <- girafe(ggobj = interactive, sizingPolicy(defaultHeight = "500px")) 

# Display the widget
widg


