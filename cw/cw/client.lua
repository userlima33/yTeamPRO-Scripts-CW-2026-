setCameraClip(false, false)

local sw, sh = guiGetScreenSize()
guiSetInputMode("no_binds_when_editing")

-- Mesma função de cantos arredondados usada no placar principal, pra
-- manter o visual consistente entre os dois HUDs.
local function dxDrawRoundedRectangle(x, y, rx, ry, color)
	local radius = 5
	rx = rx - radius * 2
	ry = ry - radius * 2
	x = x + radius
	y = y + radius
	if (rx >= 0) and (ry >= 0) then
		dxDrawRectangle(x, y, rx, ry, color)
		dxDrawRectangle(x, y - radius, rx, radius, color)
		dxDrawRectangle(x, y + ry, rx, radius, color)
		dxDrawRectangle(x - radius, y, radius, ry, color)
		dxDrawRectangle(x + rx, y, radius, ry, color)
		dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
		dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
		dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
		dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
	end
end

local team1, team2, team3
local tn1, tn2, tn3 = "", "", ""
local tp1, tp2, tp3 = 0, 0, 0
local tc1, tc2, tc3 = "", "", ""
local isSomeoneWon

local clanWarState = "Free"
local currentMapName = "[DD]"

local firstSend = true
local showHud = true
local isTeam3 = false
local roundsLeft = 0

local mapsTable = {}
local choosenMapsTable = {}

local redoAnimate, isRedoPoll, redoTeam, redoNick = false, false
local stopgoAnimate, isstopgoPoll, stopgoTeam, stopgoNick = false, false
local redoX, redoA, redoB = sw + sw * 0.5, 0, 0
local stopgoX, stopgoA, stopgoB = sw + sw * 0.5, 0, 0
local isWindow = false
local isShowStop, stopMessage, isItStopped = false, "", false

local cst, csw = false, false

local csw_def_id = 0
local cst_def_h, cst_def_m = 12, 0

local csw_id = 0
local cst_h, cst_m = 12, 0

addEvent("receiveMaps", true)
addEventHandler("receiveMaps", root,
function(maps, choosen)
	if maps then
		mapsTable = maps
	end
	if choosen then
		choosenMapsTable = choosen
	end
end)

addEvent("receivePoll", true)
addEventHandler("receivePoll", root,
function(value, nick, team)
	isRedoPoll = value
	if value == false then
		redoX = sw
	else
		if nick then
			redoNick = nick
		else
			redoNick = ""
		end
		if team then
			redoTeam = team
		end
		local text = "Vote by: "..redoNick
		local text1 = "\"go\" for confirm  \"no\" for deny"
		local len = dxGetTextWidth(text, 1, "default-bold")
		local len1 = dxGetTextWidth(text1, 1, "default-bold")
		if team == team1 then
			if localPlayer:getTeam() ~= team2 then
				text = "Vote by: "..redoNick
				text1 = "Waiting for reply"
				len = dxGetTextWidth(text, 1, "default-bold")
				len1 = dxGetTextWidth(text1, 1, "default-bold")
			end
		elseif team == team2 then
			if localPlayer:getTeam() ~= team1 then
				text = "Vote by: "..redoNick
				text1 = "Waiting for reply"
				len = dxGetTextWidth(text, 1, "default-bold")
				len1 = dxGetTextWidth(text1, 1, "default-bold")
			end
		end
		if len1 >= len then
			animate(0, 255, 1, 2000, function(value) redoA = value end)
			animate(0, 220, 1, 2000, function(value) redoB = value end)
			animate(sw + sw * 0.5, sw - len1 - 10, 11, 1000, function(value) redoAnimate = true redoX = value end,
			function() redoAnimate = false end)
		else
			animate(0, 255, 1, 2000, function(value) redoA = value end)
			animate(0, 220, 1, 2000, function(value) redoB = value end)
			animate(sw + sw * 0.5, sw - len - 10, 11, 1000, function(value) redoAnimate = true redoX = value end,
			function() redoAnimate = false end)
		end
	end
end)

addEvent("receivePollstopgo", true)
addEventHandler("receivePollstopgo", root,
function(value, nick, team)
	isstopgoPoll = value
	if value == false then
		stopgoX = sw
	else
		if nick then
			stopgoNick = nick
		else
			stopgoNick = ""
		end
		if team then
			stopgoTeam = team
		end
		local text = "Vote by: "..stopgoNick
		local text1 = "\"go\" for confirm  \"no\" for deny"
		local len = dxGetTextWidth(text, 1, "default-bold")
		local len1 = dxGetTextWidth(text1, 1, "default-bold")
		if team == team1 then
			if localPlayer:getTeam() ~= team2 then
				text = "Vote by: "..stopgoNick
				text1 = "Waiting for reply"
				len = dxGetTextWidth(text, 1, "default-bold")
				len1 = dxGetTextWidth(text1, 1, "default-bold")
			end
		elseif team == team2 then
			if localPlayer:getTeam() ~= team1 then
				text = "Vote by: "..stopgoNick
				text1 = "Waiting for reply"
				len = dxGetTextWidth(text, 1, "default-bold")
				len1 = dxGetTextWidth(text1, 1, "default-bold")
			end
		end
		if len1 >= len then
			animate(0, 255, 1, 2000, function(value) stopgoA = value end)
			animate(0, 220, 1, 2000, function(value) stopgoB = value end)
			animate(sw + sw * 0.5, sw - len1 - 10, 11, 1000, function(value) stopgoAnimate = true stopgoX = value end,
			function() stopgoAnimate = false end)
		else
			animate(0, 255, 1, 2000, function(value) stopgoA = value end)
			animate(0, 220, 1, 2000, function(value) stopgoB = value end)
			animate(sw + sw * 0.5, sw - len - 10, 11, 1000, function(value) stopgoAnimate = true stopgoX = value end,
			function() stopgoAnimate = false end)
		end
	end
end)

