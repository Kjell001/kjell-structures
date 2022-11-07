-- Weak mode: "k" for keys, "v" for values, "kv" for both
local _allowed_modes = Set{"", "k", "v", "kv", "vk"}

function weakTable(mode, tbl)
   assert(_allowed_modes:contains(mode), "Unknown mode specification " .. mode)
   tbl = tbl or {}
   local mt = getmetatable(tbl) or {}
   mt.__mode = mode
   setmetatable(tbl, mt)
   return tbl
end

-- Class definitions
WeakSet = class(Set)

function WeakSet:init(t)
   Set.init(self, t)
   weakTable("k", self.values)
end


WeakCoordSet = class(CoordSet)

function WeakCoordSet:init(t)
   CoordSet.init(self, t)
   weakTable("k", self.values)
end


WeakPairwiseSet = class(PairwiseSet)

function WeakPairwiseSet:init(t)
   PairwiseSet.init(self, t)
   weakTable("k", self.values)
end
