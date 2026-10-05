local lib = {
	panel = {},
	button = {},
	border = {},
	line = {},
	edit = {},
	memo = {},
	genel = {},
	checkboxrenk = {},
	checkbox = {},
}

local font = "default-bold-small"--guiCreateFont("lib/font.ttf",10.5)
local font2 = "default-bold"--guiCreateFont("lib/pricedown.ttf",11)


   local arkarenk = "1E1E1E"
   local tusarka = "000000"
   local ustarka = "898686"
   local ustcizgi = "c0c0c0"
   local butonkenar = "000000"
   local panelkenar = "c0c0c0"
   local opaklik = "0.98"
   local yazirenk = "ffffff"

   local checkaktif = "064011"
   local checkpasif = "0C0C0C"

--renk
function renk(resim,hex)
	guiSetProperty(resim,"ImageColours","tl:FF"..hex.." tr:FF"..hex.." bl:FF"..hex.." br:FF"..hex)
end

function hex2rgb(hex) 
hex = hex:gsub("#","") 
return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6)) 
end 
--panel
function guiWindowSetSizable(x,y)
	local xsadasd = x
	local yasdasdas = y
end
function guiWindowSetMovable(x,y)
	local xsadasd = x
	local yasdasdas = y
end
function guiCreateWindow(x,y,w,h,yazi,relative,parent,cizgirenk)
	--iprint("Panel Var")
	--print(relative)
	panelsayi = #lib.panel + 1
	if relative  then
		px,pu = guiGetSize(parent,false)
		x,y,w,h = x*px,y*pu,w*px,h*pu
		relative = false
	end
	if not lib.panel[panelsayi] then lib.panel[panelsayi] = {} end
	--iprint(panelsayi)
	lib.panel[panelsayi].arkataraf = guiCreateStaticImage(x,y,w,h,"team/lib/beyaz.png",relative,parent)
	renk(lib.panel[panelsayi].arkataraf,arkarenk)
	guiSetAlpha(lib.panel[panelsayi].arkataraf,opaklik)
	--baslik
	lib.panel[panelsayi].baslik = guiCreateStaticImage(0,0,w,20,"team/lib/beyaz.png",false,lib.panel[panelsayi].arkataraf)
	renk(lib.panel[panelsayi].baslik,ustarka)

	--panelyazi
	lib.panel[panelsayi].label = guiCreateLabel(w/2,-2,w,20, yazi, false,lib.panel[panelsayi].baslik)
	guiSetPosition(lib.panel[panelsayi].label, w/2-guiLabelGetTextExtent(lib.panel[panelsayi].label)/2,-2,false)
	lib.panel[panelsayi].labelsunucu = guiCreateLabel(0,-2.5,w-12,20, "", false,lib.panel[panelsayi].baslik)
	guiSetFont(lib.panel[panelsayi].label,font)
	guiSetFont(lib.panel[panelsayi].labelsunucu,font2)
	guiLabelSetHorizontalAlign(lib.panel[panelsayi].label, "left")
	guiLabelSetHorizontalAlign(lib.panel[panelsayi].labelsunucu, "right")
	guiLabelSetVerticalAlign(lib.panel[panelsayi].label, "center")
	guiLabelSetVerticalAlign(lib.panel[panelsayi].labelsunucu, "center")
	guiLabelSetColor(lib.panel[panelsayi].label,0, 0, 0)
	guiLabelSetColor(lib.panel[panelsayi].labelsunucu,137, 137, 137)
	
	-- lib.panel[panelsayi].kapatArka = guiCreateStaticImage(w-25,0,25,20,"team/lib/beyaz.png",false,lib.panel[panelsayi].baslik)
	-- lib.panel[panelsayi].kapat = guiCreateLabel(0,0,25,20, "X", false, lib.panel[panelsayi].kapatArka)
	-- guiSetFont(lib.panel[panelsayi].kapat, "default-bold-small") guiLabelSetColor(lib.panel[panelsayi].kapat,0,0,0)
	-- guiLabelSetHorizontalAlign(lib.panel[panelsayi].kapat, "center") guiLabelSetVerticalAlign(lib.panel[panelsayi].kapat, "center")
	-- renk(lib.panel[panelsayi].kapatArka,"898686")
	-- renk(lib.panel[panelsayi].kapat,"898686")
	-- guiSetAlpha(lib.panel[panelsayi].kapatArka,opaklik)

	-- addEventHandler('onClientGUIClick',lib.panel[panelsayi].kapat, function() guiSetVisible(getElementParent(getElementParent(getElementParent(source))), false ) showCursor(false) end,false)
	-- addEventHandler('onClientMouseEnter',lib.panel[panelsayi].kapat, function() guiLabelSetColor(source ,255, 69, 59) renk(getElementParent(source),"292828") end,false)
	-- addEventHandler('onClientMouseLeave',lib.panel[panelsayi].kapat, function() guiLabelSetColor(source ,0,0,0) renk(getElementParent(source),"898686") end,false)	
		
	return lib.panel[panelsayi].arkataraf