function receiveClanWarSettings(value, settings)
	isTeam3 = value

	tn1 = settings.tn1 or "" 
	tc1 = settings.tc1 or ""
	tp1 = settings.tp1 or 0
	team1 = settings.team1

	tn2 = settings.tn2 or ""
	tc2 = settings.tc2 or ""
	tp2 = settings.tp2 or 0
	team2 = settings.team2

	rounds = settings.rounds
	roundsLeft = settings.roundsLeft
	clanWarState = settings.clanWarState

	isSomeoneWon = settings.isSomeoneWon or false


	if isTeam3 then
		tn3 = settings.tn3 or ""
		tc3 = settings.tc3 or ""
		tp3 = settings.tp3 or 0
		team3 = settings.team3
		if isWindow then
			if team3Name:getText() ~= tn3 then
				team3Name:setText(tn1)
			end
			if team3Color:getText() ~= tc3 then
				team3Color:setText(tc3)
			end
			if team3Points:getText() ~= tp3 then
				team3Points:setText(tp3)
			end
		end
		if isSomeoneWon then
			if settings.winnerTeam == 1 then
				createTrayNotification(tn1.." won this round "..tn1..":"..tp1.." || "..tn2..":"..tp2.." ||"
																						..tn3..":"..tp3, "default", true)
			elseif settings.winnerTeam == 2 then
				createTrayNotification(tn2.." won this round "..tn1..":"..tp1.." || "..tn2..":"..tp2.." ||"
																						..tn3..":"..tp3, "default", true)
			elseif settings.winnerTeam == 3 then
				createTrayNotification(tn3.." won this round "..tn1..":"..tp1.." || "..tn2..":"..tp2.." ||"
																						..tn3..":"..tp3, "default", true)
			end
		end
	else
		if isSomeoneWon then
			if settings.winnerTeam == 1 then
				createTrayNotification(tn1.." won this round "..tn1..":"..tp1.." || "..tn2..":"..tp2, "default", true)
			elseif settings.winnerTeam == 2 then
				createTrayNotification(tn2.." won this round "..tn1..":"..tp1.." || "..tn2..":"..tp2, "default", true)
			end
		end
	end

	if firstSend then
		bindKey(settings.hudKey, "down", function() showHud = not showHud end)
		firstSend = false
	end

	if isWindow then
		if team1Name:getText() ~= tn1 then
			team1Name:setText(tn1)
		end
		if team1Color:getText() ~= tc1 then
			team1Color:setText(tc1)
		end
		if team1Points:getText() ~= tp1 then
			team1Points:setText(tp1)
		end
		
		if team2Name:getText() ~= tn2 then
			team2Name:setText(tn2)
		end
		if team2Color:getText() ~= tc2 then
			team2Color:setText(tc2)
		end
		if team2Points:getText() ~= tp2 then
			team2Points:setText(tp2)
		end
	end

end
addEvent("receiveClanWarSettings", true)
addEventHandler("receiveClanWarSettings", root, receiveClanWarSettings)

function sendmapnameonstart(mapname)
	currentMapName = mapname
end
addEvent("sendmapnameonstart", true)
addEventHandler("sendmapnameonstart", root, sendmapnameonstart)

