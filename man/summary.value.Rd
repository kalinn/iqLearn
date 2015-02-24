\name{summary.value}
\alias{summary.value}
\alias{print.summary.value}
\title{
Estimate plug-in value
}
\description{
Output plug-in value estimates of treatment regimes based on the
estimated IQ-learning parameters.
}
\usage{
\method{summary}{value}(object, ...)
}
\arguments{
  \item{object }{
object of type \code{value}
}
  \item{... }{
other arguments to be passed to \code{summary()}
}
}
\details{
Can be used to print out the estimated plug-in values of non-dynamic
regimes and any proposed regime, possibly estimated from IQ- or Q-learning.
}
\value{
None.
}
\references{
Linn, K. A., Laber, E. B., Stefanski, L. A. (2015) "iqLearn: Interactive Q-Learning in R", Journal of Statistical Software, 64(1), 1--25.

Laber, E. B., Linn, K. A., and Stefanski, L. A. (2014) "Interactive model building for Q-learning", Biometrika, 101(4), 831-847.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{learnIQ2}}, \code{\link{learnIQ1}} 
}
\examples{
## load in two-stage BMI data
data (bmiData)
bmiData$A1[which (bmiData$A1=="MR")] = 1
bmiData$A1[which (bmiData$A1=="CD")] = -1
bmiData$A2[which (bmiData$A2=="MR")] = 1
bmiData$A2[which (bmiData$A2=="CD")] = -1
bmiData$A1 = as.numeric (bmiData$A1)
bmiData$A2 = as.numeric (bmiData$A2)
s1vars = bmiData[,1:4]
s2vars = bmiData[,c (1, 3, 5)]
a1 = bmiData[,7]
a2 = bmiData[,8]
## define response y to be the negative 12 month change in BMI from
## baseline 
y = -(bmiData[,6] - bmiData[,4])/bmiData[,4]
## second-stage regression
fitIQ2 = learnIQ2 (y ~ gender + parent_BMI + month4_BMI +
  A2*(parent_BMI + month4_BMI), data=bmiData, "A2", c("parent_BMI",
                                  "month4_BMI"))
## model conditional expected value of main effect term
fitIQ1main = learnIQ1main (~ gender + race + parent_BMI + baseline_BMI
  + A1*(gender + parent_BMI), data=bmiData, "A1", c ("gender",
                                "parent_BMI"), fitIQ2)
## model conditional mean of contrast function
fitIQ1cm = learnIQ1cm (~ gender + race + parent_BMI + baseline_BMI +
  A1*(gender + parent_BMI + baseline_BMI), data=bmiData, "A1", c
  ("gender", "parent_BMI", "baseline_BMI"), fitIQ2)
## variance modeling
fitIQ1var = learnIQ1var (~ gender + race + parent_BMI + baseline_BMI +
  A1*(parent_BMI), data=bmiData, "A1", c ("parent_BMI"), "hetero",
  fitIQ1cm)
## get optimal first-stage txts
fitIQLearn = learnIQ1 (fitIQ1main, fitIQ1cm, fitIQ1var, "nonpar")
estVal = value (fitIQLearn$optA1, fitIQ2$optA2, y, a1, a2)
summary (estVal)
}