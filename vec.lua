vec = class()

function vec:init(...)
   self.values = {...}
   self:validate()
   --setmetatable(self, {__index = self.values})
end

function vec:validate()
   for i, v in ipairs(self.values) do
      assert(isNumber(v), "Element is not a number")
   end
end

function vec:size()
   return #self.values
end

function vec:elements()
   return next, self.values, nil
end
