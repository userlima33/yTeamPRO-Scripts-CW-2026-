local Mapnames = {
[1] = "Cross", [2] = "Cross 17", [3] = "Cross 28", [4] = "Cross S15", [5] = "Cross XL", [6] = "Cross Y", [7] = "Cross ZL",
[8] = "Cross ZY", [9] = "Cross MEY", [10] = "GTA-PRO Crooked", [11] = "Destruction Water", [12] = "Gray Mountain", [13] = "Mountain Derby",
[14] = "Mountain Derby Cheetah", [15] = "Riki 2",[16] = "BAW",
[17] = "Wankenstein", [18] = "Wankenstein ZM", [19] = "Zaya Training", [20] = "Plop XT "
}
--
local mapvotes = {
[1] = true, [2] = true, [3] = true, [4] = true, [5] = true, [6] = true, [7] = true,[8] = true,
[9] = true, [10] = true, [11] = true, [12] = true, [13] = true,[14] = true, [15] = true,
[16] = true,[17] = true, [18] = true, [19] = true, [20] = true
}
--
addEvent("openpanel", true)
addEventHandler("openpanel", resourceRoot, function(player)
	setElementData(player,"openpanel", true)
end)
--
addEvent("closepanel", true)
addEventHandler("closepanel", resourceRoot, function(player)
	setElementData(player,"openpanel", false)
end)
--
addEvent("sendbannedmaptoserver", true)
addEventHandler("sendbannedmaptoserver", resourceRoot, function(player,map,number,player1,player2,mapvotess)
mapvotes[number] = false
	if getElementData(player,"canipick") then
		outputChatBox("#c0c0c0* (#abcdef"..getTeamName(getPlayerTeam(player)).."#c0c0c0) #abcdef"..getPlayerName(player).." #c0c0c0has #cc0000banned #abcdef"..map.." #c0c0c0map!",root,0,0,0,true)
		exports["discord"]:msgs("#c0c0c0* (#abcdef"..getTeamName(getPlayerTeam(player)).."#c0c0c0) #abcdef"..getPlayerName(player).." #c0c0c0has #cc0000banned #abcdef"..map.." #c0c0c0map!",getServerPort())
		triggerClientEvent(player, "closepanel", resourceRoot)
		if player == player1 then
			triggerClientEvent(player2, "openpanel", resourceRoot,player1,player2,mapvotes)
		elseif player == player2 then
			triggerClientEvent(player1, "openpanel", resourceRoot,player1,player2,mapvotes)
		end
	else
		outputChatBox("#c0c0c0* It's not your turn to pick yet!",player,0,0,0,true)
	end	
end)
--
addEvent("givepickright", true)
addEventHandler("givepickright", resourceRoot, function(player1,player2)
	local playertocheck1 = getPlayerFromParticalName(player1)
	local playertocheck2 = getPlayerFromParticalName(player2)
	if playertocheck1 and playertocheck2 then
		setElementData(playertocheck1,"canipick", true)
		setElementData(playertocheck2,"canipick", true)
		triggerClientEvent(playertocheck1, "openpanel", resourceRoot,playertocheck1,playertocheck2)
		outputChatBox("#c0c0c0* Map Ban Voting has started between #abcdef"..getPlayerName(playertocheck1).." #c0c0c0and #abcdef"..getPlayerName(playertocheck2).." #c0c0c0!",root,0,0,0,true)
		exports["discord"]:msgs("#c0c0c0* Map Ban Voting has started between #abcdef"..getPlayerName(playertocheck1).." #c0c0c0and #abcdef"..getPlayerName(playertocheck2).." #c0c0c0!",getServerPort())
		outputChatBox("#c0c0c0* Plase select a map to ban by turn!",root,0,0,0,true)
	else
		outputChatBox("#c0c0c0* Can't find a player with that name!",source,0,0,0,true)
	end	
end)
--
function getPlayerFromParticalName(thePlayerName)
	local thePlayer = getPlayerFromName(thePlayerName)
	if thePlayer then
		return thePlayer
	end
	for _,thePlayer in ipairs(getElementsByType("player")) do
		if string.find(string.gsub(getPlayerName(thePlayer):lower(),"#%x%x%x%x%x%x", ""), thePlayerName:lower(), 1, true) then
			return thePlayer
		end
	end
return false
end
--
addEvent("printselectedmaps", true)
addEventHandler("printselectedmaps", resourceRoot, function(mapvotes)
mapvotes = mapvotes
	outputChatBox("#c0c0c0* Ban Map Voting has ended. Selected maps:",root,0,0,0,true)
	exports["discord"]:msgs("#c0c0c0* Ban Map Voting has ended. Selected maps:",getServerPort())
	for i = 1, #Mapnames do
		if mapvotes[i] then
			outputChatBox("#c0c0c0* #008000"..Mapnames[i],root,0,0,0,true)
			exports["discord"]:msgs("**#c0c0c0* #008000"..Mapnames[i].."**",getServerPort())
			setTimer(function()
				restartResource(getThisResource())
			end,300, 1)
		end	
	end
end)
--
addEvent("resetvotes", true)
addEventHandler("resetvotes", resourceRoot, function(source)
	outputChatBox("#c0c0c0* Map Ban Panel has been resetted by #abcdef"..getPlayerName(source).." #c0c0c0!",root,0,0,0,true)
	exports["discord"]:msgs("#c0c0c0* Map Ban Panel has been resetted by #abcdef"..getPlayerName(source).." #c0c0c0!",getServerPort())
	setTimer(function()
		restartResource(getThisResource())
	end,300, 1)
end)
--
function openadminpanel(player)
    local acc = getPlayerAccount(player)
    if not isGuestAccount(acc) and
        isObjectInACLGroup("user." .. getAccountName(acc),
                           aclGetGroup("Developer")) or
        isObjectInACLGroup("user." .. getAccountName(acc),
                           aclGetGroup("Owner")) or
        isObjectInACLGroup("user." .. getAccountName(acc),
                           aclGetGroup("Manager"))  or
        isObjectInACLGroup("user." .. getAccountName(acc),
                           aclGetGroup("Admin"))  or
        isObjectInACLGroup("user." .. getAccountName(acc),
                           aclGetGroup("Moderator")) then
		triggerClientEvent(player, "openadminpanel", resourceRoot,player)
    end
end
addCommandHandler("mapbanadmin", openadminpanel)