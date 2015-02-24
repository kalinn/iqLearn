\name{qLearnS2}
\alias{qLearnS2}
\alias{qLearnS2Est}
\alias{qLearnS2.default}
\alias{qLearnS2.formula}
\title{
Q-learning: second-stage regression
}
\description{
Same as \code{learnIQ2}. Estimates the optimal second-stage decision
rule using a linear regression of the response on second-stage history
and treatment.
}
\usage{
qLearnS2(H2, ...)

\method{qLearnS2}{formula}(formula, data, treatName, intNames, ...)
\method{qLearnS2}{default}(H2, Y, A2, s2ints, ...)
}
\arguments{
  \item{formula }{
stage 2 regression formula
}
  \item{data }{
data frame containing variables used in \code{formula}
}
  \item{treatName }{
character string indicating the stage 2 treatment name
}
  \item{intNames }{
vector of characters indicating the names of the variables that
interact with the stage 2 treatment in the regression model
}
  \item{H2 }{
matrix or data frame of second-stage covariates to include as main
effects in the linear model 
}
  \item{Y }{
response vector
}
  \item{A2 }{
vector of second-stage randomized treatments
}
  \item{s2ints }{
indices pointing to columns of \code{H2} that should be included as treatment
interaction effects in the linear model
}
  \item{\dots }{
other arguments to be passed to \code{lm()}
}
}
\details{
Fits a model of the form 
\deqn{E (Y | H_2, A_2) = H_{20}^{T}\beta_{20} +
A_{2}H_{21}^{T}\beta_{21},}{%
E (Y | H2, A2) = H20^T\beta20 + A2*H21^T\beta21,}
where \eqn{H20} and \eqn{H21} are summaries of
\eqn{H2}. For an object of type \code{qLearnS2},
\code{summary(object)} and \code{plot(object)} can be used for
evaluating model fit. 
}
\value{
  \item{betaHat20 }{
estimated main effect coefficients; first is the intercept
} 
  \item{betaHat21 }{
estimated treatment interaction coefficients; first is the main effect of the second-stage treatment
}
  \item{Ytilde }{
Q2 function maximized over treatment \eqn{a2}; the predicted future
outcome assuming optimal treatment is given at the second stage to be
used in the next step of the Q-learning algorithm 
}
  \item{optA2 }{
vector of estimated optimal second-stage treatments for the patients
in the training data
}
  \item{s2Fit }{
\code{lm()} object of the second-stage regression fit
} 
  \item{s2ints }{
indicies of variables in \code{H2} included as treatment interactions in the
model; same as input \code{s2ints}
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
\code{\link{summary.qLearnS2}}, \code{\link{plot.qLearnS2}}
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
fitQ2 = qLearnS2 (s2vars, y, a2, s2ints)
fitQ2 = qLearnS2 (y ~ gender + parent_BMI + month4_BMI +
  A2*(parent_BMI + month4_BMI), data=bmiData, "A2", c("parent_BMI",
                                  "month4_BMI"))
                                   
summary (fitQ2)
plot (fitQ2)
}
