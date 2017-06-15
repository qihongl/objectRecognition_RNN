function (t, m = hrarr, units=c(1:2), noise = 0.01, items = c(1:60), y=c(rep(1, times = 30), rep(0, times=60)))
{
#t = time
#m = 3d array of hidden units values with d1 = item, d2=units, d3=time
#units = the set of units used to fite model
#noise = amount of noise added to unit activations
#items = items used to fit model
#y = vector of true labels used to compute accuracy
#conducts nfold cross-validation to assess classification accuracy (HR-FAR) at time t

	nu <- length(units)
	nitems <- length(items)
	out <- rep(0,times = nitems)
    m <- m[items,,]
	y <- y[items]
	for(i1 in c(1:nitems)){
		items <- c(1:nitems)[c(1:nitems)!=i1] #take out test item
		nd <- m[,units,t] + matrix(runif(nitems * nu), nitems, nu) * noise
		d <- as.data.frame(cbind(y, nd))
		mod <- glm(formula(d), data = d[items,], family = "binomial")
        p <- predict(mod, newdat = d[i1,2:(nu+1)])
		out[i1] <- as.numeric(p>0)
		}
	sum(out[y==1])/sum(y) - sum(out[y==0])/sum(1-y)
}
