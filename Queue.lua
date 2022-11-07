Queue = class()

function Queue:init(t, bounded)
   assert(not bounded or #t <= bounded, "Table larger than given limit")
   t = t or {}
   self.first = 1
   self.last = 0
   self.values = {}
   for _, v in pairs(t) do
      self:enqueue(v)
   end
   self.bounded = bounded
end

function Queue:enqueue(value)
   assert(value ~= nil, "Cannot insert nil into queue")
   self.last = self.last + 1
   self.values[self.last] = value
   log("Enqueued ", value)
   if self.bounded and self:size() > self.bounded then
      return self:dequeue()
   end
end

function Queue:peek()
   return self.values[self.first]
end

function Queue:dequeue()
   assert(self:size() > 0, "Queue is empty")
   local value = self:peek()
   self.first = self.first + 1
   log("Dequeued ", value)
   return value
end

-- Return iterator
function Queue:items()
   return next, self.values, nil
end

function Queue:size()
   return self.last - self.first + 1
end

function Queue:isEmpty()
   return self:size() == 0
end

function Queue:isFull()
   return self.bounded == self:size()
end