addEvent("showStopTimer", true)
addEventHandler("showStopTimer", root,
function(show, value, remain)
	isShowStop = show
	isItStopped = value
	if value then
		if remain then
			stopMessage = "#FF0000"..remain
			if remain == 0 then
				stopMessage = "#FF0000STOP"
			end
		end
	else
		if remain then
			stopMessage = "#00FF00"..5-remain
			if remain > 1 then
				playSoundFrontEnd(44)
			elseif remain == 1 then
				playSoundFrontEnd(45)
			end
			if remain <= 1 then
				stopMessage = "#00FF00GO"
			end
		end
	end
end)
addEventHandler("onClientRender", root,
function()
if not getElementData(localPlayer,"stickerGarage") then
	if showHud then
		if isShowStop then
			dxDrawRectangle(0, 0, sw, sh, tocolor(0, 0, 0, 120))
			dxDrawText(stopMessage, 0, 0, sw, sh, _, 8, "pricedown", "center", "center", false, false, false, true)
		end
		if isRedoPoll and not isTeam3 then
			local color = tocolor(redoTeam:getColor()) or tocolor(255, 0, 0)
			local text = "Vote by: "..redoNick
			local text1 = "\"go\" for confirm  \"no\" for deny"
			if redoTeam == team1 then
				if localPlayer:getTeam() ~= team2 then
					text = "Vote by: "..redoNick
					text1 = "Redo the round?"
				end
			elseif redoTeam == team2 then
				if localPlayer:getTeam() ~= team1 then
					text = "Vote by: "..redoNick
					text1 = "Redo the round?"
				end
			end
			local len = dxGetTextWidth(text, 1, "default-bold")
			local len1 = dxGetTextWidth(text1, 1, "default-bold")
			text1 = text1:gsub("go", "#00FF00go#FFFFFF")
			text1 = text1:gsub("no", "#FF0000no#FFFFFF")
			if len1 >= len then
				if not redoAnimate and redoX ~= sw + sw * 0.5 then
					local summ = 10 + len1 + redoX
					if summ ~= sw then
						redoX = sw - len1 - 10
					end
				end
				dxDrawBorderedRectangle(redoX-5, sh/1.75, len1+10, 45, tocolor(0, 0, 0, redoB), color, 0.5, false)
				dxDrawText(text, redoX, (sh/1.75)+4, redoX+len1, 20, tocolor(255, 255, 255, redoA), 1, "default-bold", "left")
				dxDrawText(text1, redoX, (sh/1.75)+4+22, redoX+len1, 20, tocolor(255, 255, 255, redoA), 1, "default-bold", "center", "top", false, false, false, true)
			else
				if not redoAnimate and redoX ~= sw + sw * 0.5 then
					local summ = 10 + len + redoX
					if summ ~= sw then
						redoX = sw - len - 10
					end
				end
				dxDrawBorderedRectangle(redoX-5, sh/1.75, len+10, 45, tocolor(0, 0, 0, redoB), color, 0.5, false)
				dxDrawText(text, redoX, (sh/1.75)+4, redoX+len, 20, tocolor(255, 255, 255, redoA), 1, "default-bold", "left")
				dxDrawText(text1, redoX, (sh/1.75)+4+22, redoX+len, 20, tocolor(255, 255, 255, redoA), 1, "default-bold", "center", "top", false, false, false, true)
			end
		end
		if isstopgoPoll and not isTeam3 then
			local color = tocolor(stopgoTeam:getColor()) or tocolor(255, 0, 0)
			local text = "Vote by: "..stopgoNick
			local text1 = "\"go\" for confirm  \"no\" for deny"
			if stopgoTeam == team1 then
				if localPlayer:getTeam() ~= team2 then
					text = "Vote by: "..stopgoNick
					text1 = "Start the match?"
				end
			elseif stopgoTeam == team2 then
				if localPlayer:getTeam() ~= team1 then
					text = "Vote by: "..stopgoNick
					text1 = "Start the match?"
				end
			end
			local len = dxGetTextWidth(text, 1, "default-bold")
			local len1 = dxGetTextWidth(text1, 1, "default-bold")
			text1 = text1:gsub("go", "#00FF00go#FFFFFF")
			text1 = text1:gsub("no", "#FF0000no#FFFFFF")
			if len1 >= len then
				if not stopgoAnimate and stopgoX ~= sw + sw * 0.5 then
					local summ = 10 + len1 + stopgoX
					if summ ~= sw then
						stopgoX = sw - len1 - 10
					end
				end
				dxDrawBorderedRectangle(stopgoX-5, sh/1.75, len1+10, 45, tocolor(0, 0, 0, stopgoB), color, 0.5, false)
				dxDrawText(text, stopgoX, (sh/1.75)+4, stopgoX+len1, 20, tocolor(255, 255, 255, stopgoA), 1, "default-bold", "left")
				dxDrawText(text1, stopgoX, (sh/1.75)+4+22, stopgoX+len1, 20, tocolor(255, 255, 255, stopgoA), 1, "default-bold", "center", "top", false, false, false, true)
			else
				if not stopgoAnimate and stopgoX ~= sw + sw * 0.5 then
					local summ = 10 + len + stopgoX
					if summ ~= sw then
						stopgoX = sw - len - 10
					end
				end
				dxDrawBorderedRectangle(stopgoX-5, sh/1.75, len+10, 45, tocolor(0, 0, 0, stopgoB), color, 0.5, false)
				dxDrawText(text, stopgoX, (sh/1.75)+4, stopgoX+len, 20, tocolor(255, 255, 255, stopgoA), 1, "default-bold", "left")
				dxDrawText(text1, stopgoX, (sh/1.75)+4+22, stopgoX+len, 20, tocolor(255, 255, 255, stopgoA), 1, "default-bold", "center", "top", false, false, false, true)
			end
		end		
		local count1, count2, count3 = 0, 0, 0
		local len1, len2, len3 = 0, 0, 0
		local sr, sg = 255, 255
		if clanWarState == "Free" then
			sr, sg = 255, 0
		elseif clanWarState == "Live" then
			sr, sg = 0, 255
		else
			sr, sg = 255, 165
		end
		if isTeam3 then
			if isElement(team1) then count1 = getAlivePlayersInTeamCount(team1) end
			if isElement(team2) then count2 = getAlivePlayersInTeamCount(team2) end
			if isElement(team3) then count3 = getAlivePlayersInTeamCount(team3) end

			len1 = dxGetTextWidth("("..count1..") "..tn1..": "..tp1, 1, "default-bold")
			len2 = dxGetTextWidth("("..count2..") "..tn2..": "..tp2, 1, "default-bold")
			len3 = dxGetTextWidth("("..count3..") "..tn3..": "..tp3, 1, "default-bold")
			local len = math.max(len1, len2, len3) + 25
			local panelX = sw - 15 - len
			local panelY = (sh/2.1) - 8

			-- Mesmo painel escuro arredondado do modo 2 times, só que mais alto
			-- pra caber a terceira linha.
			dxDrawRoundedRectangle(panelX-1, panelY-1, len+2, 94, tocolor(70, 80, 100, 130))
			dxDrawRoundedRectangle(panelX, panelY, len, 92, tocolor(14, 16, 22, 220))
			dxDrawText(clanWarState, panelX, panelY+2, panelX+len, panelY+20, tocolor(sr, sg, 0), 1, "default-bold", "center", "center")
			dxDrawText("("..count1..") "..tc1..tn1.."#96A0AF: "..tp1.."\n"
					 .."("..count2..") "..tc2..tn2.."#96A0AF: "..tp2.."\n"
					 .."("..count3..") "..tc3..tn3.."#96A0AF: "..tp3.."\n"
					, panelX+10, panelY+22, panelX+len-10, panelY+92,_, 1.0, "default-bold", "left", "top", false, false, false, true)
		else
			if isElement(team1) then count1 = getAlivePlayersInTeamCount(team1) end
			if isElement(team2) then count2 = getAlivePlayersInTeamCount(team2) end

			local r, g, b = 225, 45, 45 -- vermelho (desvantagem), mesma paleta do rank F

			if localPlayer:getTeam() == team1 then
				if count1 >= count2 then
					r, g, b = 80, 210, 110 -- verde (vantagem), mesma paleta do rank B
				end
			elseif localPlayer:getTeam() == team2 then
				if count2 >= count1 then
					r, g, b = 80, 210, 110
				end
			end

			len1 = dxGetTextWidth(tn1..": "..tp1, 1, "default-bold")
			len2 = dxGetTextWidth(tn2..": "..tp2, 1, "default-bold")
			local len = math.max(len1, len2) + 25
			local panelX = sw - 15 - len
			local panelY = (sh/2.1) - 8

			-- Painel único, escuro e arredondado, com borda sutil - mesmo
			-- acabamento visual do placar principal (F2).
			dxDrawRoundedRectangle(panelX-1, panelY-1, len+2, 74, tocolor(70, 80, 100, 130))
			dxDrawRoundedRectangle(panelX, panelY, len, 72, tocolor(14, 16, 22, 220))
			-- Barra de vantagem/desvantagem no topo do painel
			dxDrawRoundedRectangle(panelX, panelY, len, 20, tocolor(r, g, b, 110))

			dxDrawText(clanWarState, panelX, panelY+2, panelX+len, panelY+20, tocolor(sr, sg, 0), 1, "default-bold", "center", "center")
			dxDrawText(count1.." #96A0AFvs "..count2, panelX, panelY+22, panelX+len, panelY+40, tocolor(235,238,245,255), 1, "default-bold", "center", "center", false, false, false, true)
			dxDrawText(tc1..tn1.."#96A0AF: "..tp1.."\n"
					..tc2..tn2.."#96A0AF: "..tp2
					, panelX+10, panelY+42, panelX+len-10, panelY+72,_, 1.0, "default-bold", "left", "center", false, false, false, true)
		end
	end
end	
end)
--
function window()
	local w, h = 600, 330
	if isWindow then
		if isElement(window) then window:destroy() end
		isWindow = false
		showCursor(false)
		guiSetInputEnabled(false)
		for k in pairs(pickerTable) do
			closePicker(k)
		end
	else
		window = guiCreateWindow(sw/2-w/2, sh/2-h/2, w, h, "Settings", false)
		
		
