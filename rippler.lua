-- credit to Validark and RoStrap
local ContentProvider = game:GetService("ContentProvider")

local RippleContainer = Instance.new("Frame") -- Make sure ZIndex is higher than parent by 1
RippleContainer.AnchorPoint = Vector2.new(0.5, 0.5)
RippleContainer.BackgroundTransparency = 1
RippleContainer.BorderSizePixel = 0
RippleContainer.ClipsDescendants = true
RippleContainer.Name = "RippleContainer"
RippleContainer.Size = UDim2.new(1, 0, 1, 0)
RippleContainer.Position = UDim2.new(0.5, 0, 0.5, 0)

local RIPPLE_START_DIAMETER = 0
local RIPPLE_OVERBITE = 1.05

local RippleStartSize = UDim2.new(0, RIPPLE_START_DIAMETER, 0, RIPPLE_START_DIAMETER)

local Circle = Instance.new("ImageLabel")
Circle.AnchorPoint = Vector2.new(0.5, 0.5)
Circle.BackgroundTransparency = 1
Circle.Size = RippleStartSize
Circle.Image = "rbxassetid://517259585"
Circle.Name = "Ripple"

spawn(function()
	ContentProvider:PreloadAsync{Circle.Image}
end)
local CornerData = {
	[2] = {
		0.380, 0.918,
		0.918, 1.000,
	};

	[4] = {
		0.000, 0.200, 0.690, 0.965,
		0.200, 0.965, 1.000, 1.000,
		0.690, 1.000, 1.000, 1.000,
		0.965, 1.000, 1.000, 1.000,
	};

	[8] = {
		0.000, 0.000, 0.000, 0.000, 0.224, 0.596, 0.851, 0.984,
		0.000, 0.000, 0.000, 0.596, 1.000, 1.000, 1.000, 1.000,
		0.000, 0.000, 0.722, 1.000, 1.000, 1.000, 1.000, 1.000,
		0.000, 0.596, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
		0.224, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
		0.596, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
		0.851, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
		0.984, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000, 1.000,
	};
}


do
	local t = {
		Radius0 = 0;
	}

	for BorderRadius, Data in next, CornerData do
		t["Radius" .. BorderRadius] = BorderRadius

		for i = 1, #Data do
			Data[i] = 1 - Data[i] -- Opacity -> Transparency
		end
	end

end


local function MakeContainer(GlobalContainer, Size, Position, ImageTransparency)
	local container = Instance.new("ImageLabel")

	if ImageTransparency ~= nil and ImageTransparency ~= 0 then
		container.ImageTransparency = ImageTransparency
	end

	container.BackgroundTransparency = 1
	container.ClipsDescendants = true
	container.Position = Position
	container.Size = Size
	container.Parent = GlobalContainer
	return container
end

local function MakeOuterBorders(RippleFrames, container, X, Y) -- TODO: Optimize first two frames which can be eliminated
	local NumRippleFrames = #RippleFrames
	RippleFrames[NumRippleFrames + 1] = MakeContainer(container, UDim2.new(1, -2*X, 0, 1), UDim2.new(0, X, 0, Y))
	RippleFrames[NumRippleFrames + 2] = MakeContainer(container, UDim2.new(1, -2*X, 0, 1), UDim2.new(0, X, 1, -Y - 1))
	RippleFrames[NumRippleFrames + 3] = MakeContainer(container, UDim2.new(0, 1, 1, -2*X), UDim2.new(0, Y, 0, X))
	RippleFrames[NumRippleFrames + 4] = MakeContainer(container, UDim2.new(0, 1, 1, -2*X), UDim2.new(1, -Y - 1, 0, X))
end

local PixelSize = UDim2.new(0, 1, 0, 1)

local function DestroyRoundRipple(self)
	for i = 1, #self do
		local Object = self[i]
		self[i] = nil
		Object:Destroy()
	end
end;

local RoundRippleMetatable = {
	__index = function(self, i)
		if i == "Size" then
			return RippleStartSize
		elseif i == "ImageTransparency" then
			return self.Transparency
		elseif i == "Destroy" then
			return DestroyRoundRipple
		end
	end;

	__newindex = function(self, i, v)
		if i == "Size" then
			for a = 1, #self do
				self[a].Size = v
			end
		elseif i == "ImageTransparency" then
			for a = 1, #self do
				local RippleFrame = self[a]
				local Parent = RippleFrame.Parent
				if Parent then
					RippleFrame.ImageTransparency = (1 - v) * Parent.ImageTransparency + v
				end
			end
		end
	end;
}

