\name{qLearnS1}
\alias{qLearnS1}
\alias{qLearnS1Est}
\alias{qLearnS1.default}
\alias{qLearnS1.formula}
\title{
Q-learning: first-stage regression
}
\description{
Regresses the predicted future outcome maximized over \eqn{a2} on
first-stage history and treatment to estimate the optimal first-stage
decision rule using Q-learning.
}
\usage{
qLearnS1(object, ...)

\method{qLearnS1}{formula}(formula, data, treatName, intNames,
qS2object, ...)
\method{qLearnS1}{default}(object, H1q, A1, s1ints, ...)
}
\arguments{
  \item{formula }{
right-hand sided stage 1 regression formula
}
  \item{data }{
data frame containing variables used in \code{formula}
}
  \item{treatName }{
character string indicating the stage 1 treatment name
}
  \item{intNames }{
vector of characters indicating the names of the variables that
interact with the stage 1 treatment in the regression model
}
  \item{qS2object }{
object of type \code{qLearnS2}
}
  \item{object }{
object of type \code{qLearnS2}
}
  \item{H1q }{
matrix or data frame of first-stage covariates to include as main
effects in the linear model
}
  \item{A1 }{
vector of first-stage randomized treatments
}
  \item{s1ints }{
indices pointing to columns of H1q that should be included as
treatment interaction effects in the linear model
}
  \item{\dots }{
other arguments to be passed to \code{lm()}
}
}
\details{
Fits a model of the form 
\deqn{E (\tilde{Y} | H_1, A_1) = H_{10}^{T}\beta_{10} +
A_{1}H_{11}^{T}\beta_{11},}{%
E (Ytilde | H1, A1) = H10^T\beta10 + A1*H11^T\beta11,}
where \eqn{H10} and \eqn{H11} are summaries of
\eqn{H1}. For an object of type \code{qLearnS1},
\code{summary(object)} and \code{plot(object)} can be used for
evaluating model fit. 
}
\value{
  \item{betaHat10 }{estimated main effect coeffients, beginning with
  the intercept}
  \item{betaHat11 }{estimated treatment interaction coefficients,
  beginning with the main effect of treatment}
  \item{optA1 }{vector of estimated optimal first-stage treatments for
  the patients in the training data}
  \item{s1Fit }{\code{lm()} object of the first-stage regression fit} 
  \item{s1ints }{indices of variables in \code{H1q} included as treatment
  interactions in the model; same as input \code{s1ints}}
}
\references{
Laber, E.B., Linn, K.A., and Stefanski, L.A. (2013). Interactive
Q-learning. \emph{Submitted}.
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
## first-stage regression                                   
fitQ1 = qLearnS1 (fitQ2, s1vars, a1, c(3,4))
fitQ1 = qLearnS1 (~ gender + race + parent_BMI + baseline_BMI +
  A1*(gender + parent_BMI), data=bmiData, "A1", c ("gender",
                              "parent_BMI"), fitQ2)
}
