local Exploit = (
	(game:service'RunService':IsStudio() and "Studio") or
	(syn and not is_sirhurt_closure and not pebc_execute and "Synapse") or 
	(secure_load and "Sentinel") or
	(is_sirhurt_closure and "Sirhurt") or
	(pebc_execute and "ProtoSmasher") or
	(KRNL_LOADED and "Krnl") or
	(WrapGlobal and "WeAreDevs") or
	(isvm and "Proxo") or
	(shadow_env and "Shadow") or
	(jit and "EasyExploits") or
	(getreg and getreg()['CalamariLuaEnv'] and "Calamari") or
	(unit and "Unit") or
	("Undetectable")
)

local RunningOnExploit = Exploit~='Studio' and Exploit~='Undetectable'

local Player = game:service'Players'.localPlayer
local Studio = game:service'RunService':IsStudio()
local Drag = not RunningOnExploit and require(script:WaitForChild'Drag') or loadstring(game:HttpGet'https://raw.githubusercontent.com/supersonicfan111/exploitstuff/master/guidragmodule.lua')()
local Rippler = RunningOnExploit and loadstring(game:HttpGet'https://raw.githubusercontent.com/supersonicfan111/MaterialLuaRewrite/master/rippler.lua')() or require(script:WaitForChild'Rippler')
local UserInput = game:service'UserInputService'

local materialLua = {}
local uiFolder= Exploit~='Studio' and Exploit~='Undetectable' and game:GetObjects"rbxassetid://5615885279"[1] or script:WaitForChild'UIs'
uiFolder.Parent=nil
materialLua.Theme=RunningOnExploit and loadstring(game:HttpGet'https://raw.githubusercontent.com/supersonicfan111/MaterialLuaRewrite/master/Theme.lua')() or require(script:WaitForChild'Theme')

materialLua.Container={}
materialLua.MainFrame={}
materialLua.Tab={}
materialLua.Button={}
materialLua.Toggle={}
materialLua.Slider={}
materialLua.Dropdown={}
materialLua.ToggleGroup={}
materialLua.Base={}
materialLua.TextField={}
materialLua.ColorPicker={}

local function OnCompleted(tw,callback,status)
	local conn;
	conn=tw.Completed:connect(function(state)
		conn:disconnect()
		if(state==(status or Enum.TweenStatus.Completed))then
			callback()
		end
	end)
	return conn;
end

local clickEvents = {
	[Enum.UserInputType.MouseButton1]=true;
	[Enum.UserInputType.MouseButton2]=true;
	[Enum.UserInputType.MouseButton3]=true;
}

local fakeInstanceMeta={
	__index=function(s,i)
		if(rawget(s,i)~=nil)then
			return rawget(s,i)
		end
		if(rawget(s,"Get"..i)~=nil)then
			return rawget(s,"Get"..i)
		end
		if(materialLua.Base[i])then
			return materialLua.Base[i]
		end
		if(rawget(s,'Inheritance'))then
			for inst,props in next, rawget(s,'Inheritance')do
				if(table.find(props,i))then
					return inst[i]
				end
			end
		end
		local suc,r = pcall(function()return rawget(s,'Instance')[i]end)
		if(suc)then
			return r
		else
			error(r,3)
		end
	end,
	__newindex=function(s,i,v)
		if(rawget(s,"Set"..i))then
			return rawget(s,"Set"..i)(s,v)
		elseif(rawget(s,i)~=nil)then
			return rawset(s,i,v)
		else
			if(rawget(s,'Inheritance'))then
				for inst,props in next, rawget(s,'Inheritance')do
					if(table.find(props,i))then
						local suc,r = pcall(function()inst[i]=v;end)
						if(not suc)then
							error(r,3)
						end
						return
					end
				end	
			end
			local suc,r = pcall(function()rawget(s,'Instance')[i]=v;end)
			if(not suc)then
				error(r,3)
			end
		end
	end
}


local function newFIndex(t)
	return function(s,i)
		if(rawget(t,i)~=nil)then
			return rawget(t,i)
		else
			return fakeInstanceMeta.__index(s,i)
		end
	end
end

materialLua.Tab.__index=function(s,i)
	if(rawget(s,i)~=nil)then
		return rawget(s,i)
	elseif(materialLua.Tab[i])then
		return materialLua.Tab[i]
	elseif(rawget(s,'Parent'))then
		return rawget(s,'Parent')[i]
	elseif(rawget(materialLua.Base,i))then
		return materialLua.Base[i]
	else
		return nil
	end
end;

materialLua.Container.__index=materialLua.Container;
materialLua.MainFrame.__index=materialLua.MainFrame;

materialLua.Button.__index=newFIndex(materialLua.Button)
materialLua.Button.__newindex=fakeInstanceMeta.__newindex

materialLua.Toggle.__index=newFIndex(materialLua.Toggle)
materialLua.Toggle.__newindex=fakeInstanceMeta.__newindex

materialLua.Slider.__index=newFIndex(materialLua.Slider)
materialLua.Slider.__newindex=fakeInstanceMeta.__newindex

materialLua.ColorPicker.__index=newFIndex(materialLua.ColorPicker)
materialLua.ColorPicker.__newindex=fakeInstanceMeta.__newindex

materialLua.TextField.__index=newFIndex(materialLua.TextField)
materialLua.TextField.__newindex=fakeInstanceMeta.__newindex


local dropIdx = newFIndex(materialLua.Dropdown)
materialLua.Dropdown.__index=function(s,i)
	if(rawget(s,i)~=nil)then
		return rawget(s,i)
	elseif(materialLua.Dropdown[i])then
		return materialLua.Dropdown[i]
	elseif(materialLua.Container[i])then
		return materialLua.Container[i]
	elseif(rawget(materialLua.Base,i))then
		return materialLua.Base[i]
	elseif(rawget(s,'Parent'))then
		return rawget(s,'Parent')[i]
	else
		local s,e = pcall(function()return dropIdx(s,i)end)
		return s and e or error(e,3)
	end
end;
materialLua.Dropdown.__newindex=fakeInstanceMeta.__newindex

local togGIdx = newFIndex(materialLua.ToggleGroup)
materialLua.ToggleGroup.__index=function(s,i)
	if(rawget(s,i)~=nil)then
		return rawget(s,i)
	elseif(materialLua.ToggleGroup[i])then
		return materialLua.ToggleGroup[i]
	elseif(materialLua.Container[i])then
		return materialLua.Container[i]
	elseif(rawget(materialLua.Base,i))then
		return materialLua.Base[i]
	elseif(rawget(s,'Parent'))then
		return rawget(s,'Parent')[i]
	else
		local s,e = pcall(function()return togGIdx(s,i)end)
		return s and e or error(e,3)
	end
end;
materialLua.ToggleGroup.__newindex=fakeInstanceMeta.__newindex

setmetatable(materialLua.Tab,{__index=materialLua.Container})
setmetatable(materialLua.Container,{__index=materialLua})
setmetatable(materialLua.MainFrame,{__index=materialLua})


materialLua.UI={}

function Tween(Inst,Time,Properties,EStyle,EDir,Repeat,Rev,Delay,Yield)
	local tw = game:service'TweenService':Create(Inst,TweenInfo.new(Time or 1,EStyle or Enum.EasingStyle.Quad,EDir or Enum.EasingDirection.Out,Repeat or 0,Rev or false,Delay or 0),Properties)
	tw:Play()
	if(Yield)then
		tw.Completed:wait()
	end
	return tw;
