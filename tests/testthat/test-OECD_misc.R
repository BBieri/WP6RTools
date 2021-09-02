# Run tests
test_that("oecd_members has the correct countries", {
  expect_equal(oecd_members()[[2]], c('Australia', 'Austria', 'Belgium',
                                      'Canada', 'Chile', 'Colombia',
                                      'Costa Rica', 'Czech Republic',
                                      'Denmark', 'Estonia', 'Finland',
                                      'France', 'Germany', 'Greece',
                                      'Hungary', 'Iceland', 'Ireland',
                                      'Israel', 'Italy', 'Japan', 'South Korea',
                                      'Latvia', 'Lithuania', 'Luxembourg',
                                      'Mexico', 'Netherlands', 'New Zealand',
                                      'Norway', 'Poland', 'Portugal',
                                      'Slovakia', 'Slovenia', 'Spain',
                                      'Sweden', 'Switzerland', 'Turkey',
                                      'United Kingdom', 'United States'))
           })
test_that("oecd_member_metrics has the correct countries", {
  expect_equal(oecd_member_metrics()[[2]], c('Australia', 'Austria', 'Belgium',
                                      'Canada', 'Chile', 'Colombia',
                                      'Costa Rica', 'Czech Republic',
                                      'Denmark', 'Estonia', 'Finland',
                                      'France', 'Germany', 'Greece',
                                      'Hungary', 'Iceland', 'Ireland',
                                      'Israel', 'Italy', 'Japan', 'South Korea',
                                      'Latvia', 'Lithuania', 'Luxembourg',
                                      'Mexico', 'Netherlands', 'New Zealand',
                                      'Norway', 'Poland', 'Portugal',
                                      'Slovakia', 'Slovenia', 'Spain',
                                      'Sweden', 'Switzerland', 'Turkey',
                                      'United Kingdom', 'United States',
                                      'OECDbc'))
})
test_that("oecd_secretary has the correct number of secretaries", {
  expect_equal(length(oecd_secretary()[[2]]), 8)
})
