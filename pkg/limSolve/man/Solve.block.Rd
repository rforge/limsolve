\name{Solve.block}
\alias{Solve.block}
\title{
  Solution of an almost block diagonal system of linear equations
}
\description{
  Solves the linear system A*X=B where A is an almost block diagonal matrix of
  the form:

   TopBlock

   ...   Array(1)  ... ... ...

   ... ...      Array(2)  ... ...

            ...

   ... ... ...  Array(Nblocks)...

   ... ... ...  BotBlock


  The method is based on Gauss elimination with alternate row and column
  elimination with partial pivoting, producing a stable decomposition of
  the matrix A without introducing fill-in.

  uses FORTRAN subroutine colrow
}

\usage{
Solve.block(Top, AR, Bot, B, overlap)
}

\arguments{
  \item{Top }{the first block of the almost block diagonal matrix \code{A}.
  }
  \item{AR }{intermediary blocks; \code{AR}(.,.,K) contains the kth block of
    matrix \code{A}.
  }
  \item{Bot }{the last block of the almost block diagonal matrix \code{A}.
  }
  \item{B }{Right-hand side of the equations, a vector with length = number
   of rows of \code{A}, 
   or a matrix with number of rows = number of rows of \code{A}.
  }
  \item{overlap }{the number of columns in which successive blocks
    overlap, and where \code{overlap = nrow(Top) + nrow(Bot)}.
  }
}

\value{
  matrix with the solution, X, of the block diagonal system of equations Ax=B,
  the number of columns of this matrix = number of columns of B.
}

\author{
  Karline Soetaert <karline.soetaert@nioz.nl>
}

\note{A similar function but that requires a totally different input can now 
  also be found in the \code{Matrix} package
}

\examples{
# Solve the following system: Ax=B, where A is block diagonal, and

#  0.0  -0.98 -0.79 -0.15                                                  Top
# -1.00  0.25 -0.87  0.35                                                  Top
#  0.78  0.31 -0.85  0.89 -0.69 -0.98 -0.76 -0.82                          blk1
#  0.12 -0.01  0.75  0.32 -1.00 -0.53 -0.83 -0.98
# -0.58  0.04  0.87  0.38 -1.00 -0.21 -0.93 -0.84
# -0.21 -0.91 -0.09 -0.62 -1.99 -1.12 -1.21  0.07
#                          0.78 -0.93 -0.76  0.48 -0.87 -0.14 -1.00 -0.59  blk2
#                         -0.99  0.21 -0.73 -0.48 -0.93 -0.91  0.10 -0.89
#                         -0.68 -0.09 -0.58 -0.21  0.85 -0.39  0.79 -0.71
#                          0.39 -0.99 -0.12 -0.75 -0.68 -0.99  0.50 -0.88
#                                                  0.71 -0.64  0.0   0.48  Bot
#                                                  0.08 100.0 50.00 15.00  Bot


B <- c(-1.92, -1.27, -2.12, -2.16, -2.27,  -6.08,
       -3.03, -4.62, -1.02, -3.52,  0.55, 165.08)

AA         <- matrix (nrow = 12, ncol = 12, 0)
AA[1,1:4]  <- c( 0.0,  -0.98, -0.79, -0.15)
AA[2,1:4]  <- c(-1.00,  0.25, -0.87,  0.35)
AA[3,1:8]  <- c( 0.78,  0.31, -0.85,  0.89, -0.69, -0.98, -0.76, -0.82)
AA[4,1:8]  <- c( 0.12, -0.01,  0.75,  0.32, -1.00, -0.53, -0.83, -0.98)
AA[5,1:8]  <- c(-0.58,  0.04,  0.87,  0.38, -1.00, -0.21, -0.93, -0.84)
AA[6,1:8]  <- c(-0.21, -0.91, -0.09, -0.62, -1.99, -1.12, -1.21,  0.07)
AA[7,5:12] <- c( 0.78, -0.93, -0.76,  0.48, -0.87, -0.14, -1.00, -0.59)
AA[8,5:12] <- c(-0.99,  0.21, -0.73, -0.48, -0.93, -0.91,  0.10, -0.89)
AA[9,5:12] <- c(-0.68, -0.09, -0.58, -0.21,  0.85, -0.39,  0.79, -0.71)
AA[10,5:12]<- c( 0.39, -0.99, -0.12, -0.75, -0.68, -0.99,  0.50, -0.88)
AA[11,9:12]<- c( 0.71, -0.64,   0.0,  0.48)
AA[12,9:12]<- c( 0.08, 100.0, 50.00, 15.00)

## Block diagonal input.
Top  <- matrix(nrow = 2, ncol = 4, data = AA[1:2  , 1:4] )
Bot  <- matrix(nrow = 2, ncol = 4, data = AA[11:12, 9:12])
Blk1 <- matrix(nrow = 4, ncol = 8, data = AA[3:6  , 1:8] )
Blk2 <- matrix(nrow = 4, ncol = 8, data = AA[7:10 , 5:12])

AR <- array(dim = c(4, 8, 2), data = c(Blk1, Blk2))
overlap <- 4

# answer = (1, 1,....1)
Solve.block(Top, AR, Bot, B, overlap = 4)

# Now with 3 different B values
B3 <- cbind(B, 2*B, 3*B)
Solve.block(Top, AR, Bot, B3, overlap = 4)

}

\references{
  J. C. Diaz , G. Fairweather , P. Keast, 1983.
  FORTRAN Packages for Solving Certain Almost Block Diagonal Linear
  Systems by Modified Alternate Row and Column Elimination,
  ACM Transactions on Mathematical Software (TOMS), v.9 n.3, p.358-375
}

\seealso{
  \code{\link{Solve.tridiag}} to solve a tridiagonal system of linear equations.

  \code{\link{Solve.banded}} to solve a banded system of linear equations.

  \code{\link{Solve}} the generalised inverse solution,

  \code{\link{solve}} the R default
}
\keyword{array}