end
--button
function guiCreateButton(x,y,w,h,yazi,relative,parent,butoncizgirenk)
	butonsayi = #lib.button + 1
	if relative then
		px,pu = guiGetSize(parent,false)
		x,y,w,h = x*px,y*pu,w*px,h*pu
		relative = false
	end
	if not lib.button[butonsayi] then lib.button[butonsayi] = {} end
	lib.button[butonsayi].arkataraf = guiCreateStaticImage(x,y,w,h,"team/lib/beyaz.png",relative,parent)
	renk(lib.button[butonsayi].arkataraf,tusarka)
	
	lib.button[butonsayi].kenarlar = {
		ortaust = guiCreateStaticImage(0, 0, w , 1,"team/lib/beyaz.png",false,lib.button[butonsayi].arkataraf),
		ortaalt = guiCreateStaticImage(0, h-1, w , 1,"team/lib/beyaz.png",false,lib.button[butonsayi].arkataraf),
		sol = guiCreateStaticImage(0, 1, 1, h,"team/lib/beyaz.png",false,lib.button[butonsayi].arkataraf),
		sag = guiCreateStaticImage(w-1, 0, 1, h,"team/lib/beyaz.png",false,lib.button[butonsayi].arkataraf)		
	}
	for i,v in pairs(lib.button[butonsayi].kenarlar) do
		renk(v,butoncizgirenk or butonkenar)
		guiSetProperty(v, "AlwaysOnTop", "True")
		guiSetAlpha(v,1)
	end	
	lib.button[butonsayi].label = guiCreateLabel(0,-2,w,h, yazi, false,lib.button[butonsayi].arkataraf)
	guiSetFont(lib.button[butonsayi].label,"default-bold-small")
	guiLabelSetHorizontalAlign(lib.button[butonsayi].label, "center")
	guiLabelSetVerticalAlign(lib.button[butonsayi].label, "center")
	guiLabelSetColor(lib.button[butonsayi].label,hex2rgb(yazirenk))
	lib.genel[lib.button[butonsayi].label] = lib.button[butonsayi].arkataraf
	return lib.button[butonsayi].label 
end
--editbox
_guiCreateMemo = guiCreateMemo
function guiCreateMemo(x,y,g,u,yazi,relative,parent,kenarrenk)
	memosayi = #lib.memo +1
	if not lib.memo[memosayi] then lib.memo[memosayi] = {} end
	if relative  then
		px,pu = guiGetSize(parent,false)
		x,y,g,u = x*px,y*pu,g*px,u*pu
	end
	local relative = false
	lib.memo[memosayi].resim = guiCreateLabel(x,y,g,u, "", relative, parent)
	lib.memo[memosayi].memoo = _guiCreateMemo(-5.4,-5,g+30, u+8,yazi,false, lib.memo[memosayi].resim)
	guiSetFont(lib.memo[memosayi].memoo,font2)
	
	lib.memo[memosayi].kenarlar = {
		ortaust = guiCreateStaticImage(0,0,g,1,"team/lib/beyaz.png",false,lib.memo[memosayi].resim),
		ortaalt = guiCreateStaticImage(0,u-1,g,1,"team/lib/beyaz.png",false,lib.memo[memosayi].resim),
		sol = guiCreateStaticImage(0,0,1,u,"team/lib/beyaz.png",false,lib.memo[memosayi].resim),
		sag = guiCreateStaticImage(g-1,0,1,u,"team/lib/beyaz.png",false,lib.memo[memosayi].resim)		
	}
	for i,v in pairs(lib.memo[memosayi].kenarlar) do
		renk(v,editboxkenarrenk or "000000")
		guiSetProperty(v, "AlwaysOnTop", "True")
		guiSetAlpha(v,1)
	end	
	
	return lib.memo[memosayi].memoo
end
--
_guiCreateEdit = guiCreateEdit
function guiCreateEdit(x,y,g,u,yazi,relative,parent,kenarrenk)
	editsayi = #lib.edit +1
	if not lib.edit[editsayi] then lib.edit[editsayi] = {} end
	if relative  then
		px,pu = guiGetSize(parent,false)
		x,y,g,u = x*px,y*pu,g*px,u*pu
	end
	local relative = false
	lib.edit[editsayi].resim = guiCreateLabel(x,y,g,u, "", relative, parent)
	lib.edit[editsayi].editbox = _guiCreateEdit(-5.4,-5,g+15, u+8,yazi,false, lib.edit[editsayi].resim)
	guiSetFont(lib.edit[editsayi].editbox,font2)
	
	lib.edit[editsayi].kenarlar = {
		ortaust = guiCreateStaticImage(0,0,g,1,"team/lib/beyaz.png",false,lib.edit[editsayi].resim),
		ortaalt = guiCreateStaticImage(0,u-1,g,1,"team/lib/beyaz.png",false,lib.edit[editsayi].resim),
		sol = guiCreateStaticImage(0,0,1,u,"team/lib/beyaz.png",false,lib.edit[editsayi].resim),
		sag = guiCreateStaticImage(g-1,0,1,u,"team/lib/beyaz.png",false,lib.edit[editsayi].resim)		
	}
	for i,v in pairs(lib.edit[editsayi].kenarlar) do
		renk(v,editboxkenarrenk or "000000")
		guiSetProperty(v, "AlwaysOnTop", "True")
		guiSetAlpha(v,1)
	end	
	
	return lib.edit[editsayi].editbox
