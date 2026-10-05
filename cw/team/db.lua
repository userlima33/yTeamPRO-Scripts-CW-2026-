
-- to store databse connection handle
local dbConnection = nil

-- on resource start
local function connection()
    dbConnection = dbConnect("sqlite", "yteampro.db")

    -- check if the connection is successfull
    if (dbConnection) then
        outputDebugString("yTeamPRO's TT: Connection with database was successfully established.")
    else
        outputDebugString("yTeamPRO's TT: Connection with database couldn't be established.")
        return
    end
    
    -- crreate the table if not exists
    -- teamname / cws / wins / loses 
    dbExec(dbConnection,
    [[
        CREATE TABLE IF NOT EXISTS `teams` (
            `id` INTEGER PRIMARY KEY AUTOINCREMENT,
            `teamname` TEXT NOT NULL,
            `cws` INTEGER NOT NULL DEFAULT 0,
            `wins` INTEGER NOT NULL DEFAULT 0,
            `loses` INTEGER NOT NULL DEFAULT 0,
            `winstreak` INTEGER NOT NULL DEFAULT 0
        )
      ]]
    )
end
addEventHandler("onResourceStart", resourceRoot, connection)

-- add a team
function addTeam(teamName, initialScore)

    -- teamName needs to be between 3 and 10 char
    if (#tostring(teamName) < 1) or (#tostring(teamName) > 10) then
        outputDebugString("yTeamPRO's TT: Incorrect team name length")
        return
    end

    dbQuery(function(qh, teamName, initialScore)
        local result = dbPoll(qh, 0)
        if (result[1]) then
            outputDebugString("yTeamPRO's TT: This team already exists")
            return
        end
        if (initialScore) then
            dbExec(dbConnection, "INSERT INTO teams (teamname, cws, wins, loses, winstreak) VALUES (?, ?, ?, ?, 0)", teamName, initialScore[1], initialScore[2], initialScore[3])
        else
            dbExec(dbConnection, "INSERT INTO teams (teamname, cws, wins, loses, winstreak) VALUES (?, 0, 0, 0, 0)", teamName)
        end
        outputDebugString("yTeamPRO's TT: Successfully added team "..teamName)
    end,{teamName, initialScore}, dbConnection, "SELECT * FROM teams WHERE teamname = ?", teamName)
end

-- update cws, wins and loses
function saveTeamInfo(teamName, score)

    if (tonumber(score[1]) < 0) or (tonumber(score[2]) < 0) or (tonumber(score[3]) < 0) then
        outputDebugString("Unsigned number value required")
        return
    end

    dbQuery(function(qh, teamName, score)
        local result = dbPoll(qh, 0)
        if (not result[1]) then
            outputDebugString("yTeamPRO's TT: This team does not exist")
            return
        end
        dbExec(dbConnection, "UPDATE teams SET cws=?, wins=?, loses=?, winstreak=? WHERE teamname = ?", score[1], score[2], score[3], score[4], teamName)
        outputDebugString("yTeamPRO's TT: Successfully updated team "..teamName)
    end,{teamName, score}, dbConnection, "SELECT * FROM teams WHERE teamname = ?", teamName)
end

-- remove the team
function removeTeamInfo(teamName)
    dbQuery(function(qh, teamName)
        local result = dbPoll(qh, 0)
        if (not result[1]) then
            outputDebugString("yTeamPRO's TT: This team does not exist")
            return
        end
        dbExec(dbConnection, "DELETE FROM teams WHERE teamname=?", teamName)
        outputDebugString("yTeamPRO's TT: Successfully deleted team "..teamName)
    end,{teamName}, dbConnection, "SELECT * FROM teams WHERE teamname = ?", teamName)
end	

-- get team info (callback ?)
function getTeamInfo(teamName)

    local qh = dbQuery( dbConnection, "SELECT * FROM teams WHERE teamname = ?", teamName)
    local result = dbPoll( qh, -1 )

    if (not result[1]) then
        outputDebugString("yTeamPRO's TT: This team doesn't exist in the database")
        return
    end

    return result[1]
end

-----------------------------------------------------
-----------------add win and lose func---------------
-----------------------------------------------------
function addWinToTeam(teamName)
    local stats = getTeamInfo(teamName)
    if (stats) then
        saveTeamInfo(teamName, {stats.cws + 1, stats.wins + 1, stats.loses, stats.winstreak + 1})
        outputDebugString("yTeamPRO's TT: succesfully added win to "..teamName)
		local streaklast = stats.winstreak + 1
		if streaklast >= 2 then
			setTimer(outputChatBox,1000,1,"#ffffff* #CCA95A"..teamName.." #ffffffhas a streak of #CCA95A"..streaklast.." #fffffftimes now!",root,0,0,0,true)
		end
    else
        addTeam(teamName, {1, 1, 0, 1})
        outputDebugString("yTeamPRO's TT: there was no team by that name so, succesfully created and added win to "..teamName)
    end
end

function addLoseToTeam(teamName)
    local stats = getTeamInfo(teamName)
    if (stats) then
        saveTeamInfo(teamName, {stats.cws + 1, stats.wins, stats.loses + 1, 0})
        outputDebugString("yTeamPRO's TT: succesfully added lose to "..teamName)
    else
        addTeam(teamName, {1, 0, 1, 0})
        outputDebugString("yTeamPRO's TT: there was no team by that name so, succesfully created and added lose to "..teamName)
    end
end

-- [[ functions to test ]] --
-- REMOVE THEM BEFORE PUSH THE SCRIPTS

addCommandHandler("yteamproaddteamcmd", function(pSource, cmd, name)
    addTeam(name)
end
)

addCommandHandler("yteamprosaveteamcmd", function(pSource, cmd, name,a,b,c)
    saveTeamInfo(name, {tonumber(a),tonumber(b),tonumber(c)})
end
)

addCommandHandler("yteamprogetteamcmd", function(pSource, cmd, name)
    iprint(getTeamInfo(name))
end
)

addCommandHandler("yteamprodelteamcmd", function(pSource, cmd, name)
    removeTeamInfo(name)
end
)

addCommandHandler("yteamproapteamcmd", function(pSource, cmd, name)
    addWinToTeam(name)
end
)

addCommandHandler("yteamprodpteamcmd", function(pSource, cmd, name)
    addLoseToTeam(name)
end
)

addCommandHandler("yteamprogetteamscmd", function(pSource, cmd, name)
    clanTopTeamListFunc(name)
end
)

-- Exportado pra outros resources (ex: sync) conseguirem pegar a lista de clas
-- sem precisar de acesso direto ao banco (que agora é local por resource).
function getTopClansExport(limit)
    if not isElement(dbConnection) then return {} end
    local qh = dbQuery(dbConnection, "SELECT * FROM teams")
    local result = dbPoll(qh, -1)
    if not result then return {} end
    table.sort(result, function(a, b) return (tonumber(a.wins) or 0) > (tonumber(b.wins) or 0) end)
    for k, v in ipairs(result) do v.ranking = k end
    if limit then
        local trimmed = {}
        for i = 1, math.min(limit, #result) do trimmed[i] = result[i] end
        return trimmed
    end
    return result
end
