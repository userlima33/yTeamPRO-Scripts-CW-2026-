local sx, sy = guiGetScreenSize()
player1, player2 = false,false
--
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
local Btn,xBtn,yBtn,wBtn,hBtn,space = {},65,30,170,30,40
window = guiCreateWindow(sx/2-240,sy/2-240,480,480,"Map Ban Panel",false)
closepanelforme = guiCreateButton(440,20,30,30,"X",false, window)
Btn[1] = guiCreateButton(xBtn,yBtn,wBtn,hBtn,Mapnames[1],false, window)
Btn[2] = guiCreateButton(xBtn,yBtn+space,wBtn,hBtn,Mapnames[2],false, window)
Btn[3] = guiCreateButton(xBtn,yBtn+2*space,wBtn,hBtn,Mapnames[3],false, window)
Btn[4] = guiCreateButton(xBtn,yBtn+3*space,wBtn,hBtn,Mapnames[4],false, window)
Btn[5] = guiCreateButton(xBtn,yBtn+4*space,wBtn,hBtn,Mapnames[5],false, window)
Btn[6] = guiCreateButton(xBtn,yBtn+5*space,wBtn,hBtn,Mapnames[6],false, window)
Btn[7] = guiCreateButton(xBtn,yBtn+6*space,wBtn,hBtn,Mapnames[7],false, window)
Btn[8] = guiCreateButton(xBtn,yBtn+7*space,wBtn,hBtn,Mapnames[8],false, window)
Btn[9] = guiCreateButton(xBtn,yBtn+8*space,wBtn,hBtn,Mapnames[9],false, window)
Btn[10] = guiCreateButton(xBtn,yBtn+9*space,wBtn,hBtn,Mapnames[10],false, window)
Btn[11] = guiCreateButton(xBtn+200,yBtn,wBtn,hBtn,Mapnames[11],false, window)
Btn[12] = guiCreateButton(xBtn+200,yBtn+space,wBtn,hBtn,Mapnames[12],false, window)
Btn[13] = guiCreateButton(xBtn+200,yBtn+2*space,wBtn,hBtn,Mapnames[13],false, window)
Btn[14] = guiCreateButton(xBtn+200,yBtn+3*space,wBtn,hBtn,Mapnames[14],false, window)
Btn[15] = guiCreateButton(xBtn+200,yBtn+4*space,wBtn,hBtn,Mapnames[15],false, window)
Btn[16] = guiCreateButton(xBtn+200,yBtn+5*space,wBtn,hBtn,Mapnames[16],false, window)
Btn[17] = guiCreateButton(xBtn+200,yBtn+6*space,wBtn,hBtn,Mapnames[17],false, window)
Btn[18] = guiCreateButton(xBtn+200,yBtn+7*space,wBtn,hBtn,Mapnames[18],false, window)
Btn[19] = guiCreateButton(xBtn+200,yBtn+8*space,wBtn,hBtn,Mapnames[19],false, window)
Btn[20] = guiCreateButton(xBtn+200,yBtn+9*space,wBtn,hBtn,Mapnames[20],false, window)
info = guiCreateLabel(10, 440, 280, 45,"Each team leader has to pick 8 maps to ban.\nRemaining 4 maps will be played.", false, window) 
info2 = guiCreateLabel(300, 440, 280, 45,"0/16", false, window) 
guiSetVisible(window, false)
for i = 1, #Mapnames do
		guiSetFont (Btn[i], "default-bold-small" )
		guiSetProperty (Btn[i], "NormalTextColour", "ff008000") 
end
--
windowadmin = guiCreateWindow(sx-480,sy/2-120,460,240,"Map Ban Admin Panel",false)
closepanelformeadmin = guiCreateButton(410,30,30,30,"X",false, windowadmin)
guiSetVisible(windowadmin, false)

gridOnlinePlayers = guiCreateGridList(10,30,150,200,false,windowadmin)
guiGridListSetSortingEnabled(gridOnlinePlayers, false)
guiGridListAddColumn(gridOnlinePlayers,"Name",0.6)

gridSelectedPlayers = guiCreateGridList(170,30,150,200,false,windowadmin)
guiGridListSetSortingEnabled(gridSelectedPlayers, false)
guiGridListAddColumn(gridSelectedPlayers,"Selected",0.6)

pickplayer = guiCreateButton(330,80,120,50,"Start Voting",false, windowadmin)
resetvotes = guiCreateButton(330,150,120,50,"Reset Votes",false, windowadmin)
--
local akac = 0
function hideGui()
if getElementData(getLocalPlayer(),"canipick") then
	if (guiGetVisible(window) == false) then 
		guiSetVisible(window, true)
		showCursor(true)
		triggerServerEvent("openpanel", resourceRoot, getLocalPlayer())
		for i = 1, #Mapnames do
			if mapvotes[i] == false then
				guiSetProperty (Btn[i], "NormalTextColour", "ffff0000")
				guiSetProperty (Btn[i], "DisabledTextColour", "ffff0000")
				guiSetEnabled (Btn[i],false)
			end	
		end
		a = 20
		for i = 1, #mapvotes do
			if mapvotes[i] then
				a = a - 1
				guiSetText(info2,a.."/16") 
				akac = a
			end	
		end
		
	else
		guiSetVisible(window, false)
		if not guiGetVisible(windowadmin) then 
			showCursor(false)
		end	
		triggerServerEvent("closepanel", resourceRoot, getLocalPlayer())
	end
