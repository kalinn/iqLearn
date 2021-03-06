\name{summary.qLearnS1}
\alias{summary.qLearnS1}
\alias{print.summary.qLearnS1}
\title{
Q-learning: first-stage regression summary
}
\description{
Output from the first-stage regression in Q-learning.
}
\usage{
\method{summary}{qLearnS1}(object, ...)
}
\arguments{
  \item{object }{
object of type \code{qLearnS1}
}
  \item{... }{
additional arguments to be passed to \code{summary()}
}
}
\details{
Regression output and other summary statistics from the second-stage
regression. See \code{summary.lm} for more details.
}
\value{
Computes and returns multiple summary statistics from the linear model
in \code{object}. See \code{summary.lm} for a list of available
summary statistics.
}
\references{
Linn, K. A., Laber, E. B., Stefanski, L. A. (2015) "iqLearn: Interactive Q-Learning in R", Journal of Statistical Software, 64(1), 1--25.

Laber, E. B., Linn, K. A., and Stefanski, L. A. (2014) "Interactive model building for Q-learning", Biometrika, 101(4), 831-847.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{qLearnS1}}
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
fitQ2 = qLearnS2 (y ~ gender + parent_BMI + month4_BMI +
  A2*(parent_BMI + month4_BMI), data=bmiData, "A2", c("parent_BMI",
  "month4_BMI"))                                     
## first-stage regression                                   
fitQ1 = qLearnS1 (fitQ2, s1vars, a1, c(3,4))
fitQ1 = qLearnS1 (~ gender + race + parent_BMI + baseline_BMI +
  A1*(gender + parent_BMI), data=bmiData, "A1", c ("gender",
                              "parent_BMI"), fitQ2)
summary (fitQ1)
}