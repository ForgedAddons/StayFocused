local myname, ns = ...

local ICONSIZE, ICONGAP, GAP, EDGEGAP, BIGGAP = 32, 3, 8, 16, 16
local tekcheck = LibStub("tekKonfig-Checkbox")
local tekslide = LibStub("tekKonfig-Slider")

local frame = CreateFrame("Frame", "StayFocusedConfig", InterfaceOptionsFramePanelContainer)
frame.name = "Stay Focused!"

local title, subtitle = LibStub("tekKonfig-Heading").new(frame, "|cffa0a0f0Stay Focused!|r", "Options for main bar.")

local class_colored = tekcheck.new(frame, nil, "Class colored bar", "TOPLEFT", subtitle, "BOTTOMLEFT", 0, -GAP)
local checksound = class_colored:GetScript("OnClick")
class_colored:SetScript("OnClick", function(self)
	checksound(self);
	StayFocused.db.class_colored = not StayFocused.db.class_colored
	StayFocused:ApplyOptions()
end)

local styledropdown, styletext, stylecontainer, stylelabel = LibStub("tekKonfig-Dropdown").new(frame, "Style", "TOPLEFT", class_colored, "BOTTOMLEFT", 0, -GAP)
stylecontainer:SetHeight(28)
styledropdown:ClearAllPoints()
styledropdown:SetPoint("LEFT", stylelabel, "RIGHT", -8, -2)
styledropdown.tiptext = "How text should be displayed"

local function OnClickStyle(self)
	local text = "9999 (100.0%)"
	if self.value == 2 then text = "9999 (100%)" end
	if self.value == 3 then text = "9999" end
	if self.value == 4 then text = "100.0%" end
	if self.value == 5 then text = "100%" end
	if self.value == 6 then text = "" end
	styletext:SetText(text)
	StayFocused.db.style = self.value
	StayFocused:ApplyOptions()
end

local texdropdown, textext, texcontainer, texlabel = LibStub("tekKonfig-Dropdown").new(frame, "Texture", "TOPLEFT", stylecontainer, "BOTTOMLEFT", 0, -BIGGAP)
texcontainer:SetHeight(28)
texdropdown:ClearAllPoints()
texdropdown:SetPoint("LEFT", texlabel, "RIGHT", -8, -2)

local function OnClickTexture(self)
	textext:SetText(self.value)
	StayFocused.db.texture = self.value
	StayFocused:ApplyOptions()
end

local backdropalpha, backdropalpha_l, backdropalpha_c = tekslide.new(frame, "Backdrop alpha", 0, 1, "TOPLEFT", stylecontainer, "TOPRIGHT", 4*GAP, 0)
backdropalpha:SetValueStep(0.1)
backdropalpha:SetScript("OnValueChanged", function(self, newvalue)
	backdropalpha_l:SetText(string.format("Backdrop alpha: %.1f", newvalue))
	StayFocused.db.backdrop_alpha = newvalue
	StayFocused:ApplyOptions()
end)


local frame_width, frame_width_l, frame_width_c = tekslide.new(frame, "Width", 50, 500, "TOPLEFT", texcontainer, "BOTTOMLEFT", 0, -BIGGAP)
frame_width:SetValueStep(5)
frame_width:SetScript("OnValueChanged", function(self, newvalue)
	frame_width_l:SetText(string.format("Width: %d", newvalue))
	StayFocused.db.width = newvalue
	StayFocused:ApplyOptions()
end)
local frame_height, frame_height_l, frame_height_c = tekslide.new(frame, "Height", 1, 100, "TOPLEFT", frame_width_c, "TOPRIGHT", 4*GAP, 0)
frame_height:SetValueStep(1)
frame_height:SetScript("OnValueChanged", function(self, newvalue)
	frame_height_l:SetText(string.format("Height: %d", newvalue))
	StayFocused.db.height = newvalue
	StayFocused:ApplyOptions()
end)	


local font_size, font_size_l, font_size_c = tekslide.new(frame, "Font size", 6, 32, "TOPLEFT", frame_width_c, "BOTTOMLEFT", 0, -BIGGAP)
font_size:SetValueStep(1)
font_size:SetScript("OnValueChanged", function(self, newvalue)
	font_size_l:SetText(string.format("Font size: %d", newvalue))
	StayFocused.db.font_size = newvalue
	StayFocused:ApplyOptions()
end)
local font_outline = tekcheck.new(frame, nil, "Font Outline", "TOPLEFT", font_size_c, "TOPRIGHT", 4*GAP, 0)
font_outline:SetScript("OnClick", function(self)
	checksound(self);
	StayFocused.db.font_outline = not StayFocused.db.font_outline
	StayFocused:ApplyOptions()
end)