tab1,tab1lbl = guiCreateCheckBox(10,25,100,20,"Main Settings",true,false,window)
tab2,tab2lbl = guiCreateCheckBox(120,25,60,20,"Maps",false,false,window)
addEventHandler('onClientGUIClick',tab1, function()
guiCheckBoxSetSelected(tab1,true)
guiCheckBoxSetSelected(tab2,false)
guiSetVisible(searchMaps, false)
guiSetVisible(allMapsGridList, false)
guiSetVisible(choosenMapsGridList, false)
guiSetVisible(choosenMapsUpdateButton, false)

guiSetVisible(team1Label, true)
guiSetVisible(team1NameLabel, true)
guiSetVisible(team1Name, true)
guiSetVisible(team1ColorLabel, true)
guiSetVisible(team1Color, true)
guiSetVisible(team1ColorPicker, true)
guiSetVisible(team1PointsLabel, true)
guiSetVisible(team1removeButton, true)
guiSetVisible(team1addButton, true)
guiSetVisible(team1Points, true)
guiSetVisible(team1Players, true)
guiSetVisible(team1SaveButton, true)
guiSetVisible(team2Label, true)
guiSetVisible(team2NameLabel, true)
guiSetVisible(team2Name, true)
guiSetVisible(team2ColorLabel, true)
guiSetVisible(team2Color, true)
guiSetVisible(team2ColorPicker, true)
guiSetVisible(team2PointsLabel, true)
guiSetVisible(team2removeButton, true)
guiSetVisible(team2addButton, true)
guiSetVisible(team2Points, true)
guiSetVisible(team2Players, true)
guiSetVisible(team2SaveButton, true)
if isTeam3 then
guiSetVisible(team3Label, true)
guiSetVisible(team3NameLabel, true)
guiSetVisible(team3Name, true)
guiSetVisible(team3ColorLabel, true)
guiSetVisible(team3Color, true)
guiSetVisible(team3ColorPicker, true)
guiSetVisible(team3PointsLabel, true)
guiSetVisible(team3removeButton, true)
guiSetVisible(team3addButton, true)
guiSetVisible(team3Points, true)
guiSetVisible(team3Players, true)
guiSetVisible(team3SaveButton, true)
end
end,false)

addEventHandler('onClientGUIClick',tab2, function()
guiCheckBoxSetSelected(tab1,false)
guiCheckBoxSetSelected(tab2,true)
guiSetVisible(searchMaps, true)
guiSetVisible(allMapsGridList, true)
guiSetVisible(choosenMapsGridList, true)
guiSetVisible(choosenMapsUpdateButton, true)
guiSetVisible(team1Label, false)
guiSetVisible(team1NameLabel, false)
guiSetVisible(team1Name, false)
guiSetVisible(team1ColorLabel, false)
guiSetVisible(team1Color, false)
guiSetVisible(team1ColorPicker, false)
guiSetVisible(team1PointsLabel, false)
guiSetVisible(team1removeButton, false)
guiSetVisible(team1addButton, false)
guiSetVisible(team1Points, false)
guiSetVisible(team1Players, false)
guiSetVisible(team1SaveButton, false)
guiSetVisible(team2Label, false)
guiSetVisible(team2NameLabel, false)
guiSetVisible(team2Name, false)
guiSetVisible(team2ColorLabel, false)
guiSetVisible(team2Color, false)
guiSetVisible(team2ColorPicker, false)
guiSetVisible(team2PointsLabel, false)
guiSetVisible(team2removeButton, false)
guiSetVisible(team2addButton, false)
guiSetVisible(team2Points, false)
guiSetVisible(team2Players, false)
guiSetVisible(team2SaveButton, false)
if isTeam3 then
guiSetVisible(team3Label, false)
guiSetVisible(team3NameLabel, false)
guiSetVisible(team3Name, false)
guiSetVisible(team3ColorLabel, false)
guiSetVisible(team3Color, false)
guiSetVisible(team3ColorPicker, false)
guiSetVisible(team3PointsLabel, false)
guiSetVisible(team3removeButton, false)
guiSetVisible(team3addButton, false)
guiSetVisible(team3Points, false)
guiSetVisible(team3Players, false)
guiSetVisible(team3SaveButton, false)
end
end,false)
addEventHandler('onClientGUIClick',tab1lbl, function()
guiCheckBoxSetSelected(tab1,true)
guiCheckBoxSetSelected(tab2,false)
guiSetVisible(searchMaps, false)
guiSetVisible(allMapsGridList, false)
guiSetVisible(choosenMapsGridList, false)
guiSetVisible(choosenMapsUpdateButton, false)

guiSetVisible(team1Label, true)
guiSetVisible(team1NameLabel, true)
guiSetVisible(team1Name, true)
guiSetVisible(team1ColorLabel, true)
guiSetVisible(team1Color, true)
guiSetVisible(team1ColorPicker, true)
guiSetVisible(team1PointsLabel, true)
guiSetVisible(team1removeButton, true)
guiSetVisible(team1addButton, true)
guiSetVisible(team1Points, true)
guiSetVisible(team1Players, true)
guiSetVisible(team1SaveButton, true)
guiSetVisible(team2Label, true)
guiSetVisible(team2NameLabel, true)
guiSetVisible(team2Name, true)
guiSetVisible(team2ColorLabel, true)
guiSetVisible(team2Color, true)
guiSetVisible(team2ColorPicker, true)
guiSetVisible(team2PointsLabel, true)
guiSetVisible(team2removeButton, true)
guiSetVisible(team2addButton, true)
guiSetVisible(team2Points, true)
guiSetVisible(team2Players, true)
guiSetVisible(team2SaveButton, true)
if isTeam3 then
guiSetVisible(team3Label, true)
guiSetVisible(team3NameLabel, true)
guiSetVisible(team3Name, true)
guiSetVisible(team3ColorLabel, true)
guiSetVisible(team3Color, true)
guiSetVisible(team3ColorPicker, true)
guiSetVisible(team3PointsLabel, true)
guiSetVisible(team3removeButton, true)
guiSetVisible(team3addButton, true)
guiSetVisible(team3Points, true)
guiSetVisible(team3Players, true)
guiSetVisible(team3SaveButton, true)
end
end,false)

