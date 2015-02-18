\name{plot.qLearnS2}
\alias{plot.qLearnS2}
\title{
Residual plots for the second-stage regression
}
\description{
Displays common residual plots that can be used to diagnose model fit
for the second-stage regression model.
}
\usage{
\method{plot}{qLearnS2}(x, ...)
}
\arguments{
  \item{x }{
object of type \code{qLearnS2}
}
  \item{... }{
other arguments to be passed to \code{plot()}
}
}
\value{
None.
}
\references{
Laber, E.B., Linn, K.A., and Stefanski, L.A. (2013). Interactive
Q-learning. \emph{Submitted}.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{qLearnS2}}
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
plot (fitQ2)
}