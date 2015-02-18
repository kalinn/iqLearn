\name{summary.learnIQ1main}
\alias{summary.learnIQ1main}
\alias{print.summary.learnIQ1main}
\title{
IQ-learning: main effect regression summary
}
\description{
Output from the main effect term regression in IQ-learning.
}
\usage{
\method{summary}{learnIQ1main}(object, ...)
}
\arguments{
  \item{object }{
object of type \code{learnIQ1main}
}
  \item{... }{
additional arguments to be passed to \code{summary()}
}
}
\details{
Regression output and other summary statistics from the main effect
term regression. See \code{summary.lm} for more details.
}
\value{
Computes and returns multiple summary statistics from the linear model
in \code{object}. See \code{summary.lm} for a list of available
summary statistics.
}
\references{
Laber, E.B., Linn, K.A., and Stefanski, L.A. (2013). Interactive
Q-learning. \emph{Submitted}.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{learnIQ1main}}
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
fitIQ2 = learnIQ2 (y ~ gender + parent_BMI + month4_BMI +
  A2*(parent_BMI + month4_BMI), data=bmiData, "A2", c("parent_BMI",
  "month4_BMI"))                                    
fitIQ1main = learnIQ1main (~ gender + race + parent_BMI + baseline_BMI
  + A1*(gender + parent_BMI), data=bmiData, "A1", c ("gender",
                                "parent_BMI"), fitIQ2)
summary (fitIQ1main)
}