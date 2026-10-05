setServerConfigSetting( "max_player_triggered_events_per_interval", "100", true )
--
function processPlayerTriggerEventThreshold()
    kickPlayer(source, "Event spam")
end
addEventHandler("onPlayerTriggerEventThreshold", root, processPlayerTriggerEventThreshold)
--
-- addEvent("breakTheObject",true)
-- addEventHandler("breakTheObject",root,function(object)
	-- for i, player in ipairs(getElementsByType("player")) do
		-- triggerClientEvent(player,"breakTheObject_c",player,object)
	-- end
-- end)


---------------------------------------


-- addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),
-- function ()
	-- setElementData(getRootElement(),"breakableObjectSyncTrustAttacker",get("breakableobjectsync.TrustObjectAttacker"),true)
-- end)

-- addEvent("objSBreak",true)
-- addEventHandler("objSBreak",getRootElement(),
-- function (obj)
	-- if client == source then
		-- triggerEvent("onObjectBreak",obj,client)
	-- end
-- end)

-- addEvent("onObjectBreak",false)
-- addEventHandler("onObjectBreak",getRootElement(),
-- function (attacker)
	-- if not wasEventCancelled() then
		-- triggerClientEvent("objCBreak",attacker,source)
		-- setElementData(source,"objBroken",true,true)
	-- elseif getElementData(getRootElement(),"breakableObjectSyncTrustAttacker") and attacker then
		-- triggerClientEvent(attacker,"onClientObjectRespawn",obj,false)
	-- end
-- end)

-- function breakObject(obj)
	-- if isElement(obj) and getElementType(obj) == "object" then
		-- return triggerEvent("onObjectBreak",obj)
	-- else
		-- return false
	-- end
-- end

-- function respawnObject(obj)
	-- if isElement(obj) and getElementType(obj) == "object" then
		-- return triggerEvent("onObjectRespawn",obj,true)
	-- else
		-- return false
	-- end
-- end

-- addEvent("onObjectRespawn",false)
-- addEventHandler("onObjectRespawn",getRootElement(),
-- function (triggeredByScript)
	-- if not wasEventCancelled() then
		-- triggerClientEvent("onClientObjectRespawn",source,triggeredByScript)
		-- setElementData(source,"objBroken",false,true)
	-- end
-- end)