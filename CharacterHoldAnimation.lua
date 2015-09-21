local common = require "common"

local CharacterHoldAnimation = {}
CharacterHoldAnimation.__index = CharacterHoldAnimation

function CharacterHoldAnimation.new(args)
  local animation = {}
  setmetatable(animation, CharacterHoldAnimation)

  animation.character = args.character

  return animation
end

function CharacterHoldAnimation:update(dt)
  local inputY = (self.character.downInput and 1 or 0) - (self.character.upInput and 1 or 0)

  local angle = inputY * 0.25 * math.pi - 0.625 * math.pi

  self.character.skeleton.bones.leftShoulder:setAngle(angle)
  self.character.skeleton.bones.rightShoulder:setAngle(angle)

  self.character.skeleton.bones.leftElbow:setAngle(-0.125 * math.pi)
  self.character.skeleton.bones.rightElbow:setAngle(-0.125 * math.pi)
end

return CharacterHoldAnimation
