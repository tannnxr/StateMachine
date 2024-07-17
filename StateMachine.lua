-- Some Constants for Function
local StarterPlayer = game:GetService("StarterPlayer")
local utils = require(script.Utils)

local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.newState(states)
	local newStateMachine = {}
	setmetatable(newStateMachine, StateMachine)
	
	newStateMachine.stateChanged = Instance.new("BindableEvent")
	newStateMachine.error = Instance.new("BindableEvent")

	newStateMachine.stateables = states
	newStateMachine.state = Instance.new("StringValue")
	newStateMachine.state.Value = newStateMachine.stateables[1]
	
	return newStateMachine
end

function StateMachine:setState(stateToChange: string)
	if stateToChange == self.state.Value then
		return warn(`State is already set as {self.state.Value}`)
	end

	if utils.tableContains(self.stateables, stateToChange) ~= true then
		self.error:Fire(`Tried to set state to a non-state value {stateToChange} not in \{{table.concat(self.stateables, ", ")}\} State Change Failed`)
		return
	end
	local lastState = self.state.Value
	self.state.Value = stateToChange
	self.stateChanged:Fire(lastState, stateToChange)
end

function StateMachine:getCurrentState()
	return self.state.Value
end

return StateMachine