#reading the data
mydata<-read.csv("military_lottery.txt",header=TRUE, sep="")
attach(mydata)

#chart of Day of Year vs Draft by Month, with annotation arrow
library(ggplot2)
library(grid)
plot1<-ggplot(mydata, aes(x=Day_of_year, y=Draft_No., color=Month))
plot1+ geom_point (shape=1) +ggtitle("Scatterplot of the days of the year\n and their lottery(draft) number")
+ scale_x_continuous (name = "Day of the year (1-366)")
+ scale_y_continuous (name = "Draft Number (1-366)")
+ theme (plot.title=element_text(size=20,face="bold",vjust=2))
+ guides(colour=guide_legend(override.aes=list(size=2.5))) 
+ geom_segment(aes(x = 355, y = 380, xend = 345, yend = 345), colour="black", arrow = arrow(length = unit(0.5, "cm")))

#create a new column in order to plot the months chronoloically 
months<-factor(Month, levels=Month)

#boxplot of Day of Year vs Draft by Month    
plot2<-ggplot(mydata, aes(x=months, Draft_No.), y=Draft_No.) + geom_boxplot()
+ ggtitle("Boxplots of the months and their lottery(draft) number")
+ scale_x_discrete (name = "Month of year (Jan-Dec)")
+ scale_y_continuous (name = "Draft Number (1-366)")
+ theme (plot.title=element_text(size=15,face="bold",vjust=2))

## Non-parametric regression

# Local linear regression with 3 diffrerent spans
local_linear1<-loess(Draft_No. ~ Day_of_year, span=2/3, degree=1, data=mydata)
local_linear2<-loess(Draft_No. ~ Day_of_year, span=1/3, degree=1, data=mydata)
local_linear3<-loess(Draft_No. ~ Day_of_year, span=1/10, degree=1,data=mydata)
plot(Day_of_year, Draft_No., ylab="Draft Number", xlab="Day of the year", main="Local Linear Regression")
s <- c(2/3, 1/3, 1/10)
colors <- c("red", "green", "blue")
for (i in 1:length(s)) lines(Day_of_year, predict(loess(Draft_No. ~ Day_of_year, span=s[i], degree=1), data=mydata), col=colors[i])
legend("topright", c("span = 2/3", "span = 1/3", "span = 1/10"), lty=1, col=c("red", "green", "blue"))

 # Local quadratic regression with 3 different spans 
local_quad1<-loess(Draft_No. ~ Day_of_year, span=2/3, degree=2, data=mydata)
local_quad2<-loess(Draft_No. ~ Day_of_year, span=1/3, degree=2, data=mydata)
local_quad3<-loess(Draft_No. ~ Day_of_year, span=1/10, degree=2, data=mydata)
plot(Day_of_year, Draft_No., ylab="Draft Number", xlab="Day of the year", main="Local Quadratic Regression")
for (i in 1:length(s)) lines(Day_of_year, predict(loess(Draft_No. ~ Day_of_year, span=s[i], degree=2), data=mydata), col=colors[i])
legend("topright", c("span = 2/3", "span = 1/3", "span = 1/10"), lty=1, col=c("red", "green", "blue"))

## autoloess.R: compute loess metaparameters automatically
# by Kyle Gorman <gormanky@ohsu.edu>
aicc.loess <- function(fit) {
	stopifnot(inherits(fit, 'loess'))
	n <- local_quad1$n
	trace <-fit$trace.hat
	sigma2 <- sum(resid(fit) ^ 2) / (n - 1)
	return(log(sigma2) + 1 + 2 * (2 * (trace + 1)) / (n - trace - 2))
	}
autoloess <- function(fit, span=c(.1, .9)) {
	stopifnot(inherits(fit, 'loess'), length(span) == 2)
	 f <- function(span) aicc.loess(update(fit, span=span))
	 return(update(fit, span=optimize(f, span)$minimum))
	 }
	 
# Non- parametric regression based on AICc
basic<-loess(Draft_No. ~ Day_of_year)
loess3 <- autoloess(basic)
plot(Day_of_year, Draft_No., xlab= "Day of the year", ylab="Draft Number", main="Non parametric regression based on AICc")
lines(Day_of_year, loess3$fit, col=35)

# Confidence bands
predict1<-predict(loess3 , se=T)
plot(Day_of_year, Draft_No., xlab="Day of the year ", ylab="Draft Number", main="Scatterplot of the days of the year and their lottery(draft) number\n with non-parametric regression and confidence band")
lines(Day_of_year,predict1$fit, col=35)
lines(Day_of_year,predict1$fit-qt(0.975,predict1$df)*predict1$se, lty=2, col="red")
lines(Day_of_year,predict1$fit+qt(0.975,predict1$df)*predict1$se, lty=2, col="red")

dettach(mydata)