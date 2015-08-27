local function clamp(x, x1, x2)
  return math.min(math.max(x, x1), x2)
end

local function squaredDistance(x1, y1, x2, y2)
  return (x2 - x1) ^ 2 + (y2 - y1) ^ 2
end

local function distance(x1, y1, x2, y2)
  return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

local function sign(x)
  return x < 0 and -1 or 1
end

local function get2(t, x, y)
  return t[y] and t[y][x]
end

local function set2(t, x, y, value)
  if value == nil then
    if t[y] then
      t[y][x] = nil

      if not next(t[y]) then
        t[y] = nil
      end
    end
  else
    t[y] = t[y] or {}
    t[y][x] = value
  end
end

local function toByte(fraction)
  return clamp(math.floor(fraction * 256), 0, 255)
end

local function toByteColor(r, g, b, a)
  return toByte(r), toByte(g), toByte(b), toByte(a)
end

local function keys(t)
  local ks = {}

  for k, v in pairs(t) do
    table.insert(ks, k)
  end

  return ks
end

local function values(t)
  local vs = {}

  for k, v in pairs(t) do
    table.insert(vs, v)
  end

  return vs
end

local function filter(t, f)
  local result = {}

  for i, v in ipairs(t) do
    if f(v) then
      table.insert(result, v)
    end
  end

  return result
end

local function dot(x1, y1, x2, y2)
  return x1 * x2 + y1 * y2
end

local function mix(x1, x2, t)
  return (1 - t) * x1 + t * x2
end

local function normalize(x, y)
  local length = math.sqrt(x ^ 2 + y ^ 2)
  return x / length, y / length, length
end

return {
  clamp = clamp,
  distance = distance,
  dot = dot,
  get2 = get2,
  filter = filter,
  keys = keys,
  mix = mix,
  normalize = normalize,
  set2 = set2,
  sign = sign,
  squaredDistance = squaredDistance,
  toByte = toByte,
  toByteColor = toByteColor,
  values = values,
}