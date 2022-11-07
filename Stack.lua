Stack = class()

function Stack:init(t, bounded)
   assert(not bounded or #t <= bounded, "Table larger than given limit")
   t = t or {}
   self.last = 0
   self.values = {}
   for _, v in pairs(t) do
      self:enqueue(v)
   end
   self.bounded = bounded
end

function Stack:stack()
   assert(value ~= nil, "Cannot insert nil into stack")
   assert(not self.bounded or self:size() < self.bounded, "Stack overflow")
   self.last = self.last + 1
   self.values[self.last] = value
   log("Stacked ", value)
end

function Stack:peek()
   return self.values[self.last]
end

function Stack:destack()
   assert(self:size() > 0, "Stack is empty")
   local value = self:peek()
   self.last = self.last - 1
   log("Destacked ", value)
   return value
end

function Stack:items()
   return next, self.values, nil
end

function Stack:size()
   return self.last
end

function Stack:isEmpty()
   return self:size() == 0
end

function Stack:isFull()
   return self.bounded == self:size()
end

