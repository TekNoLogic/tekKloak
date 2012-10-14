
local myname, ns = ...


local switching = false


local function CurrentSet()
	for i=1,GetNumEquipmentSets() do
		local name, icon, _, equipped = GetEquipmentSetInfo(i)
		if equipped then return name end
	end
end


local function SaveSet(name, icon)
	if not name then return end
	tekKloakdb[name.."helm"], tekKloakdb[name.."cloak"] = ShowingHelm(), ShowingCloak()
end


local function SwitchSet(name)
	if not name then return end
	ShowHelm(tekKloakdb[name.."helm"])
	ShowCloak(tekKloakdb[name.."cloak"])
end


function ns.OnLoad()
	tekKloakdb = tekKloakdb or {}
end


hooksecurefunc("DeleteEquipmentSet", function(name)
	tekKloakdb[name.."helm"], tekKloakdb[name.."cloak"] = nil
end)


hooksecurefunc("ShowCloak", function(v)
	local set = CurrentSet()
	if set and not switching then tekKloakdb[set.."cloak"] = v end
end)


hooksecurefunc("ShowHelm", function(v)
	local set = CurrentSet()
	if set and not switching then tekKloakdb[set.."helm"] = v end
end)

ns.RegisterEvent("WEAR_EQUIPMENT_SET", print)

-- ns.RegisterEvent("PLAYER_LOGIN", function()
-- 	ns.UnregisterEvent("PLAYER_LOGIN")
-- end)


ns.RegisterEvent("EQUIPMENT_SWAP_FINISHED", function(event, completed, name)
	if completed and name then
		switching = true
		ShowCloak(tekKloakdb[name.."cloak"])
    ShowHelm(tekKloakdb[name.."helm"])
		switching = false
	end
end)
