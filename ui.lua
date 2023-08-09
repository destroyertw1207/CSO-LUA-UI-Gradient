--UI============================================--
--                [[ 製作名單 ]]                --
--==============================================--
--[[

Lua Script：DestroyerI滅世I

]]--
--==============================================--
--                [[ 變數宣告 ]]                --
--==============================================--

screen = UI.ScreenSize()

--==============================================--
--                [[ 介面設計 ]]                --
--==============================================--

--[[
	Box:Set({
		  x      = x軸
		, y      = y軸
		, width  = 寬度
		, height = 高度
		, r      = 紅
		, g      = 綠
		, b      = 藍
		, a      = 不透明度
	})
	
	Text:Set({
		  text   = "字串"
		, font   = "small" (小) / "medium" (中) / "large" (大)
		, align  = "left"  (左) / "center" (中) / "right" (右)
		, x      = x軸
		, y      = y軸
		, width  = 寬度
		, height = 高度
		, r      = 紅
		, g      = 綠
		, b      = 藍
		, a      = 不透明度
	})
]]

--------------------------------------------------
--                [[ ＴＥＳＴ ]]                --
--------------------------------------------------

a_keys = UI.Text.Create()
a_keys:Set({text = "xy軸移動 : WASD\n不透明度 :  1 2\n rgb調整 :  3 4\n長寬調整 :  5 6", font = "medium", align = "right", x = 5, y = 0, width = screen.width - 5, height = 1000, r = 255, g = 255, b = 255, a = 255})

a_args = UI.Text.Create()
a_args:Set({text = "", font = "medium", align = "left", x = 5, y = 0, width = 1000, height = 1000, r = 255, g = 255, b = 255, a = 255})

a = UI.Box.Create()
a:Set({x = screen.width / 2 - 50, y = screen.height / 2 - 50, width = 100, height = 100, r = 255, g = 255, b = 255, a = 255})

--==============================================--
--                [[ 自訂涵式 ]]                --
--==============================================--

--------------------------------------------------
--                [[ 漸變顯示 ]]                --
--------------------------------------------------

function gradient(value)
	if not value then
		return
	end
	
    local config = value.ui:Get()
	local a, b, c, var
	if type(value.arg) == "table" then
		for k, v in pairs(value.arg) do
			if string.find(v, "%.") then
				a, b = v:match("(%w+)%.(%w+)")
				if config[a] then
					var = config[a][b]
				end
			else
				c = v
				var = config[c]
			end
			
			if var then
				if var ~= value.into then
					if value.add > 0 then
						var = math.min(var + value.add, value.into or var + value.add)
					else
						var = math.max(var + value.add, value.into or var + value.add)
					end
				end
				
				local temp = {}
				if c then
					temp[c] = var
					value.ui:Set(temp)
				end
				if a then
					temp[a] = {}
					temp[a][b] = var
					value.ui:Set(temp)
				end
			end
		end
	else
		if string.find(value.arg, "%.") then
			a, b = value.arg:match("(%w+)%.(%w+)")
			if config[a] then
				var = config[a][b]
			end
		else
			c = value.arg
			var = config[c]
		end
		
		if var then
			if var ~= value.into then
				if value.add > 0 then
					var = math.min(var + value.add, value.into or var + value.add)
				else
					var = math.max(var + value.add, value.into or var + value.add)
				end
			end
			
			local temp = {}
			if c then
				temp[c] = var
				value.ui:Set(temp)
			end
			if a then
				temp[a] = {}
				temp[a][b] = var
				value.ui:Set(temp)
			end
		end
	end
end

--[[
	gradient({
		  ui   = UI.Box / UI.Text
		, arg  = UI的屬性 (ex. width / height / r / g / b / a)
		, add  = 增加的值 (正負數)
		, into = 增加至... (正負數) ※非必要
	})
]]

--==============================================--
--                [[ 內建涵式 ]]                --
--==============================================--

--------------------------------------------------
--                [[ 按住按鍵 ]]                --
--------------------------------------------------

function UI.Event:OnInput(inputs)
	if inputs[UI.KEY.W] then
		gradient({ui = a, arg = "y", add = -5, into = 0})
	end
	if inputs[UI.KEY.S] then
		gradient({ui = a, arg = "y", add = 5, into = screen.height - 100})
	end
	if inputs[UI.KEY.A] then
		gradient({ui = a, arg = "x", add = -5, into = 0})
	end
	if inputs[UI.KEY.D] then
		gradient({ui = a, arg = "x", add = 5, into = screen.width - 100})
	end
	if inputs[UI.KEY.NUM1] then
		gradient({ui = a, arg = "a", add = -5, into = 0})
	end
	if inputs[UI.KEY.NUM2] then
		gradient({ui = a, arg = "a", add = 5, into = 255})
	end
	if inputs[UI.KEY.NUM3] then
		gradient({ui = a, arg = {"r", "g", "b"}, add = -5, into = 0})
	end
	if inputs[UI.KEY.NUM4] then
		gradient({ui = a, arg = {"r", "g", "b"}, add = 5, into = 255})
	end
	if inputs[UI.KEY.NUM5] then
		gradient({ui = a, arg = {"width", "height"}, add = 5, into = 200})
	end
	if inputs[UI.KEY.NUM6] then
		gradient({ui = a, arg = {"width", "height"}, add = -5, into = 100})
	end
end

--------------------------------------------------
--                [[ 調用涵式 ]]                --
--------------------------------------------------

function UI.Event:OnUpdate(time)
	a_args:Set({text = ""})
	for k, v in pairs(a:Get()) do
		local argcht = {
			  x      = "x軸"
			, y      = "y軸"
			, width  = "寬度"
			, height = "高度"
			, r      = "紅"
			, g      = "綠"
			, b      = "藍"
			, a      = "不透明度"
		}
		a_args:Set({text = a_args:Get().text .. argcht[k] .. " : " .. v .. "\n"})
	end
end

--------------------------------------------------