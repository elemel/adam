local Background = require "Background"
local Ball = require "Ball"
local Character = require "Character"
local common = require "common"
local Fire = require "Fire"
local KeyboardInput = require "KeyboardInput"
local Lightning = require "Lightning"
local MouseInput = require "MouseInput"
local Physics = require "Physics"
local Platform = require "Platform"
local SceneGraph = require "SceneGraph"
local Terrain = require "Terrain"
local TrackingShot = require "TrackingShot"
local VictorAi = require "VictorAi"
local VillagerAi = require "VillagerAi"

function love.load()
  love.physics.setMeter(1)

  love.window.setTitle("Adam")
  love.filesystem.setIdentity("adam")
  -- love.mouse.setVisible(false)

  love.window.setMode(800, 600, {
    -- fullscreen = true,
    fullscreentype = "desktop",
    resizable = true,
  })

  game = {
    dt = 0,
    minDt = 1 / 120,
    maxDt = 1 / 30,

    camera = {
      x = 0,
      y = -4,
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
      throw = {"j", "lshift", "rshift"},
    },

    updates = {
      input = {},
      control = {},
      physics = {},
      collision = {},
      animation = {},
    },

    draws = {
      background = {},
      scene = {},
      particles = {},
      debug = {},
    },

    images = {
      background = love.graphics.newImage("resources/images/background.png"),
      foreground = love.graphics.newImage("resources/images/foreground.png"),

      adamBody = love.graphics.newImage("resources/images/adamBody.png"),
      adamHead = love.graphics.newImage("resources/images/adamHead.png"),
      adamLeftUpperArm = love.graphics.newImage("resources/images/adamLeftUpperArm.png"),
      adamLeftLowerArm = love.graphics.newImage("resources/images/adamLeftLowerArm.png"),
      adamRightUpperArm = love.graphics.newImage("resources/images/adamRightUpperArm.png"),
      adamRightLowerArm = love.graphics.newImage("resources/images/adamRightLowerArm.png"),
      adamLeftUpperLeg = love.graphics.newImage("resources/images/adamLeftUpperLeg.png"),
      adamLeftLowerLeg = love.graphics.newImage("resources/images/adamLeftLowerLeg.png"),
      adamRightUpperLeg = love.graphics.newImage("resources/images/adamRightUpperLeg.png"),
      adamRightLowerLeg = love.graphics.newImage("resources/images/adamRightLowerLeg.png"),
    },

    sounds = {
      collide = love.audio.newSource("resources/sounds/collide.ogg", "static"),
      grab = love.audio.newSource("resources/sounds/grab.ogg", "static"),
      jump = love.audio.newSource("resources/sounds/jump.ogg", "static"),
      land = love.audio.newSource("resources/sounds/land.ogg", "static"),
      throw = love.audio.newSource("resources/sounds/throw.ogg", "static"),
    },

    music = love.audio.newSource("resources/music.ogg"),

    skins = {
      adam = {
        falling = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/walking/1.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/2.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/3.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/4.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/standing.png"),
          },
        },

        grabbed = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/walking/1.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/2.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/3.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/4.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/standing.png"),
          },
        },

        grabbing = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/standing.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/standing.png"),
          },
        },

        holding = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/standing.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/holding.png"),
          },
        },

        jumping = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/walking/1.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/2.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/3.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/4.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/standing.png"),
          },
        },

        landing = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/standing.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/standing.png"),
          },
        },

        spinning = {
          lower = {
            love.graphics.newImage("resources/images/skins/adam/lower/walking/1.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/2.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/3.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/4.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/standing.png"),
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

        throwing = {
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
            love.graphics.newImage("resources/images/skins/adam/lower/walking/3.png"),
            love.graphics.newImage("resources/images/skins/adam/lower/walking/4.png"),
          },

          upper = {
            love.graphics.newImage("resources/images/skins/adam/upper/standing.png"),
          },
        },
      },
    },

    sceneGraph = SceneGraph.new(),
  }

  local shaderSource = love.filesystem.read("resources/shaders/shader.glsl")
  game.shader = love.graphics.newShader(shaderSource, shaderSource)


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

  Physics.new()
  Terrain.new()

  Platform.new({
    y = -1,
    width = 4,
    height = 0.45,
    angle = 0.125 * math.pi,
  })

  Ball.new({
    x = 10,
    y = -1.5,
    width = 4,
    height = 0.45,
    radius = 1.5,
  })

  Character.new({
    name = "adam",
    width = 0.8,
    height = 2.4,
    x = -10,
    y = -1.2,
    skin = game.skins.adam,
  })

  -- Character.new({
  --   name = "victor",
  --   skin = game.skins.adam,
  --   width = 0.9,
  --   height = 1.8,
  --   x = -2,
  --   y = -0.9,
  --   walkAcceleration = 4,
  --   maxWalkVelocity = 2,
  --   color = {common.toByteColor(0, 0.75, 1, 1)},
  -- })

  for i = 1, 0 do
    local villager = Character.new({
      tags = {"villager"},
      skin = game.skins.adam,
      width = 0.9,
      height = 1.8,
      x = 16 + 16 * love.math.random(),
      y = -0.9,
      walkAcceleration = 2,
      maxWalkVelocity = 1,
      color = {common.toByteColor(1, 0.5 * love.math.random(), 0.5 * love.math.random(), 1)},
    })

    villager.fire = Fire.new({
      x = villager.x,
      y = villager.y - 1.5,
    })
  end

  Background.new()
  TrackingShot.new()
  VictorAi.new()
  VillagerAi.new()
  -- Lightning.new({x1 = 0, y1 = -16, x2 = 0, y2 = 0})

  KeyboardInput.new()
  MouseInput.new()

  game.music:setLooping(true)
  game.music:play()
end

function love.update(dt)
  game.dt = math.min(game.dt + dt, game.maxDt)

  if game.dt > game.minDt then
    for i, phase in ipairs({"input", "control", "physics", "collision", "animation"}) do
      for entity, handler in pairs(game.updates[phase]) do
        handler(entity, dt)
      end
    end

    game.dt = 0
  end

  game.sceneGraph:updateWorldTransforms()
end

function love.draw()
  local width, height = love.window.getDimensions()
  love.graphics.translate(0.5 * width, 0.5 * height)
  love.graphics.scale(game.camera.scale * height)
  love.graphics.translate(-game.camera.x, -game.camera.y)

  for i, phase in ipairs({"background", "scene", "particles", "debug"}) do
    for entity, handler in pairs(game.draws[phase]) do
      handler(entity, dt)
    end
  end

  love.graphics.setLineWidth(1 / 32)
  love.graphics.setColor(0x00, 0xff, 0x00, 0xff)
  -- game.sceneGraph:debugDraw()
end

function love.keypressed(key, isrepeat)
  if key == "return" and not isrepeat then
    local screenshot = love.graphics.newScreenshot()
    screenshot:encode("screenshot.png")
  end
end
