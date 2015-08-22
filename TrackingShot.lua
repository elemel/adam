local common = require "common"

local TrackingShot = {}
TrackingShot.__index = TrackingShot

function TrackingShot.new(args)
  local shot = {}
  setmetatable(shot, TrackingShot)

  game.updates.animation[shot] = TrackingShot.update

  return terrshotn
end

function TrackingShot:destroy()
  game.updates.animation[self] = nil
end

function TrackingShot:update(dt)
  local character = game.names.adam

  if character then
    game.camera.x = character.x
  end
end

return TrackingShot