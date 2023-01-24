-- LuaKjell

function setup()
   DEBUG = true
   
   -- Set
   local a = {4, 8, 15, 16, 23, 42}
   local a_ = {15, 16, 4, 8, 23, 42}
   local b = {4, 15, 23}
   local c = {4, 8, 15, 108}
   
   local A1 = Set(a)
   local A2 = Set(a)
   local A3 = Set(a_)
   local B = Set(b)
   local C = Set(c)
   
   assert(
      A1 == A2,
      "Identical table Set equality failed"
   )
   assert(
      A1 == A3,
      "Permuted table Set equality failed"
   )
   assert(
      A1 + B == A1,
      "Idempotent Set union failed"
   )
   assert(
      B + C == Set{4, 8, 15, 23, 108}, 
      "Additive Set union failed"
   )
   assert(
      A1 - B == Set{8, 16, 42},
      "Set difference failed"
   )
   assert(
      A1 * C == Set{4, 8, 15}, 
      "Set intersection failed"
   )
   assert(
      A1 % C == Set{16, 23, 42, 108},
      "Set symmetric difference failed"
   )
   assert(
      B < A1, 
      "Set subset operation failed"
   )
   
   -- CoordSet
   assert(
      not pcall(function() CoordSet{69} end), 
      "Error for wrong type failed"
   )
   assert(
      not pcall(function() CoordSet{vec2(1.1, 0)} end),
      "Error for floats failed"
   )
   
   local d = {vec2(1, 0), vec2(2, 3), vec2(-4, 1)}
   local d_ = {vec2(-4, 1), vec2(2, 3), vec2(1, 0)}
   local e = {vec2(2, 3), vec2(0, 1), vec2(4, -1)}
   local f = {vec2(0, 1), vec2(2, 3)}
   
   local D1 = CoordSet(d)
   local D2 = CoordSet(d_)
   local E = CoordSet(e)
   local F = CoordSet(f)
   
   assert(
      D1 == D2, 
      "CoordSet equality failed"
   )
   assert(
      D1 + E == CoordSet{vec2(1, 0), vec2(2, 3), vec2(-4, 1), vec2(0, 1), vec2(4, -1)},
      "CoordSet union failed"
   )
   assert(
      E - F == CoordSet{vec2(4, -1)},
      "CoordSet difference failed"
   )
   assert(
      D1 * F == CoordSet{vec2(2, 3)},
      "CoordSet intersection failed"
   )
   assert(
      D1 % F == CoordSet{vec2(1, 0), vec2(-4, 1), vec2(0, 1)},
      "CoordSet symmetric difference failed"
   )
   assert(
      E > F,
      "CoordSet subset operation failed"
   )
   
   -- PairwiseSet
   local g1 = {0, 1, 1, 2, 3, 5}
   local g2 = {4, 8, 15, 16, 23, 42}
   local h1 = {99, 98}
   local h2 = {77, 76}
   
   local G1 = PairwiseSet(g1, g2)
   local G2 = PairwiseSet(g2, g1)
   local H = PairwiseSet(h1, h2)
   
   assert(
      G1 == G2,
      "Switched PairwiseSet equality failed"
   )
   G2:remove(0, 4)
   G2:remove(2, 16)
   assert(
      G1 + G2 == G1,
      "Idempotent PairwiseSet union failed"
   )
   assert(
      G2 + H == PairwiseSet({1, 1, 3, 5, 77, 76}, {8, 15, 23, 42, 99, 98}),
      "Additive PairwiseSet union failed"
   )
   assert(
      G2 < G1, 
      "PairwiseSet inequality failed"
   )
   G2:add("strange", "charm")
   assert(
      G1 - G2 == PairwiseSet({0, 2}, {4, 16}),
      "PairwiseSet difference failed"
   )
   assert(
      G1 * G2 == PairwiseSet({1, 1, 3, 5}, {8, 15, 23, 42}),
      "PairwiseSet intersection failed"
   )
   assert(
      G1 % G2 == PairwiseSet({0, 2, "charm"}, {4, 16, "strange"}),
      "PairwiseSet symmetrical difference failed"
   )
   
   -- WeakSet
   x = {}
   y = {}
   name_x = tostring(x)
   name_y = tostring(y)
   J = WeakSet({x, y})
   x = nil
   collectgarbage()
   for value in J:items() do
      contains_x = contains_x or tostring(value) == name_x
      contains_y = contains_y or tostring(value) == name_y
   end
   assert(
      not contains_x and contains_y,
      "WeakSet weakly referred value removal failed"
   )
   
   -- Polygon
   poly = Polygon{vec2(1, 0), vec2(8, 1), vec2(7, 8), vec2(0, 7)}
   assert(not poly:contains(vec2(0, 0)), "Polygon 'contains' failed")
   assert(poly:contains(vec2(4, 4)), "Polygon 'contains' failed")
end
