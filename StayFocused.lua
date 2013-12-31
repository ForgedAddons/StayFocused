local myname, ns = ...

StayFocused = CreateFrame("StatusBar", "StayFocusedMainFrame", UIParent)
local frame = StayFocused

StayFocused.textures = {
	["Blizzard"] = [=[Interface\TargetingFrame\UI-StatusBar]=],
	["Aluminium"] = [=[Interface\Addons\StayFocused\statusbar\Aluminium]=],
	["Armory"] = [=[Interface\Addons\StayFocused\statusbar\Armory]=],
	["BantoBar"] = [=[Interface\Addons\StayFocused\statusbar\BantoBar]=],
	["Glaze2"] = [=[Interface\Addons\StayFocused\statusbar\Glaze2]=],
	["Gloss"] = [=[Interface\Addons\StayFocused\statusbar\Gloss]=],
	["Graphite"] = [=[Interface\Addons\StayFocused\statusbar\Graphite]=],
	["Grid"] = [=[Interface\Addons\StayFocused\statusbar\Grid]=],
	["Healbot"] = [=[Interface\Addons\StayFocused\statusbar\Healbot]=],
	["LiteStep"] = [=[Interface\Addons\StayFocused\statusbar\LiteStep]=],
	["Minimalist"] = [=[Interface\Addons\StayFocused\statusbar\Minimalist]=],
	["Otravi"] = [=[Interface\Addons\StayFocused\statusbar\Otravi]=],
	["Outline"] = [=[Interface\Addons\StayFocused\statusbar\Outline]=],
	["Perl"] = [=[Interface\Addons\StayFocused\statusbar\Perl]=],
	["Smooth"] = [=[Interface\Addons\StayFocused\statusbar\Smooth]=],
	["Round"] = [=[Interface\Addons\StayFocused\statusbar\Round]=]
}

-- CUSTOM UPDATE (COLOR) HANDLERS
frame.after_update_handlers = {}

function frame:AddHandler(name, funct)
	if 'function' == type(funct) then
		table.insert(frame.after_update_handlers, funct)
		print("|cffa0a0f0Stay Focused!|r: New after update handler: '"..name.."'.")
	else
		print("|cffa0a0f0Stay Focused!|r: Cannot add new handler '"..name.."'! Need a function!")
	end
end

function frame:CreateFrame()
	frame:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
	frame:SetMinMaxValues(0, 100)
	frame:SetValue(0)

	frame.backdrop = frame:CreateTexture(nil, "BACKGROUND", frame)
	frame.backdrop:SetPoint("TOPLEFT", -1, 1)
	frame.backdrop:SetPoint("BOTTOMRIGHT", 1, -1)
	frame.backdrop:SetTexture(0, 0, 0, .5)
	
	frame.value = frame:CreateFontString(nil, "OVERLAY", frame)
	frame.value:SetPoint("CENTER")
	frame.value:SetJustifyH("CENTER")

	frame:ApplyOptions()
	
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
end

local locked = true
SLASH_STAYFOCUSED1 = "/stayfocused"
SLASH_STAYFOCUSED2 = "/sf"
SlashCmdList.STAYFOCUSED = function(input)
	local input = input:lower()
	if input == "" then
		InterfaceOptionsFrame_OpenToCategory(StayFocused.configframe)
	elseif input == "lock" or input == "unlock" or input == "drag" then
		locked = not locked
		frame:ApplyLock()
	end
end 

function frame:ApplyLock()
	if locked then
		print("|cffa0a0f0Stay Focused!|r frame is now |cffff8080locked|r. Position saved!")
		local point, _, relativePoint, xOfs, yOfs = frame:GetPoint()
		frame.db.point = point
		frame.db.relativePoint = relativePoint
		frame.db.xOfs = xOfs
		frame.db.yOfs = yOfs

		frame:StopMovingOrSizing()
		
		frame:SetMovable(false)
		frame:EnableMouse(false)
		frame:RegisterForDrag()
	else
		print("|cffa0a0f0Stay Focused!|r frame is now |cff80ff80unlocked|r. Drag blue frame around! Type |cff808080/sf lock|r again to save position.")
		frame:SetAlpha(1)

		frame:SetMovable(true)
		frame:EnableMouse(true)
		frame:RegisterForDrag("LeftButton")
	end
end

