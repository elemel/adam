local common = require "common"

local CharacterStruggleAnimation = {}
CharacterStruggleAnimation.__index = CharacterStruggleAnimation

function CharacterStruggleAnimation.new(args)
  local animation = {}
  setmetatable(animation, CharacterStruggleAnimation)

  animation.character = args.character
  animation.fraction = 0

  return animation
end

function CharacterStruggleAnimation:update(dt)
  self.fraction = self.fraction + dt

  local function phase(t0, f)
    t0 = t0 or 0
    f = f or 1.375

    return 0.5 + 0.5 * math.sin(2 * math.pi * (f * self.fraction - t0))
  end

  local bones = self.character.skeleton.bones

  bones.leftShoulder:setAngle(math.pi * common.mix(-1, -0.5, phase(0.5)))
  bones.rightShoulder:setAngle(math.pi * common.mix(-1, -0.5, phase(0)))

  bones.leftElbow:setAngle(math.pi * common.mix(-0.5, 0, phase(0.5)))
  bones.rightElbow:setAngle(math.pi * common.mix(-0.5, 0, phase(0)))

  bones.leftHip:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0.25)))
  bones.rightHip:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0.75)))

  bones.leftKnee:setAngle(math.pi * common.mix(0, 0.5, phase(0.25)))
  bones.rightKnee:setAngle(math.pi * common.mix(0, 0.5, phase(0.75)))
end

return CharacterStruggleAnimation
