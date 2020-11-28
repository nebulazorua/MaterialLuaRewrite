wait(2)
local Material = script:FindFirstChild'core' and require(script.core) or loadstring(game:HttpGet'https://raw.githubusercontent.com/supersonicfan111/MaterialLuaRewrite/master/Module.lua')()
local RNG = Random.new()
function RandomColor()
	return Color3.fromRGB(RNG:NextInteger(0,255),RNG:NextInteger(0,255),RNG:NextInteger(0,255))
end

local window = Material.new{
	Title='Hub';
	Size=Vector2.new(500,400);
	--Theme=Material.Theme.Presets.Dark;
}

local t1 = window:NewTab{
	Name='tab1';
}

local t2 = window:NewTab{
	Name='tab2';
}

local t3 = window:NewTab{
	Name='tab3';
}

local b=t1:NewButton{
	Text='Random Theme';
}

b.MouseButton1Click:connect(function()
	local Primary = RandomColor()
	local Secondary = RandomColor()
	local Components = {}
	for component,data in next, Material.Theme.Presets.Default.Components do
		Components[component]={}
		for name,_ in next,data do
			Components[component][name]=RandomColor()
		end
	end
	
	window:SetTheme(Material.Theme.new(Primary,Secondary,{}))
end)

local t=t1:NewToggle{
	Text='Switchy!';
	Type=1;
}
t.StateChanged:connect(function(state)
	print(t.Text,state)
end)

local cm=t1:NewToggle{
	Text='Check!';
	Type=2;
}
cm.StateChanged:connect(function(state)
	print(cm.Text,state)
end)

local cb=t1:NewToggle{
	Text='Check!';
	Type=3;
}
cb.StateChanged:connect(function(state)
	print(cb.Text,state)
end)

local cb=t1:NewToggle{
	Text='Radio!';
	Type=4;
}
cb.StateChanged:connect(function(state)
	print(cb.Text,state)
end)

local sl = t1:NewSlider{
	Text='Slide';
	Min=0;
	Max=100;
	Default=0;
	Steps=1;
	StrictStepObey=false;
}

local drop = t1:NewDropdown{Text="Droppin' down"}

drop:NewButton{
	Text='woah'
}

drop:NewSlider{
	Text="Slip 'n' slide!"
}

t1:NewColorPicker{
	Text='Colourer';	
}

t1:NewToggleGroup{
	DefaultType=4;
	Options={
		"this";
		"is";
		"a";
		"toggle";
		"group";
		{Type=1;Text="you can have diff types"};
		{Type=2;Text="'n shit"};
	}
}

t1:NewTextBox{
	Placeholder='Placeholder Text';
	Default='Default Text';
	ClearTextOnFocus=false;
}

t1:NewLegacyDropdown{}
