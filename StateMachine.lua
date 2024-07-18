local signal = require(script.Parent.GoodSignal)
local stateMachine = {}
stateMachine.__index = stateMachine

local stateObject = {}
stateObject.__index = stateObject

export type State = {name: string, master:{}, branches:Branch}
export type Branch = {[string]: {string} | {}}

function stateMachine.New(states)
	local self = setmetatable({
		states ={} :: {State},
		current=nil,
		StateChanged=signal.new(),
	}, stateMachine)
	for _, v in ipairs(states) do
		self:NewState(v[1], v[2])
	end
	return self
end

function stateMachine:NewState(name, branches)
	local newSelf = setmetatable({name=name, master=self, branches=branches or {}} :: State, stateObject)
	self.states[name] = newSelf

	return newSelf
end

function stateObject:PushBranch(...)
	for _, v in ipairs({...}) do
		self.branches[v] = true
	end
end

function stateObject:PullBranch(...)
	for _, v in ipairs({...}) do
		self.branches[v] = false
	end
end

function stateObject:CanBranch(target)
	return self.branches[target]
end

function stateMachine:Next(target)
	if (self.current) then
		if (not table.find(self.current.branches, target)) then
			return
		end
	end
	local lastState = self.current
	self.current = self.states[target]
	self.StateChanged:Fire(lastState, self.current)
end

function stateMachine:Get(state)
	return self.states[state]
end

function stateObject:Destroy()
	self.master.states[self.name] = nil
	setmetatable(self, nil)
end

function stateMachine:Destroy()
	for _, v in (self.master.states) do
		v:Destroy()
	end
	self.StateChanged:DisconnectAll()
	setmetatable(self, nil)
end

return stateMachine