addEventHandler('onClientGUIClick',tab2lbl, function()
guiCheckBoxSetSelected(tab1,false)
guiCheckBoxSetSelected(tab2,true)
guiSetVisible(searchMaps, true)
guiSetVisible(allMapsGridList, true)
guiSetVisible(choosenMapsGridList, true)
guiSetVisible(choosenMapsUpdateButton, true)
guiSetVisible(team1Label, false)
guiSetVisible(team1NameLabel, false)
guiSetVisible(team1Name, false)
guiSetVisible(team1ColorLabel, false)
guiSetVisible(team1Color, false)
guiSetVisible(team1ColorPicker, false)
guiSetVisible(team1PointsLabel, false)
guiSetVisible(team1removeButton, false)
guiSetVisible(team1addButton, false)
guiSetVisible(team1Points, false)
guiSetVisible(team1Players, false)
guiSetVisible(team1SaveButton, false)
guiSetVisible(team2Label, false)
guiSetVisible(team2NameLabel, false)
guiSetVisible(team2Name, false)
guiSetVisible(team2ColorLabel, false)
guiSetVisible(team2Color, false)
guiSetVisible(team2ColorPicker, false)
guiSetVisible(team2PointsLabel, false)
guiSetVisible(team2removeButton, false)
guiSetVisible(team2addButton, false)
guiSetVisible(team2Points, false)
guiSetVisible(team2Players, false)
guiSetVisible(team2SaveButton, false)
if isTeam3 then
guiSetVisible(team3Label, false)
guiSetVisible(team3NameLabel, false)
guiSetVisible(team3Name, false)
guiSetVisible(team3ColorLabel, false)
guiSetVisible(team3Color, false)
guiSetVisible(team3ColorPicker, false)
guiSetVisible(team3PointsLabel, false)
guiSetVisible(team3removeButton, false)
guiSetVisible(team3addButton, false)
guiSetVisible(team3Points, false)
guiSetVisible(team3Players, false)
guiSetVisible(team3SaveButton, false)
end
end,false)


		--tabPanel = GuiTabPanel.create(10, 25, w-20, h-30, false, window)

		--mainTab = GuiTab.create("Main", tabPanel)
		--mapsTab = GuiTab.create("Maps", tabPanel)
		-- settingsTab = GuiTab.create("Settings", tabPanel)

		-- #MAIN TAB
		if not isTeam3 then
			local startX = 50 --
			team1Label = GuiLabel.create(startX, 55, 45, 20, "Team 1:", false, window)
			team1NameLabel = GuiLabel.create(startX, 80, 50, 20, "Tag:", false, window)
			team1Name = guiCreateEdit(startX + 60, 80, 120, 20, tn1, false, window)
			team1ColorLabel = GuiLabel.create(startX, 105, 50, 20, "Color:", false, window)
			team1Color = guiCreateEdit(startX + 60, 105, 90, 20, tc1, false, window)
			team1ColorPicker = guiCreateButton(startX + 150, 105, 30, 20, "#", false, window)
			team1PointsLabel = GuiLabel.create(startX, 130, 50, 20, "Points:", false, window)
			team1removeButton = guiCreateButton(startX + 60, 130, 30, 20, "-", false, window)
			team1addButton = guiCreateButton(startX + 150, 130, 30, 20, "+", false, window)
			team1Points = guiCreateEdit(startX + 90, 130, 60, 20, tp1, false, window)
			team1Points:setReadOnly(true)
			team1Players = GuiGridList.create(startX, 160, 180, 130, false, window)
			team1Players:addColumn("Players", 0.85)

			if team1 and isElement(team1) then
				for i, v in ipairs(team1:getPlayers()) do
					team1Players:addRow(newNick(v:getName()))
				end
			end

			team1SaveButton = guiCreateButton(startX, 295, 180, 20, "Save", false, window)

			team2Label = GuiLabel.create(startX + 300, 55, 45, 20, "Team 2:", false, window)
			team2NameLabel = GuiLabel.create(startX + 300, 80, 50, 20, "Tag:", false, window)
			team2Name = guiCreateEdit(startX + 360, 80, 120, 20, tn2, false, window)
			team2ColorLabel = GuiLabel.create(startX + 300, 105, 50, 20, "Color:", false, window)
			team2Color = guiCreateEdit(startX + 360, 105, 90, 20, tc2, false, window)
			team2ColorPicker = guiCreateButton(startX + 450, 105, 30, 20, "#", false, window)
			team2PointsLabel = GuiLabel.create(startX + 300, 130, 50, 20, "Points:", false, window)
			team2removeButton = guiCreateButton(startX + 360, 130, 30, 20, "-", false, window)
			team2addButton = guiCreateButton(startX + 450, 130, 30, 20, "+", false, window)
			team2Points = guiCreateEdit(startX + 390, 130, 60, 20, tp2, false, window)
			team2Points:setReadOnly(true)
			team2Players = GuiGridList.create(startX + 300, 160, 180, 130, false, window)
			team2Players:addColumn("Players", 0.85)

			if team2 and isElement(team2) then
				for i, v in ipairs(team2:getPlayers()) do
					team2Players:addRow(newNick(v:getName()))
				end
			end

			team2SaveButton = guiCreateButton(startX+300, 295, 180, 20, "Save", false, window)
		else
			local startX = 10
			team1Label = GuiLabel.create(startX, 55, 45, 20, "Team 1:", false, window)
			team1NameLabel = GuiLabel.create(startX, 80, 50, 20, "Tag:", false, window)
			team1Name = guiCreateEdit(startX + 60, 80, 120, 20, tn1, false, window)
			team1ColorLabel = GuiLabel.create(startX, 105, 50, 20, "Color:", false, window)
			team1Color = guiCreateEdit(startX + 60, 105, 90, 20, tc1, false, window)
			team1ColorPicker = guiCreateButton(startX + 150, 105, 30, 20, "#", false, window)
			team1PointsLabel = GuiLabel.create(startX, 130, 50, 20, "Points:", false, window)
			team1removeButton = guiCreateButton(startX + 60, 130, 30, 20, "-", false, window)
			team1addButton = guiCreateButton(startX + 150, 130, 30, 20, "+", false, window)
			team1Points = guiCreateEdit(startX + 90, 130, 60, 20, tp1, false, window)
			team1Points:setReadOnly(true)
			team1Players = GuiGridList.create(startX, 160, 180, 130, false, window)
			team1Players:addColumn("Players", 0.85)

			if team1 and isElement(team1) then
				for i, v in ipairs(team1:getPlayers()) do
					team1Players:addRow(newNick(v:getName()))
				end
			end

			team1SaveButton = guiCreateButton(startX, 290, 180, 20, "Save", false, window)

			team2Label = GuiLabel.create(startX + 190, 55, 45, 20, "Team 2:", false, window)
			team2NameLabel = GuiLabel.create(startX + 190, 80, 50, 20, "Tag:", false, window)
			team2Name = guiCreateEdit(startX + 250, 80, 120, 20, tn2, false, window)
			team2ColorLabel = GuiLabel.create(startX + 190, 105, 50, 20, "Color:", false, window)
			team2Color = guiCreateEdit(startX + 250, 105, 90, 20, tc2, false, window)
			team2ColorPicker = guiCreateButton(startX + 340, 105, 30, 20, "#", false, window)
			team2PointsLabel = GuiLabel.create(startX + 190, 130, 50, 20, "Points:", false, window)
			team2removeButton = guiCreateButton(startX + 250, 130, 30, 20, "-", false, window)
			team2addButton = guiCreateButton(startX + 340, 130, 30, 20, "+", false, window)
			team2Points = guiCreateEdit(startX + 280, 130, 60, 20, tp2, false, window)
			team2Points:setReadOnly(true)
			team2Players = GuiGridList.create(startX + 190, 160, 180, 130, false, window)
			team2Players:addColumn("Players", 0.85)

			if team2 and isElement(team2) then
				for i, v in ipairs(team2:getPlayers()) do
					team2Players:addRow(newNick(v:getName()))
				end
			end

			team2SaveButton = guiCreateButton(startX + 190, 290, 180, 20, "Save", false, window)

			team3Label = GuiLabel.create(startX + 380, 55, 45, 20, "Team 3:", false, window)
			team3NameLabel = GuiLabel.create(startX + 380, 80, 50, 20, "Tag:", false, window)
			team3Name = guiCreateEdit(startX + 440, 80, 120, 20, tn3, false, window)
			team3ColorLabel = GuiLabel.create(startX + 380, 105, 50, 20, "Color:", false, window)
			team3Color = guiCreateEdit(startX + 440, 105, 90, 20, tc3, false, window)
			team3ColorPicker = guiCreateButton(startX + 530, 105, 30, 20, "#", false, window)
			team3PointsLabel = GuiLabel.create(startX + 380, 130, 50, 20, "Points:", false, window)
			team3removeButton = guiCreateButton(startX + 440, 130, 30, 20, "-", false, window)
			team3addButton = guiCreateButton(startX + 530, 130, 30, 20, "+", false, window)
			team3Points = guiCreateEdit(startX + 470, 130, 60, 20, tp3, false, window)
			team3Points:setReadOnly(true)
			team3Players = GuiGridList.create(startX + 380, 160, 180, 130, false, window)
			team3Players:addColumn("Players", 0.85)

			if team3 and isElement(team3) then
				for i, v in ipairs(team3:getPlayers()) do
					team3Players:addRow(newNick(v:getName()))
				end
			end

			team3SaveButton = guiCreateButton(startX + 380, 290, 180, 20, "Save", false, window)
		end

		-- #MAPS TAB
			searchMaps = guiCreateEdit(25, 55, w/2.3, 20, "", false, window)
			allMapsGridList = GuiGridList.create(25, 80, w/2.3, 235, false, window)
			allMapsGridList:addColumn("Maps", 0.85)

			for i, v in ipairs(mapsTable) do
				local row = allMapsGridList:addRow(v.name)
				allMapsGridList:setItemData(row, 1, v.map)
			end

			choosenMapsGridList = GuiGridList.create(70+w/2.3, 55, w/2.3, 235, false, window)
			choosenMapsUpdateButton = guiCreateButton(70+w/2.3, 295, w/2.3, 20, "Update maps", false, window)
			choosenMapsGridList:addColumn("Choosen maps", 0.85)

			for i, v in ipairs(choosenMapsTable) do
				local row = choosenMapsGridList:addRow(v.name)
				choosenMapsGridList:setItemData(row, 1, v.map)
			end

		guiSetVisible(searchMaps, false)
		guiSetVisible(allMapsGridList, false)
		guiSetVisible(choosenMapsGridList, false)
		guiSetVisible(choosenMapsUpdateButton, false)
		isWindow = true
		showCursor(true)
		guiSetInputEnabled(true)
	end
