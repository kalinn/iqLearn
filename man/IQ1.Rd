\name{IQ1}
\alias{IQ1}
\title{
IQ-learning: Recommend stage 1 treatment
}
\description{
Recommends the IQ-estimated optimal first-stage treatment for a patient
with observed stage 1 variables.
}
\usage{
IQ1(mainObj, cmObj, sigObj, dens, h1main, h1cm, h1sig)
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
method of density estimation, either "norm" for normal location-scale
density estimate or "nonpar" for the empiricial density estimator
}
  \item{h1main }{
vector of observed first-stage main effects corresponding to the
variables in \code{H1Main} used in \code{learnIQ1main()}
}
  \item{h1cm }{
vector of observed first-stage main effects corresponding to the
variables in \code{H1CMean} used in \code{learnIQ1cm()}
}
  \item{h1sig }{
vector of observed first-stage main effects corresponding to the
variables in \code{H1CVar} used in \code{learnIQ1var()}
}
}
\details{
Use the estimated optimal first-stage decision rule from
\code{learnIQ1()} to recommend the best stage 1 treatment for a
patient presenting with history \code{h1}. It is \bold{essential}
that \code{h1main} include the \bold{same variables and ordering} as
\code{H1Main}. If a formula was used to fit \code{learnIQ1main()}, we
recommend checking \code{summary(<learnIQ1main object>)} for the correct order
of \code{h2}. Similarly for \code{h1cm} and \code{h1sig}. \code{dens}
can be chosen by looking at a normal QQ-plot of the standardized residuals from the contrast mean and variance modeling steps.
}
\value{
  \item{q1Pos }{estimated value of the first-stage Q-function when
  \eqn{H1}=\eqn{h1} and \eqn{A1}=1}
  \item{q1Neg }{estimated value of the first-stage Q-function when
  \eqn{H1}=\eqn{h1} and \eqn{A1}=-1}
  \item{q1opt }{estimated optimal first-stage treatment for a patient
  presenting with \eqn{h1}}
}
\references{
Laber, E.B., Linn, K.A., and Stefanski, L.A. (2013). Interactive
Q-learning. \emph{Submitted}.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{learnIQ1main}}, \code{\link{learnIQ1cm}}, \code{\link{learnIQ1var}},
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
summary (fitIQ2)
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
## new patient
h1 = c (1, 1, 30, 35)
optIQ1 = IQ1 (fitIQ1main, fitIQ1cm, fitIQ1var, "nonpar", h1, h1, h1) 
optIQ1$q1opt
}