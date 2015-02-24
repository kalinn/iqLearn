\name{learnIQ1cm}
\alias{learnIQ1cm}
\alias{iqQ1cmEst}
\alias{learnIQ1cm.formula}
\alias{learnIQ1cm.default}
\title{
IQ-learning: contrast function mean regression
}
\description{
Estimates the mean of the contrast function by fitting a linear regression of the estimated contrast function term on
first-stage history and treatment.
}
\usage{
learnIQ1cm(object, ...)

\method{learnIQ1cm}{formula}(formula, data, treatName, intNames, s2object, ...)
\method{learnIQ1cm}{default}(object, H1CMean, A1, s1cmInts, ...)
}
\arguments{
  \item{formula }{
formula for the contrast function mean regression
}
  \item{data }{
data frame containing variables used in \code{formula}
}
  \item{treatName }{
character string indicating the stage 1 treatment name
}
  \item{intNames }{
vector of characters indicating the names of the variables that
interact with the stage 1 treatment in the contrast function mean
regression model
}
  \item{s2object }{
object of type \code{learnIQ2}
}
  \item{object }{
object of type \code{learnIQ2}
}
  \item{H1CMean }{
matrix or data frame of first-stage covariates to include as main
effects in the linear model 
}
  \item{A1 }{
vector of first-stage randomized treatments
}
  \item{s1cmInts }{
indices pointing to columns of H1CMean that should be included as
treatment interaction effects in the linear model 
}
  \item{\dots }{
other arguments to be passed to \code{lm()}
}
}
\details{
Fits a model of the form 
\deqn{E (H_{21}^{T}\beta_{21} | H_1, A_1) = H_{10}^{T}\beta_{10} +
A_{1}H_{11}^{T}\beta_{11},}{%
E (H21^T\beta21 | H1, A1) = H11^T\beta10 + A1*H11^T\beta11,}
where \eqn{H10} and \eqn{H11} are summaries of
\eqn{H1}. Though a slight abuse of notation, these summaries are
not required to be the same as \eqn{H10} and \eqn{H11} in
the main effect term regression or the variance model. For an object of type \code{learnIQ1cm},
\code{summary(object)} and \code{plot(object)} can be used for
evaluating model fit. 
}
\value{
  \item{betaHat10 }{estimated main effect coefficients; first is the intercept} 
  \item{betaHat11 }{estimated treatment interaction coefficients;
  first is the main effect of the first-stage treatment}
  \item{s1cmFit }{\code{lm()} object of the contrast mean
  regression fit}  
  \item{cmeanResids }{residuals from the regression}
  \item{cmPos }{vector of predicted values with \eqn{A1}=1 for
  all patients}
  \item{cmNeg }{vector of predicted values with \eqn{A1}=1 for
  all patients}
  \item{s1cmInts }{indicies of variables in H1CMean included as
  treatment  
  interactions in the model; same as input \code{s1cmInts}}
  \item{A1 }{vector of first-stage randomized treatments; same as
  input \code{A1}}
}
\references{
Linn, K. A., Laber, E. B., Stefanski, L. A. (2015) "iqLearn: Interactive Q-Learning in R", Journal of Statistical Software, 64(1), 1--25.

Laber, E. B., Linn, K. A., and Stefanski, L. A. (2014) "Interactive model building for Q-learning", Biometrika, 101(4), 831-847.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{learnIQ2}}, \code{\link{summary.learnIQ1cm}},
\code{\link{plot.learnIQ1cm}} 
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
fitIQ1cm = learnIQ1cm (~ gender + race + parent_BMI + baseline_BMI +
	 A1*(gender + parent_BMI + baseline_BMI), data=bmiData, "A1",
	 c ("gender", "parent_BMI", "baseline_BMI"), fitIQ2) 
summary (fitIQ1cm)
plot (fitIQ1cm)
}