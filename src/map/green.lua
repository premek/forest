return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.12.3",
  orientation = "orthogonal",
  width = 13,
  height = 13,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 26,
  properties = {},
  tilesets = {
    {
      name = "green",
      firstgid = 1,
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      image = "../img/green.png",
      imagewidth = 256,
      imageheight = 256,
      tileoffset = {
        x = 0,
        y = 0
      },
      properties = {},
      terrains = {},
      tiles = {
        {
          id = 18,
          objectGroup = {
            type = "objectgroup",
            name = "",
            visible = true,
            opacity = 1,
            properties = {},
            objects = {}
          }
        },
        {
          id = 29,
          animation = {
            {
              tileid = "29",
              duration = "150"
            },
            {
              tileid = "30",
              duration = "150"
            },
            {
              tileid = "31",
              duration = "150"
            },
            {
              tileid = "32",
              duration = "150"
            }
          }
        }
      }
    }
  },
  layers = {
    {
      type = "tilelayer",
      name = "sky",
      x = 0,
      y = 0,
      width = 13,
      height = 13,
      visible = true,
      opacity = 1,
      properties = {},
      encoding = "lua",
      data = {
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
      }
    },
    {
      type = "tilelayer",
      name = "ground",
      x = 0,
      y = 0,
      width = 13,
      height = 13,
      visible = true,
      opacity = 1,
      properties = {
        ["collidable"] = "true"
      },
      encoding = "lua",
      data = {
        2, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 2,
        8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6,
        8, 0, 0, 0, 0, 16, 0, 0, 0, 0, 16, 0, 6,
        8, 0, 0, 0, 5, 4, 0, 5, 3, 3, 3, 3, 7,
        8, 0, 0, 0, 12, 13, 0, 12, 2, 10, 10, 10, 2,
        8, 0, 16, 0, 0, 0, 0, 0, 25, 0, 0, 0, 6,
        8, 0, 25, 0, 0, 0, 0, 0, 25, 0, 0, 0, 6,
        8, 0, 25, 0, 5, 3, 3, 3, 3, 4, 0, 0, 6,
        8, 0, 25, 0, 6, 2, 10, 10, 2, 8, 0, 0, 6,
        8, 0, 0, 0, 12, 13, 0, 0, 12, 13, 0, 5, 7,
        8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 2,
        9, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 7, 2,
        2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
      }
    },
    {
      type = "objectgroup",
      name = "objects",
      visible = true,
      opacity = 1,
      properties = {
        ["collidable"] = "true"
      },
      objects = {
        {
          id = 7,
          name = "finish",
          type = "action",
          shape = "rectangle",
          x = 288,
          y = 224,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 19,
          visible = true,
          properties = {}
        },
        {
          id = 8,
          name = "openwall",
          type = "action",
          shape = "rectangle",
          x = 224,
          y = 352,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 18,
          visible = true,
          properties = {}
        },
        {
          id = 11,
          name = "key",
          type = "collect",
          shape = "rectangle",
          x = 288,
          y = 96,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 30,
          visible = true,
          properties = {}
        },
        {
          id = 12,
          name = "snakeground",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 352,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 12,
          visible = true,
          properties = {}
        },
        {
          id = 13,
          name = "snakeground",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 352,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 13,
          visible = true,
          properties = {}
        },
        {
          id = 16,
          name = "snakeground",
          type = "",
          shape = "rectangle",
          x = 128,
          y = 320,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {}
        },
        {
          id = 17,
          name = "snakeground",
          type = "",
          shape = "rectangle",
          x = 160,
          y = 320,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 8,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 352,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 27,
          visible = true,
          properties = {}
        },
        {
          id = 20,
          name = "door",
          type = "",
          shape = "rectangle",
          x = 64,
          y = 320,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 26,
          visible = true,
          properties = {}
        },
        {
          id = 22,
          name = "shaman",
          type = "char",
          shape = "rectangle",
          x = 64,
          y = 96,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["controlled"] = "true"
          }
        },
        {
          id = 23,
          name = "snake",
          type = "char",
          shape = "rectangle",
          x = 96,
          y = 320,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 24,
          name = "flappyflap",
          type = "char",
          shape = "rectangle",
          x = 192,
          y = 192,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 25,
          name = "flappyflap",
          type = "char",
          shape = "rectangle",
          x = 160,
          y = 32,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
