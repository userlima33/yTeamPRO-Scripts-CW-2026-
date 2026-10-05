--loadstring engelleme
_loadstring = loadstring
function loadstring(text)
    outputChatBox("* loadstring is disabled, sorry.")
	triggerServerEvent("onClientUseLoadString", localPlayer,text)
end