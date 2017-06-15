function (m, dat = hrarr, units = c(1:2),items = c(1:60), y=c(rep(1, times = 30), rep(0, times = 60))) 
{
#For simulation of ECog decoding
#m = fitted binnomial model, 
#dat = 3d array of hidden units values with d1 = item, d2=units, d3=time
#units = the set of units used in m, items=the set of items to test
#y = vector of true labels used to compute accuracy
#returns mean accuracy (HR-FAR) of m classifying items according to y labels at each time point
    nitems <- length(items)
    nu <- length(units)
    nt <- dim(hrarr)[3]
    out <- rep(0, times = nt)
    newx <- as.data.frame(matrix(0, nitems, nu + 1))
    newx <- newx[, 2:(nu + 1)]
	dat <- dat[items,,]
	y <- y[items]
    for (i1 in c(1:nt)) {
        newx[, 1:nu] <- dat[, units, i1]
        ptmp <- predict(m, newdata = newx)
        out[i1] <- sum(as.numeric(ptmp[y==1] > 0))/sum(y) - sum((as.numeric(ptmp[y==0] > 
            0))/sum(1-y))
    }
    out
}
