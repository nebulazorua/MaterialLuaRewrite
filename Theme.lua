local theme = {}
theme.__index=theme;

function theme:GetTheme(component)
	return component and self.Components[component] or {Primary=self.Primary;Secondary=self.Secondary;}
end

function theme:GetPrimary(component)
	return self:GetTheme(component).Primary;
end

function theme:GetSecondary(component)
	return self:GetTheme(component).Secondary;
end

function theme:AddComponent(component,primary,secondary)
	self.Components[component]={Primary=primary;Secondary=secondary;}
end

function theme.new(primary,secondary,components)
	if(typeof(primary)~='Color3')then primary = Color3.fromRGB(124,37,255); end
	if(typeof(secondary)~='Color3')then secondary = Color3.fromRGB(255,255,255); end	
	if(typeof(components)~='table')then components={};end
	
	return setmetatable({
		Primary=primary;
		Secondary=secondary;
		Components=components;
	},theme)
end

return theme
