\name{qLearnQ1}
\alias{qLearnQ1}
\title{
Q-learning: Recommend stage 1 treatment
}
\description{
Recommends the Q-learning estimated optimal first-stage treatment for
a given stage 1 history, \eqn{h1}.
}
\usage{
qLearnQ1(object, h1q)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{object }{
object of type \code{qLearnS1}
}
  \item{h1q }{
vector of observed first-stage main effects corresponding to the
variables in \code{H1q} used in \code{qLearnS1()}
}
}
\details{
Use the estimated optimal first-stage decision rule from
\code{qLearnS1()} to recommend the best stage 1 treatment for a
patient presenting with history \code{h1q}. It is \bold{essential}
that \code{h1q} include the \bold{same variables and ordering} as
\code{H1q}. If a formula was used to fit \code{qLearnS1()}, we
recommend checking \code{summary(<qLearnS1 object>)} for the correct order of \code{h1q}.
}
\value{
  \item{q1Pos }{estimated value of the first-stage Q-function when \eqn{H1}=\eqn{h1} and \eqn{A1}=1}
  \item{q1Neg }{estimated value of the first-stage Q-function when \eqn{H1}=\eqn{h1} and \eqn{A1}=-1}
  \item{q1opt }{estimated optimal first-stage treatment for a patient presenting with \eqn{h1}}
}
\references{
Linn, K. A., Laber, E. B., Stefanski, L. A. (2015) "iqLearn: Interactive Q-Learning in R", Journal of Statistical Software, 64(1), 1--25.

Laber, E. B., Linn, K. A., and Stefanski, L. A. (2014) "Interactive model building for Q-learning", Biometrika, 101(4), 831-847.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{qLearnS1}}, \code{\link{summary.qLearnS1}},
\code{\link{plot.qLearnS1}} 
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
fitQ2 = qLearnS2 (y ~ gender + parent_BMI + month4_BMI +
  A2*(parent_BMI + month4_BMI), data=bmiData, "A2", c("parent_BMI",
  "month4_BMI"))                                 
## first-stage regression                                   
fitQ1 = qLearnS1 (~ gender + race + parent_BMI + baseline_BMI +
  A1*(gender + parent_BMI), data=bmiData, "A1", c ("gender",
                              "parent_BMI"), fitQ2)
summary (fitQ1)

h1q = c (1, 1, 35, 45);
optQ1 = qLearnQ1 (fitQ1, h1q);
optQ1$q1opt
}