end
addEvent("openSettingsWindow", true)
addEventHandler("openSettingsWindow", root, window)

addEventHandler("onClientGUIChanged", root,
function()
	if source == searchMaps then
		local text = (source:getText()):lower()
		allMapsGridList:clear()
		for i, v in ipairs(mapsTable) do
			if string.find((v.name):lower(), text, 1, true) then
				local row = allMapsGridList:addRow(v.name)
				allMapsGridList:setItemData(row, 1, v.map)
			end
		end
	end
end)

addEventHandler("onClientGUIClick", root,
function()
	if source == team1ColorPicker then
		openPicker(team1ColorPicker, tc1, tn1.."  color")
	elseif source == team2ColorPicker then
		openPicker(team2ColorPicker, tc2, tn2.."  color")
	elseif source == team3ColorPicker then
		openPicker(team3ColorPicker, tc3, tn3.."  color")
	end

	if source == team1removeButton then
		if team1Points:getText() - 1 >= 0 then
			team1Points:setText(team1Points:getText() - 1)
		end
	elseif source == team2removeButton then
		if team2Points:getText() - 1 >= 0 then
			team2Points:setText(team2Points:getText() - 1)
		end
	elseif source == team3removeButton then
		if team3Points:getText() - 1 >= 0 then
			team3Points:setText(team3Points:getText() - 1)
		end
	elseif source == team1addButton then
		team1Points:setText(team1Points:getText() + 1)
	elseif source == team2addButton then
		team2Points:setText(team2Points:getText() + 1)
	elseif source == team3addButton then
		team3Points:setText(team3Points:getText() + 1)
	end

	
	if source == team1SaveButton then
		local name, color, points = team1Name:getText(), team1Color:getText(), team1Points:getText()
		if getColorFromString(color) and string.len(color) == 7 then
			triggerServerEvent("updateTeamSettings", localPlayer, 1, name, color, points)
		else
			outputChatBox("Wrong color", 255, 0, 0)
		end
	elseif source == team2SaveButton then
		local name, color, points = team2Name:getText(), team2Color:getText(), team2Points:getText()
		if getColorFromString(color) and string.len(color) == 7 then
			triggerServerEvent("updateTeamSettings", localPlayer, 2, name, color, points)
		else
			outputChatBox("Wrong color", 255, 0, 0)
		end
	elseif source == team3SaveButton then
		local name, color, points = team3Name:getText(), team3Color:getText(), team3Points:getText()
		if getColorFromString(color) and string.len(color) == 7 then
			triggerServerEvent("updateTeamSettings", localPlayer, 3, name, color, points)
		else
			outputChatBox("Wrong color", 255, 0, 0)
		end
	end

	if source == choosenMapsUpdateButton then
		local count = choosenMapsGridList:getRowCount()
		if count > 0 then
			if count == 2 or count == 4 then
				local maps = {}
				for i = 0, count-1 do
					local text = choosenMapsGridList:getItemText(i, 1)
					local data = choosenMapsGridList:getItemData(i, 1)
					maps[i+1] = {["map"] = data, ["name"] = text}
				end
				triggerServerEvent("updateChoosenMaps", localPlayer, maps, 0)
			else
				if isTeam3 then
					if count ~= 4 then
						outputChatBox("#ffffff* [ERROR] Maps count should be #FF00004#ffffff.", 255, 0, 0, true)
					end
				else
					outputChatBox("#ffffff* [ERROR] Maps count should be #FF00002 #ffffffor #FF00004#ffffff.", 255, 0, 0, true)
				end
			end
		else
			triggerServerEvent("updateChoosenMaps", localPlayer, {}, 0)
		end
	end
end)

