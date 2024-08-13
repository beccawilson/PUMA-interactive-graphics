#clear environment
rm(list=ls())
# Load libraries
library(readxl)
library(tidyr)
library(visNetwork)

##############
#nodes 
# Read in data
nodes <- read_excel("finaldata2.xlsx", sheet="nodes")
nodes$id <- 1:248

##############
#edge
# Read in edge data
edges <- read_excel("finaldata2.xlsx", sheet="edges")

# Split each study into a separate row
edges_separate <- tidyr::separate_rows(edges, Tags, sep="\\; ")

# Rename columns
colnames(edges_separate) <- c("from", "to")

# Remove the "Study: "
edges_separate$to <- gsub("Study: ", "", edges_separate$to)

# Remove NA values
edges_no_na <- na.omit(edges_separate)

# Create edge data frame and assign IDs
edges_id <- merge(edges_no_na, nodes, by.x = "from", by.y = "Name", all.x = TRUE)
edges_id2 <- merge(edges_id, nodes, by.x = "to", by.y = "Name", all.x = TRUE)
final_edges <- edges_id2[, c("id.x", "id.y")]
colnames(final_edges) <- c("from", "to")

###############
#node properties
nodes$color <- ifelse(nodes$Type == 1, "#92B2BD", "#C9002F")
nodes$shape <- ifelse(nodes$Type == 1, "dot", "square")
nodes$group <- ifelse(nodes$Type == 1, "Publication", "Study")
nodes$title <- nodes$Name
nodes$label <- ""

#edge properties
final_edges$color <- "#BFBFBF"

##########
#network plot
visNetwork(nodes, final_edges) %>%
  visNodes(shape = ~shape, color = ~color, title = ~title, label = ~label) %>%
  visGroups(groupname = "Publication", shape = "dot", color = "#92B2BD") %>%
  visGroups(groupname = "Study", shape = "square", color = "#C9002F") %>%
  visOptions(highlightNearest = list(enabled = TRUE, degree = 1, hover = TRUE)) %>%
  visLegend(width = 0.2, position = "left")
