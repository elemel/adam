local Transform = {}
Transform.__index = Transform

function Transform.new(a, b, c, d, e, f)
    local transform = {}
    setmetatable(transform, Transform)

    transform.a = a or 1
    transform.b = b or 0
    transform.c = c or 0
    transform.d = d or 0
    transform.e = e or 1
    transform.f = f or 0

    return transform
end

function Transform:get()
    return self.a, self.b, self.c, self.d, self.e, self.f
end

function Transform:set(a, b, c, d, e, f)
    self.a = a or 1
    self.b = b or 0
    self.c = c or 0
    self.d = d or 0
    self.e = e or 1
    self.f = f or 0
end

function Transform:multiply(a, b, c, d, e, f)
    self:set(
        self.a * a + self.b * d,
        self.a * b + self.b * e,
        self.a * c + self.b * f + self.c,
        self.d * a + self.e * d,
        self.d * b + self.e * e,
        self.d * c + self.e * f + self.f)
end

function Transform:multiplyRight(a, b, c, d, e, f)
    self:set(
        a * self.a + b * self.d,
        a * self.b + b * self.e,
        a * self.c + b * self.f + c,
        d * self.a + e * self.d,
        d * self.b + e * self.e,
        d * self.c + e * self.f + f)
end

function Transform:translate(x, y)
    self:multiply(1, 0, x, 0, 1, y)
end

function Transform:rotate(angle, x, y)
    local cosAngle = math.cos(angle)
    local sinAngle = math.sin(angle)

    if x then
        self:translate(-x, -y)
    end

    self:multiply(cosAngle, -sinAngle, 0, sinAngle, cosAngle, 0)

    if x then
        self:translate(x, y)
    end
end

function Transform:scale(scaleX, scaleY)
    self:multiply(scaleX, 0, 0, 0, scaleY, 0)
end

function Transform:shear(shearX, shearY)
    self:multiply(1, shearX, 0, shearY, 1, 0)
end

function Transform:reflect(angle, x, y)
    local axisY, axisX = math.atan2(angle)

    if x then
        self:translate(-x, -y)
    end

    self:multiply(
        axisX * axisX - axisY * axisY,
        2 * axisX * axisY,
        0,
        2 * axisX * axisY,
        axisY * axisY - axisX * axisX,
        0)

    if x then
        self:translate(x, y)
    end
end

function Transform:transformVector(x, y)
    return self.a * x + self.b * y, self.d * x + self.e * y
end

function Transform:transformPoint(x, y)
    return self.a * x + self.b * y + self.c, self.d * x + self.e * y + self.f
end

function Transform:invert()
    local invDeterminant = 1 / (self.a * self.e - self.b * self.d)
    self:set(
        invDeterminant * self.e,
        invDeterminant * -self.b,
        invDeterminant * (self.b * self.f - self.c * self.e),
        invDeterminant * -self.d,
        invDeterminant * self.a,
        invDeterminant * (-self.a * self.f + self.c * self.d))
end

function Transform:toMatrix()
    return {
        {self.a, self.b, self.c},
        {self.d, seld.e, self.f},
    }
end

function Transform:toTransposedMatrix()
    return {
        {self.a, self.d},
        {self.b, seld.e},
        {self.c, self.f},
    }
end

function Transform:toMatrix3()
    return {
        {self.a, self.b, self.c},
        {self.d, seld.e, self.f},
        {0, 0, 1},
    }
end

function Transform:toTransposedMatrix3()
    return {
        {self.a, self.d, 0},
        {self.b, seld.e, 0},
        {self.c, self.f, 1},
    }
end

function Transform:toMatrix4()
    return {
        {self.a, self.b, 0, self.c},
        {self.d, self.e, 0, self.f},
        {0, 0, 1, 0},
        {0, 0, 0, 1},
    }
end

function Transform:toTransposedMatrix4()
    return {
        {self.a, self.d, 0, 0},
        {self.b, self.e, 0, 0},
        {0, 0, 1, 0},
        {self.c, self.f, 0, 1},
    }
end

function Transform:clone()
    return Transform.new(self.get())
end

return Transform