addEventHandler("onClientGUIDoubleClick", root,
function(button)
	if source == allMapsGridList then
		if button == "left" then
			local item = source:getSelectedItem()
			local text = source:getItemText(item, 1)
			local data = source:getItemData(item, 1)
			local row = choosenMapsGridList:addRow(text)
			choosenMapsGridList:setItemData(row, 1, data)
		end
	elseif source == choosenMapsGridList then
		if button == "left" then
			local item = source:getSelectedItem()
			source:removeRow(item)
		end
	end
end)

addEvent("onColorPickerOK")
addEventHandler("onColorPickerOK", root,
function(element, color)
	if element == team1ColorPicker then
		team1Color:setText(color)
	elseif element == team2ColorPicker then
		team2Color:setText(color)
	elseif element == team3ColorPicker then
		team3Color:setText(color)
	end
end)

addEvent("onColorPickerChange")
addEventHandler("onColorPickerChange", root,
function(element, color, r, g, b)
	local vehicle = localPlayer:getOccupiedVehicle()
	if isElement(vehicle) then
		setVehicleColor(vehicle, r, g, b)
	end
end)

triggerServerEvent("requestClanWarSettings", localPlayer)
triggerServerEvent("requestMaps", localPlayer)

function setTimeForCw(cmd,h, m,type)
	if tonumber(h) ~= nil then
		if tonumber(h) > 23 then
			h = "00"
		elseif tonumber(h) < 0 then
			h = "00"
		end
		if tonumber(m) ~= nil then
			if tonumber(m) > 59 then
				m = "59"
			elseif tonumber(m) < 0 then
				m = "00"
			end
			setTime(h, m)
			setMinuteDuration(6000000)
			local m = string.format("%02d", m)
			if not type then
			--outputChatBox("#ffffff* Time set to "..h..":"..m..".", 255, 255, 255, true)
			end
			cst = true
			cst_h = tonumber(h)
			cst_m = tonumber(m)
		else
			setTime(h, 0)
			setMinuteDuration(6000000)
			if not type then
			--outputChatBox("#ffffff* Time set to #CCA95A"..h..":".."00"..".", 255, 255, 255, true)
			end
			cst = true
			cst_h = tonumber(h)
			cst_m = 0
		end
	else
		if cst then
			outputChatBox("#ffffff* Time set by the map.", 255, 255, 255, true)			
			cst = false
			cst_h, cst_m = nil, nil
			setTime(cst_def_h or 12, cst_def_m or 0)
		end
	end
end
addCommandHandler("st", setTimeForCw)
addCommandHandler("cst", setTimeForCw)
-- block 8 9 16 19 24
function setWeatherForCw(cmd, id,type)
	if exports["cw"]:getclanWarStateForClient() == "Live" then
		if getElementData(localPlayer,"state") == "alive" then
			outputChatBox("#ffffff* You can't change the weather when the CW is Live.", 255, 255, 255, true)
		else
			if tonumber(id) ~= nil then
				if tonumber(id) > 25 then
					id = 25
				elseif tonumber(id) == 8 or tonumber(id) == 9 or tonumber(id) == 16 or tonumber(id) == 19 or tonumber(id) == 24 then
					id = 0
				elseif tonumber(id) < 0 then
					id = 0
				end
				setWeather(id)
				if not type then
				--outputChatBox("#ffffff* Weather set to #CCA95A"..id..".", 255, 255, 255, true)
				end
				csw = true
				csw_id = tonumber(id)
			else
				if csw then
					outputChatBox("#ffffff* Weather set by the map.", 255, 255, 255, true)
					csw = false
					csw_id = nil
					setWeather(csw_def_id or 0)
				end
			end
		end
	else
		if tonumber(id) ~= nil then
			if tonumber(id) > 25 then
				id = 25
			elseif tonumber(id) == 8 or tonumber(id) == 9 or tonumber(id) == 16 or tonumber(id) == 19 or tonumber(id) == 24 then
				id = 0
			elseif tonumber(id) < 0 then
				id = 0
			end
			setWeather(id)
			if not type then
			--outputChatBox("#ffffff* Weather set to #CCA95A"..id..".", 255, 255, 255, true)
			end
			csw = true
			csw_id = tonumber(id)
		else
			if csw then
				outputChatBox("#ffffff* Weather set by the map.", 255, 255, 255, true)
				csw = false
				csw_id = nil
				setWeather(csw_def_id or 0)
			end
		end
	end	
end
addCommandHandler("sw", setWeatherForCw)
addCommandHandler("csw", setWeatherForCw)
--
function getclanWarStateForClient()
	return clanWarState or "Free"
end
--
function getCurrentMapNameForClient()
	return currentMapName or "[DD]"
end
--
function getIsCwStopped()
	return isItStopped or false
end
--
addEvent("onClientMapStarting", true)
addEventHandler("onClientMapStarting", root,
function()
	cst_def_h, cst_def_m = getTime()
	csw_def_id = getWeather()
	if cst then
		setTime(cst_h, cst_h)
		setMinuteDuration(6000000)
	end
	if csw then
		setWeather(csw_id)
	end
end, true, "low")

--function onPreFunction(sourceResource)
--	local resname = sourceResource and sourceResource:getName()
--	if resname ~= "checker" then return "skip" end
--end
--addDebugHook("preFunction", onPreFunction, {"addDebugHook"})

-- Kill System

local clearKillTime = 8
bildirimci = true
addEventHandler("onClientVehicleCollision", root,
function(hitElement)
	if hitElement then
		theCar = getPedOccupiedVehicle(getLocalPlayer())
		if theCar then
			if getElementType(hitElement) == "vehicle" and source == theCar then
				local hitPlayer = getVehicleOccupant(hitElement)
				if hitPlayer then
					local myKiller = getElementData(getLocalPlayer(), "myKiller")
					if isTimer(clearKillerTimer) then killTimer(clearKillerTimer) end
					if myKiller == nil or myKiller == hitPlayer then
						setElementData(getLocalPlayer(), "myKiller", hitPlayer)
						clearKillerTimer = setTimer(clearKill, clearKillTime*1000, 1)
					elseif myKiller ~= hitPlayer then
						setElementData(getLocalPlayer(), "myKiller", hitPlayer)
						setElementData(getLocalPlayer(), "myAssister", myKiller)
						clearKillerTimer = setTimer(clearKill, clearKillTime*1000, 1)
					end
				end
			end
		end
	end
end)
--
function clearKill()
	local theCar = getPedOccupiedVehicle(getLocalPlayer())
	if not theCar then return end
	if isVehicleOnGround(theCar) == true and isElementInWater(theCar) == false and getElementHealth(theCar)>250 then
		setElementData(getLocalPlayer(), "myKiller", nil)
		setElementData(getLocalPlayer(), "myAssister", nil)
	else
		setTimer(clearKill, 300, 1)
	end
