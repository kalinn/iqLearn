\name{learnIQ2}
\alias{learnIQ2}
\alias{iqQ2Est}
\alias{learnIQ2.default}
\alias{learnIQ2.formula}
\title{
IQ-learning: second-stage regression
}
\description{
Fits a linear regression of the response on second-stage history and
treatment to estimate the optimal second-stage decision rule.
}
\usage{
learnIQ2(H2, ...)

\method{learnIQ2}{formula}(formula, data, treatName, intNames, ...)
\method{learnIQ2}{default}(H2, Y, A2, s2ints, ...)
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
indices pointing to columns of H2 that should be included as treatment
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
\eqn{H2}. For an object of type \code{learnIQ2},
\code{summary(object)} and \code{plot(object)} can be used for
evaluating model fit. 
}
\value{
  \item{betaHat20 }{estimated main effect coefficients; first is the
  intercept} 
  \item{betaHat21 }{estimated treatment interaction coefficients;
  first is the main effect of the second-stage treatment}
  \item{s2Fit }{\code{lm()} object of the second-stage regression fit} 
  \item{optA2 }{vector of estimated optimal second-stage treatments
  for the patients in the training data}
  \item{main }{estimated main effect vector,
  \eqn{H20^T}\eqn{\hat{\beta20}}}
  \item{contrast }{estimated contrast function vector,
  \eqn{H21^T}\eqn{\hat{\beta21}}} 
  \item{s2ints }{indicies of variables in H2 included as treatment
  interactions in the model; same as input \code{s2ints}}
  \item{A2 }{vector of second-stage randomized treatments; same as
  input \code{A2}}
}
\references{
Laber, E.B., Linn, K.A., and Stefanski, L.A. (2013). Interactive
Q-learning. \emph{Submitted}.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{summary.learnIQ2}}, \code{\link{plot.learnIQ2}}
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
fitIQ2 = learnIQ2 (s2vars, y, a2, s2ints)
fitIQ2 = learnIQ2 (y ~ gender + parent_BMI + month4_BMI +
  A2*(parent_BMI + month4_BMI), data=bmiData, "A2", c("parent_BMI",
                                  "month4_BMI"))
                                   
summary (fitIQ2)
plot (fitIQ2)
}
