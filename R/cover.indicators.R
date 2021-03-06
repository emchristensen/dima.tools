#' Percent Cover Indicators
#' @description Calculate the percent cover  indicators by plot or line for variables or combinations of variables.This is a family of standard indicator variables to examine total foliar cover, bare soil, litter cover, and other ground cover indicators. To compute cover by species, growth habit and duration, or other custom line-point intercept combinations, see \code{pct.cover()}.
  #' @param lpi.tall A tall/long-format data frame. Use the data frame \code{"layers"} from the \code{gather.lpi()} output.
  #' @param tall Logical. If \code{TRUE} then the returned data frame will be tall rather than wide and will not have observations for non-existent values e.g., if no data fell into a group on a plot, there will be no row for that group on that plot. Defaults to \code{FALSE}.
  #' @param by.year Logical. If \code{TRUE} then results will be reported further grouped by year using the \code{DateModified} field from the data forms. Defaults to \code{FALSE}.
  #' @param by.line Logical. If \code{TRUR} then results will be reported further grouped by line using the \code{LineID} and \code{LineKey} fields from the data forms. Defaults to \code{FALSE}.
  #' @name cover.indicators
  #' @return A \code{tbl} of either wide or tall format.



#' @export
#' @rdname cover.indicators
# Percent Cover Between Plants####
#This function assumes that all non-plant codes are <3 characters long
pct.cover.between.plant<-function(lpi.tall, tall=FALSE, by.year=FALSE, by.line=FALSE){
  #Calculate between plant cover
  summary<-pct.cover(lpi.tall, tall=TRUE, hit="first",by.year=by.year, by.line=by.line, code)%>%
  #Remove all layer codes that are >=3 codes (i.e., species codes)
  subset(., nchar(indicator)<3)

  if (!tall) {
    summary <- tidyr::spread(summary, key = indicator, value = percent) %>%
      ## Replace the NA values with 0s because they represent 0% cover for that indicator
      tidyr::replace_na(replace = setNames(as.list(rep.int(0,
                                                           # Make a list of 0s named with the newly-created field names for replace_na()
                                                           times = length(unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))),
                                           unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))
  }
  return(summary)
  }
#' @export
#' @rdname cover.indicators

#Percent Ground Cover####
#This function assumes that all non-plant codes are <3 characters long
pct.cover.all.ground<-function(lpi.tall, tall=FALSE, by.year=FALSE, by.line=FALSE){
  #Calculate between plant cover
  summary<-pct.cover(lpi.tall, tall=TRUE, hit="basal",by.year=by.year, by.line=by.line, code)%>%
  #Remove all layer codes that are >=3 codes (i.e., species codes)
  subset(., nchar(indicator)<3)
  if (!tall) {
    summary <- tidyr::spread(summary, key = indicator, value = percent) %>%
      ## Replace the NA values with 0s because they represent 0% cover for that indicator
      tidyr::replace_na(replace = setNames(as.list(rep.int(0,
                                                           # Make a list of 0s named with the newly-created field names for replace_na()
                                                           times = length(unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))),
                                           unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))
  }
  return(summary)
}
#' @export
#' @rdname cover.indicators

#Percent Total Foliar Cover####
pct.cover.total.foliar<-function(lpi.tall, tall=FALSE, by.year=FALSE, by.line=FALSE){
  #Calculate between plant cover
  summary<-pct.cover(lpi.tall, tall=TRUE, hit="first",by.year=by.year, by.line=by.line, code)%>%
    #Remove all layer codes that are <3 codes (i.e., non-species codes)
    subset(., nchar(indicator)>=3)

  #Sum all first hit plant codes to get total foliar cover
  summary<- dplyr::group_by_at(summary, names(summary)[-grep("percent|indicator",names(summary))]) %>%
    dplyr::summarize(., percent=sum(percent))
  summary$indicator<-"TotalFoliar"
  if (!tall) {
    summary <- tidyr::spread(summary, key = indicator, value = percent) %>%
      ## Replace the NA values with 0s because they represent 0% cover for that indicator
      tidyr::replace_na(replace = setNames(as.list(rep.int(0,
                                                           # Make a list of 0s named with the newly-created field names for replace_na()
                                                           times = length(unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))),
                                           unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))
  }

  return(summary)
}
#' @export
#' @rdname cover.indicators

#Percent Bare Soil Cover####
pct.cover.bare.soil<-function(lpi.tall, tall=FALSE, by.year=FALSE, by.line=FALSE){
  #Calculate between plant cover
  summary<-pct.cover(lpi.tall, tall=TRUE, hit="first",by.year=by.year, by.line=by.line, code)%>%
    #Remove all layer codes that are <3 codes (i.e., non-species codes)
    subset(., indicator=="S")
  if (!tall) {
    summary <- tidyr::spread(summary, key = indicator, value = percent) %>%
      ## Replace the NA values with 0s because they represent 0% cover for that indicator
      tidyr::replace_na(replace = setNames(as.list(rep.int(0,
                                                           # Make a list of 0s named with the newly-created field names for replace_na()
                                                           times = length(unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))),
                                           unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))
  }
  return(summary)
}
#' @export
#' @rdname cover.indicators

#Percent Litter Cover####
pct.cover.litter<-function(lpi.tall, tall=FALSE, by.year=FALSE, by.line=FALSE){
  #Calculate between plant cover
  summary<-pct.cover(lpi.tall, tall=TRUE, hit="any",by.year=by.year, by.line=by.line, code)%>%
    #Remove all layer codes that are <3 codes (i.e., non-species codes)
    subset(., indicator%in% c("L","WL", "NL"))
  if (!tall) {
    summary <- tidyr::spread(summary, key = indicator, value = percent) %>%
      ## Replace the NA values with 0s because they represent 0% cover for that indicator
      tidyr::replace_na(replace = setNames(as.list(rep.int(0,
                                                           # Make a list of 0s named with the newly-created field names for replace_na()
                                                           times = length(unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))),
                                           unique(names(.)[!(names(.) %in% c("Year", "SiteKey", "SiteID", "SiteName", "PlotKey", "PlotID", "LineKey", "LineID"))])))
  }

  return(summary)
}


