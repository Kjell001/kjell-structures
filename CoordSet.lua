CoordSet = class(Set)

function CoordSet:init(...)
   self:setMaxCoord(2^16)
   Set.init(self, ...)
end

-- Methods for storing coordinates as integers
function CoordSet:setMaxCoord(maxCoord)
   self.maxCoord = maxCoord
end

function CoordSet:coord2index(coord)
   assert(isVec2(coord), "Coordinates must be vec2")
   assert(coord.x % 1 == 0 and coord.y % 1 == 0, "Coordinates must be integers")
   local offset = self.maxCoord / 2
   return (coord.x + offset) * self.maxCoord + coord.y + offset
end

function CoordSet:index2coord(index)
   local offset = self.maxCoord / 2
   local y = index % self.maxCoord - offset
   local x = index // self.maxCoord - offset
   return vec2(x, y)
end

-- Coord variants of basic set operations
function CoordSet:assign(content, coord)
   local index = self:coord2index(coord)
   Set.assign(self, content, index)
end

function CoordSet:contains(coord)
   local index = self:coord2index(coord)
   return Set.contains(self, index)
end

function CoordSet:items()
   local index = next(self.values)
   return function()
      if index then
         local coord = self:index2coord(index)
         index = next(self.values, index)
         return coord
      end
   end
end

-- Translate allcoordinates in set by a vector
function CoordSet:translate(dir)
   local indexDir = dir.x * self.maxCoord + dir.y
   local newValues = {}
   for index, content in pairs(self.values) do
      newValues[index + indexDir] = content
   end
   local new = newInstance(self)
   new:setMaxCoord(self.maxCoord)
   new.values = newValues
   return new
end

function CoordSet.__tostring(a)
   local str = "CoordSet(" .. #a .. "): {"
   for coord in a:items() do
      str = str .. "\n  (" .. string.format("%6d; %6d",  coord.x, coord.y) .. "),"
   end
   str = str .. "\n}"
   return str
end
