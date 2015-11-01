local fixated_info = GetSpellInfo(186348)
local marks = {star=true, circle=true, diamond=true, triangle=true, moon=true} -- Availabilty
local healers = {"Kruiuiul", "Shimara", "Naturage", "Janga", "Harmoné"}
local ranged = {"Ant", "Aeric", "Ashirha", "Clucilfer", "Awien", "Nexussoul", "Emveekay", "Fedeh", "Anouszka", "Bobilicous", "Blinkatron"}
local melee = {"Oboroth", "Brog", "Reapeh", "Knöpper", "Katrikan", "Kaljurei", "Jòzu"}
local rangedSpecs = {"Balance", "Beast Mastery", "Marksmanship", "Survival", "Arcane", "Frost", "Fire", "Shadow", "Elemental", "Affliction", "Demonology", "Destruction"}
local healingSpecs = {"Restoration", "Holy", "Discipline", "Mistweaver" }
local meleeSpecs = {"Frost", "Unholy", "Feral", "Windwalker", "Assasination", "Combat", "Subtlety", "Enhancement", "Arms", "Fury"}
local f = CreateFrame("Frame")
--[[local function getRaidMembers()
	for i = 1, GetNumGroupMembers() do
		local name = UnitName("raid".. i)
		if name == UnitName("player") then
			local activeSpec = GetSpecialization()
			local specName = select(2, GetSpecializationInfo(activeSpec))
		else
			if CanInspect("raid" .. i) then
				local specID = GetInspectSpecialization("raid" .. i)
				local specName = select(2, GetSpecializationInfoByID(specID))
			end
		end
		print(specName)
		if contains(rangedSpecs, specName) then
			ranged[getSize(ranged)+1] = name
		elseif contains(meleeSpecs, specName) then
			melee[getSize(melee)+1] = name
		elseif contains(healerSpecs, specName) then
			healers[getSize(healers)+1] = name
		end
	end
end--]]
local fixated_players = {}
SLASH_MARKFIXATED1, SLASH_MARKFIXATED2 = '/mf2', '/markfixated2'
local function handler(msg, editbox)
	if msg == "update" then
		healers = {}
		ranged = {}
		melee = {}
		getRaidMembers()
	elseif tonumber(msg) ~= nil then
		spellID = tonumber(msg)
		if spellID > 0 and spellID < 999999 then
			fixated_info = GetSpellInfo(msg)
			local name = GetSpellInfo(msg)
			print("Now marking players with: ", name)
		else
			print("Syntax /mf2 spellID")
		end
	else
		print("Syntax: /mf2 spellID")
	end
end
SlashCmdList["MARKFIXATED"] = handler
f:RegisterEvent("UNIT_AURA")
f:SetScript("OnEvent", function(self, event, ...)
	local unit = ...
	local playerName = GetUnitName(unit)
	if UnitDebuff(unit, fixated_info) then -- Adding marker
		if fixated_players ~= nil then
			for k, v in pairs(fixated_players) do
				if k == playerName then
					return
				end
			end
		end
		if contains(melee, playerName) then
			if marks["star"] == true then
				fixated_players[playerName] = "star"
				marks["star"] = false
				SetRaidTarget(playerName, 1)
				SendChatMessage("{Star}" .. playerName .. " is " .. fixated_info .. "{Star}", "RAID_WARNING", nil, nil)
			elseif marks["moon"] == true then
				fixated_players[playerName] = "moon"
				marks["moon"] = false
				SetRaidTarget(playerName, 5)
				SendChatMessage("{Moon}" .. playerName .. " is " .. fixated_info .. "{Moon}", "RAID_WARNING", nil, nil)
			end
		elseif contains(ranged, playerName) then
			if marks["circle"] == true then
				fixated_players[playerName] = "circle"
				marks["circle"] = false
				SetRaidTarget(playerName, 2)
				SendChatMessage("{Circle}" .. playerName .. " is " .. fixated_info .. "{Circle}", "RAID_WARNING", nil, nil)
			elseif marks["diamond"] == true then
				fixated_players[playerName] = "diamond"
				marks["diamond"] = false
				SetRaidTarget(playerName, 3)
				SendChatMessage("{Diamond}" .. playerName .. " is " .. fixated_info .. "{Diamond}", "RAID_WARNING", nil, nil)
			end
		elseif contains(healers, playerName) then
			if marks["triangle"] == true then
				fixated_players[playerName] = "triangle"
				marks["triangle"] = false
				SetRaidTarget(playerName, 4)
				SendChatMessage("{Triangle}" .. playerName .. " is " .. fixated_info .. "{Triangle}", "RAID_WARNING", nil, nil)
			end
		end
	else -- Removing marker
		if fixated_players ~= nil then
			for k, v in pairs(fixated_players) do
				if k == playerName then
					mark = v
					marks[mark] = true
					SetRaidTarget(k, 0)
					fixated_players[k] = nil
					return
				end
			end
		end
	end
end)
--[[
	Checking if a table contains a given value and if it does, what index is the value located at
	param(arr) table
	param(value) T - value to check exists
	return boolean or integer / returns false if the table does not contain the value otherwise it returns the index of where the value is locatedd
]]
function contains(arr, value)
	if value == nil then
		return false
	end
	if arr == nil then
		return false
	end
	for k, v in pairs(arr) do
		if v == value then
			return k
		end
	end
	return false
end
--[[
	Returns the size of a table
	param(arr) table
	returns integer / The size of the table
]]
function getSize(arr)
	local count = 0
	for k, v in pairs(arr) do
		count = count + 1
	end
	return count
end
