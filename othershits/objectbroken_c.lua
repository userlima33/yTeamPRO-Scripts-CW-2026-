-- addEventHandler("onClientObjectBreak", root,
-- function()
	-- triggerServerEvent("breakTheObject",root,source)
-- end)

-- addEvent("breakTheObject_c",true)
-- addEventHandler("breakTheObject_c",root,function(object)
	-- breakObject(object)
-- end)

---------------------------------------


-- function onClientBreak(attacker)
	-- if isElement(attacker) and (attacker == getLocalPlayer() or isElementSyncer(attacker) or (getElementType(attacker) == "vehicle" and getVehicleController(attacker) == getLocalPlayer())) then -- for some reason the driver is not known as the syncer client side
		-- triggerServerEvent("objSBreak",getLocalPlayer(),source)
		-- if not getElementData(getRootElement(),"breakableObjectSyncTrustAttacker") then
			-- cancelEvent()
		-- end
	-- else
		-- cancelEvent()
	-- end
-- end
-- addEventHandler("onClientObjectBreak",getRootElement(),onClientBreak)

-- addEvent("objCBreak",true)
-- addEventHandler("objCBreak",getRootElement(),
-- function (obj)
	-- removeEventHandler("onClientObjectBreak",getRootElement(),onClientBreak)
	-- breakObject(obj)
	-- addEventHandler("onClientObjectBreak",getRootElement(),onClientBreak)
-- end)

-- addEvent("onClientObjectRespawn",true)
-- addEventHandler("onClientObjectRespawn",getRootElement(),
-- function (triggeredByScript)
	-- if not wasEventCancelled() then
		-- respawnObject(source)
	-- end
-- end)

-- addEventHandler("onClientExplosion",getRootElement(),
-- function (x,y,z,type)
	-- if type == 9 and getElementData(source,"objBroken") then
		-- cancelEvent()
	-- end
-- end)

-- addEventHandler("onClientElementStreamIn",getRootElement(),
-- function ()
	-- if getElementType(source) == "object" then
		-- if getElementData(source,"objBroken") then
			-- removeEventHandler("onClientObjectBreak",getRootElement(),onClientBreak)
			-- breakObject(source)
			-- addEventHandler("onClientObjectBreak",getRootElement(),onClientBreak)
		-- end
	-- end
-- end)