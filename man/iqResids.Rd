\name{iqResids}
\alias{iqResids}
\alias{iqResids.default}
\title{
IQ-learning: standardized residuals
}
\description{
Creates an object containing the standardized residuals from the
contrast mean and variance modeling steps.
}
\usage{
iqResids(object)
}
\arguments{
  \item{object }{
object of type \code{learnIQ1var}
}
}
\details{
Creates an object containing the standardized residuals from the
contrast mean and variance modeling steps to be used with the plotting
function \code{plot.iqResids}. The choice of density estimator in the
next step of IQ-learning should be based on a QQ-plot of the
standardized residuals. 
}
\value{
Returns \code{object$stdResids} from an object of type
\code{learnIQ1var} in the form of an object of type \code{iqResids}.
}
\references{
Laber, E.B., Linn, K.A., and Stefanski, L.A. (2013). Interactive
Q-learning. \emph{Submitted}.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{learnIQ1var}}, \code{\link{plot.iqResids}} 
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
## model conditional mean of contrast function
fitIQ1cm = learnIQ1cm (~ gender + race + parent_BMI + baseline_BMI +
  A1*(gender + parent_BMI + baseline_BMI), data=bmiData, "A1", c
  ("gender", "parent_BMI", "baseline_BMI"), fitIQ2)
## variance modeling
fitIQ1var = learnIQ1var (~ gender + race + parent_BMI + baseline_BMI +
  A1*(parent_BMI), data=bmiData, "A1", c ("parent_BMI"), "hetero",
  fitIQ1cm)
## plot standardized residuals
fitResids = iqResids (fitIQ1var)
plot (fitResids)
}

                    