local common = require "common"

local CharacterCrouchAnimation = {}
CharacterCrouchAnimation.__index = CharacterCrouchAnimation

function CharacterCrouchAnimation.new(args)
  local animation = {}
  setmetatable(animation, CharacterCrouchAnimation)

  animation.character = args.character
  animation.fraction = 0

  return animation
end

function CharacterCrouchAnimation:update(dt)
  local bones = self.character.skeleton.bones
  local scale = self.character.skeleton.height / 1.8

  bones.back:set(
    bones.back.x,
    bones.back.y + 0.45 * scale,
    bones.back.r,
    bones.back.sx)

  bones.leftShoulder:setAngle(0)
  bones.rightShoulder:setAngle(0)

  bones.leftElbow:setAngle(-0.25 * math.pi)
  bones.rightElbow:setAngle(-0.25 * math.pi)

  bones.leftHip:setAngle(0)
  bones.rightHip:setAngle(-0.5 * math.pi)

  bones.leftKnee:setAngle(0.625 * math.pi)
  bones.rightKnee:setAngle(0.5 * math.pi)
end

return CharacterCrouchAnimation
