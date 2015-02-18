\name{qLearnQ2}
\alias{qLearnQ2}
\title{
Q-learning: Recommend stage 2 treatment
}
\description{
Recommends the estimated optimal second-stage treatment for a given
stage 2 history, \eqn{h2}. This is the same as \code{IQ2}.
}
\usage{
qLearnQ2(object, h2)
}
\arguments{
  \item{object }{
object of type \code{qLearnS2}
}
  \item{h2 }{
vector of observed second-stage main effects corresponding to the
variables in \code{H2} used in \code{qLearnS2()}
}
}
\details{
Use the estimated optimal second-stage decision rule from
\code{qLearnS2()} to recommend the best stage 2 treatment for a
patient presenting with history \code{h2}. It is \bold{essential}
that \code{h2} include the \bold{same variables and ordering} as
\code{H2}. If a formula was used to fit \code{qLearnS2()}, we
recommend checking \code{summary(qLearnS2)} for the correct order of \code{h2}.
}
\value{
  \item{q2Pos }{estimated value of the second-stage Q-function when
  \eqn{H2}=\eqn{h2} and \eqn{A2}=1}
  \item{q2Neg }{estimated value of the second-stage Q-function when
  \eqn{H2}=\eqn{h2} and \eqn{A2}=-1}
  \item{q2opt }{estimated optimal second-stage treatment for a patient
  presenting with \eqn{h2}}
}
\references{
Laber, E.B., Linn, K.A., and Stefanski, L.A. (2013). Interactive
Q-learning. \emph{Submitted}.
}
\author{
Kristin A. Linn <kalinn@ncsu.edu>, Eric B. Laber, Leonard A. Stefanski
}
\seealso{
\code{\link{qLearnS2}}, \code{\link{summary.qLearnS2}},
\code{\link{plot.qLearnS2}} 
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
fitQ2 = qLearnS2 (y ~ gender + parent_BMI + month4_BMI +
  A2*(parent_BMI + month4_BMI), data=bmiData, "A2", c("parent_BMI",
  "month4_BMI"))                                     
summary (fitQ2)

h2 = c (1, 30, 45)
optQ2 = qLearnQ2 (fitQ2, h2)
optQ2$q2opt
}