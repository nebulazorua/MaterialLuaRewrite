local theme = {}
theme.__index=theme;

theme.Presets={
	Default={
		Primary=Color3.fromRGB(124,37,255);
		Secondary=Color3.fromRGB(255,255,255);
		Components={
			TextBox={Secondary=Color3.fromRGB(124,37,255)};
			ColorPicker={Primary=Color3.fromRGB(255,255,255);Secondary=Color3.fromRGB(124,37,255);};
		};
	};
}
function theme:GetTheme(component)
	return component and self.Components[component] or {Primary=self.Primary;Secondary=self.Secondary;}
end

function theme:GetPrimary(component)
	return self:GetTheme(component).Primary or self:GetTheme().Primary;
end

function theme:GetSecondary(component)
	return self:GetTheme(component).Secondary or self:GetTheme().Secondary;
end

function theme:AddComponent(component,primary,secondary)
	self.Components[component]={Primary=primary or self:GetPrimary();Secondary=secondary or self:GetPrimary();}
end

function theme:Set(a,b)
	if(self.Components[a])then
		self.Components[a]=b
	else
		self[a]=b;
	end
end

function theme.new(primary,secondary,components)
	if(typeof(primary)~='Color3')then primary=theme.Presets.Default.Primary; end
	if(typeof(secondary)~='Color3')then secondary=theme.Presets.Default.Secondary; end	
	if(typeof(components)~='table')then components=theme.Presets.Default.Components;end
	
	if(not components.Minimise)then
		components.Minimise={
			Primary=Color3.fromRGB(255,106,0);
			Secondary=Color3.fromRGB(147,59,0);
		}
	end
	if(not components.Maximise)then
		components.Maximise={
			Primary=Color3.fromRGB(25,255,0);
			Secondary=Color3.fromRGB(0,255,110);
		}
	end
	return setmetatable({
		Primary=primary;
		Secondary=secondary;
		Components=components;
	},theme)
end

function theme.fromTable(t)
	local t = t or theme.Presets.Default
	return theme.new(t.Primary,t.Secondary,t.Components)
end

theme.Presets.Purple=theme.fromTable(theme.Presets.Default)
theme.Presets.Dark=theme.new(
	Color3.fromRGB(85,85,85),
	Color3.fromRGB(255,255,255),
	{
		TitleBar={
			Primary=Color3.fromRGB(55,55,55);
		};
		MainFrame={
			Secondary=Color3.fromRGB(30,30,30);
			Primary=Color3.fromRGB(55,55,55);
		};
		Toggle={
			Primary=Color3.fromRGB(235,235,235);
			Secondary=Color3.fromRGB(85,85,85);
		};
		ColorPicker={
			Secondary=Color3.fromRGB(255,255,255);
		};
		Slider={
			Primary=Color3.fromRGB(235,235,235);
			Secondary=Color3.fromRGB(85,85,85);
		};
		TextField={
			Secondary=Color3.fromRGB(255,255,255);
		};
	}
)

return theme
