local Animation = {}
Animation.__index = Animation

function Animation.new(args)
  local animation = {}
  setmetatable(animation, Animation)

  animation.images = args.images or {}
  animation.index = 1
  animation.delay = 0.25

  return animation
end

function Animation:update(dt)
  self.delay = self.delay - dt

  if self.delay < 0 then
    self.index = (self.index % #self.images) + 1
    self.delay = 0.25
  end
end

return Animation