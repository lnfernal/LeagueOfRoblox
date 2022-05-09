local Class = {}

Class.Id = 0
Class.Active = true

function Class:InitializeId()
	Class.Id = Class.Id + 1
	self.Id = Class.Id
end

function Class:Extend(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Class:New(o)
	o = self:Extend(o)
	o:InitializeId()
	if o.OnNew then
		o:OnNew()
	end
	return o
end

function Class:Contains(t, v)
	for _, val in pairs(t) do
		if val == v then
			return true
		end
	end
	return false
end

return Class