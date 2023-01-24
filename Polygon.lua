Polygon = class()

function Polygon:init(points)
   self.points = points
end

function Polygon:vertices()
   local len = #self.points
   local index = 0
   return function()
      index = index + 1 
      if index <= len then
         return self.points[index]
      end
   end
end

function Polygon:lines()
   local len = #self.points
   local a
   local b = self.points[len]
   local index = 0
   return function()
      index = index + 1
      if index <= len then
         a, b = b, self.points[index]
         return a, b
      end
   end
end

-- Winding number
-- See love2d.org/forums/viewtopic.php?t=89699
function Polygon:contains(p)
   local cross
   local winding = 0
   for a, b in self:lines() do
      cross = (a.x - p.x) * (b.y - p.y) - (b.x - p.x) * (a.y - p.y)
      if a.y > p.y then
         if (b.y <= p.y) and cross < 0 then
            winding = winding + 1
         end
      else
         if (b.y > p.y) and cross > 0 then
            winding = winding - 1
         end
      end
   end
   return winding % 2 ~= 0 -- even/odd rule
end
