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
end

return CharacterHoldAnimation
