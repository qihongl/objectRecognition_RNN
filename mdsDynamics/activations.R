rm(list = ls())
setwd('/Users/Qihong/Dropbox/github/categorization_PDP/stateSpaceDyn')
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

# -----------------------------------------------------------------------------

tmp <- read.table("dev.acts", header = FALSE, stringsAsFactors = FALSE)
head(tmp)

# number of possible questions that you can ask to the model
numQs = 32
numObj = 8
dim(tmp)
dim(tmp)[1]/numQs  # num time points

rum_dev <- as.matrix(tmp[, 4:11])

distMat_t0 <- as.matrix(dist(rum_dev[1:8, ]))
image(distMat_t0[8:1, ], zlim = c(0, 1.75), col = cm.colors(10))

time_point_rows <- function(time_point = 0) {
    time_point * 32 + 1:8
}


distMat_t4 <- as.matrix(dist(rum_dev[time_point_rows(4), ]))
image(distMat_t4[8:1, ], zlim = c(0, 1.75), col = cm.colors(10))

distMat_t29 <- as.matrix(dist(rum_dev[time_point_rows(29), ]))
image(distMat_t29[8:1, ], zlim = c(0, 1.75), col = cm.colors(10))

plot(hclust(as.dist(distMat_t0)), labels = patnames)
plot(hclust(as.dist(distMat_t4)), labels = patnames)
plot(hclust(as.dist(distMat_t29)), labels = patnames)

plot(cmdscale(as.dist(distMat_t0)), ylim = c(-1,1), xlim = c(-1, 1))
plot(cmdscale(as.dist(distMat_t4)), ylim = c(-1,1), xlim = c(-1, 1))
plot(cmdscale(as.dist(distMat_t29)), ylim = c(-1,1), xlim = c(-1, 1))
# problem: no reason the cmdscale solutions retain stable axes across time pts

all_scales <- cmdscale(dist(rum_dev))

plot(0, 0, type = "n", ylim = range(all_scales), xlim = range(all_scales))
lines(all_scales[0:29 * 32 + 1, ]) # first item at each of the snapshots in time

for (item_num in 2:8) lines(all_scales[0:29 * 32 + item_num, ])

plot(0, 0, type = "n", ylim = range(all_scales), xlim = range(all_scales))
for (item_num in 1:8) {
    lines(all_scales[1:29 * 32 + item_num, ])
    points(all_scales[1:29 * 32 + item_num, ])
}

points(all_scales[1:8, ], pch = 17)
text(all_scales[29 * 32 + 1:8, ], labels = patnames)