end

local ColorProp={
	TextLabel='TextColor3';
	TextButton='TextColor3';
	TextBox='TextColor3';
	ImageLabel='ImageColor3';
	ImageButton='ImageColor3';
}

function materialLua.Base:UpdateColours()
	local themeData = (({pcall(function()return self.GetTheme end)})[1] and self:GetTheme() or self.Parent and self.Parent:GetTheme())
	for Inst,Data in next, self.ThemeData or {} do
		if(typeof(Inst)=='table' and Inst.SetColor)then
			local color = themeData['Get' .. (Data.Colour or 'Primary')](themeData,Data.Component)
			Inst:SetColor(color)
		elseif(typeof(Data)=='table')then
			if(Data.Properties)then
				for Prop,Value in next, Data.Properties do
					if(Prop~='Property' and Prop~='Colour' and Prop~='Component')then
						local color = themeData['Get' .. (Value.Colour or 'Primary')](themeData,Value.Component)
						Inst[Prop]=color;
					end
				end
			else
				local color = themeData['Get' .. (Data.Colour or 'Primary')](themeData,Data.Component)
				Inst[Data.Property or ColorProp[Inst.ClassName] or 'BackgroundColor3']=color
			end
		end	
	end
end

function materialLua.Container:NewButton(options)
	local options = options or {}
	local newButton = self.UI.new("Button")
	local textLabel = newButton:WaitForChild'TextLabel'
	textLabel.Text=options.Text or 'Button'
	newButton.Parent=self.Content
	newButton.ImageTransparency=1
	newButton.Shadow.ImageTransparency=1
	textLabel.TextTransparency=1
	
	Tween(newButton,.15,{ImageTransparency=0})
	Tween(newButton.Shadow,.15,{ImageTransparency=0})
	Tween(textLabel,.15,{TextTransparency=0})
	local ripple = Rippler.new(newButton,'Round',4,self:GetTheme():GetSecondary'Button')
	
	newButton:WaitForChild'Clicker'.InputBegan:connect(function(io)
		if(clickEvents[io.UserInputType])then
			ripple:Down(io.Position.x,io.Position.y)
		end
	end)
	
	newButton:WaitForChild'Clicker'.InputEnded:connect(function(io)
		if(clickEvents[io.UserInputType] or io.UserInputType==Enum.UserInputType.MouseMovement)then
			ripple:Up()
		end
	end)
	if(options.Callback)then
		newButton.MouseButton1Click:connect(options.Callback)
	end
	
	local button = setmetatable({
		Parent=self;
		Instance=newButton;
		Rippler=ripple;
		Text=textLabel;
		Component='Button';
		ThemeData={
			[newButton]={Colour="Primary";Component="Button"};
			[newButton.Shadow]={Colour="Primary";Component="Button"};
			[textLabel]={Colour="Secondary";Component="Button"};
			[ripple]={Colour="Secondary",Component="Button"};
		};
		Inheritance={[textLabel]={"Text","TextSize","TextColor3","TextStrokeColor3","TextStrokeTransparency","RichText","TextScaled","TextFits","TextTruncate","TextWrapped","TextScaled","TextXAlignment","TextYAlignment","TextBounds","LineHeight"}};
	},materialLua.Button)
	
	table.insert(self.Children,button)
	
	button:UpdateColours()
	
	return button
end

function materialLua:GetTheme()
	return self.ThemeD
end


function materialLua.Tab:Show()
	for _,v in next, self.Parent.Tabs do
		v.Visible=v==self
		v:Update()
	end
end

function materialLua.Tab:Update()
	self.Content.Visible=self.Visible
	Tween(self.Button,(self.Button.TextTransparency==1 and 1 or .15),{TextTransparency=self.Visible and 0 or .5})
end

function materialLua.Toggle:Update()
	warn("blank toggle update")
end

function materialLua.Container:UpdateColours(recursive)
	materialLua.Base.UpdateColours(self)
	local recursive = recursive or true
	if(recursive)then
		for i = 1,#self.Children do
			local lol=true;
			pcall(function()
				if(self.Children[i].UpdateColours)then
					lol=false;
					self.Children[i]:UpdateColours(true)
				end
			end)
			pcall(function()
				if(lol)then
					materialLua.Base.UpdateColours(self.Children[i],true)
				end
			end)
		end
	end
	
end

function materialLua.Tab:UpdateColours(...)
	pcall(function()self.Button.TextColor3=self:GetTheme().Tab and self:GetTheme().Tab.Primary or self:GetTheme().Secondary;end)
	return materialLua.Container.UpdateColours(self,...)
end

function materialLua.ColorPicker:Update()
	self.Tracker.ImageColor3=self:GetColor()
	self.SaturationSlider:WaitForChild'UIGradient'.Color=ColorSequence.new(Color3.fromHSV(self:GetHSV(1),1,self:GetHSV(3)),Color3.new(0,0,0):lerp(Color3.new(1,1,1),self:GetHSV(3)))
end

function materialLua.ColorPicker:SetColor(c3)
	return self:SetHSV(Color3.toHSV(c3))
end

function materialLua.ColorPicker:SetHSV(h,s,v)
	local H,S,V = self:GetHSV()
	self.HSV={h or H,s or S,v or V}
	self:Update()	
end

function materialLua.ColorPicker:GetColor()
	return Color3.fromHSV(self:GetHSV())
end

