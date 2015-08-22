local common = require "common"

local VictorAi = {}
VictorAi.__index = VictorAi

function VictorAi.new(args)
  local ai = {}
  setmetatable(ai, VictorAi)

  game.updates.input[ai] = VictorAi.update

  return terrain
end

function VictorAi:destroy()
  game.updates.input[self] = nil
end

function VictorAi:update(dt)
  local character = game.names.victor

  if character then
  end
end

return VictorAi