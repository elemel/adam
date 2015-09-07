local common = require "common"

local VictorAi = {}
VictorAi.__index = VictorAi

function VictorAi.new(args)
  local ai = {}
  setmetatable(ai, VictorAi)

  ai.delay = 0

  game.updates.controls[ai] = VictorAi.update

  return terrain
end

function VictorAi:destroy()
  game.updates.controls[self] = nil
end

function VictorAi:update(dt)
  self.delay = self.delay - dt

  if self.delay < 0 then
    local adam = game.names.adam
    local victor = game.names.victor

    if victor then
      local inputX

      if adam and math.abs(adam.x - victor.x) > 2 then
        inputX = common.sign(adam.x - victor.x)
      else
        inputX = love.math.random(-1, 1)
      end

      victor.leftInput = (inputX == -1)
      victor.rightInput = (inputX == 1)
    end

    self.delay = 0.5 + 0.5 * math.random()
  end
end

return VictorAi
