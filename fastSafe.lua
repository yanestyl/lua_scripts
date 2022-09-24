script_name('fast fsafe&getgun for ERP')
script_author('Franchesko')
require("lib.moonloader")
local inicfg = require ('inicfg')
local imgui = require "imgui"
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local sampev = require 'samp.events'

local main_window_state = imgui.ImBool(false)
local sw, sh = getScreenResolution()
local fsafe = false
local fslastd = false
local fsak = false
local fsm4 = false
local fsde = false
local fsri = false
local fssh = false

local cross = false

local path_ini = '..\\config\\Fsafe&getgun.ini'
local mainIni = inicfg.load({
    fsafe = {      
		key = 80,
		de = 0,
		ri = 0,
		sh = 0,
		ak = 0,
		m4 = 0,
		delay = 200
    }
},path_ini)

function saveIniFile()
    local inicfgsaveparam = inicfg.save(mainIni,path_ini)
end
saveIniFile()

function sampev.onServerMessage(color, text)
	text_1 = text
	if string.find(text, "Вы взяли из сейфа патроны") then cross = true end
	if string.find(text, "В вашем сейфе такого количества нет") then
		fsafe = false
		fsak = false
		sfm4 = false
		sfde = false
		fsri = false
		fssh = false
		return true
	end
end



local fskey = imgui.ImInt(mainIni.fsafe.key)
local fsdelay = imgui.ImInt(mainIni.fsafe.delay)
local fsakkol = imgui.ImInt(mainIni.fsafe.ak)
local fsm4kol = imgui.ImInt(mainIni.fsafe.m4)
local fsdekol = imgui.ImInt(mainIni.fsafe.de)
local fsrikol = imgui.ImInt(mainIni.fsafe.ri)
local fsshkol = imgui.ImInt(mainIni.fsafe.sh)



function main()
    if not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
	sampRegisterChatCommand("asafe", function() main_window_state.v = not main_window_state.v end)
    while true do
        wait(0)
		
		imgui.Process = main_window_state.v
		if isKeyJustPressed(mainIni.fsafe.key) and not isPauseMenuActive() and isPlayerPlaying(PLAYER_HANDLE) and not sampIsChatInputActive() and not sampIsDialogActive() then
			sampSendChat("/safe")
			fsafe = true
			fsak = true
			fsm4 = true
			fsde = true
			fsri = true
			fssh = true
		end
		
		if mainIni.fsafe.ak <= 0 then
			fsak = false
		end
		if mainIni.fsafe.m4 <= 0 then
			fsm4 = false
		end
		if mainIni.fsafe.de <= 0 then
			fsde = false
		end
		if mainIni.fsafe.ri <= 0 then
			fsri = false
		end
		if mainIni.fsafe.sh <= 0 then
			fssh = false
		end
    end
end


