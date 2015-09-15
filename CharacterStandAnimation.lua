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

  bones.leftElbow:setAngle(0)
  bones.rightElbow:setAngle(0)

  bones.leftHip:setAngle(0)
  bones.rightHip:setAngle(0)

  bones.leftKnee:setAngle(0)
  bones.rightKnee:setAngle(0)
end

return CharacterStandAnimation