local aon, aon_l, aonc = tekslide.new(frame, "OOC alpha", 0, 1, "TOPLEFT", font_size_c, "BOTTOMLEFT", 0, -BIGGAP)
aon:SetValueStep(0.1)
aon:SetScript("OnValueChanged", function(self, newvalue)
	aon_l:SetText(string.format("OOC alpha: %.1f", newvalue))
	StayFocused.db.alpha_ooc_normal = newvalue
end)
local aoz, aoz_l = tekslide.new(frame, "OOC alpha when zero", 0, 1, "TOPLEFT", aon, "BOTTOMLEFT", 0, -GAP)
aoz:SetValueStep(0.1)
aoz:SetScript("OnValueChanged", function(self, newvalue)
	aoz_l:SetText(string.format("OOC alpha when zero: %.1f", newvalue))
	StayFocused.db.alpha_ooc_zero = newvalue
end)
local aom, aom_l = tekslide.new(frame, "OOC alpha when max", 0, 1, "TOPLEFT", aoz, "BOTTOMLEFT", 0, -GAP)
aom:SetValueStep(0.1)
aom:SetScript("OnValueChanged", function(self, newvalue)
	aom_l:SetText(string.format("OOC alpha when max: %.1f", newvalue))
	StayFocused.db.alpha_ooc_maximum = newvalue
end)

local acn, acn_l = tekslide.new(frame, "Combat alpha", 0, 1, "TOPLEFT", aonc, "TOPRIGHT", 4*GAP, 0)
acn:SetValueStep(0.1)
acn:SetScript("OnValueChanged", function(self, newvalue)
	acn_l:SetText(string.format("Combat alpha: %.1f", newvalue))
	StayFocused.db.alpha_normal = newvalue
end)
local acz, acz_l = tekslide.new(frame, "Combat alpha when zero", 0, 1, "TOPLEFT", acn, "BOTTOMLEFT", 0, -GAP)
acz:SetValueStep(0.1)
acz:SetScript("OnValueChanged", function(self, newvalue)
	acz_l:SetText(string.format("Combat alpha when zero: %.1f", newvalue))
	StayFocused.db.alpha_zero = newvalue
end)
local acm, acm_l = tekslide.new(frame, "Combat alpha when max", 0, 1, "TOPLEFT", acz, "BOTTOMLEFT", 0, -GAP)
acm:SetValueStep(0.1)
acm:SetScript("OnValueChanged", function(self, newvalue)
	acm_l:SetText(string.format("Combat alpha when max: %.1f", newvalue))
	StayFocused.db.alpha_maximum = newvalue
end)


frame:SetScript("OnShow", function(frame)
	
	local text = "9999 (100.0%)"
	if StayFocused.db.style == 2 then text = "9999 (100%)" end
	if StayFocused.db.style == 3 then text = "9999" end
	if StayFocused.db.style == 4 then text = "100.0%" end
	if StayFocused.db.style == 5 then text = "100%" end
	if StayFocused.db.style == 6 then text = "" end
	styletext:SetText(text)
	
	UIDropDownMenu_Initialize(styledropdown, function()
		local selected, info = StayFocused.db.style, UIDropDownMenu_CreateInfo()
	
		info.func = OnClickStyle
	
		info.text = "value (percent [1 decimal place])"
		info.value = 1
		info.checked = 1 == selected
		UIDropDownMenu_AddButton(info)
	
		info.text = "value (percent [no decimal places])"
		info.value = 2
		info.checked = 2 == selected
		UIDropDownMenu_AddButton(info)
		
		info.text = "value"
		info.value = 3
		info.checked = 3 == selected
		UIDropDownMenu_AddButton(info)
	
		info.text = "percent [1 decimal place]"
		info.value = 4
		info.checked = 4 == selected
		UIDropDownMenu_AddButton(info)
		
		info.text = "percent [no decimal places]"
		info.value = 5
		info.checked = 5 == selected
		UIDropDownMenu_AddButton(info)
		
		info.text = "no text"
		info.value = 6
		info.checked = 6 == selected
		UIDropDownMenu_AddButton(info)
	end)

	textext:SetText(StayFocused.db.texture)
	
	UIDropDownMenu_Initialize(texdropdown, function()
		local selected, info = StayFocused.db.texture, UIDropDownMenu_CreateInfo()
	
		info.func = OnClickTexture
		
		for k,v in pairs(StayFocused.textures) do
			info.text = k
			info.value = k
			info.checked = k == selected
			UIDropDownMenu_AddButton(info)
		end
	end)
	
	class_colored:SetChecked(StayFocused.db.class_colored)
	
	backdropalpha:SetValue(StayFocused.db.backdrop_alpha)

	aon:SetValue(StayFocused.db.alpha_ooc_normal)
	aoz:SetValue(StayFocused.db.alpha_ooc_zero)
	aom:SetValue(StayFocused.db.alpha_ooc_maximum)
	acn:SetValue(StayFocused.db.alpha_normal)
	acz:SetValue(StayFocused.db.alpha_zero)
	acm:SetValue(StayFocused.db.alpha_maximum)
	

	font_size:SetValue(StayFocused.db.font_size)
	font_outline:SetChecked(StayFocused.db.font_outline)

	frame_width:SetValue(StayFocused.db.width)
	frame_height:SetValue(StayFocused.db.height)
end)

StayFocused.configframe = frame
InterfaceOptions_AddCategory(frame)

LibStub("tekKonfig-AboutPanel").new("Stay Focused!", "StayFocused")
