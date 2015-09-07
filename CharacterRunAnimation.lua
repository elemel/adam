local common = require "common"

local CharacterRunAnimation = {}
CharacterRunAnimation.__index = CharacterRunAnimation

function CharacterRunAnimation.new(args)
  local animation = {}
  setmetatable(animation, CharacterRunAnimation)

  animation.character = args.character
  animation.fraction = 0

  return animation
end

function CharacterRunAnimation:update(dt)
  local inputX = (self.character.rightInput and 1 or 0) - (self.character.leftInput and 1 or 0)
  local inputSign = common.sign(inputX)
  self.fraction = self.fraction + inputSign * self.character.direction * dt

  local function phase(t0, f)
    t0 = t0 or 0
    f = f or 1.375

    return 0.5 + 0.5 * math.sin(2 * math.pi * (f * self.fraction - t0))
  end

  local bones = self.character.skeleton.bones

  bones.back:set(
    bones.back.x,
    bones.back.y - 0.3 * math.abs(phase(0) - 0.5),
    bones.back.r,
    bones.back.sx)

  bones.leftShoulder:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0.5)))
  bones.rightShoulder:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0)))

  bones.leftElbow:setAngle(-0.25 * math.pi)
  bones.rightElbow:setAngle(-0.25 * math.pi)

  bones.leftHip:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0)))
  bones.rightHip:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0.5)))

  bones.leftKnee:setAngle(math.pi * common.mix(0, 0.5, phase(0.25)))
  bones.rightKnee:setAngle(math.pi * common.mix(0, 0.5, phase(0.75)))
end

return CharacterRunAnimation
