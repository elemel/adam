local common = require "common"

local VictorAi = {}
VictorAi.__index = VictorAi

function VictorAi.new(args)
  local ai = {}
  setmetatable(ai, VictorAi)

  ai.delay = 0

  game.updates.input[ai] = VictorAi.update

  return terrain
end

function VictorAi:destroy()
  game.updates.input[self] = nil
end

function VictorAi:update(dt)
  self.delay = self.delay - dt

  if self.delay < 0 then
    local adam = game.names.adam
    local victor = game.names.victor

    if victor then
      if adam then
        local inputX = love.math.random(-1, 1)
        victor.leftInput = (inputX == -1)
        victor.rightInput = (inputX == 1)
      end
    end

    self.delay = 0.5 + 0.5 * math.random()
  end
end

return VictorAi