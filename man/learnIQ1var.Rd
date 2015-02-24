\name{learnIQ1var}
\alias{learnIQ1var}
\alias{iqQ1varEst}
\alias{learnIQ1var.default}
\alias{learnIQ1var.formula}
\title{
IQ-learning: contrast variance modeling
}
\description{
Estimates the variance function of the contrast function by fitting a
constant variance function or a log linear model to the residuals of
the contrast mean fit.
}
\usage{
learnIQ1var(object, ...)

\method{learnIQ1var}{formula}(formula, data, treatName, intNames,
method, cmObject, ...)
\method{learnIQ1var}{default}(object, H1CVar, s1sInts, method, ...)
}
\arguments{
  \item{formula }{
right-hand side formula containing the linear model to be used for the
log-transformed, squared residuals from the contrast function mean fit
}
  \item{data }{
data frame containing variables used in \code{formula}
}
  \item{treatName }{
character string indicating the stage 1 treatment name
}
  \item{intNames }{
vector of characters indicating the names of the variables that
interact with the stage 1 treatment in the contrast function variance
model
}
  \item{method }{
either "homo" for a constant variance function or "hetero" for a
log-linear variance function; default method is "homo"
}
  \item{cmObject }{
object of type \code{learnIQ1cm}
}
  \item{object }{
object of type \code{learnIQ1cm}
}
  \item{H1CVar }{
matrix or data frame of first-stage covariates to include as main
effects in the log-linear model; default is \code{NULL} for a constant
variance fit
}
  \item{s1sInts }{
indices pointing to columns of H1CVar that should be included as
treatment interaction effects in the log-linear model; default is \code{NULL}
}
  \item{\dots }{
additional arguments to be passed to \code{lm()} when fitting the
hetero log-linear model
}
}
\details{
If \code{method="homo"}, computes the variance of the residuals from
the contrast function mean fit. If \code{method="hetero"}, fits a
model of the form 
\deqn{E (\log e^2 | H_1, A_1) = H_{10}^{T}\gamma_0 + A_{1}H_{11}^{T}
\gamma_1,}{%
E (log e^2 | H1, A1) = H10^T\gamma0 + A1*H11^T\gamma1}
where \eqn{H10} and \eqn{H11} are summaries of
\eqn{H1}. Though a slight abuse of notation, these summaries are
not required to be the same as \eqn{H10} and \eqn{H11} in
the main effect term regression or the contrast mean fit. Also,
\eqn{e^2} = \eqn{H21^T}\eqn{\beta21} - \eqn{E(H21^T \beta21 | H1,
A1)}. For an object of type \code{learnIQ1var}, \code{summary(object)} and
\code{plot(object)} can be used for evaluating model fit. 
}
\value{
  \item{stdDev }{standard deviation of the residuals from the contrast
  function mean fit when \code{method="homo"}, otherwise \code{NULL}}
  \item{stdResids }{standardized residuals of the contrast function
  after mean and variance modeling, using either \code{method="homo"}
  or \code{"hetero"}}
  \item{gammaHat0 }{estiamted regression coefficients from the
  log-linear model main effects when \code{method="hetero"}, otherwise
  \code{NULL}}
  \item{gammaHat1 }{estimated regression coefficients from the
  log-linear model interaction effects when \code{method="hetero"},
  otherwise \code{NULL}}
  \item{s1VarFit }{\code{lm()} object from the log-linear model when
  \code{method="hetero"}, otherwise \code{NULL}}
  \item{homo }{logical variable indicating if \code{method="homo"} was
  used}
  \item{sigPos }{vector of predicted values when \eqn{A1}=1 for all
  patients}
  \item{sigNeg }{vector of predicted values when \eqn{A1}=-1 for
  all patients}
  \item{s1sInts }{indices of variables in \code{H1CVar} included as
  treatment interactions in the model; same as input \code{s1sInts}}
}
\references{
Linn, K. A., Laber, E. B., Stefanski, L. A. (2015) "iqLearn: Interactive Q-Learning in R", Journal of Statistical Software, 64(1), 1--25.

Laber, E. B., Linn, K. A., and Stefanski, L. A. (2014) "Interactive model building for Q-learning", Biometrika, 101(4), 831-847.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{learnIQ1cm}}, \code{\link{iqResids}}
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
fitIQ1var = learnIQ1var (fitIQ1cm) ## constant variance fit 
fitIQ1var = learnIQ1var (fitIQ1cm, s1vars, c (3, 4), method="hetero")
## non-constant variance fit
fitIQ1var = learnIQ1var (~ gender + race + parent_BMI + baseline_BMI +
	  A1*(parent_BMI), data=bmiData, "A1", c ("parent_BMI"),
	  "hetero", fitIQ1cm) 
## non-constant variance fit using formula specification  
}