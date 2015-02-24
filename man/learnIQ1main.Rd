\name{learnIQ1main}
\alias{learnIQ1main}
\alias{iqQ1MainEst}
\alias{learnIQ1main.default}
\alias{learnIQ1main.formula}
\title{
IQ-learning: main effect term regression
}
\description{
Fits a linear regression of the estimated main effect term on
first-stage history and treatment.
}
\usage{
learnIQ1main(object, ...)

\method{learnIQ1main}{formula}(formula, data, treatName, intNames, s2object, ...)
\method{learnIQ1main}{default}(object, H1Main, A1, s1mainInts, ...)
}
\arguments{
  \item{formula }{
formula for the main effect term regression
}
  \item{data }{
data frame containing variables used in \code{formula}
}
  \item{treatName }{
character string indicating the stage 1 treatment name
}
  \item{intNames }{
vector of characters indicating the names of the variables that
interact with the stage 1 treatment in the main effect term regression
model
}
  \item{s2object }{
object of type \code{learnIQ2}
}
  \item{object }{
object of type \code{learnIQ2}
}
  \item{H1Main }{
matrix or data frame of first-stage covariates to include as main
effects in the linear model 
}
  \item{A1 }{
vector of first-stage randomized treatments
}
  \item{s1mainInts }{
indices pointing to columns of H1Main that should be included as
treatment interaction effects in the linear model 
}
  \item{\dots }{
other arguments to be passed to \code{lm()}
}
}
\details{
Fits a model of the form 
\deqn{E (H_{20}^{T}\beta_{20} | H_1, A_1) = H_{10}^{T}\alpha_{0} +
A_{1}H_{11}^{T}\alpha_{1},}{%
E (H20^T\beta20 | H1, A1) = H10^T\alpha0 +
A1*H11^T\alpha1,}
where \eqn{H10} and \eqn{H11} are summaries of
\eqn{H1}. For an object of type \code{learnIQ1main},
\code{summary(object)} and \code{plot(object)} can be used for
evaluating model fit. 
}
\value{
  \item{alphaHat0 }{estimated main effect coefficients; first is the
  intercept} 
  \item{alphaHat1 }{estimated treatment interaction coefficients;
  first is the main effect of the first-stage treatment}
  \item{s1MainFit }{\code{lm()} object of the main effect term
  regression fit}  
  \item{mainPos }{vector of predicted values with \eqn{A1}=1 for
  all patients}
  \item{mainNeg }{vector of predicted values with \eqn{A1}=-1 for
  all patients}
  \item{s1mainInts }{indicies of variables in H1Main included as
  treatment  
  interactions in the model; same as input \code{s1mainInts}}
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
\code{\link{learnIQ2}}, \code{\link{summary.learnIQ1main}},
\code{\link{plot.learnIQ1main}} 
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
fitIQ1main = learnIQ1main (fitIQ2, s1vars, a1, c (1, 3))
fitIQ1main = learnIQ1main (~ gender + race + parent_BMI + baseline_BMI
  + A1*(gender + parent_BMI), data=bmiData, "A1", c ("gender",
                                "parent_BMI"), fitIQ2)
summary (fitIQ1main)
plot (fitIQ1main)
}
