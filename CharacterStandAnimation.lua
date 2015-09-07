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
  local inputX = (self.character.rightInput and 1 or 0) - (self.character.leftInput and 1 or 0)
  local inputSign = common.sign(inputX)
  self.fraction = self.fraction + inputSign * self.character.direction * dt

  local function phase(t0, f)
    t0 = t0 or 0
    f = f or 1.375

    return 0.5 + 0.5 * math.sin(2 * math.pi * (f * self.fraction - t0))
  end

  local scale = self.character.skeleton.height / 1.8
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
