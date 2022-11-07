Set = class()

function Set:init(t)
   self.values = {}
   if t then
      for _, v in pairs(t) do
         self:add(v)
      end
   end
end

function Set:assign(content, value)
   self.values[value] = content
   self.count = nil
end

function Set:contains(value)
   return self.values[value]
end

function Set:add(...)
   local hasValue = self:contains(...)
   if not hasValue then
      self:assign(1, ...)
      return true
   end
   return false
end

function Set:remove(...)
   local changed = self:contains(...)
   self:assign(nil, ...)
   return changed
end

function Set:size()
   if self.count then return self.count end
   local count = 0
   for _ in self:items() do
      count = count + 1
   end
   self.count = count
   return count
end

-- Tallying
function Set:tally(...)
   return self:contains(...) or 0
end

function Set:increment(...)
   self:assign(self:tally(value) + 1, ...)
end

-- Return iterator
function Set:items()
   return next, self.values, nil
end

-- Return hard copy of this set
function Set:copy(includeTallies)
   local new = newInstance(self)
   for value in self:items() do
      if not includeTallies then
         new:add(value)
      else
         new:assign(self:contains(value), value)
      end
   end
   return new
end

-- Return first result from iteration
function Set:first()
   for value in self:items() do
      return value
   end
end

-- Returns items from self and other
function Set:union(other)
   local new = self:copy()
   for value in other:items() do
      new:add(value)
   end
   return new
end

-- Returns items from self that are not in other
function Set:difference(other)
   local new = self:copy()
   for value in other:items() do
      new:remove(value)
   end
   return new
end

-- Returns items that are in both self and other
function Set:intersect(other)
   local new = newInstance(self)
   for value in self:items() do
      if other:contains(value) then
         new:add(value)
      end
   end
   return new
end

-- Returns items that are in self or other, but not in both
function Set:symmetricDifference(other)
   local new = self:copy()
   for value in other:items() do
      if self:contains(value) then
         new:remove(value)
      else
         new:add(value)
      end
   end
   return new
end

-- Test equality of two sets
function Set:isEmpty()
   return self:size() == 0
end

function Set:equals(other)
   local symDiff = self:symmetricDifference(other)
   return symDiff:isEmpty()
end

function Set:isSubset(other)
   for value in self:items() do
      if not other:contains(value) then
         return false
      end
   end
   return true
end

-- Convert set to table with arbitrary order
function Set:toTable(sort)
   local t = {}
   for value in self:items() do
      table.insert(t, value)
   end
   if sort then
      table.sort(t)
   end
   return t
end

-- Type check
function isSet(instance)
   return getmetatable(instance) == Set
end

-- Metamethods
function Set.__len(a)
   return a:size()
end

function Set.__add(a, b)
   return a:union(b)
end

function Set.__sub(a, b)
   return a:difference(b)
end

function Set.__mul(a, b)
   return a:intersect(b)
end

function Set.__mod(a, b)
   return a:symmetricDifference(b)
end

function Set.__eq(a, b)
   return a:equals(b)
end

function Set.__lt(a, b)
   return a:isSubset(b) and not a:equals(b)
end

function Set.__le(a, b)
   return a:isSubset(b)
end

function Set.__tostring(a)
   local str = "Set(" .. #a .. "): {"
   for value in a:items() do
      str = str .. "\n  " .. string.format("%6s", tostring(value)) .. ","
   end
   str = str .. "\n}"
   return str
end
