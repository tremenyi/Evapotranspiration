\name{ET.PenmanMonteith}
\alias{ET.PenmanMonteith}

\title{Penman-Monteith Formulation
}
\description{
Implementing the Penman-Monteith formulation. To estimate crop evapotranspiration, the formulation can take possible of either FAO-56 model for hypothetical short grass, the ASCE-EWRI Standardised model for tall grass. The model can also estimate ET from several other vegetation types based on Equation 6.70 in Dingman (2015).
}
\usage{
\method{ET}{PenmanMonteith}(data, constants, ts="daily", solar="sunshine hours", wind="yes", 
vegetation="reference crop", \dots)
}

\arguments{
  \item{data}{
  A 'zoo object' created by the Evapotranspiration function ReadInputs().  This is a list which contains the following items (climate variables) required by Penman-Monteith formulation:\cr
  \emph{Tmax} - Maximum temperature (Celsisus), 
  \emph{Tmin} - Minimum temperature (Celsisus), 
  \emph{RHmax} - Maximum relative humidity (%), 
  \emph{RHmin} - Minimum relative humidity (%), 
  \emph{Rs} - Incoming Solar radiation (MJ.m^{-2})
    or 
    \emph{n} - Unknown 
    or 
    \emph{Cd} - Unknown, 
  \emph{u2} - Wind speed at 2m above surface (m.s^{-1})
    or 
    \emph{uz} - Wind speed at surface (m.s^{-1}) 
  }
  \item{constants}{
  A list named \code{constants} consists of constants required for the calculation of Penman-Monteith formulation which must contain the following items:\cr
  \emph{Elev} - ground elevation above mean sea level in m,\cr
  \emph{lambda} - latent heat of vaporisation = 2.45 MJ.kg^-1,\cr
  \emph{lat_rad} - latitude in radians,\cr
  \emph{Gsc} - solar constant = 0.0820 MJ.m^-2.min^-1,\cr
  \emph{z} - height of wind instrument in m,\cr
  \emph{sigma} - Stefan-Boltzmann constant = 4.903*10^-9 MJ.K^-4.m^-2.day^-1.\cr
  \emph{G} - soil heat flux in MJ.m^-2.day^-1, = 0 when using daily time step.
  \cr
  The following constants are also required when argument \code{solar} has value of \code{sunshine hours}:\cr 
  \emph{as} - fraction of extraterrestrial radiation reaching earth on sunless days,\cr
  \emph{bs} - difference between fracion of extraterrestrial radiation reaching full-sun days and that on sunless days.
  }
  \item{ts}{
  Must be either \code{daily}, \code{monthly} or \code{annual}, which indicates the disired time step that the output ET estimates should be on. 
  Default is \code{daily}.
  }
  \item{solar}{
  Must be either \code{data}, \code{sunshine hours}, \code{cloud} or \code{monthly precipitation}:\cr
  \code{data} indicates that solar radiation data is to be used directly for calculating evapotranspiration; \cr
  \code{sunshine hours} indicates that solar radiation is to be calculated using the real data of sunshine hours;\cr
  \code{cloud} sunshine hours is to be estimated from cloud data; \cr
  \code{monthly precipitation} indicates that solar radiation is to be calculated directly from monthly precipitation.\cr
  Default is \code{sunshine hours}.
  }
  \item{wind}{
  Must be either \code{yes} or \code{no}.\cr
  \code{yes} indicates that the calculation will use real data of wind speed; \cr
  \code{no} indicates that the alternative calculation without using wind data will be used in Penman formulation (Valiantzas 2006, Equation33).\cr
  Default is \code{yes}.
  }
  \item{vegetation}{
  Must be either: \cr
  \code{reference crop}, \cr
  \code{long grass}, \cr
  \code{deciduous broad-leaf forest}, \cr
  \code{evergreen needle-leaf forest}, \cr
  \code{open shrubland} or \cr
  \code{grassland}.\cr 
  \cr
  \code{reference crop} indicates that the method for FAO-56 hypothetical short grass will be applied (Allen et al., 1998, Equation 6); \cr
  \code{long grass} indicates that the method for  ASCE-EWRI Standardised crop will be applied (ASCE, 2005, Equation 1, Table 1).\cr
  All other options lead to the use of Equation 6.70 in Dingman (2015) to estimate ET for specific vegetation cover, with wind measured at instrument height adjusted to 2m following Federer er al. (1996) . Constants for each vegetation type are defined according to values suggested in \url{http://ldas.gsfc.nasa.gov/nldas/web/web.veg.table.html}.\cr
  \cr
  Default is \code{reference crop}.
  }
  \item{\dots}{
  Dummy for generic function, no need to define.
  }
}

\details{
  The alternative calculation options can be selected through arguments \code{solar} and \code{wind}, please see \code{Arguments} for details.\cr
  User-defined evaporative surface is allowed through arguments \code{vegetation}, please see \code{Arguments} for details.
}

\value{
The function prints a calculation summary to the screen containing the following elements:\cr
- ET model name and ET quantity estimated\cr
- Evaporative surface with values of albedo, surface resistance, crop height and roughness height\cr
- Option for calculating solar radiation (i.e. the value of argument \code{solar})\cr
- If actual wind data has been used for calculation (i.e. the value of argument \code{wind}) \cr
- Time step of the output ET estimates (i.e. the value of argument \code{ts})\cr
- Units of the output ET estimates\cr
- Time duration of the ET estimation\cr
- Number of ET estimates obtained in the entire time-series\cr
- Basic statistics of the estimated ET time-series including \emph{mean}, \emph{max} and \emph{min} values.\cr
\cr

The function also generates a list containing the following components, which is saved into a \code{csv} file named as \emph{ET_PenmanMonteith.csv} in the working directory:
  \item{ET.Daily}{
  Daily aggregated estimations of Penman-Monteith evapotranspiration.
  }
  \item{ET.Monthly}{
  Monthly aggregated estimations of Penman-Monteith evapotranspiration.
  }
  \item{ET.Annual}{
  Annually aggregated estimations of Penman-Monteith evapotranspiration.
  }
  \item{ET.MonthlyAve}{
  Monthly averaged estimations of daily Penman-Monteith evapotranspiration.
  }
  \item{ET.AnnualAve}{
  Annually averaged estimations of daily Penman-Monteith evapotranspiration.
  }
  \item{ET_formulation}{
  Name of the formulation used which equals to either \code{Penman-Monteith FAO56} or \code{Penman-Monteith ASCE-EWRI Standardised}.
  }
  \item{ET_type}{
  A character string containing the type of the estimation obtained depending on the vegetation type.
  }
  \item{message1}{
  A message to inform the users about how solar radiation has been calculated by using which data.
  }
  \item{message2}{
  A message to inform the users about if actual wind data has been used in the calculations or alternative calculations has been performed without wind data.
  }
}
\references{
McMahon, T., Peel, M., Lowe, L., Srikanthan, R. & McVicar, T. 2012. \emph{Estimating actual, potential, reference crop and pan evaporation using standard meteorological data: a pragmatic synthesis}. Hydrology and Earth System Sciences Discussions, 9, 11829-11910.

Allen, R. G., Pereira, L. S., Raes, D. & Smith, M. 1998. \emph{Crop evapotranspiration-Guidelines for computing crop water requirements-FAO Irrigation and drainage}. paper 56. FAO, Rome, 300, 6541.

Allen, R. G. 2005. \emph{The ASCE standardized reference evapotranspiration equation}. Amer Society of Civil Engineers.

Brian Cosgrove, \emph{Mapped Static Vegetation Data}, available from \url{http://ldas.gsfc.nasa.gov/nldas/web/web.veg.table.html}.

Dingman, S.L., 2015, \emph{Physical Hydrology}, Third edition, Waveland Press, Inc.

Federer, C. A., et al. (1996). \emph{Intercomparison of Methods for Calculating Potential Evaporation in Regional and Global Water Balance Models}, Water Resources Research 32(7): 2315-2321.
}


\author{
Danlu Guo
}
\seealso{
\code{\link{ET}},\code{\link{data}},\code{\link{defaultconstants}},\code{\link{constants}}
}
\examples{
# Use processed existing data set and constants from kent Town, Adelaide
data("processeddata")
data("constants")

# Call ET.PenmanMonteith under the generic function ET
results <- ET.PenmanMonteith(data, constants, ts="daily", solar="sunshine hours", 
wind="yes") 

# Call ET.PenmanMonteith to estimate ET from different vegetation covers

# referecen crop (FAO-56)
results <- ET.PenmanMonteith(data, constants, ts="daily", solar="sunshine hours", 
wind="yes",vegetation="reference crop") 

# long grass (ASCE-EWRI)
results <- ET.PenmanMonteith(data, constants, ts="daily", solar="sunshine hours", 
wind="yes",vegetation="long grass") 

# other types etc. (Equation 6.70 in Dingman (2015))
results <- ET.PenmanMonteith(data, constants, ts="daily", solar="sunshine hours", 
wind="yes",vegetation="deciduous broad-leaf forest") 

}

% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{Penman-Monteith}
\keyword{evapotranspiration}
\keyword{Reference crop evapotranspiration}
\keyword{FAO-56}
\keyword{ASCE}
% __ONLY ONE__ keyword per line

