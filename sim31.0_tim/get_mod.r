function (t, m = hrarr, units=c(1:2), noise = 0.01, items = c(1:60), y=c(rep(1, times = 30), rep(0, times = 60))) 
{
#t = time point to fit model
#m = model hidden unit array with d1=item, d2=units, d3=time
#units = subset of units to use in model
#noise = amount of noise added to unit activations
#items = items used to fit model
#y = item labels
#returns a binomial glm that classifies items from specified unit activations at time t according to y labels
	nu <- length(units)
	nitems <- length(items)
	nd <- m[items,units,t] + matrix(runif(nitems * nu), nitems, nu) * noise
    d <- as.data.frame(cbind(y[items], nd))
    glm(formula(d), data = d, family = "binomial")
}