end
--checkbox
function guiCreateCheckBox(x,y,w,h,yazi,onoff,relative,parent) --(85,38,60,15,"Normal",true,false,settingswindow)
	checkboxsayi = #lib.checkbox + 1
	if relative  then
		px,pu = guiGetSize(parent,false)
		x,y,w,h = x*px,y*pu,w*px,h*pu
		relative = false
	end
	local relative = false
	if not lib.checkbox[checkboxsayi] then lib.checkbox[checkboxsayi] = {} end
	if onoff then deger = "on" else deger = "off" end
	lib.checkbox[checkboxsayi].arkataraf = guiCreateStaticImage(x,y+3,20,20,"team/lib/"..deger..".png",relative,parent)
	lib.checkbox[checkboxsayi].label = guiCreateLabel(x+24,y+5,w,20, yazi, false,parent)
	lib.checkbox[checkboxsayi].durum = deger
	lib.checkboxrenk[lib.checkbox[checkboxsayi].label] = lib.checkbox[checkboxsayi].arkataraf
	lib.checkboxrenk[lib.checkbox[checkboxsayi].arkataraf] = lib.checkbox[checkboxsayi].arkataraf
	renk(lib.checkbox[checkboxsayi].arkataraf,"ffffff")
	return lib.checkbox[checkboxsayi].arkataraf,lib.checkbox[checkboxsayi].label
end
--
function guiCheckBoxGetSelected(checkbox)
	if checkmi(checkbox) then
		local durum,image = checkmi(checkbox)
		if durum == "on" then 
			guiCheckBoxSetSelected(checkbox,false)
			return false
		else 
			guiCheckBoxSetSelected(checkbox,true)
			return true
		end
	end
end
--
function guiCheckBoxSetSelected(checkbox,napim)
	if checkmi(checkbox) then
		local durum,image = checkmi(checkbox)
		if napim then yenidurum = "on" else yenidurum = "off" end
		if napim then
			lib.checkbox[image].durum = yenidurum
			guiStaticImageLoadImage(lib.checkbox[image].arkataraf,"team/lib/on.png")
		else
			lib.checkbox[image].durum = yenidurum
			guiStaticImageLoadImage(lib.checkbox[image].arkataraf,"team/lib/off.png")
		end
	end
end

--events
addEventHandler("onClientMouseEnter", resourceRoot, function()
	for i,v in pairs(lib.genel) do
		if source == i then
			--for i,v in pairs(v) do
				--guiSetAlpha(v, 0.3)
				renk(v,"444343")
			--end	
		end
	end	
	for i,v in pairs(lib.checkboxrenk) do
		if source == i then
			--for i,v in pairs(v) do
				--guiSetAlpha(v, 1)
				renk(v,"c0c0c0")
			--end	
		end
	end
end)
addEventHandler("onClientMouseLeave", resourceRoot, function()
	for i,v in pairs(lib.genel) do
		if source == i then
			--for i,v in pairs(v) do
				--guiSetAlpha(v, 1)
				renk(v,"000000")
			--end	
		end
	end
	for i,v in pairs(lib.checkboxrenk) do
		if source == i then
			--for i,v in pairs(v) do
				--guiSetAlpha(v, 1)
				renk(v,"ffffff")
			--end	
		end
	end	
end)


function butonmu(label)
	for i,v in pairs(lib.button) do
		if v.label == label then
			return i
		end	
	end
	return false	
end
function editmi(label)
	for i,v in pairs(lib.edit) do
		if v.editbox == label then
			return i
		end	
	end
	return false	
end
function memomu(label)
	for i,v in pairs(lib.memo) do
		if v.memoo == label then
			return i
		end	
	end
	return false	
end
function checkmi(label)
	for i,v in pairs(lib.checkbox) do
		if v.arkataraf == label then
			return v.durum,i
		end	
	end
	return false	
end

_guiSetVisible = guiSetVisible
function guiSetVisible(element, bool)
if isElement(element) then
	local butonmu = butonmu(element)
	local editmi = editmi(element)
	local memomu = memomu(element)
	if butonmu then
		for i, v in pairs(lib.button[butonmu].kenarlar) do
			_guiSetVisible(v, bool)
		end
		_guiSetVisible(lib.button[butonmu].arkataraf, bool)
		_guiSetVisible(lib.button[butonmu].label, bool)
	
	elseif editmi then
		for i, v in pairs(lib.edit[editmi].kenarlar) do
			_guiSetVisible(v, bool)
		end
	elseif memomu then
		for i, v in pairs(lib.memo[memomu].kenarlar) do
			_guiSetVisible(v, bool)
		end
		_guiSetVisible(lib.memo[memomu].resim, bool)
		_guiSetVisible(lib.memo[memomu].memoo, bool)
	end	
	_guiSetVisible(element, bool)
end	
end