else
	outputChatBox("#c0c0c0* Only team leaders can access the panel!",0,0,0,true)
end	
end
--
function hideGuiadmin()
	if (guiGetVisible(windowadmin) == false) then 
		guiSetVisible(windowadmin, true)
		showCursor(true)
		guiGridListClear(gridOnlinePlayers)
		guiGridListClear(gridSelectedPlayers)
		for _,player in ipairs(getElementsByType("player")) do
			if getTeamName(getPlayerTeam(player)) ~= "Spectators" then
				local row = guiGridListAddRow (gridOnlinePlayers)
				guiGridListSetItemText(gridOnlinePlayers,row,1,string.gsub(getPlayerName(player),"#%x%x%x%x%x%x", ""),false,false)
				guiGridListSetItemColor ( gridOnlinePlayers, row, 1, getTeamColor(getPlayerTeam(player)) )
			end	
		end
	else
		guiSetVisible(windowadmin, false)
		if guiGetVisible(window) then 
			showCursor(true)
		else
			showCursor(false)	
		end	
		
	end
end
--
function onGuiClickPanel()
	for i = 1, #Mapnames do
		if source == Btn[i] then
			triggerServerEvent("sendbannedmaptoserver", resourceRoot, getLocalPlayer(),Mapnames[i],i,player1,player2,mapvotes)
			mapvotes[i] = false
			if akac == 15 then
				triggerServerEvent("printselectedmaps", resourceRoot,mapvotes)
			end
		end	
	end	
	if (source == closepanelforme) then
		hideGui()
	end
	if (source == closepanelformeadmin) then
		hideGuiadmin()
	end
	if (source == pickplayer) then
		local count = guiGridListGetRowCount(gridSelectedPlayers)
		if count == 2 then
			local chosenplayer1 = guiGridListGetItemText(gridSelectedPlayers,0,1)
			local chosenplayer2 = guiGridListGetItemText(gridSelectedPlayers,1,1)
			if getPlayerTeam(getPlayerFromParticalName(string.gsub(chosenplayer1,"#%x%x%x%x%x%x", ""))) == getPlayerTeam(getPlayerFromParticalName(string.gsub(chosenplayer2,"#%x%x%x%x%x%x", ""))) then
				outputChatBox("#c0c0c0* Please select 2 players from opposite teams!",0,0,0,true)
			else
				triggerServerEvent("givepickright", resourceRoot,chosenplayer1,chosenplayer2)
			end	
		else
			outputChatBox("#c0c0c0* Please select 2 players!",0,0,0,true)
		end
	end
	if (source == resetvotes) then
		triggerServerEvent("resetvotes", resourceRoot,getLocalPlayer())
	end
end
addEventHandler ("onClientGUIClick", getRootElement(), onGuiClickPanel)
--
function onGuiDoubleClickPanel()
	if (source == gridOnlinePlayers) then
		local qrow,qcolumn = guiGridListGetSelectedItem(gridOnlinePlayers)
		local chosenplayer = guiGridListGetItemText(gridOnlinePlayers,qrow,1)
		if chosenplayer == "" then outputChatBox("#c0c0c0* Plase pick a player",0,0,0,true) return end
		guiGridListRemoveRow ( gridOnlinePlayers, qrow )
		local row = guiGridListAddRow (gridSelectedPlayers)
		guiGridListSetItemText(gridSelectedPlayers,row,1,string.gsub(chosenplayer,"#%x%x%x%x%x%x", ""),false,false)
		guiGridListSetItemColor(gridSelectedPlayers, row, 1, getTeamColor(getPlayerTeam(getPlayerFromParticalName(string.gsub(chosenplayer,"#%x%x%x%x%x%x", "")))))
	end
	if (source == gridSelectedPlayers) then
		local qrow,qcolumn = guiGridListGetSelectedItem(gridSelectedPlayers)
		local chosenplayer = guiGridListGetItemText(gridSelectedPlayers,qrow,1)
		if chosenplayer == "" then outputChatBox("#c0c0c0* Plase pick a player",0,0,0,true) return end
		guiGridListRemoveRow ( gridSelectedPlayers, qrow )
		local row = guiGridListAddRow (gridOnlinePlayers)
		guiGridListSetItemText(gridOnlinePlayers,row,1,string.gsub(chosenplayer,"#%x%x%x%x%x%x", ""),false,false)
		guiGridListSetItemColor(gridOnlinePlayers, row, 1, getTeamColor(getPlayerTeam(getPlayerFromParticalName(string.gsub(chosenplayer,"#%x%x%x%x%x%x", "")))))
	end
end
addEventHandler ("onClientGUIDoubleClick", getRootElement(), onGuiDoubleClickPanel)
--
addEvent("openpanel", true)
addEventHandler("openpanel", resourceRoot, function(player11,player22,mapvotess)
	player1 = player11
	player2 = player22
	mapvotes = mapvotess
	hideGui()
end)
--
addEvent("closepanel", true)
addEventHandler("closepanel", resourceRoot, function(number)
	hideGui()
end)
--
addEvent("openadminpanel", true)
addEventHandler("openadminpanel", resourceRoot, function()
	hideGuiadmin()
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