local Values={
	number="NumberValue";
	Instance="ObjectValue";
	Vector3="Vector3Value";
	string="StringValue";
	CFrame="CFrameValue";
	Color3="Color3Value";
	Ray="RayValue";
	BrickColor="BrickColorValue";
}

function Tween(Inst,Time,Properties,EStyle,EDir,Repeat,Rev,Delay,Yield,DestroyOnFinish)
	local tw;
	print(typeof(Inst))
	if(typeof(Inst)=='table')then
		local tweens={}
		for i,v in next, Properties do
			if(Values[typeof(v)])then
				local I = Instance.new(Values[typeof(v)])
				I.Value=Inst[i]
				coroutine.wrap(function()
					while I do
						Inst[i]=I.Value
						game:service'RunService'.Stepped:wait()
					end
				end)()
				table.insert(tweens,{I=Inst,Tween(I,Time,{Value=v},EStyle,EDir,Repeat,Rev,Delay,Yield)})
				tweens[#tweens][1].Completed:connect(function()I:destroy();I=nil;end)
			elseif(typeof(v)=='UDim2')then
				local I = Instance.new("Frame")
				I.Size=Inst[i]
				coroutine.wrap(function()
					while I do
						Inst[i]=I.Size
						game:service'RunService'.Stepped:wait()
					end
				end)()
				table.insert(tweens,{I=Inst,Tween(I,Time,{Size=v},EStyle,EDir,Repeat,Rev,Delay,Yield)})
				tweens[#tweens][1].Completed:connect(function()I:destroy();I=nil;end)
			end
		end
		if(#tweens>1)then
			if(Yield)then
				wait(Time)
				if(DestroyOnFinish)then for _,v in next, tweens do v.I:Destroy()end;end;
			elseif(DestroyOnFinish)then
				delay(Time,function()
					for _,v in next, tweens do v.I:Destroy() end
				end)
			end
			return tweens
		elseif(#tweens==1)then
			if(Yield)then
				tweens[1][1].Completed:wait()
				if(DestroyOnFinish)then
					tweens[1].I:Destroy()
					tweens={}
				end
			else
				coroutine.wrap(function()
					tweens[1][1].Completed:wait()
					if(DestroyOnFinish)then
						table.foreach(tweens[1],print)
						tweens[1].I:Destroy()
						tweens={}
					end
				end)()
			end
			return tweens[1][1]
		end
	else
		local tw = game:service'TweenService':Create(Inst,TweenInfo.new(Time or 1,EStyle or Enum.EasingStyle.Quad,EDir or Enum.EasingDirection.Out,Repeat or 0,Rev or false,Delay or 0),Properties)
		tw:Play()
		if(Yield)then
			tw.Completed:wait()
		end
		return tw;
	end
	

end

local function newRipple(parent,style,radius,color)
	--local styler =
	local RippleFrames = {}
	local style = style or 'Full'
	local radius = radius or 0
	local container = RippleContainer:Clone()
	container.Parent=parent
	local transparency = 0.7
	local color = color or Color3.new(1,1,1)
	
	container.ZIndex=parent.ZIndex+1
	parent:GetPropertyChangedSignal'ZIndex':connect(function()
		container.ZIndex = parent.ZIndex+1
	end)
	
	if radius == 0 then
		style = 'Full'
	else
		style = 'Round'
		local Data = CornerData[radius]

		if not RippleFrames then
			RippleFrames = {}
			RippleFrames = RippleFrames
		end

		local MiddleSquarePoint

		for j = 0, radius - 1 do
			if Data[radius * j + (j + 1)] == 0 then
				MiddleSquarePoint = j
				break
			end
		end

		MakeOuterBorders(RippleFrames, container, radius, 0)

		-- Make large center frame
		RippleFrames[#RippleFrames + 1] = MakeContainer(container, UDim2.new(1, -2 * MiddleSquarePoint, 1, -2 * MiddleSquarePoint), UDim2.new(0, MiddleSquarePoint, 0, MiddleSquarePoint))

		do -- Make other bars to fill
			local X = MiddleSquarePoint
			local Y = MiddleSquarePoint - 1

			while Data[radius * Y + (X + 1)] == 0 do
				MakeOuterBorders(RippleFrames, container, X, Y)
				X = X + 1
				Y = Y - 1
			end
		end

		do
			local a = 0
			local amax = radius * radius
			local NumRippleFrames = #RippleFrames
			while a < amax do
				local PixelTransparency = Data[a + 1]

				if PixelTransparency ~= 1 then
					if PixelTransparency ~= 0 then
						local X = a % radius
						local Y = (a - X) / radius
						local V = -1 - X
						local W = -1 - Y

						RippleFrames[NumRippleFrames + 1] = MakeContainer(container, PixelSize, UDim2.new(0, X, 0, Y), PixelTransparency)
						RippleFrames[NumRippleFrames + 2] = MakeContainer(container, PixelSize, UDim2.new(0, X, 1, W), PixelTransparency)
						RippleFrames[NumRippleFrames + 3] = MakeContainer(container, PixelSize, UDim2.new(1, V, 0, Y), PixelTransparency)
						RippleFrames[NumRippleFrames + 4] = MakeContainer(container, PixelSize, UDim2.new(1, V, 1, W), PixelTransparency)
						NumRippleFrames = NumRippleFrames + 4
					end
				end

				a = a + 1
			end
		end
	end
	local CurrentRipple;
	
	local function SetCurrentRipple(Ripple)
		if CurrentRipple then
			local Rip = CurrentRipple
			Tween(CurrentRipple,1,{ImageTransparency=1}).Completed:connect(function()Rip:Destroy()end)
		end

		CurrentRipple = Ripple
	end
	local function down(_,X,Y)
		local Diameter

		local ContainerAbsoluteSizeX = container.AbsoluteSize.X
		local ContainerAbsoluteSizeY = container.AbsoluteSize.Y

		-- Get near corners
		X = (X or (0.5 * ContainerAbsoluteSizeX + container.AbsolutePosition.X)) - container.AbsolutePosition.X
		Y = (Y or (0.5 * ContainerAbsoluteSizeY + container.AbsolutePosition.Y)) - container.AbsolutePosition.Y

		if style == 'Icon' then
			Diameter = 2 * container.AbsoluteSize.Y
			container.ClipsDescendants = false
		else
			-- Get far corners
			local V = X - ContainerAbsoluteSizeX
			local W = Y - ContainerAbsoluteSizeY

			-- Calculate distance between mouse and corners
			local a = (X*X + Y*Y) ^ 0.5
			local b = (X*X + W*W) ^ 0.5
			local c = (V*V + Y*Y) ^ 0.5
			local d = (V*V + W*W) ^ 0.5

			-- Find longest distance between mouse and a corner and decide Diameter
			Diameter = 2 * (a > b and a > c and a > d and a or b > c and b > d and b or c > d and c or d) * RIPPLE_OVERBITE

			-- Cap Diameter
			if math.huge < Diameter then
				Diameter = math.huge
			end
		end

		-- Create Ripple Object
		local Ripple = Circle:Clone()
		Ripple.ImageColor3 = color
		Ripple.ImageTransparency = transparency
		Ripple.Position = UDim2.new(0, X, 0, Y)
		Ripple.ZIndex = container.ZIndex + 1
		Ripple.Parent = container

		if style == 'Round' and radius ~= 0 then
			local Ripples = {Transparency = Ripple.ImageTransparency}
			local NumRipples = #RippleFrames

			for i = 1, NumRipples do
				local RippleFrame = RippleFrames[i]
				local NewRipple = Ripple:Clone()
				local AbsolutePosition = Ripple.AbsolutePosition - RippleFrame.AbsolutePosition + 0.5*Ripple.AbsoluteSize
				NewRipple.Position = UDim2.new(0, AbsolutePosition.X, 0, AbsolutePosition.Y)
				NewRipple.ImageTransparency = (1 - transparency) * RippleFrame.ImageTransparency + transparency
				NewRipple.Parent = RippleFrame

				Ripples[i] = NewRipple
			end
			Ripple:Destroy()
			Ripple = setmetatable(Ripples, RoundRippleMetatable)
		end

		SetCurrentRipple(Ripple)
		
		Tween(Ripple,.5,{Size=UDim2.new(0,Diameter,0,Diameter)})
	end
	
	local function up()
		SetCurrentRipple(false)
	end
	
	return {Down=down;Up=up;SetColor=function(_,clr)color=clr or Color3.new(1,1,1) end}
end

return {new=newRipple};