function imgui.OnDrawFrame()
    if main_window_state.v then 
        imgui.SetNextWindowPos(imgui.ImVec2(sw / 2, sh / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(430, 240), imgui.Cond.FirstUseEver)
		imgui.Begin("Fast fsafe&getgun for Evolve RP", main_window_state)

        imgui.SetCursorPosX(8)
		
		imgui.Text(u8"Клавиша активации (По умолчанию P): ")
		imgui.SameLine()
		imgui.PushItemWidth(60)
        if imgui.InputInt(u8"##fskey", fskey, 0 , 0) then
			mainIni.fsafe.key = tonumber(fskey.v)
			saveIniFile()
		end
        imgui.PopItemWidth()
		imgui.Text(u8"Количество патронов АК (0 для отключения): ")
		imgui.SameLine()
		imgui.PushItemWidth(100)
        if imgui.InputInt(u8"##fsakkol", fsakkol) then
			mainIni.fsafe.ak = tonumber(fsakkol.v)
			saveIniFile()
		end
        imgui.PopItemWidth()
		imgui.Text(u8"Количество патронов M4 (0 для отключения): ")
		imgui.SameLine()
		imgui.PushItemWidth(100)
        if imgui.InputInt(u8"##fsm4kol", fsm4kol) then
			mainIni.fsafe.m4 = tonumber(fsm4kol.v)
			saveIniFile()
        end
        imgui.PopItemWidth()
		imgui.Text(u8"Количество патронов Deagle (0 для отключения): ")
		imgui.SameLine()
		imgui.PushItemWidth(100)
        if imgui.InputInt(u8"##fsdekol", fsdekol) then
			mainIni.fsafe.de = tonumber(fsdekol.v)
			saveIniFile()
        end
        imgui.PopItemWidth()
		imgui.Text(u8"Количество патронов Rifle (0 для отключения): ")
		imgui.SameLine()
		imgui.PushItemWidth(100)
        if imgui.InputInt(u8"##fsrikol", fsrikol) then
			mainIni.fsafe.ri = tonumber(fsrikol.v)
			saveIniFile()
        end
        imgui.PopItemWidth()
		imgui.Text(u8"Количество патронов Shotgun (0 для отключения): ")
		imgui.SameLine()
		imgui.PushItemWidth(100)
        if imgui.InputInt(u8"##fsshkol", fsshkol) then
			mainIni.fsafe.sh = tonumber(fsshkol.v)
			saveIniFile()
        end
        imgui.PopItemWidth()
		imgui.Text(u8"Задержка: ")
		imgui.SameLine()
		imgui.PushItemWidth(100)
        if imgui.InputInt(u8"##fsdelay", fsdelay, 50) then
			mainIni.fsafe.delay = tonumber(fsdelay.v)
			saveIniFile()
        end
		imgui.Separator()
		imgui.End()
    end
end


function closedialog()
    wait(250)
	sampCloseCurrentDialogWithButton(0)
	wait(250)
	sampCloseCurrentDialogWithButton(0)
end

function sampev.onShowDialog(dialogId, dialogStyle, dialogTitle, okButtonText, cancelButtonText, dialogText)
	if fsafe then
		if dialogId == 217 then
            sampSendDialogResponse(217, 1, 0, nil)
            return false
        end
		
		while not cross do
			if dialogId == 218 and fsde then
				sampSendDialogResponse(218, 1, 5, nil)
				fsde = false
				return false
			end
			if dialogId == 219 then
				lua_thread.create(function()
					wait(mainIni.fsafe.delay)
					sampSendDialogResponse(219, 1, 0, mainIni.fsafe.de)
					sampCloseCurrentDialogWithButton(0)
				end)
			end
		end
		cross = false
		while not cross do
			if dialogId == 218 and fssh and not fsde then
				sampSendDialogResponse(218, 1, 6, nil)
				fssh = false
				return false
			end
			if dialogId == 219 then
				lua_thread.create(function()
					wait(mainIni.fsafe.delay)
					sampSendDialogResponse(219, 1, 0, mainIni.fsafe.sh)
					sampCloseCurrentDialogWithButton(0)
				end)
			end
		end
		cross = false
		while not cross do
			if dialogId == 218 and fsm4 and not fsde and not fssh then
				sampSendDialogResponse(218, 1, 9, nil)
				fsm4 = false
				return false
			end
			if dialogId == 219 then
				lua_thread.create(function()
					wait(mainIni.fsafe.delay)
					sampSendDialogResponse(219, 1, 0, mainIni.fsafe.m4)
					sampCloseCurrentDialogWithButton(0)
				end)
			end
		end
		cross = false
		--[[if dialogId == 218 and fsak then
            sampSendDialogResponse(218, 1, 8, nil)
			fsak = false
            return false
        end
        if dialogId == 219 then
			lua_thread.create(function()
				wait(mainIni.fsafe.delay)
				sampSendDialogResponse(219, 1, 0, mainIni.fsafe.ak)
				sampCloseCurrentDialogWithButton(0)
			end)
        end]]
		cross = false
		while not cross do
			if dialogId == 218 and fsri and not fsde and not fssh and not fsm4 then
				sampSendDialogResponse(218, 1, 10, nil)
				fsri = false
				return false
			end
			if dialogId == 219 then
				lua_thread.create(function()
					wait(mainIni.fsafe.delay)
					sampSendDialogResponse(219, 1, 0, mainIni.fsafe.ri)	
					sampCloseCurrentDialogWithButton(0)
				end)
			end
		end
		if dialogId == 218 and not fsak and not fsm4 and not fsde and not fsri and not fssh then
			fslastd = true
		end
    end
	if dialogId == 218 and fslastd then
		fslastd = false
		fsafe = false
		cross = false
		lua_thread.create(closedialog)
    end
end

function apply_custom_style()
	imgui.SwitchContext()
local style = imgui.GetStyle()
local colors = style.Colors
local clr = imgui.Col
local ImVec4 = imgui.ImVec4

colors[clr.Text] = ImVec4(1.00, 1.00, 1.00, 1.00)
colors[clr.TextDisabled] = ImVec4(0.60, 0.60, 0.60, 1.00)
colors[clr.WindowBg] = ImVec4(0.11, 0.10, 0.11, 1.00)
colors[clr.ChildWindowBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.PopupBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.Border] = ImVec4(0.86, 0.86, 0.86, 1.00)
colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.FrameBg] = ImVec4(0.21, 0.20, 0.21, 0.60)
colors[clr.FrameBgHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.FrameBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.TitleBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.TitleBgActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.MenuBarBg] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ScrollbarBg] = ImVec4(0.00, 0.46, 0.65, 0.00)
colors[clr.ScrollbarGrab] = ImVec4(0.00, 0.46, 0.65, 0.44)
colors[clr.ScrollbarGrabHovered] = ImVec4(0.00, 0.46, 0.65, 0.74)
colors[clr.ScrollbarGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ComboBg] = ImVec4(0.15, 0.14, 0.15, 1.00)
colors[clr.CheckMark] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.SliderGrab] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.SliderGrabActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.Button] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ButtonHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ButtonActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.Header] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.HeaderHovered] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.HeaderActive] = ImVec4(0.00, 0.46, 0.65, 1.00)
colors[clr.ResizeGrip] = ImVec4(1.00, 1.00, 1.00, 0.30)
colors[clr.ResizeGripHovered] = ImVec4(1.00, 1.00, 1.00, 0.60)
colors[clr.ResizeGripActive] = ImVec4(1.00, 1.00, 1.00, 0.90)
colors[clr.CloseButton] = ImVec4(1.00, 0.10, 0.24, 0.00)
colors[clr.CloseButtonHovered] = ImVec4(0.00, 0.10, 0.24, 0.00)
colors[clr.CloseButtonActive] = ImVec4(1.00, 0.10, 0.24, 0.00)
colors[clr.PlotLines] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.PlotLinesHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.PlotHistogram] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.PlotHistogramHovered] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.TextSelectedBg] = ImVec4(0.00, 0.00, 0.00, 0.00)
colors[clr.ModalWindowDarkening] = ImVec4(0.00, 0.00, 0.00, 0.00)
end
apply_custom_style()
