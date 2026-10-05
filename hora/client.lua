-- /hora <hora>  |  muda o horario do jogo SOMENTE pra quem usar o comando
-- (nao afeta os outros jogadores, é so visual/local, roda no client-side)
-- Uso: /hora 12   -> define 12:00
--      /hora 12 30 -> define 12:30
--      /hora        -> mostra a hora atual
--      /hora sync   -> volta a acompanhar o horario normal do servidor/mapa
--
-- Obs: quando um mapa novo carrega, o servidor pode definir um horário padrão
-- pra todo mundo (isso é normal, faz parte do mapa) e vai sobrescrever o seu
-- /hora local. Se isso acontecer, é só usar /hora de novo.

addCommandHandler("hora", function(cmd, arg1, arg2)
    if not arg1 then
        local h, m = getTime()
        outputChatBox(string.format("Hora atual: %02d:%02d (uso: /hora <hora> [minuto], ou /hora sync pra voltar ao normal)", h, m), 255, 200, 0)
        return
    end

    if arg1 == "sync" then
        triggerServerEvent("hora:requestServerTime", resourceRoot)
        outputChatBox("Voltando a acompanhar o horário normal do servidor.", 0, 255, 0)
        return
    end

    local hour = tonumber(arg1)
    local minute = tonumber(arg2) or 0

    if not hour or hour < 0 or hour > 23 then
        outputChatBox("Uso: /hora <hora entre 0 e 23> [minuto entre 0 e 59]", 255, 100, 100)
        return
    end
    if minute < 0 or minute > 59 then
        outputChatBox("O minuto precisa estar entre 0 e 59.", 255, 100, 100)
        return
    end

    setTime(hour, minute)
    outputChatBox(string.format("Hora ajustada pra %02d:%02d (só pra você).", hour, minute), 0, 255, 0)
end)

addEvent("hora:receiveServerTime", true)
addEventHandler("hora:receiveServerTime", resourceRoot, function(h, m)
    setTime(h, m)
end)
