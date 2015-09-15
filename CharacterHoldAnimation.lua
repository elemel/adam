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
  local scale = self.character.skeleton.height / 1.8
  local angle = math.atan2(self.character.targetY - self.character.y + scale * 0.6,
    self.character.direction * (self.character.targetX - self.character.x))

  self.character.skeleton.bones.leftShoulder:setAngle(angle - (0.5 - 0.0625) * math.pi)
  self.character.skeleton.bones.rightShoulder:setAngle(angle - (0.5 - 0.0625) * math.pi)

  self.character.skeleton.bones.leftElbow:setAngle(-0.125 * math.pi)
  self.character.skeleton.bones.rightElbow:setAngle(-0.125 * math.pi)
end

return CharacterHoldAnimation
