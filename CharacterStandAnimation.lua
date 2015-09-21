local common = require "common"

local CharacterStandAnimation = {}
CharacterStandAnimation.__index = CharacterStandAnimation

function CharacterStandAnimation.new(args)
  local animation = {}
  setmetatable(animation, CharacterStandAnimation)

  animation.character = args.character
  animation.fraction = 0

  return animation
end

function CharacterStandAnimation:update(dt)
  local bones = self.character.skeleton.bones

  bones.back:set(
    bones.back.x,
    bones.back.y,
    bones.back.r,
    bones.back.sx)

  bones.leftShoulder:setAngle(0)
  bones.rightShoulder:setAngle(0)

  bones.leftElbow:setAngle(-(1 / 16) * math.pi)
  bones.rightElbow:setAngle(-(1 / 16) * math.pi)

  bones.leftHip:setAngle(0)
  bones.rightHip:setAngle(-(1 / 16) * math.pi)

  bones.leftKnee:setAngle((1 / 16) * math.pi)
  bones.rightKnee:setAngle((1 / 16) * math.pi)
end

return CharacterStandAnimation
