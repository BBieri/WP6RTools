# Create the plot to test
p <- dplyr::count(ggplot2::mpg, class) %>%
  ggplot2::ggplot(ggplot2::aes(class, n)) +
  ggplot2::geom_col(fill = oecd_palette("oecd", 7, type = "continuous")) +
  ggplot2::geom_text(ggplot2::aes(label = n), nudge_y = 3) +
  ggplot2::labs(x = "Vehicle Category", y = "Number of Vehicles",
                title = "Seminal ggplot2 bar chart example",
                subtitle = "A plot that is only useful for demonstration purposes",
                caption = "Source: somewhere on the web") +
  theme_oecd(grid = "Y") +
  ggplot2::theme(axis.text.y = element_blank())
# Run tests on plots
test_that("Colours of the light plot theme are correct", {
  expect_equal(p[["theme"]][["line"]][["colour"]], "black")
  expect_equal(p[["theme"]][["rect"]][["colour"]], "black")
  expect_equal(p[["theme"]][["text"]][["colour"]], "black")
           })
