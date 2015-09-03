local SceneNode = {}
SceneNode.__index = SceneNode

function SceneNode.new(graph, parent, x, y, r, sx, sy, ox, oy, kx, ky)
  local node = {}
  setmetatable(node, SceneNode)

  node.graph = graph
  node.parent = parent
  node.id = graph:add(x, y, r, sx, sy, ox, oy, kx, ky)

  node.x = x
  node.y = y
  node.r = r
  node.sx = sx
  node.sy = sy
  node.ox = ox
  node.oy = oy
  node.kx = kx
  node.ky = ky

  if parent then
    graph:setParent(node.id, parent.id)
  end

  return node
end

function SceneNode:newChild(x, y, r, sx, sy, ox, oy, kx, ky)
  return SceneNode.new(self.graph, self, x, y, r, sx, sy, ox, oy, kx, ky)
end

function SceneNode:destroy()
  self.graph:remove(self.id)
end

function SceneNode:set(x, y, r, sx, sy, ox, oy, kx, ky)
  self.x = x
  self.y = y
  self.r = r
  self.sx = sx
  self.sy = sy
  self.ox = ox
  self.oy = oy
  self.kx = kx
  self.ky = ky

  self.graph:set(
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

function SceneNode:setAngle(r)
  self.r = r

  self.graph:set(
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

return SceneNode
