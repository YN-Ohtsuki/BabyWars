return {
  warFieldName = "陨 石 群",
  authorName   = "RushFTK",
  playersCount = 2,

  width = 15,
  height = 17,
  layers = {
    {
      type = "tilelayer",
      name = "TileBase",
      x = 0,
      y = 0,
      width = 15,
      height = 17,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 58, 52, 52, 56, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 75, 61, 30, 18, 18, 21, 62, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 38, 18, 18, 47, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 58, 61, 30, 19, 71, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 63, 48, 1, 49, 71, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 69, 56, 1, 59, 62, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 69, 26, 21, 61, 48, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 58, 26, 18, 34, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 63, 30, 18, 18, 21, 61, 76, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 49, 43, 43, 47, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    },
    {
      type = "tilelayer",
      name = "TileObject",
      x = 0,
      y = 0,
      width = 15,
      height = 17,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        132, 100, 130, 0, 147, 0, 100, 100, 100, 0, 147, 77, 77, 80, 150,
        145, 99, 101, 0, 101, 0, 0, 0, 0, 155, 100, 0, 130, 78, 123,
        123, 101, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 79, 82, 0,
        0, 0, 0, 0, 130, 0, 0, 0, 0, 0, 79, 77, 82, 0, 0,
        0, 0, 135, 0, 90, 97, 0, 0, 0, 77, 86, 99, 0, 0, 0,
        100, 0, 0, 90, 93, 0, 0, 0, 100, 0, 78, 0, 101, 0, 0,
        130, 79, 77, 86, 0, 0, 130, 0, 0, 123, 0, 0, 127, 101, 130,
        77, 82, 101, 81, 77, 80, 99, 0, 0, 130, 0, 0, 0, 0, 0,
        0, 0, 130, 101, 0, 81, 77, 77, 77, 80, 0, 101, 130, 0, 0,
        0, 0, 0, 0, 0, 130, 0, 0, 99, 81, 77, 80, 101, 79, 77,
        130, 101, 126, 0, 0, 123, 0, 0, 130, 0, 0, 85, 77, 82, 130,
        0, 0, 101, 0, 78, 0, 100, 0, 0, 0, 90, 93, 0, 0, 100,
        0, 0, 0, 99, 85, 77, 0, 0, 0, 96, 93, 0, 135, 0, 0,
        0, 0, 79, 77, 82, 0, 0, 0, 0, 0, 130, 0, 0, 0, 0,
        0, 79, 82, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 101, 123,
        123, 78, 130, 0, 100, 155, 0, 0, 0, 0, 101, 0, 101, 99, 145,
        150, 81, 77, 77, 146, 0, 100, 100, 100, 0, 146, 0, 130, 100, 131
      }
    },
    {
      type = "tilelayer",
      name = "Unit",
      x = 0,
      y = 0,
      width = 15,
      height = 17,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 187, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 283, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 282, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    }
  }
}