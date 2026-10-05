-- Comandos competitivos: /rank, /topkills, /topclan
-- Usa os exports do "sync" (kills/rank por letra) e do "cw" (clas).

-- "exports.X" sempre existe mesmo com o resource parado - o jeito certo de
-- checar se dá pra usar é olhar o estado real do resource.
local function isResourceRunning(name)
    local res = getResourceFromName(name)
    return res and getResourceState(res) == "running"
end

local RANK_COLOR = {
    -- Progressão de "ruim" pra "lendário", cores que qualquer jogador já
    -- reconhece de outros jogos (comum -> raro -> épico -> lendário).
    SS = {255, 200, 40},  -- dourado - lendário
    S  = {190, 80, 235},  -- roxo - épico
    A  = {60, 150, 240},  -- azul - muito bom
    B  = {80, 210, 110},  -- verde - bom
    C  = {170, 170, 170}, -- cinza - mediano
    F  = {225, 45, 45},   -- vermelho - ruim
}

local function colorFor(rank)
    local c = RANK_COLOR[rank] or {255, 255, 255}
    return c[1], c[2], c[3]
end

addCommandHandler("rank", function(player, cmd, targetName)
    if not isResourceRunning("sync") then
        outputChatBox("Sistema de stats indisponível no momento.", player, 255, 100, 100)
        return
    end

    local targetSerial, targetNick

    if targetName then
        local found = nil
        for _, p in ipairs(getElementsByType("player")) do
            if getPlayerName(p):lower():find(targetName:lower(), 1, true) then
                found = p
                break
            end
        end
        if not found then
            outputChatBox("Jogador '" .. targetName .. "' não encontrado (precisa estar online).", player, 255, 100, 100)
            return
        end
        targetSerial = getPlayerSerial(found)
        targetNick = getPlayerName(found)
    else
        targetSerial = getPlayerSerial(player)
        targetNick = getPlayerName(player)
    end

    local info = exports.sync:getPlayerRankExport(targetSerial)
    if not info then
        outputChatBox(targetNick .. " ainda não tem estatísticas registradas (participe de uma Clan War pra começar a ranquear).", player, 255, 200, 0)
        return
    end

    local posText = info.ranking and ("#" .. info.ranking .. " no ranking geral") or "ainda fora do ranking (sem CW)"
    outputChatBox(
        string.format("== Rank de %s ==", info.nickname),
        player, 0, 200, 255
    )
    local r, g, b = colorFor(info.rank)
    outputChatBox(
        string.format("Rank: %s  |  Kills: %s  Deaths: %s  Assists: %s  |  KDA: %s  |  %s",
            info.rank, tostring(info.kills), tostring(info.deaths), tostring(info.assists), tostring(info.kdr), posText),
        player, r, g, b
    )
end)

addCommandHandler("topkills", function(player, cmd, arg)
    if not isResourceRunning("sync") then
        outputChatBox("Sistema de stats indisponível no momento.", player, 255, 100, 100)
        return
    end
    local limit = tonumber(arg) or 5
    limit = math.min(limit, 10)

    local list = exports.sync:getTopKillsExport(limit)
    if not list or #list == 0 then
        outputChatBox("Ainda não há jogadores ranqueados (precisa ter pelo menos 1 CW).", player, 255, 200, 0)
        return
    end

    outputChatBox("== Top " .. #list .. " Kills ==", player, 0, 200, 255)
    for _, v in ipairs(list) do
        local r, g, b = colorFor(v.rank)
        outputChatBox(
            string.format("#%s  %s [%s]  -  %s kills / %s deaths / %s assists  (KDA %s)",
                tostring(v.ranking), v.nickname, v.rank, tostring(v.kills), tostring(v.deaths), tostring(v.assists), tostring(v.kdr)),
            player, r, g, b
        )
    end
end)

addCommandHandler("topclan", function(player, cmd, arg)
    if not isResourceRunning("cw") then
        outputChatBox("Sistema de clãs indisponível no momento.", player, 255, 100, 100)
        return
    end
    local limit = tonumber(arg) or 5
    limit = math.min(limit, 10)

    local list = exports.cw:getTopClansExport(limit)
    if not list or #list == 0 then
        outputChatBox("Ainda não há clãs registrados.", player, 255, 200, 0)
        return
    end

    outputChatBox("== Top " .. #list .. " Clãs ==", player, 0, 200, 255)
    for _, v in ipairs(list) do
        local wins = tonumber(v.wins) or 0
        local loses = tonumber(v.loses) or 0
        local winrate = (wins + loses) > 0 and math.floor(100 * wins / (wins + loses)) or 0
        outputChatBox(
            string.format("#%s  %s  -  %s vitórias / %s derrotas  (%s%% win rate, streak: %s)",
                tostring(v.ranking), v.teamname, tostring(wins), tostring(loses), tostring(winrate), tostring(v.winstreak)),
            player, 200, 255, 200
        )
    end
end)
