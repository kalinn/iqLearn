\name{value}
\alias{value}
\alias{value.default}
\alias{valueEst}
\title{
Estimate plug-in value 
}
\description{
Estimate the plug-in value of the  any fixed treatment regime. 
}
\usage{
value(d1, d2, Y, A1, A2)
}
\arguments{
  \item{d1 }{
vector of first-stage treatments corresponding to the first-stage
decision rule of the proposed regime
}
  \item{d2 }{
vector of second-stage treatments corresponding to the second-stage
decision rule of the proposed regime
}
  \item{Y }{
vector of responses
}
  \item{A1 }{
vector of first-stage randomized treatments
}
  \item{A2 }{
vector of second-stage randomized treatments
}
}
\details{
The formula for the plug-in value estimate is

\deqn{\frac{\sum_i Y_i*ind1_i*ind1_i}{\sum_i ind1_i*ind2_i }}{%
(\sum_i Y_i*ind1_i*ind2_i)/(\sum_i ind1_i*ind2_i)}

where \eqn{ind1} and \eqn{ind2} are indicators that the first- and
second-stage randomized treatments were consistent with the regime of interest.
}
\value{
  \item{value }{
estimated plug-in value of the regime
}
  \item{valPosPos }{
estimated plug-in value of the regime that treats all patients with
\eqn{A1}=1 and \eqn{A2=1}
}
  \item{valPosNeg }{
estimated plug-in value of the regime that treats all patients with
\eqn{A1}=1 and \eqn{A2=-1}
}
  \item{valNegPos }{
estimated plug-in value of the regime that treats all patients with
\eqn{A1}=-1 and \eqn{A2}=1
}
  \item{valNegNeg }{
estimated plug-in value of the regime that treats all patients with
\eqn{A1}=-1 and \eqn{A2}=-1
}
}
\references{
Linn, K. A., Laber, E. B., Stefanski, L. A. (2015) "iqLearn: Interactive Q-Learning in R", Journal of Statistical Software, 64(1), 1--25.

Laber, E. B., Linn, K. A., and Stefanski, L. A. (2014) "Interactive model building for Q-learning", Biometrika, 101(4), 831-847.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{summary.value}} 
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
estVal
}