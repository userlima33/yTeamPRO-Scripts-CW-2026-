local blockedTags = {"[4F]","[DDC]","[Gr8]","stars//","(&)","[SMT]","FuckN|",}
--
addEventHandler ( "onResourceStart", getResourceRootElement ( getThisResource() ),
function ()
	for i, p in ipairs ( getElementsByType ( "player" ) ) do
		local tempName = getPlayerName ( p )
		for x = 1, #blockedTags do
			if ( string.find ( tempName, blockedTags [ i ], 1, true ) ~= nil ) then
				kickPlayer ( source, "This nametag is forbidden, remove it!" )
			end
		end
	end
end)
--
addEventHandler ( "onPlayerJoin", root,
function ()
	local name = getPlayerName ( source )
	for i = 1, #blockedTags do
		if ( string.find ( name, blockedTags [ i ], 1, true ) ~= nil ) then
			kickPlayer ( source, "This nametag is forbidden, remove it!" )
		end
		end
end)
--
addEventHandler ( "onPlayerChangeNick", root,
function ( _, newNick )
	for i = 1, #blockedTags do
		if ( string.find ( newNick, blockedTags [ i ], 1, true ) ~= nil ) then
			kickPlayer ( source, "This nametag is forbidden, remove it!" )
		end
	end
end)