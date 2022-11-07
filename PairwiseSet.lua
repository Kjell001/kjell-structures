PairwiseSet = class(Set)

function PairwiseSet:init(t1, t2)
   self.values = {}
   if t1 and t2 then
      assert(#t1 == #t2, "Tables must be of same length")
      for i = 1, #t1 do
         self:add(t1[i], t2[i])
      end
   end
end

function PairwiseSet:assign(content, value1, value2)
   if content and not self.values[value1] then
      self.values[value1] = {}
   end
   self.values[value1][value2] = content
   self.count = nil
end

function PairwiseSet:remove(value1, value2)
   local hasPair, reversed = self:contains(value1, value2)
   if hasPair then
      if reversed then
         self:assign(nil, value2, value1)
      else
         self:assign(nil, value1, value2)
      end
   end
end

-- Returns whether the set contains the pair and whether it is reversed
function PairwiseSet:contains(value1, value2)
   if self.values[value1] and self.values[value1][value2] then
      return true, false
   elseif self.values[value2] and self.values[value2][value1] then
      return true, true
   else
      return false
   end
end

function PairwiseSet:size()
   if self.count then return self.count end
   local count = 0
   for _ in self:items() do
      count = count + 1
   end
   self.count = count
   return count
end

-- Returns iterator
function PairwiseSet:items()
   -- Initiate k1 with first value
   local k1 = next(self.values)
   local k2
   return function()
      while k1 do
         k2 = next(self.values[k1], k2)
         if k2 then
            return k1, k2
         else
            k1 = next(self.values, k1)
            k2 = nil
         end
      end
      return nil
   end
end

-- Return hard copy of this set
function PairwiseSet:copy(includeTallies)
   local new = newInstance(self)
   for value1, value2 in self:items() do
      if not includeTallies then
         new:add(value1, value2)
      else
         new:assign(self:contains(value1, value2), value1, value2)
      end
   end
   return new
end

-- Return first result from iteration
function PairwiseSet:first()
   for value1, value2 in self:items() do
      return value1, value2
   end
end

-- Returns pairs from self and other
function PairwiseSet:union(other)
   local new = self:copy()
   for value1, value2 in other:items() do
      new:add(value1, value2)
   end
   return new
end

-- Returns pairs from self that are not in other
function PairwiseSet:difference(other)
   local new = self:copy()
   for value1, value2 in other:items() do
      new:remove(value1, value2)
   end
   return new
end

-- Returns pairs that are both in self and other
function PairwiseSet:intersect(other)
   local new = PairwiseSet()
   for value1, value2 in self:items() do
      if other:contains(value1, value2) then
         new:add(value1, value2)
      end
   end
   return new
end

-- Returns pairs that are in self or other, but not in both
function PairwiseSet:symmetricDifference(other)
   local new = self:copy()
   for value1, value2 in other:items() do
      if self:contains(value1, value2) then
         new:remove(value1, value2)
      else
         new:add(value1, value2)
      end
   end
   return new
end

function PairwiseSet:isSubset(other)
   for value1, value2 in self:items() do
      if not other:contains(value1, value2) then
         return false
      end
   end
   return true
end

-- Convert set to two tables with corresponding indices
function PairwiseSet:toTables(sort)
   local t1 = {}
   local t2 = {}
   for value1, value2 in self:items() do
      table.insert(t1, value1)
      table.insert(t2, value2)
   end
   if sort then
      table.sortAlong(t2, t1)
      table.sort(t1)
   end
   return t1, t2
end

-- Metamethods
function PairwiseSet.__tostring(a)
   local str = "PairwiseSet(" .. #a .. "): {"
   for value1, value2 in a:items() do
      str = str .. "\n  (" .. string.format("%6s; %6s",  tostring(value1), tostring(value2)) .. "),"
   end
   str = str .. "\n}"
   return str
end