function materialLua.ColorPicker:GetHSV(val)
	local hsv=rawget(self,'HSV')
	if(typeof(val)=='number' and val>=1 and val<=#hsv)then
		return hsv[val]
	end
	return unpack(hsv)
end

function materialLua.Container:NewColorPicker(options)
	local options = options or {}
	local Picker = materialLua.UI.new("ColorPicker")
	local TitleB = Picker:WaitForChild'TitleBar'
	local TitleT = TitleB:WaitForChild'Title'
	local Tracker = TitleB:WaitForChild'Tracker'
	local TrackerShad=Tracker:WaitForChild'Shadow'
	Tracker:GetPropertyChangedSignal'ImageColor3':connect(function()
		TrackerShad.ImageColor3=Tracker.ImageColor3
	end)
	local HueG = Picker:WaitForChild'Hue'
	local SatG = Picker:WaitForChild'Saturation'
	local ValG = Picker:WaitForChild'Value'
	local ripple = Rippler.new(TitleB,'Round',4,self:GetTheme():GetSecondary'ColorPicker')
	local SatS = SatG.Shadow
	local HL = Picker:WaitForChild'HL'
	local SL = Picker:WaitForChild'SL'
	local VL = Picker:WaitForChild'VL'
	SatG.UIGradient:GetPropertyChangedSignal'Color':connect(function()
		SatS.UIGradient.Color=SatG.UIGradient.Color
	end)
	
	local pickerInst = {Component='ColorPicker';HSV={0,0,0};HueSlider=HueG;SaturationSlider=SatG;BrightnessSlider=ValG;Open=false;Value=Color3.new(1,0,0);Tracker=Tracker;Instance=Picker;Parent=self;}
	
	pickerInst.ThemeData={
		[Picker]={Colour="Primary";Component="ColorPicker"};
		[TitleB]={Colour="Secondary";Component="ColorPicker"};
		[TitleB.Shadow]={Colour="Secondary";Component="ColorPicker"};
		[TitleT]={Colour="Secondary";Component="ColorPicker"};
		[HL]={Colour="Primary";Component="ColorPicker"};
		[SL]={Colour="Primary";Component="ColorPicker"};
		[VL]={Colour="Primary";Component="ColorPicker"};
		[HL.Label]={Colour="Secondary";Component="ColorPicker"};
		[SL.Label]={Colour="Secondary";Component="ColorPicker"};
		[VL.Label]={Colour="Secondary";Component="ColorPicker"};
		[ripple]={Colour="Secondary";Component="ColorPicker"};	
	}
	setmetatable(pickerInst,materialLua.ColorPicker)
	
	TitleT.Text = options.Title or options.Text or 'Taste the rainbow'
	
	HueG.InputBegan:connect(function(Input)
		if(Input.UserInputType==Enum.UserInputType.MouseButton1)then
			pickerInst:SetHSV(math.clamp(Input.Position.x-HueG.AbsolutePosition.x,0,HueG.AbsoluteSize.x)/HueG.AbsoluteSize.x)
			local detectChange = UserInput.InputChanged:connect(function(io)
				if(io.UserInputType==Enum.UserInputType.MouseMovement)then 
					pickerInst:SetHSV(math.clamp(io.Position.x-HueG.AbsolutePosition.x,0,HueG.AbsoluteSize.x)/HueG.AbsoluteSize.x)
				end
			end)
			local inputE;
			inputE=HueG.InputEnded:connect(function(Input)
				if(Input.UserInputType==Enum.UserInputType.MouseButton1)then
					detectChange:disconnect()
					inputE:disconnect()
				end
			end)
		end
	end)
	
	SatG.InputBegan:connect(function(Input)
		if(Input.UserInputType==Enum.UserInputType.MouseButton1)then
			pickerInst:SetHSV(pickerInst:GetHSV(1),1-math.clamp(Input.Position.x-SatG.AbsolutePosition.x,0,SatG.AbsoluteSize.x)/SatG.AbsoluteSize.x)
			local detectChange = UserInput.InputChanged:connect(function(io)
				if(io.UserInputType==Enum.UserInputType.MouseMovement)then 
					pickerInst:SetHSV(pickerInst:GetHSV(1),1-math.clamp(io.Position.x-SatG.AbsolutePosition.x,0,SatG.AbsoluteSize.x)/SatG.AbsoluteSize.x)
				end
			end)
			local inputE;
			inputE=SatG.InputEnded:connect(function(Input)
				if(Input.UserInputType==Enum.UserInputType.MouseButton1)then
					detectChange:disconnect()
					inputE:disconnect()
				end
			end)
		end
	end)
	
	ValG.InputBegan:connect(function(Input)
		if(Input.UserInputType==Enum.UserInputType.MouseButton1)then
			pickerInst:SetHSV(pickerInst:GetHSV(1),pickerInst:GetHSV(2),1-math.clamp(Input.Position.x-ValG.AbsolutePosition.x,0,ValG.AbsoluteSize.x)/ValG.AbsoluteSize.x)
			local detectChange = UserInput.InputChanged:connect(function(io)
				if(io.UserInputType==Enum.UserInputType.MouseMovement)then 
					pickerInst:SetHSV(pickerInst:GetHSV(1),pickerInst:GetHSV(2),1-math.clamp(io.Position.x-ValG.AbsolutePosition.x,0,ValG.AbsoluteSize.x)/ValG.AbsoluteSize.x)
				end
			end)
			local inputE;
			inputE=ValG.InputEnded:connect(function(Input)
				if(Input.UserInputType==Enum.UserInputType.MouseButton1)then
					detectChange:disconnect()
					inputE:disconnect()
				end
			end)
		end
	end)
	
	
	TitleB:WaitForChild'Clicker'.InputBegan:connect(function(io)
		if(clickEvents[io.UserInputType])then
			ripple:Down(io.Position.x,io.Position.y)
		end
	end)
	
	TitleB:WaitForChild'Clicker'.InputEnded:connect(function(io)
		if(clickEvents[io.UserInputType] or io.UserInputType==Enum.UserInputType.MouseMovement)then
			ripple:Up()
		end
	end)
	
	TitleB:WaitForChild'Clicker'.MouseButton1Click:connect(function()
		pickerInst.Open = not pickerInst.Open
		Tween(Picker,.15,{Size=pickerInst.Open and UDim2.new(1,0,0,115) or UDim2.new(1,0,0,40)})
	end)
	
	pickerInst:Update()
	pickerInst:UpdateColours()
	
	table.insert(self.Children,pickerInst)
	pickerInst:SetColor(options.Default or options.Color or Color3.new(1,0,0))
	
	Picker.Parent=self.Content
	return pickerInst
end

materialLua.Container.NewColourPicker=materialLua.Container.NewColorPicker;

function materialLua.Dropdown:Update()
	local offset = self.Open and self.UIList.AbsoluteContentSize.Y+5 or 0
	self.Content.Size=UDim2.new(1,-5,0,offset)
	--	self.Instance.Size=UDim2.new(1,0,0,30+offset)
	Tween(self.Instance,.15,{Size=UDim2.new(1,0,0,30+offset)})
	
end

function materialLua.Container:NewDropdown(options)
	local options = options or {}
	local drop = materialLua.UI.new("Dropdown")
	local content = drop:WaitForChild'Content'
	local button = drop:WaitForChild'Tab'
	local label = button:WaitForChild'TextLabel'
	local arrow = button:WaitForChild'Arrow'
	local Dropdown={Component='Dropdown';Content=content;Instance=drop;UIList=content:WaitForChild'UIListLayout';Children={};Parent=self;Label=label;Arrow=arrow;Button=button;Open=false;};
	button.ImageTransparency=1
	label.TextTransparency=1
	
	Dropdown.UIList:GetPropertyChangedSignal"AbsoluteContentSize":connect(function()
		Dropdown:Update()
	end)
	
	Tween(button,.15,{ImageTransparency=.6})
	Tween(arrow,.15,{ImageTransparency=.5})
	Tween(label,.15,{TextTransparency=0})
	local ripple = Rippler.new(button,'Round',4,self:GetTheme():GetSecondary'Dropdown')
	label.Text=options.Title or options.Text or "Where we droppin' boys?"
	
	Dropdown.ThemeData={
		[label]={Colour="Secondary";Component="Dropdown"};
		[button]={Colour="Primary";Component="Dropdown"};
		[arrow]={Colour="Primary";Component="Dropdown"};
		[ripple]={Colour="Secondary",Component="Dropdown"};
	};
	button:WaitForChild'Clicker'.InputBegan:connect(function(io)
		if(clickEvents[io.UserInputType])then
			ripple:Down(io.Position.x,io.Position.y)
		end
	end)
	
	button:WaitForChild'Clicker'.InputEnded:connect(function(io)
		if(clickEvents[io.UserInputType] or io.UserInputType==Enum.UserInputType.MouseMovement)then
			ripple:Up()
		end
	end)
	
	button.MouseButton1Click:connect(function()
		Dropdown.Open=not Dropdown.Open
		Dropdown:Update()
	end)
	
	Dropdown.Inheritance={[label]={"Text","TextSize","TextColor3","TextStrokeColor3","TextStrokeTransparency","RichText","TextScaled","TextFits","TextTruncate","TextWrapped","TextScaled","TextXAlignment","TextYAlignment","TextBounds","LineHeight"}};
	
	Dropdown.Rippler=ripple
	setmetatable(Dropdown,materialLua.Dropdown)
	
	table.insert(self.Children,Dropdown)
	
	Dropdown:UpdateColours()
	drop.Parent=self.Content
	return Dropdown
end

materialLua.Container.NewFolder=materialLua.Container.NewDropdown;

function Snap(num,steps)
	if(steps>=math.huge or steps<=-math.huge or steps==0)then
		return Round(num,3)
	else
		return math.floor(num/steps+0.5)*steps
	end
end

function Scale(dist,minDist,maxDist,minVal,maxVal)
	return math.clamp((maxVal-minVal)/(maxDist-minDist)*(dist-minDist)+minVal or maxVal,minVal,maxVal)
end

function Round(num,numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function materialLua.Toggle:SetState(state,triggeredByUser)
	if(rawget(self,'Locked') and triggeredByUser)then return end
	if(self.State~=state)then
		self.State=state
		self:Update();
		self._StateChangedEvent:Fire(self.State,triggeredByUser or false)
	end	
end

function materialLua.Slider:SetValue(value)
	self.RawValue=math.clamp(value,self.Min,self.Max);
	if(self.StrictStepObey)then
		self.RawValue=Snap(self.RawValue,self.Steps)
	end
	self.Input.Text=self.RawValue
	self._ValueChanged:Fire(self.RawValue)
	self:Update()
end

function materialLua.Slider:GetValue()
	return self.RawValue;
end

function materialLua.Slider:SetPos(value)
	local value = math.clamp(value,self.Min,self.Max)
	if(self.StrictStepObey)then
		value=Snap(value,self.Steps)
	end
	local pos = 1-((self.Max-value)/(self.Max-self.Min))
	local indicatorSize = Scale(value,self.Min,self.Max,16,36)
	Tween(self.Dot,.15,{Position=UDim2.new(pos,0,.5,0)})
	Tween(self.Fill,.15,{Size=UDim2.new(pos,0,1,0)})
	self.ValInd.Size=UDim2.new(0,indicatorSize,0,indicatorSize)
end

function materialLua.Slider:Update()
	self.Input.Text=self.RawValue
	self:SetPos(self.RawValue)
end

function materialLua.Slider:GetPrimary()
	return self.Parent:GetTheme():GetPrimary("Toggle")
end

function materialLua.Slider:GetSecondary()
	return self.Parent:GetTheme():GetSecondary("Toggle")
end

function materialLua.Container:NewSlider(options)
	local container=self;
	local options = options or {}
	local event = Instance.new("BindableEvent")
	local self={
		_ValueChanged=event;
		ValueChanged=event.Event;
		Component='Slider';
		Parent=container;
		Min=options.Min or 0;
		Max=options.Max or options.Min and options.Min+100 or 100;
		Steps=options.Steps or options.Decimals and tonumber("1" .. string.rep(0,options.Decimals)) or 1;
		StrictStepObey=options.StrictStepObey or options.AllStep or false;
	}
	self.Max=math.max(self.Min+1,self.Max)
	self.Min=math.min(self.Min,self.Max)
	self.RawValue=options.Default or options.Value or (self.Min+self.Max)/2
	if(self.StrictStepObey)then
		self.RawValue=Snap(self.RawValue,self.Steps)
	end
	local SliderInst = materialLua.UI.new("Slider")
	local SliderTrack = SliderInst:WaitForChild'Track'
	local SliderFill = SliderTrack:WaitForChild'Fill'
	local SliderDot = SliderTrack:WaitForChild'Dot'
	local SliderTxt = SliderInst:WaitForChild'TextLabel'
	local SliderInp = SliderInst:WaitForChild'Input'
	local ValueIndicator = SliderDot:WaitForChild'ValueIndicator'
	self.Instance=SliderInst
	self.Track=SliderTrack
	self.Fill=SliderFill
	self.Dot=SliderDot
	self.Input=SliderInp
	self.Label=SliderTxt
	self.ValInd=ValueIndicator;
	self.Label.Text=options.Text or "Slip 'n' Slide"
	SliderInst.Parent=container.Content
	
	self.ThemeData={
		[self.Instance]={Colour="Secondary";Component="Slider"};
		[self.Track]={Colour="Primary";Component="Slider"};
		[self.Fill]={Colour="Primary";Component="Slider"};
		[self.Dot]={Colour="Primary",Component="Slider"};
		[self.Label]={Colour="Primary",Component="Slider"};
		[self.Input]={Colour="Primary",Component="Slider"};
		[ValueIndicator]={Colour="Primary",Component="Slider"};
	};
	
	SliderInp.Text=self.RawValue
	
	SliderInst.ImageTransparency=1
	SliderTrack.BackgroundTransparency=1
	SliderFill.BackgroundTransparency=1
	SliderDot.ImageTransparency=1
	SliderTxt.TextTransparency=1
	SliderInp.TextTransparency=1
	
	Tween(SliderInst,.15,{ImageTransparency=0})
	Tween(SliderTrack,.15,{BackgroundTransparency=.5})
	Tween(SliderFill,.15,{BackgroundTransparency=0})
	Tween(SliderDot,.15,{ImageTransparency=0})
	Tween(SliderTxt,.15,{TextTransparency=0})
	Tween(SliderInp,.15,{TextTransparency=0})
	
	setmetatable(self,materialLua.Slider)
	self:Update()
	
	SliderInp.FocusLost:connect(function(enter,io)
		local newVal = tonumber(SliderInp.Text)
		if(typeof(newVal)~='number')then
			newVal=self.RawValue
		end
		if(enter)then
			SliderInp.Text=newVal
			self:SetValue(newVal)
		else
			self:Update()
		end
	end)
	
	SliderInp.Changed:connect(function()
		if(SliderInp:IsFocused())then
			local newVal = tonumber(SliderInp.Text)
			if(typeof(newVal)~='number')then
				newVal=self.RawValue
			end
			self:SetPos(newVal)
		end
	end)
	
	local detectMB1=SliderDot.InputBegan:connect(function(Input)
		if(Input.UserInputType==Enum.UserInputType.MouseButton1)then
			Tween(ValueIndicator,.15,{ImageTransparency=.8})
			local detectChange = UserInput.InputChanged:connect(function(io)
				if(io.UserInputType==Enum.UserInputType.MouseMovement)then 
					local newPos = io.Position.x-SliderTrack.AbsolutePosition.X
					local value = Scale(newPos,0,SliderTrack.AbsoluteSize.X,self.Min,self.Max)
					self:SetValue(Snap(value,self.Steps))
				end
			end)
			local inputE;
			inputE=SliderDot.InputEnded:connect(function(Input)
				if(Input.UserInputType==Enum.UserInputType.MouseButton1)then
					Tween(ValueIndicator,.15,{ImageTransparency=1})
					detectChange:disconnect()
					inputE:disconnect()
				end
			end)
		end
	end)
	
	if(options.Callback)then
		event.Event:connect(options.Callback)
	end
	
	table.insert(container.Children,self)
	self:UpdateColours()
	return self
end

function materialLua.Toggle:GetPrimary()
	return self.Parent:GetTheme():GetPrimary("Toggle")
end

function materialLua.Toggle:GetSecondary()
	return self.Parent:GetTheme():GetSecondary("Toggle")
end

function materialLua.Toggle:UpdateColours()
	for inst,clr in next, self.ThemeData do
		local color = self['Get'..clr](self)
		if(inst:IsA'TextLabel' or inst:IsA'TextButton')then
			Tween(inst,0,{TextColor3 = color})
		elseif(inst:IsA'ImageLabel' or inst:IsA'ImageButton')then
			Tween(inst,0,{ImageColor3 = color})
		end
	end
end

function materialLua.ToggleGroup:SetToggle(t)
	if(not t)then return end
	if(not table.find(self.Children,t))then return error("That is not a valid toggle!")end;
	if(not self.CanSelectMultiple)then
		rawset(self,'Toggled',t)
		for i = 1,#self.Children do
			self.Children[i]:SetState(self.Children[i]==t)
			self.Children[i].Locked=not self.AllowSelectingNone and self.Children[i]==t or false
		end
	end
	self._NewToggleChosen:Fire(t.Text)
end

function materialLua.ToggleGroup:GetToggle(text)
	for i = 1,#self.Children do
		if(self.Children[i].Text==text)then
			return self.Children[i]
		end
	end
	return self.Children[1]
end

function materialLua.ToggleGroup:AddOptions(toggleData)
	for i,v in next, toggleData do
		local tog;
		if(typeof(v)=='table')then
			v.Type=v.Type or self.Type;
			if(typeof(i)=='string')then
				v.Text=i;
			end
			tog = self:NewToggle(v)
		elseif(typeof(v)=='string')then
			tog = self:NewToggle{
				Text=v;
				Type=self.Type;
			}
		elseif(typeof(v)=='boolean')then
			tog = self:NewToggle{
				State=v;
				Text=i;
				Type=self.Type;
			}
		end
		if(tog)then
			tog.StateChanged:connect(function(b,n)
				if(self.CanSelectMultiple and not self.AllowSelectingNone)then
					local shouldLock=true;
					for i = 1,#self.Children do
						if(self.Children[i].State)then
							shouldLock=false
							break;
						end
					end
					if(not shouldLock)then
						for i = 1,#self.Children do
							self.Children[i].Locked=false
						end
					else
						tog:SetState(true)
						tog.Locked=shouldLock
					end
					self._NewToggleChosen:Fire(tog.Text)
				else
					if(b and self.Toggled~=tog)then
						self:SetToggle(tog)
					end
				end
				local t={}
				for i = 1,#self.Children do
					local v = self.Children[i]
					t[v.Text]=v.State
				end
				self._Changed:Fire(t)
			end)
		end
	end
end
function materialLua.Container:NewToggleGroup(options)
	local options = options or {}
	local toggleData = options.Toggles or options.ToggleData or options.Options or {
		"test1";
		"test2";
		"test3";
	}
	local groupUI = materialLua.UI.new("ToggleGroup")
	local content = groupUI:WaitForChild'Container'
	local togEvent = Instance.new("BindableEvent")
	local chaEvent = Instance.new("BindableEvent")
	local containerObject={Changed=chaEvent.Event;_Changed=chaEvent;CanSelectMultiple=options.CanSelectMultiple or false;AllowSelectingNone=options.AllowEmptySelection or options.AllowSelectingNone or false;ToggleChanged=togEvent.Event;_NewToggleChosen=togEvent;Component='ToggleGroup';Content=content,UIList=content:WaitForChild'UIListLayout';Children={};Parent=self;}
	containerObject.Type=options.Type or options.DefaultType or 4;
	local listLayout = containerObject.UIList
	listLayout:GetPropertyChangedSignal'AbsoluteContentSize':connect(function()
		groupUI.Size=UDim2.new(1,0,0,listLayout.AbsoluteContentSize.Y+10)
	end)
	
	setmetatable(containerObject.Children,{
		__newindex=function(self,index,value)
			if(typeof(value)~='table' or value.Component~='Toggle')then
				if(value.Instance)then value.Instance:destroy();end;
				return nil;
			end
			rawset(self,index,value)
		end
	})
	
	containerObject.ThemeData={
		[groupUI]={Colour="Primary";Component="ToggleGroup"};
		[groupUI.Shadow]={Colour="Primary";Component="ToggleGroup"};
	}
	
	setmetatable(containerObject,materialLua.ToggleGroup)
	
	containerObject:AddOptions(toggleData)
	
	containerObject:SetToggle(containerObject.Children[1])
	
	groupUI.Parent=self.Content;
	table.insert(self.Children,containerObject)
	containerObject:UpdateColours()
	return containerObject
end

function materialLua.Container:NewLegacyDropdown(options)
	local options = options or {}
	local dropdown = self:NewDropdown{
		Text=options.Text;
	}
	local title = dropdown.Text
	local toggle = dropdown:NewToggleGroup{
		Options=options.Options;
	}
	if(options.Callback)then toggle.ToggleChanged:connect(options.Callback)end
	
	return {Dropdown=dropdown;Group=toggle;};
end

function materialLua.Container:NewLegacyChipSet(options)
	local options = options or {}
	local set = self:NewToggleGroup{
		CanSelectMultiple=true;
		AllowEmptySelection=true;
		Type=2;
		Options=options.Options;
	}
	if(options.Callback)then 
		set.Changed:connect(options.Callback)
	end
	
	return set
end

function materialLua.Container:NewLegacyDataTable(options)
	local options = options or {}
	local set = self:NewToggleGroup{
		CanSelectMultiple=true;
		AllowEmptySelection=true;
		Type=3;
		Options=options.Options;
	}
	if(options.Callback)then 
		set.Changed:connect(options.Callback)
	end
	
	return set
end


function materialLua.TextField:GetText()
	return self.Textbox.Text;
end

function materialLua.Container:NewTextBox(options)
	local options = options or {}
	local event = Instance.new("BindableEvent")
	local textfield = materialLua.UI.new("TextField")
	local box = textfield:WaitForChild'Value'
	local eff = textfield:WaitForChild'Effect'
	local txtShadow = textfield:WaitForChild'Shadow'
	
	box.PlaceholderText=options.PlaceholderText or options.Placeholder or 'Placeholder'
	box.Text=options.Default or ''
	box.ClearTextOnFocus=options.ClearTextOnFocus or true;
	
	local obj={
		_FocusLost=event;
		TextChanged=event.Event;
		Textbox=box;
		Instance=textfield;
		Effect=eff;
		Parent=self;
		Component='TextField';
		Inheritance={[box]={"FocusLost","Focused","Text","TextSize","TextColor3","TextStrokeColor3","TextStrokeTransparency","RichText","TextScaled","TextFits","TextTruncate","TextWrapped","TextScaled","TextXAlignment","TextYAlignment","TextBounds","LineHeight"}};
		ThemeData={
			[textfield]={Colour="Primary";Component="TextBox"};
			[eff]={Colour="Primary";Component="TextBox"};
			[txtShadow]={Colour="Primary";Component="TextBox"};
			[box]={Properties={PlaceholderColor3={Colour="Secondary";Component="TextBox"};TextColor3={Colour="Secondary";Component="TextBox"}}};
		};
	}
	
	setmetatable(obj,materialLua.TextField)
	
	box.Focused:connect(function()
		Tween(textfield,.5,{ImageTransparency=.7})
		Tween(box,.5,{TextTransparency=0})
	end)
	
	box.FocusLost:connect(function(ent)
		Tween(textfield,.5,{ImageTransparency=.8})
		Tween(box,.5,{TextTransparency=.5})
	end)
	
	
	
	textfield.Parent=self.Content
	table.insert(self.Children,obj)
	obj:UpdateColours()
	return obj;	
end

materialLua.Container.NewTextField=materialLua.Container.NewTextBox

function materialLua.Container:NewLegacyTextField(options)
	local options = options or {}
	options.PlaceholderText=options.Text
	options.Text=''
	
	local box = self:NewTextBox(options)
	if(options.Callback)then
		box.FocusLost:connect(options.Callback)
	end
	return box
end

function materialLua.Container:NewToggle(options)
	local options = options or {}
	local Type = options.Type or self:GetTheme().ToggleType or 1;
	local stateChanged = Instance.new("BindableEvent")
	local ToggleInstance={Locked=false;Component='Toggle';Parent=self;_StateChangedEvent=stateChanged;StateChanged=stateChanged.Event;Type=Type;State=options.Default and true or options.State and true or options.Enabled and true or false;};
	if(Type==1)then
		local Switch = materialLua.UI.new("Switch")
		ToggleInstance.Instance=Switch
		local Tracker = Switch:WaitForChild'Tracker'
		local Clicker = Tracker:WaitForChild'Clicker'
		local Dot = Tracker:WaitForChild'Dot'
		local Hover = Dot:WaitForChild'Hover'
		local Text = Switch:WaitForChild'TextLabel'
		local currHoverRipple
		
		Text.TextTransparency=1
		Dot.ImageTransparency=1
		Tracker.ImageTransparency=1
		Switch.ImageTransparency=1
		
		Tween(Text,.15,{TextTransparency=0})
		Tween(Dot,.15,{ImageTransparency=0})
		Tween(Tracker,.15,{ImageTransparency=.8})
		Tween(Switch,.15,{ImageTransparency=.8})
		
		ToggleInstance.ThemeData={
			[Switch]='Primary';
			[Tracker]='Primary';
			[Hover]='Primary';
			[Dot]='Secondary';
			[Text]='Primary';
		}
		
		Text.Text = options.Text or "Sugarie"
		
		local function lazy()
			if(currHoverRipple)then
				Tween(currHoverRipple,.3,{ImageTransparency=1;}):Play()
				game:service'Debris':AddItem(currHoverRipple,.4)
				ToggleInstance.ThemeData[currHoverRipple]=nil;
				currHoverRipple=nil
			end
			currHoverRipple = Instance.new("ImageLabel")
			currHoverRipple.BackgroundTransparency = 1
			currHoverRipple.Image = "rbxassetid://5554831670"
			currHoverRipple.Name = "Hover"
			currHoverRipple.Position = UDim2.fromScale(.5,.5)
			currHoverRipple.Size = UDim2.fromOffset(0,0)
			currHoverRipple.ImageTransparency=.5
			currHoverRipple.AnchorPoint=Vector2.new(.5,.5)
			currHoverRipple.ImageColor3 = self:GetTheme():GetPrimary"Toggle"
			currHoverRipple.Parent = Dot
			Tween(currHoverRipple,.15,{Size=UDim2.fromOffset(36,36)}):Play()
			
			ToggleInstance.ThemeData[currHoverRipple]='Primary'
			
		end
		local hoverin=false;
		
		local function hover(io)
			if(clickEvents[io.UserInputType])then
				lazy()
			elseif(not hoverin)then
				hoverin=true
				Tween(Hover,.15,{ImageTransparency=.9})
			end
		end
		
		Clicker.InputEnded:connect(function(io)
			if(currHoverRipple)then
				Tween(currHoverRipple,.3,{ImageTransparency=1;}):Play()
				game:service'Debris':AddItem(currHoverRipple,.4)
				ToggleInstance.ThemeData[currHoverRipple]=nil;
				currHoverRipple=nil
			end
			if(io.UserInputType==Enum.UserInputType.MouseMovement)then
				hoverin=false
				Tween(Hover,.15,{ImageTransparency=1})
			end
		end)
		
		function ToggleInstance:Update()
			self.ThemeData[self.Instance.Tracker.Dot]=self.State and 'Primary' or 'Secondary'
			Tween(self.Instance.Tracker.Dot,.15,{Position=self.State and UDim2.new(1,0,.5,0) or UDim2.new(0,0,.5,0),ImageColor3=self.State and self:GetPrimary() or self:GetSecondary()})
		end
		
		Clicker.InputBegan:connect(hover)
		Clicker.InputChanged:connect(function(io)if(io.UserInputType==Enum.UserInputType.MouseMovement)then hover(io) end end)
		Clicker.MouseButton1Click:connect(function()
			ToggleInstance:SetState(not ToggleInstance.State,true)
		end)
		
		ToggleInstance.Inheritance={[Text]={"Text","TextSize","TextColor3","TextStrokeColor3","TextStrokeTransparency","RichText","TextScaled","TextFits","TextTruncate","TextWrapped","TextScaled","TextXAlignment","TextYAlignment","TextBounds","LineHeight"}};
	elseif(Type==2)then
		local Check = materialLua.UI.new("Check")
		local Shadow = Check:WaitForChild'Shadow'
		local Mark = Check:WaitForChild'Tick'
		local Label = Check:WaitForChild'TextLabel'
		
		Label.TextTransparency=1
		Shadow.ImageTransparency=1
		Mark.ImageTransparency=1
		Check.ImageTransparency=1
		
		Label.Text = options.Text or 'Checkmark'
		
		ToggleInstance.ThemeData={
			[Check]='Secondary';
			[Shadow]='Secondary';
			[Label]='Primary';
			[Mark]='Secondary';
		}
		
		Tween(Label,.15,{TextTransparency=0})
		Tween(Shadow,.15,{ImageTransparency=0})
		Tween(Check,.15,{ImageTransparency=0})
		Tween(Mark,.15,{ImageTransparency=self.State and 0 or 1})
		
		function ToggleInstance:Update()
			self.ThemeData[self.Instance]=self.State and 'Primary' or 'Secondary'
			self.ThemeData[self.Instance.Shadow]=self.State and 'Primary' or 'Secondary'
			self.ThemeData[self.Instance.TextLabel]=self.State and 'Secondary' or 'Primary'
			
			Tween(self.Instance,.15,{ImageColor3=self.State and self:GetPrimary() or self:GetSecondary()})
			Tween(self.Instance.Shadow,.15,{ImageColor3=self.State and self:GetPrimary() or self:GetSecondary()})
			Tween(self.Instance.Tick,.15,{ImageTransparency=self.State and 0 or 1})
			Tween(self.Instance.TextLabel,.15,{Position = self.State and UDim2.new(0,30,0,0) or UDim2.new(0,5,0,0),TextColor3 = self.State and self:GetSecondary() or self:GetPrimary(),Size = ToggleInstance.State and UDim2.new(1,-30,1,0) or UDim2.new(1,-5,1,0),})
		end
		ToggleInstance.Instance=Check
		Check.MouseButton1Click:connect(function()
			ToggleInstance:SetState(not ToggleInstance.State,true)
		end)	
		ToggleInstance.Inheritance={[Label]={"Text","TextSize","TextColor3","TextStrokeColor3","TextStrokeTransparency","RichText","TextScaled","TextFits","TextTruncate","TextWrapped","TextScaled","TextXAlignment","TextYAlignment","TextBounds","LineHeight"}};
	elseif(Type==3)then
		local Check = materialLua.UI.new("Checkbox")
		local Box = Check:WaitForChild'Tracker'
		local Mark = Box:WaitForChild'Tick'
		local Label = Check:WaitForChild'Value'
		Label.TextTransparency=1
		Box.ImageTransparency=1
		Mark.ImageTransparency=1
		Check.ImageTransparency=1
		
		Label.Text = options.Text or 'Checkbox'
		
		ToggleInstance.ThemeData={
			[Check]='Secondary';
			[Box]='Primary';
			[Mark]='Secondary';
			[Label]='Primary';
		}
		
		Tween(Label,.15,{TextTransparency=0})
		
		function ToggleInstance:Update()
			--self.ThemeData[self.Instance]=self.State and "Primary" or "Secondary"
			Tween(self.Instance,.15,{ImageTransparency=self.State and .8 or 0;})
			Tween(self.Instance.Tracker,.15,{ImageTransparency=self.State and 0 or .8})
			Tween(self.Instance.Tracker.Tick,.15,{ImageTransparency=self.State and 0 or .7})
		end
		
		ToggleInstance.Instance=Check
		Check.MouseButton1Click:connect(function()
			ToggleInstance:SetState(not ToggleInstance.State,true)
		end)	
		ToggleInstance.Inheritance={[Label]={"Text","TextSize","TextColor3","TextStrokeColor3","TextStrokeTransparency","RichText","TextScaled","TextFits","TextTruncate","TextWrapped","TextScaled","TextXAlignment","TextYAlignment","TextBounds","LineHeight"}};
	elseif(Type==4)then
		local RadioButton = materialLua.UI.new("Radio")
		local OuterRing = RadioButton:WaitForChild'Tracker'
		local InnerCircle = OuterRing:WaitForChild'Tick'
		local HovCircle = OuterRing:WaitForChild'Hovering'
		local Label = RadioButton:WaitForChild'Value'
		-- TODO: fade
		
		Label.Text = options.Text or 'Radios!'
		ToggleInstance.ThemeData={
			[RadioButton]='Secondary';
			[OuterRing]='Primary';
			[InnerCircle]='Primary';
			[Label]='Primary';
			[HovCircle]='Primary';
		}
		
		function ToggleInstance:Update()
			Tween(self.Instance,.15,{ImageTransparency=self.State and .8 or 0})
			Tween(self.Instance.Tracker.Tick,.15,{ImageTransparency=self.State and .4 or .9})
		end
		
		RadioButton:WaitForChild'Clicker'.InputBegan:connect(function(io,gpe)
			if(io.UserInputType==Enum.UserInputType.MouseMovement)then
				Tween(HovCircle,.15,{ImageTransparency=.9})
			end
		end)
		
		RadioButton:WaitForChild'Clicker'.InputEnded:connect(function(io,gpe)
			if(io.UserInputType==Enum.UserInputType.MouseMovement)then
				Tween(HovCircle,.15,{ImageTransparency=1})
			end
		end)
		
		RadioButton:WaitForChild'Clicker'.MouseButton1Click:connect(function()
			ToggleInstance:SetState(not ToggleInstance.State,true)
		end)
		
		ToggleInstance.Instance=RadioButton
		ToggleInstance.Inheritance={[Label]={"Text","TextSize","TextColor3","TextStrokeColor3","TextStrokeTransparency","RichText","TextScaled","TextFits","TextTruncate","TextWrapped","TextScaled","TextXAlignment","TextYAlignment","TextBounds","LineHeight"}};
		
	else
		error("Toggle can only be Type 1, 2, 3 or 4!")
	end
	
	
	if(options.Callback)then
		ToggleInstance.StateChanged:connect(options.Callback)
	end
	ToggleInstance.Instance.Parent=self.Content
	setmetatable(ToggleInstance,materialLua.Toggle)
	
	ToggleInstance:Update()
	ToggleInstance:UpdateColours()
	table.insert(self.Children,ToggleInstance)
	
	return ToggleInstance
end


function materialLua.MainFrame:NewTab(options) -- TODO: images
	local Name = options.Name or options.Title or "Tab"
	local Display = Name:upper()
	local navBar = self.NavBar;
	local navBarContent = navBar:WaitForChild'Content'
	
	local Button = materialLua.UI.new("Tab")
	Button.LayoutOrder=0
	for i = 1,#self.Tabs do self.Tabs[i].Button.LayoutOrder+=1 end
	local TextSize = game:service'TextService':GetTextSize(Display,Button.TextSize,Button.Font,Vector2.new(9e9,9e9)).X
	Button.Name = Name
	Button.Text = Display
	Button.Size = UDim2.new(0,TextSize+10,1,0)
	Button.TextColor3 = Color3.fromRGB(255,255,255) -- TODO: Theming
	Button.Parent=navBarContent
	local ContentFrame = materialLua.UI.new("ContentFrame",self.Content)
	local uiList = ContentFrame:WaitForChild'UIListLayout'
	local ContainerObj=setmetatable({
		Component='Tab';
		Parent=self;
		Name=Name;
		DisplayName=Display;
		Content=ContentFrame;
		Button=Button;
		Visible=#self.Tabs==0;
		Children={};
	},materialLua.Tab)
	table.insert(self.Tabs,ContainerObj)
	uiList:GetPropertyChangedSignal"AbsoluteContentSize":connect(function()
		ContentFrame.CanvasSize=UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y+10)
	end)
	ContainerObj:Update()
	Button.MouseButton1Down:connect(function()
		ContainerObj:Show()
	end)
	
	return ContainerObj
end

function materialLua.MainFrame:SetTitle(title)
	local titleBar = self.TitleBar;
	self.ScreenGui.Name=title
	self.Title=title
	self.TitleText.Text=title;
end

function materialLua.MainFrame:SetSize(newSize,tweenTime)
	self.Size=newSize
	return Tween(self.MainFrame,math.max(0,tweenTime or 1),{Size=UDim2.new(0,newSize.X,0,newSize.Y)})
end

function materialLua.MainFrame:Init()-- TODO: theming
	local navBar = self.NavBar;
	local navBarContent = navBar:WaitForChild'Content'
	
	self:UpdateColours(false)
	local Parent  =not RunningOnExploit and Player.PlayerGui or game.CoreGui
	if(Parent:FindFirstChild(self.ScreenGui.Name))then
		Parent[self.ScreenGui.Name]:destroy()			
	end
	self:SetTitle(self.Title)
	self.MainFrame.Size=UDim2.new(0,0,0,self.Size.Y)
	self.ScreenGui.Parent=Parent
	Tween(self.MainFrame,1,{Size=UDim2.new(0,self.Size.X,0,self.Size.Y)}).Completed:wait()
	for _,v in next, self do
		if(typeof(v)=='Instance' and v:IsA'GuiObject')then
			Tween(v,1,{[(v:IsA'ImageLabel' or v:IsA'ImageButton') and 'ImageTransparency' or (v:IsA'TextLabel' or v:IsA'TextButton') and 'TextTransparency']=v.Name=='Content' and .8 or 0})
			if(v:FindFirstChild'Shadow')then
				Tween(v.Shadow,1,{ImageTransparency=0})
			end
		end
	end
	wait(1)
end


function materialLua.UI.new(object,parent) -- TODO: (style,object,parent)
	local gui = uiFolder:FindFirstChild(object)
	if(gui)then
		local clone = gui:Clone()
		if(parent)then clone.Parent=parent;end
		return clone
	end
end

function materialLua.MainFrame:UpdateColours(recursive)
	local recursive = recursive or true;
	materialLua.Base.UpdateColours(self)
	for i = 1,#self.Tabs do
		self.Tabs[i]:UpdateColours(recursive)
	end
end

function materialLua.MainFrame:SetTheme(theme)
	if(typeof(theme)=='table' and not theme.GetPrimary)then
		theme=materialLua.Theme.new(theme.Primary,theme.Secondary)
	end
	self.ThemeD=theme
	self:UpdateColours()
end

function materialLua.MainFrame:Minimise()
	self.Minimised=true
	self.ThemeData[self.MinimiseButton]={Colour="Primary";Component="Maximise"};
	pcall(function()self.ThemeData[self.MinimiseButton.Shadow]={Colour="Secondary";Component="Maximise"};end)
	self.MainFrame.ClipsDescendants=true
	Tween(self.MainFrame,.15,{Size=UDim2.new(0,self.Size.X,0,30)})
	Tween(self.MinimiseButton,.15,{ImageColor3=self:GetTheme():GetPrimary'Maximise'})
	pcall(function()Tween(self.MinimiseButton.Shadow,.15,{ImageColor3=self:GetTheme():GetSecondary'Maximise'})end)
	pcall(function()Tween(self.MainFrame.Shadow,.15,{ImageTransparency=0})end)
end

function materialLua.MainFrame:Maximise()
	self.Minimised=false
	self.ThemeData[self.MinimiseButton]={Colour="Primary";Component="Minimise"};
	pcall(function()self.ThemeData[self.MinimiseButton.Shadow]={Colour="Secondary";Component="Minimise"};end)
	OnCompleted(Tween(self.MainFrame,.15,{Size=UDim2.new(0,self.Size.X,0,self.Size.Y)}),function()
		self.MainFrame.ClipsDescendants=false
	end)
	Tween(self.MinimiseButton,.15,{ImageColor3=self:GetTheme():GetPrimary'Minimise'})
	pcall(function()Tween(self.MinimiseButton.Shadow,.15,{ImageColor3=self:GetTheme():GetSecondary'Minimise'})end)
	pcall(function()Tween(self.MainFrame.Shadow,.15,{ImageTransparency=1})end)
end

function materialLua.MainFrame:ToggleMinimised()
	if(self.Minimised)then self:Maximise()else self:Minimise()end
end

function materialLua.MainFrame:Hide()
	self.ScreenGui.Enabled=false
end

function materialLua.MainFrame:Show()
	self.ScreenGui.Enabled=true
end

function materialLua.MainFrame:Toggle()
	self.ScreenGui.Enabled = not self.ScreenGui.Enabled
end

function materialLua.new(options)
	local options = options or {}
	local theme = typeof(options.Theme)=='table' and options.Theme or typeof(options.Theme)=='string' and materialLua.Theme.Presets[options.Theme] or materialLua.Theme.Presets.Default
	if(typeof(theme)=='table' and not theme.GetPrimary)then
		theme=materialLua.Theme.fromTable(theme)
	end
	
	options.Size = options.Size or Vector2.new(350,350)
	local SGui = Instance.new("ScreenGui")
	SGui.DisplayOrder=1e9
	SGui.IgnoreGuiInset=true
	SGui.Name=options.Title
	local mainFrame = materialLua.UI.new("MainFrame",SGui)
	mainFrame.Shadow.ImageTransparency=1
	mainFrame.Position=UDim2.new(0.5,-options.Size.X/2,0.5,-options.Size.Y/2)
	local navBar = materialLua.UI.new("NavBar",mainFrame)
	navBar.ImageTransparency=1
	navBar.Shadow.ImageTransparency=1
	--[[local navBar;
	local navbarType=options.NavbarType or options.Style
	if(navbarType==3)then
		
	end]] -- TODO: navbar types
	local content = mainFrame:WaitForChild'Content'
	content.ImageTransparency=1
	local titleBar = mainFrame:WaitForChild'TitleBar'
	titleBar.Transparency=1
	local titleText = titleBar:WaitForChild'Title'
	titleText.TextTransparency=1
	local minimise = titleBar:WaitForChild'Minimise'
	minimise.ImageTransparency=1
	minimise.Shadow.ImageTransparency=1
	
	local dragObj = Drag:Connect(titleBar,{mainFrame})
	dragObj:SetDragTime(options.DragTime or 0)
	local mainframeObj = setmetatable({
		ThemeD=theme;
		ScreenGui=SGui;
		Minimised=false;
		ThemeData={
			[mainFrame]={Colour="Secondary";Component="MainFrame"};
			[mainFrame.Shadow]={Colour="Secondary";Component="MainFrame"};
			[navBar]={Colour="Primary";Component="NavBar"};
			[navBar.Shadow]={Colour="Primary";Component="NavBar"};
			[content]={Colour="Primary";Component="MainFrame"};	
			[titleBar]={Colour="Primary";Component="TitleBar"};
			[titleBar.Shadow]={Colour="Primary";Component="TitleBar"};
			[titleBar.Hidden]={Colour="Primary";Component="TitleBar"};
			[titleText]={Colour="Secondary";Component="TitleBar"};
			[minimise]={Colour="Primary";Component="Minimise"};
			[minimise.Shadow]={Colour="Secondary";Component="Minimise"};
		};
		MinimiseButton=minimise;
		MainFrame=mainFrame;
		NavBar=navBar;
		Content=content;
		TitleBar=titleBar;
		TitleText=titleText;
		Title=options.Title;
		Size=options.Size;
		DragObj=dragObj;
		Tabs={};
	},materialLua.MainFrame)
	minimise.MouseButton1Click:connect(function()
		mainframeObj:ToggleMinimised()
	end)
	mainframeObj:Init()
	return mainframeObj
end

-- TODO: better backward compatibility

function materialLua.Load(options)
	local rOptions = {
		Size=Vector2.new(options.SizeX or 500,options.SizeY or 350);
		Title=options.Title;
		Theme=options.Theme;
	}
	local realObj = materialLua.new(rOptions)
	local proxyObj = {New=function(...)
			local realTab=realObj:NewTab(...) 
			local proxyTab={}
			setmetatable(proxyTab,{
				__index=function(s,i)
					print(i)
					if(realTab["NewLegacy"..i])then
						return function(...)
							return realTab["NewLegacy"..i](realTab,...)
						end	
					elseif(realTab["New"..i])then
						return function(...)
							return realTab["New"..i](realTab,...)
						end
					else
						return rawget(realTab,i)
					end
				end
			})
			return proxyTab
		end}
	return proxyObj
end

return materialLua
