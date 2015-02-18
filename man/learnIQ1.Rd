\name{learnIQ1}
\alias{learnIQ1}
\alias{learnIQ1Est}
\alias{learnIQ1.default}
\title{
IQ-learning: estimate optimal first-stage rule
}
\description{
Estimates the optimal first-stage decision rule using IQ-learning.
}
\usage{
learnIQ1(mainObj, cmObj, sigObj, dens)
}
\arguments{
  \item{mainObj }{
object of type \code{learnIQ1main}
}
  \item{cmObj }{
object of type \code{learnIQ1cm}
}
  \item{sigObj }{
object of type \code{learnIQ1var}
}
  \item{dens }{
either "norm" or "nonpar"; density estimator to use for the
conditional density of the contrast function
}
}
\details{
If \code{dens="norm"} the normal location-scale density estimator is
used, otherwise when \code{dens="nonpar"} the empirical density
estimator is used.
}
\value{
  \item{optA1 }{vector of estimated optimal first-stage treatment for
  the patients in the training data}
}
\references{
Laber, E.B., Linn, K.A., and Stefanski, L.A. (2013). Interactive
Q-learning. \emph{Submitted}.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{learnIQ1main}}, \code{\link{learnIQ1cm}}, \code{\link{learnIQ1var}}
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
s2ints = c (2, 3)
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
}