#' Complete list of palettes
#'
#' Discrete color palette based on OECD colors.
#'
#' @export

oecd_palettes <- list(
  "oecd" = c(
    "oecd_gray" = "#343a40",
    "oecd_blue" = "#264653",
    "oecd_turquoise" = "#2a9d8f",
    "oecd_yellow" = "#e9c46a",
    "oecd_orange" = "#f4a261",
    "oecd_red" = "#e76f51"
  )

)

#' An OECD palette generator
#'
#' This is a small palette generator for OECD graphs that generates color vectors
#' to be used in graphs
#'
#' @param n Number of colors desired. If omitted, uses all colours.
#' @param name Name of desired palette. Current choice is:
#' \code{oecd}
#' @param type Either "continuous" or "discrete". Use continuous if you want
#'   to automatically interpolate between colours.
#' @importFrom graphics rect par image text
#' @return A vector of colours.
#' @source Adapted from https://github.com/karthik/wesanderson/blob/master/R/colors.R
#' @export
#' @keywords colors
#' @examples
#' oecd_palette("oecd")
#'
#' # If you need more colours than normally found in a palette, you
#' # can use a continuous palette to interpolate between existing
#' # colours
#' pal <- oecd_palette(21, name = "Centres", type = "continuous")
#' image(volcano, col = pal)
oecd_palette <- function(name, n, type = c("discrete", "continuous")) {
  type <- match.arg(type)
  pal <- oecd_palettes[[name]]
  if (is.null(pal))
    stop("Palette not found.")
  if (missing(n)) {
    n <- length(pal)
  }
  if (type == "discrete" && n > length(pal)) {
    stop("Number of requested colors greater than what palette can offer")
  }
  out <- switch(type,
                continuous = grDevices::colorRampPalette(pal)(n),
                discrete = pal[1:n]
  )
  structure(out, class = "palette", name = name)
}

#' @export
#' @importFrom graphics rect par image text
#' @importFrom grDevices rgb
print.palette <- function(x, ...) {
  n <- length(x)
  old <- par(mar = c(0.5, 0.5, 0.5, 0.5))
  on.exit(par(old))
  image(1:n, 1, as.matrix(1:n), col = x,
        ylab = "", xaxt = "n", yaxt = "n", bty = "n")
  rect(0, 0.9, n + 1, 1.1, col = rgb(1, 1, 1, 0.8), border = NA)
  text((n + 1) / 2, 1, labels = attr(x, "name"), cex = 1, family = "serif")
}
