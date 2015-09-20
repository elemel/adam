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
    local x, y = character.physics.body:getPosition()
    game.camera.x = x
  end
end

return TrackingShot
