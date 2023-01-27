anon_img <- magick::image_read("hexsticker/rene-magritte.png")
hexSticker::sticker(
  subplot = anon_img,,
  s_width = 1,
  s_height = 1,
  s_x = 1,
  s_y = 0.75,
  p_size = 19,
  p_color = "violetred",
  p_family = "Amasis Medium",
  h_fill = "lightblue",
  package = "simplanonym",
  spotlight = TRUE,
  l_x = 3
) |> print()
