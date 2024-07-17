local UTILS = {}


function UTILS.tableContains(t, c)
	for i, v in pairs(t) do
		if t[i] == c then
			return true
		end
	end
	return false
end


return UTILS