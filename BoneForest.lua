local Transform = require "Transform"

local BoneForest = {}
BoneForest.__index = BoneForest

function BoneForest.new()
  local forest = {}
  setmetatable(forest, BoneForest)

  forest.transforms = {}
  forest.worldTransforms = {}

  forest.parents = {}
  forest.children = {}

  forest.dirty = {}
  forest.free = {}

  return forest
end

function BoneForest:add(x, y, r, sx, sy, ox, oy, kx, ky)
  local id = next(self.free)

  if id then
    self.free[id] = nil
  else
    table.insert(self.transforms, Transform.new())
    table.insert(self.worldTransforms, Transform.new())
    table.insert(self.children, {})

    id = #self.transforms
  end

  self:set(id, x, y, r, sx, sy, ox, oy, kx, ky)
  return id
end

function BoneForest:remove(id)
  self:setParent(id, nil)
  local children = self.children[id]

  while true do
    local childId = next(children)

    if not childId then
      break
    end

    self:setParent(childId, nil)
  end

  self.free[id] = true
end

function BoneForest:set(id, x, y, r, sx, sy, ox, oy, kx, ky)
  local transform = self.transforms[id]
  transform:set()

  if x or y then
    transform:translate(x or 0, y or 0)
  end

  if r then
    transform:rotate(r)
  end

  if sx or sy then
    transform:scale(sx or 1, sy or 1)
  end

  if kx or ky then
    transform:shear(kx or 0, ky or 0)
  end

  if ox or oy then
    transform:translate(-ox or 0. -oy or 0)
  end

  self:setDirty(id)
end

function BoneForest:setParent(id, parentId)
  local oldParentId = self.parents[id]

  if parentId ~= oldParentId then
    if oldParentId then
      self.children[oldParentId][id] = nil
    end

    self.parents[id] = parentId

    if parentId then
      self.children[parentId][id] = true
    end

    self:setDirty(id)
  end
end

function BoneForest:setDirty(id)
  if not self.dirty[id] then
    for childId, _ in pairs(self.children[id]) do
      self:setDirty(childId)
    end

    self.dirty[id] = true
  end
end

function BoneForest:updateWorldTransform(id)
  if self.dirty[id] then
    local transform = self.worldTransforms[id]
    transform:set(self.transforms[id]:get())
    local parentId = self.parents[id]

    if parentId then
      self:updateWorldTransform(parentId)
      local parentTransform = self.worldTransforms[parentId]
      transform:multiplyRight(parentTransform:get())
    end

    self.dirty[id] = nil
  end
end

function BoneForest:updateWorldTransforms()
  while true do
    local id = next(self.dirty)

    if not id then
      break
    end

    self:updateWorldTransform(id)
  end
end

function BoneForest:debugDraw()
  self:updateWorldTransforms()

  for parentId, childIds in pairs(self.children) do
    local parentTransform = self.worldTransforms[parentId]
    local x1, y1 = parentTransform.c, parentTransform.f

    for childId, _ in pairs(childIds) do
      local childTransform = self.worldTransforms[childId]
      local x2, y2 = childTransform.c, childTransform.f
      love.graphics.line(x1, y1, x2, y2)
    end
  end
end

return BoneForest