function frame:ApplyOptions()
	local o = frame.db;
	local color = o.class_colored and RAID_CLASS_COLORS[select(2, UnitClass("player"))] or {r = o.color.r, g = o.color.g, b = o.color.b}
	
	frame.backdrop:SetTexture(0, 0, 0, o.backdrop_alpha)
	frame:SetStatusBarTexture(StayFocused.textures[o.texture])
	
	frame:SetStatusBarColor(color.r, color.g, color.b)
	frame:SetPoint(o.point, 'UIParent', o.relativePoint, o.xOfs, o.yOfs)
	frame:SetSize(o.width, o.height)

	frame.value:SetFont([=[Fonts\ARIALN.ttf]=], o.font_size, o.font_outline and "OUTLINE" or "")
	frame.value:SetTextColor(1, 1, 1)
end

local max_power = 0

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("ADDON_LOADED")

frame:RegisterEvent('UNIT_CONNECTION')
frame:RegisterEvent('UNIT_MAXPOWER')

local in_combat = false
frame:SetScript("OnEvent", function(self, event, ...)
	if event == "ADDON_LOADED" then
		local addon = ...
		if addon:lower() ~= "stayfocused" then return end
		StayFocusedDB = StayFocusedDB or {
			class_colored = true,
			style = 1,
			texture = 'Blizzard',
			color = {1, 1, 1},
			
			backdrop_alpha = 0.5,
			
			alpha_ooc_zero = 0,
			alpha_ooc_maximum = .2,
			alpha_ooc_normal = .5,
			alpha_zero = .1,
			alpha_maximum = .5,
			alpha_normal = .9,
			
			font_size = 18,
			font_outline = true,
			
			width = 225,
			height = 20,
			
			point = "CENTER", 
			relativePoint = "CENTER",
			xOfs = 0, 
			yOfs = -250,
		}
		if not StayFocusedDB.style then StayFocusedDB.style = 1 end
		if not StayFocusedDB.backdrop_alpha then
			StayFocusedDB.backdrop_alpha = 0.5
			StayFocusedDB.texture = 'Blizzard' 
			StayFocusedDB.color = {1, 1, 1}
		end
		
		self.db = StayFocusedDB
		
		self:CreateFrame()
		
		self:UnregisterEvent("ADDON_LOADED")

		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		
		--self:AddHandler('test function', TestFunc)

	elseif event == "PLAYER_REGEN_ENABLED" then
		in_combat = false
	elseif event == "PLAYER_REGEN_DISABLED" then
		in_combat = true
	else
		max_power_new = UnitPowerMax("player")
		if max_power_new ~= max_power then
			max_power = max_power_new
			frame:SetMinMaxValues(0, max_power)
		end
	end
end)


local function getPwPercent(p, decimal, smart)
	if smart and (p == max_power or p == 0) then return '' end
	local v = p / max_power * 100.0
	return smart and (decimal and format(' (%.1f%%)', v) or format(' (%.0f%%)', v)) or (decimal and format('%.1f%%', v) or format('%.0f%%', v))
end

local function getText(v)
	local style = StayFocused.db.style
	if style == 1 then
		return v..getPwPercent(v, true, true)
	elseif style == 2 then
		return v..getPwPercent(v, false, true)
	elseif style == 3 then
		return v
	elseif style == 4 then
		return getPwPercent(v, true, false)
	elseif style == 5 then
		return getPwPercent(v, false, false)
	else
		return ''
	end
end


local lastUpdate = 0
frame:SetScript("OnUpdate", function(self, elapsed)
	lastUpdate = lastUpdate + elapsed
	if lastUpdate > 0.1 then
		lastUpdate = 0

		local power = UnitPower("player")
		frame:SetValue(power)
		frame.value:SetText(getText(power))
		if power == 0 then
			if locked then frame:SetAlpha(in_combat and frame.db.alpha_zero or frame.db.alpha_ooc_zero) end
		else
			if power == max_power then
				if locked then frame:SetAlpha(in_combat and frame.db.alpha_maximum or frame.db.alpha_ooc_maximum) end
			else
				if locked then frame:SetAlpha(in_combat and frame.db.alpha_normal or frame.db.alpha_ooc_normal) end
			end
		end
		
		for key, value in pairs(self.after_update_handlers) do value(power, max_power, elapsed) end
	end
end)
