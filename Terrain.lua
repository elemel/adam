local common = require "common"

local Terrain = {}
Terrain.__index = Terrain

function Terrain.new(args)
  local terrain = {}
  setmetatable(terrain, Terrain)

  terrain.blocks = {}

  local block = {
    x = 0,
    y = 0.5,

    width = 256,
    height = 1,
  }

  terrain.blocks[block] = true

  game.draws.scene[terrain] = Terrain.draw
  game.names.terrain = terrain

  return terrain
end

function Terrain:destroy()
  game.names.terrain = nil
  game.draws.scene[self] = nil

  self.body:destroy()
end

function Terrain:draw()
  love.graphics.setColor(255, 255, 255, 255)
  for block, _ in pairs(self.blocks) do
    -- love.graphics.rectangle("fill", block.x - 0.5 * block.width, block.y - 0.5 * block.height, block.width, block.height)
  end
end

return Terrain