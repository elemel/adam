local common = require "common"

local CharacterRunAnimation = {}
CharacterRunAnimation.__index = CharacterRunAnimation

function CharacterRunAnimation.new(args)
  local animation = {}
  setmetatable(animation, CharacterRunAnimation)

  animation.skeleton = args.skeleton
  animation.time = 0

  return animation
end

function CharacterRunAnimation:update(dt)
  self.time = self.time + dt

  local function phase(t0, f)
    t0 = t0 or 0
    f = f or 1.375

    return 0.5 + 0.5 * math.sin(2 * math.pi * (f * self.time - t0))
  end

  local backBone = self.skeleton.bones.back

  backBone:set(
    backBone.x,
    backBone.y - 0.3 * math.abs(phase(0) - 0.5),
    backBone.r,
    backBone.sx)

  self.skeleton.bones.leftShoulder:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0.5)))
  self.skeleton.bones.rightShoulder:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0)))

  self.skeleton.bones.leftElbow:setAngle(-0.25 * math.pi)
  self.skeleton.bones.rightElbow:setAngle(-0.25 * math.pi)

  self.skeleton.bones.leftHip:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0)))
  self.skeleton.bones.rightHip:setAngle(math.pi * common.mix(-0.25, 0.25, phase(0.5)))

  self.skeleton.bones.leftKnee:setAngle(math.pi * common.mix(0, 0.5, phase(0.25)))
  self.skeleton.bones.rightKnee:setAngle(math.pi * common.mix(0, 0.5, phase(0.75)))
end

return CharacterRunAnimation
