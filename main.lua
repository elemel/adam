local Character = require "Character"
local common = require "common"
local Fire = require "Fire"
local KeyboardControls = require "KeyboardControls"
local Terrain = require "Terrain"
local TrackingShot = require "TrackingShot"
local VictorAi = require "VictorAi"

function love.load()
  love.window.setMode(0, 0, {
    fullscreen = true,
    fullscreentype = "desktop",
  })

  game = {
    dt = 0,
    minDt = 1 / 120,
    maxDt = 1 / 30,

    camera = {
      x = 0,
      y = -3,
      scale = 1 / 16,
    },

    entities = {},
    names = {},

    tags = {
      villager = {},
    },

    keys = {
      up = {"w", "up"},
      left = {"a", "left"},
      down = {"s", "down"},
      right = {"d", "right"},

      jump = {" "},
      throw = {"lshift"},
    },

    updates = {
      input = {},
      physics = {},
      collision = {},
      animation = {},
    },

    draws = {
      scene = {},
      particles = {},
    },

    images = {},

    skins = {
      adam = {
        falling = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/walking/1.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/2.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/holding.png"),
          },
        },

        jumping = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/standing.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/holding.png"),
          },
        },

        standing = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/standing.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/standing.png"),
          },
        },

        walking = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/walking/1.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/2.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/standing.png"),
          },
        },
      },
    }
  }

  local pixelData = love.image.newImageData(1, 1)
  pixelData:setPixel(0, 0, 255, 255, 255, 255)
  game.images.pixel = love.graphics.newImage(pixelData)

  local ballData = love.image.newImageData(4, 4)

  ballData:setPixel(1, 0, 255, 255, 255, 127)
  ballData:setPixel(2, 0, 255, 255, 255, 127)

  ballData:setPixel(0, 1, 255, 255, 255, 127)
  ballData:setPixel(1, 1, 255, 255, 255, 255)
  ballData:setPixel(2, 1, 255, 255, 255, 255)
  ballData:setPixel(3, 1, 255, 255, 255, 127)

  ballData:setPixel(0, 2, 255, 255, 255, 127)
  ballData:setPixel(1, 2, 255, 255, 255, 255)
  ballData:setPixel(2, 2, 255, 255, 255, 255)
  ballData:setPixel(3, 2, 255, 255, 255, 127)

  ballData:setPixel(1, 3, 255, 255, 255, 127)
  ballData:setPixel(2, 3, 255, 255, 255, 127)

  game.images.ball = love.graphics.newImage(ballData)

  for name, image in pairs(game.images) do
    image:setFilter("nearest")
  end

  for _, skin in pairs(game.skins) do
    for _, animation in pairs(skin) do
      for _, part in pairs(animation) do
        for i, image in pairs(part) do
          image:setFilter("nearest")
        end
      end
    end
  end

  Terrain.new()
  Character.new({
    name = "adam",
    skin = game.skins.adam,
    color = {common.toByteColor(0.5, 1, 0, 1)},
  })

  Character.new({
    name = "victor",
    skin = game.skins.adam,
    x = -2,
    color = {common.toByteColor(0, 0.75, 1, 1)},
  })

  for i = 1, 8 do
    local villager = Character.new({
      tags = {"villager"},
      skin = game.skins.adam,
      x = 4 + 8 * love.math.random(),
      color = {common.toByteColor(1, 0.5 * love.math.random(), 0.5 * love.math.random(), 1)},
    })

    villager.fire = Fire.new({
      x = villager.x,
      y = villager.y,
    })
  end

  KeyboardControls.new()
  TrackingShot.new()
  VictorAi.new()
end

function love.update(dt)
  game.dt = math.min(game.dt + dt, game.maxDt)

  if game.dt > game.minDt then
    for i, phase in ipairs({"input", "physics", "collision", "animation"}) do
      for entity, handler in pairs(game.updates[phase]) do
        handler(entity, dt)
      end
    end

    game.dt = 0
  end
end

function love.draw()
  local width, height = love.window.getDimensions()
  love.graphics.translate(0.5 * width, 0.5 * height)
  love.graphics.scale(game.camera.scale * height)
  love.graphics.translate(-game.camera.x, -game.camera.y)

  for i, phase in ipairs({"scene", "particles"}) do
    for entity, handler in pairs(game.draws[phase]) do
      handler(entity, dt)
    end
  end
end