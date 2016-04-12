rm(list = ls())


setwd('/Users/Qihong/Dropbox/github/categorization_PDP/mdsDynamics')
# read the data
tmp <- read.table("learned-item.acts", header = FALSE, stringsAsFactors = FALSE)
tmp <- tmp[1:8, ]

patnames <- tmp[, 2]
patnames # print pattern name

rum_items <- as.matrix(tmp[, 4:11])  # Rumelhart items
row.names(rum_items) <- patnames

rum_dist <- as.matrix(dist(rum_items))

image(rum_dist[8:1, ], zlim = c(1,2), col = heat.colors(10))
# reverse the order of the rows so that the diagonal goes from the upper
# left to the lower right (instead of reflected)

lower.tri(rum_dist)
unique_dists <- rum_dist[lower.tri(rum_dist)]
# figure out the range of distances
range(unique_dists)
image(rum_dist[8:1, ], zlim = range(unique_dists), col = heat.colors(10))