end
-- (Discord Rich Presence removido)
-- cw end screen
endfont = guiCreateFont( "team/lib/font.ttf", 20 ) 
npcopfont = guiCreateFont( "team/lib/font.ttf", 13 ) 
listfont = guiCreateFont( "team/lib/font.ttf", 10 ) 
--
function cwendwindow()
local screenW, screenH = guiGetScreenSize()
yuk = 300
gen = 600
cwstats = guiCreateWindow((screenW/2) - gen/2, (screenH/2) - yuk/2, gen, yuk, "CW Results", false)
statsicon = guiCreateStaticImage(20,30,30,30,"team/lib/stats.png",false,cwstats)
statslabel = guiCreateLabel(55,30,150,30,"Statistics",false,cwstats)
guiSetFont(statslabel,endfont)
statslabellist = guiCreateLabel(20,70,280,330,"xxxxx: - xx kills xx deaths xx assists\nxxxxx: - xx kills xx deaths xx assists\nxxxxx: - xx kills xx deaths xx assists\nxxxxx: - xx kills xx deaths xx assists\nxxxxx: - xx kills xx deaths xx assists\nxxxxx: - xx kills xx deaths xx assists\nxxxxx: - xx kills xx deaths xx assists\nxxxxx: - xx kills xx deaths xx assists\n ",false,cwstats)
guiSetFont(statslabellist,listfont)
teamlabel1 = guiCreateLabel(315,30,100,30,tn1,false,cwstats)
teamicon = guiCreateStaticImage(420,30,30,30,"team/lib/vs.png",false,cwstats)
teamlabel2 = guiCreateLabel(455,30,100,30,tn2,false,cwstats)
guiSetFont(teamlabel1,endfont)
guiSetFont(teamlabel2,endfont)
guiLabelSetHorizontalAlign(teamlabel1,"right")
guiLabelSetHorizontalAlign(teamlabel2,"left")
teamlabelstats1 = guiCreateLabel(315,70,100,100,tp1.." wins\nxx kills\nxx deaths\nxx assist\n\nBest : xxx",false,cwstats)
teamlabelstats2 = guiCreateLabel(455,70,100,100,tp2.." wins\nxx kills\nxx deaths\nxx assist\n\nBest : xxx",false,cwstats)
guiSetFont(teamlabelstats1,listfont)
guiSetFont(teamlabelstats2,listfont)
guiLabelSetHorizontalAlign(teamlabelstats1,"right")
guiLabelSetHorizontalAlign(teamlabelstats2,"left")
--npclabel = guiCreateLabel(315,185,240,30,"NPC : xxxx",false,cwstats)
--oplabel = guiCreateLabel(315,205,240,50,"MVP : xxxx",false,cwstats)
--guiSetFont(npclabel,listfont)
--guiSetFont(oplabel,npcopfont)
--guiLabelSetHorizontalAlign(npclabel,"center")
--guiLabelSetHorizontalAlign(oplabel,"center")
closelabel = guiCreateLabel(0,265,600,100,"This screen will be closed in 15 seconds.\nPress X to close now.",false,cwstats)
guiSetFont(closelabel,listfont)
guiLabelSetHorizontalAlign(closelabel,"center")
end
--
closetimer = nil
function closestatswindowfunc() 
	destroyElement(cwstats) 
	if isTimer(closetimer) then
		killTimer(closetimer)
	end	
	unbindKey("x","down",closestatswindowfunc)
end
--
addEvent( "openCWResultspage", true )
addEventHandler( "openCWResultspage", localPlayer, function(list,t1,t2)
	setTimer(function()
		cwendwindow()
		--
		guiSetText(statslabellist,list)
		guiSetText(teamlabel1,tn1)
		guiSetText(teamlabel2,tn2)
		guiSetText(teamlabelstats1,string.gsub(t1, "#%x%x%x%x%x%x", ""))
		guiSetText(teamlabelstats2,string.gsub(t2, "#%x%x%x%x%x%x", ""))
		--guiSetText(npclabel,"NPC : "..npc)
		--guiSetText(oplabel,"MVP : "..mvp)
		--
		closetimer = setTimer(closestatswindowfunc,15000,1)
		bindKey("x","down",closestatswindowfunc)
	end,2000,1)
end)
--
addEvent("checkForCheats", true)
addEventHandler("checkForCheats", root,
function()
    if isWorldSpecialPropertyEnabled("aircars") then
		setElementData(localPlayer,"FPS\r", 66)
		setElementData(localPlayer,"neyaptinsen", "aircars")
    end
    if isWorldSpecialPropertyEnabled("hovercars") then
		setElementData(localPlayer,"FPS\r", 66)
		setElementData(localPlayer,"neyaptinsen", "hovercars")
    end
    if isWorldSpecialPropertyEnabled("extrajump") then
		setElementData(localPlayer,"FPS\r", 66)
		setElementData(localPlayer,"neyaptinsen", "extrajump")
    end
    if isWorldSpecialPropertyEnabled("extrabunny") then
		setElementData(localPlayer,"FPS\r", 66)
		setElementData(localPlayer,"neyaptinsen", "extrabunny")
    end
end)
--
addEvent("checkForGravityAndSpeed", true)
addEventHandler("checkForGravityAndSpeed", root,
function()
	local gravity = getGravity() or false
	if gravity then
		local formatted_gravity = string.format("%.3f", gravity) or false
		if formatted_gravity then
			if tonumber(formatted_gravity) ~= 0.008 then
				setElementData(localPlayer,"FPS\r", 66)
				setElementData(localPlayer,"neyaptinsen", "setGravity")
			end
		end
	end
	local gamespeed = getGameSpeed() or false
	if gamespeed then
		if tonumber(gamespeed) ~= 1 then
			setElementData(localPlayer,"FPS\r", 66)
			setElementData(localPlayer,"neyaptinsen", "setGameSpeed")
		end
	end
end)