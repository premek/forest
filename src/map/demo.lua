return {
  version = "1.1",
  luaversion = "5.1",
  tiledversion = "0.12.3",
  orientation = "orthogonal",
  width = 13,
  height = 13,
  tilewidth = 32,
  tileheight = 32,
  nextobjectid = 52,
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
      terrains = {
        {
          name = "gnd",
          tile = -1,
          properties = {}
        }
      },
      tiles = {
        {
          id = 1,
          terrain = { 0, 0, 0, 0 }
        },
        {
          id = 2,
          terrain = { -1, -1, 0, 0 }
        },
        {
          id = 3,
          terrain = { -1, -1, 0, -1 }
        },
        {
          id = 4,
          terrain = { -1, -1, -1, 0 }
        },
        {
          id = 5,
          terrain = { -1, 0, -1, 0 }
        },
        {
          id = 6,
          terrain = { -1, 0, 0, 0 }
        },
        {
          id = 7,
          terrain = { 0, -1, 0, -1 }
        },
        {
          id = 8,
          terrain = { 0, -1, 0, 0 }
        },
        {
          id = 9,
          terrain = { 0, 0, -1, -1 }
        },
        {
          id = 11,
          terrain = { -1, 0, -1, -1 }
        },
        {
          id = 12,
          terrain = { 0, -1, -1, -1 }
        },
        {
          id = 16,
          terrain = { 0, 0, 0, -1 }
        },
        {
          id = 17,
          terrain = { 0, 0, -1, 0 }
        },
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
        },
        {
          id = 33,
          animation = {
            {
              tileid = "33",
              duration = "100"
            },
            {
              tileid = "34",
              duration = "100"
            },
            {
              tileid = "35",
              duration = "100"
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
        2, 2, 2, 2, 10, 10, 10, 10, 10, 10, 10, 10, 2,
        2, 2, 2, 13, 0, 0, 0, 0, 0, 0, 0, 0, 6,
        2, 10, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6,
        8, 0, 0, 0, 0, 0, 0, 5, 3, 3, 3, 3, 7,
        8, 0, 0, 0, 0, 0, 0, 12, 2, 2, 10, 10, 2,
        8, 0, 5, 3, 3, 4, 0, 0, 6, 8, 0, 0, 6,
        8, 0, 6, 10, 10, 13, 0, 0, 6, 8, 0, 0, 6,
        8, 0, 25, 0, 0, 0, 0, 5, 7, 8, 0, 0, 6,
        8, 0, 0, 0, 0, 0, 0, 12, 10, 13, 0, 5, 7,
        8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 2,
        9, 3, 3, 3, 3, 4, 0, 5, 3, 3, 3, 7, 2,
        2, 2, 2, 2, 2, 2, 0, 2, 2, 2, 2, 2, 2,
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
          x = 352,
          y = 192,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 19,
          visible = true,
          properties = {}
        },
        {
          id = 19,
          name = "key",
          type = "collect",
          shape = "rectangle",
          x = 32,
          y = 256,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 30,
          visible = true,
          properties = {}
        },
        {
          id = 28,
          name = "shaman",
          type = "char",
          shape = "rectangle",
          x = 32,
          y = 288,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {
            ["controlled"] = "true"
          }
        },
        {
          id = 32,
          name = "door",
          type = "action",
          shape = "rectangle",
          x = 64,
          y = 320,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 27,
          visible = true,
          properties = {}
        },
        {
          id = 33,
          name = "door",
          type = "action",
          shape = "rectangle",
          x = 64,
          y = 288,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 26,
          visible = true,
          properties = {}
        },
        {
          id = 38,
          name = "snake",
          type = "char",
          shape = "rectangle",
          x = 96,
          y = 288,
          width = 30,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 39,
          name = "flappyflap",
          type = "char",
          shape = "rectangle",
          x = 96,
          y = 128,
          width = 32,
          height = 32,
          rotation = 0,
          visible = true,
          properties = {}
        },
        {
          id = 40,
          name = "lava",
          type = "action",
          shape = "rectangle",
          x = 192,
          y = 386,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 34,
          visible = true,
          properties = {}
        },
        {
          id = 43,
          name = "snakeground",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 288,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 6,
          visible = true,
          properties = {}
        },
        {
          id = 44,
          name = "snakeground",
          type = "",
          shape = "rectangle",
          x = 224,
          y = 320,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 12,
          visible = true,
          properties = {}
        },
        {
          id = 45,
          name = "snakeground",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 320,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 13,
          visible = true,
          properties = {}
        },
        {
          id = 46,
          name = "snakeground",
          type = "",
          shape = "rectangle",
          x = 256,
          y = 288,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 2,
          visible = true,
          properties = {}
        },
        {
          id = 47,
          name = "openwall",
          type = "action",
          shape = "rectangle",
          x = 288,
          y = 320,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 18,
          visible = true,
          properties = {}
        },
        {
          id = 50,
          name = "box",
          type = "move",
          shape = "rectangle",
          x = 288,
          y = 96,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 16,
          visible = true,
          properties = {}
        },
        {
          id = 51,
          name = "box",
          type = "move",
          shape = "rectangle",
          x = 128,
          y = 160,
          width = 32,
          height = 32,
          rotation = 0,
          gid = 16,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
