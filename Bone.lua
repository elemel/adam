local Bone = {}
Bone.__index = Bone

function Bone.newRoot(forest, x, y, r, sx, sy, ox, oy, kx, ky)
  local bone = {}
  setmetatable(bone, Bone)

  bone.forest = forest
  bone.id = bone.forest:add(x, y, r, sx, sy, ox, oy, kx, ky)

  bone.x = x
  bone.y = y
  bone.r = r
  bone.sx = sx
  bone.sy = sy
  bone.ox = ox
  bone.oy = oy
  bone.kx = kx
  bone.ky = ky

  return bone
end

function Bone.newChild(parent, x, y, r, sx, sy, ox, oy, kx, ky)
  local bone = Bone.newRoot(parent.forest, x, y, r, sx, sy, ox, oy, kx, ky)

  bone.forest:setParent(bone.id, parent.id)

  return bone
end

function Bone:destroy()
  self.forest:remove(self.id)
end

function Bone:set(x, y, r, sx, sy, ox, oy, kx, ky)
  self.x = x
  self.y = y
  self.r = r
  self.sx = sx
  self.sy = sy
  self.ox = ox
  self.oy = oy
  self.kx = kx
  self.ky = ky

  self.forest:set(
    self.id,
    self.x,
    self.y,
    self.r,
    self.sx,
    self.sy,
    self.ox,
    self.oy,
    self.kx,
    self.ky)
end

function Bone:setAngle(r)
  self.r = r

  self.forest:set(
    self.id,
    self.x,
    self.y,
    self.r,
    self.sx,
    self.sy,
    self.ox,
    self.oy,
    self.kx,
    self.ky)
end

return Bone
