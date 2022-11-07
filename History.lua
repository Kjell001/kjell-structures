History = class()

function History:init(maxStates)
   self.states = {}
   self.maxStates = maxStates
   self.index = 0
end

function History:currentState()
   return self.states[self.index]
end

function History:hasStates()
   return self.index ~= 0
end

function History:hasPreviousState()
   return self.index > 1
end

function History:hasNextState()
   return self.index < #self.states
end

function History:previousState()
   if self:hasPreviousState() then
      return self.states[self.index - 1]
   end
end

function History:nextState()
   if self:hasNextState() then
      return self.states[self.index + 1]
   end
end

function History:appendState(state)
   assert(state ~= nil, "Adding nil state not allowed")
   self:cutStates()
   table.insert(self.states, state)
   log("Add state " .. #self.states)
   self:forward()
   self:cull()
end

function History:cutStates()
   for _ = self.index + 1, #self.states do
      log("Cut state " .. #self.states)
      table.remove(self.states)
   end
end

function History:cull()
   local surplus = #self.states - self.maxStates
   if surplus > 0 then
      for _ = 1, surplus do
         log("Cull state " .. 1)
         table.remove(self.states, 1)
      end
      self.index = self.index - surplus
   end
end

function History:forward()
   log("State " .. self.index .. " -> " .. (self.index + 1))
   assert(self:hasNextState(), "Can't go forward, history exhausted")
   self.index = self.index + 1
   return self:currentState()
end

function History:backward()
   log("State " .. self.index .. " -> " .. (self.index - 1))
   assert(self:hasPreviousState(), "Can't go backward, history exhausted.")
   self.index = self.index - 1
   return self:currentState()
end

function History:show()
   print("History(" .. self.maxStates .. ")")
   for i, v in ipairs(self.states) do
      local chevron = (i == self.index) and "> " or "  "
      print(chevron .. i .. ": " .. v)
   end
end
