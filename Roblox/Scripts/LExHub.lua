--[[
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 *  __       ________          __    __          __
 * |  \     |        \        |  \  |  \        |  \
 * | ▓▓     | ▓▓▓▓▓▓▓▓__    __| ▓▓  | ▓▓__    __| ▓▓____
 * | ▓▓     | ▓▓__   |  \  /  \ ▓▓__| ▓▓  \  |  \ ▓▓    \
 * | ▓▓     | ▓▓  \   \▓▓\/  ▓▓ ▓▓    ▓▓ ▓▓  | ▓▓ ▓▓▓▓▓▓▓\
 * | ▓▓     | ▓▓▓▓▓    >▓▓  ▓▓| ▓▓▓▓▓▓▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓
 * | ▓▓_____| ▓▓_____ /  ▓▓▓▓\| ▓▓  | ▓▓ ▓▓__/ ▓▓ ▓▓__/ ▓▓
 * | ▓▓     \ ▓▓     \  ▓▓ \▓▓\ ▓▓  | ▓▓\▓▓    ▓▓ ▓▓    ▓▓
 *  \▓▓▓▓▓▓▓▓\▓▓▓▓▓▓▓▓\▓▓   \▓▓\▓▓   \▓▓ \▓▓▓▓▓▓ \▓▓▓▓▓▓▓
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 * LExHub, open-source Aimbot and ESP project.
 * Thanks depso for the Silent Aim and Safe Enviroment Library.
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 * loadstring(game:HttpGet("https://lexploits.top/Roblox/Scripts/LExHub.lua"))()
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--]]
local Lux = loadstring(game:HttpGet("https://raw.githubusercontent.com/LExteamz/website/main/Roblox/Scripts/Required/Luxware.lua"))()
local getsfenv = loadstring(game:HttpGet("https://rc7.glitch.me/Roblox/Safe_ENV.lua"))()
local getsaim = loadstring(game:HttpGet("https://rc7.glitch.me/Roblox/Slient_Aim.lua"))()
local LEx = {}

-- / Create the Windows
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

local Window = Lux.CreateWindow("LExHub", 0)

-- / Aimbot Logic
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

local Camera = getsfenv.CurrentCamera
local RunService = getsfenv.GetService("RunService")
local UserInputService = getsfenv.GetService("UserInputService")
local LocalPlayer = getsfenv.GetPlayers()[1]
local TweenService = getsfenv.GetService("TweenService")

getsfenv.getgenv().AimbotEnabled = false
getsfenv.getgenv().TeamCheck = false
getsfenv.getgenv().Sensitivity = 0
getsfenv.getgenv().MaxDistance = 100
getsfenv.getgenv().AimPart = "Head"

UserInputService.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Holding = true
	end
end)

UserInputService.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton2 then
		Holding = false
	end
end)

RunService.RenderStepped:Connect(function()
	if Holding == true and getsfenv.getgenv().AimbotEnabled == true then
		local closestPlayer, closestPosition = getsaim.ClosestPlayerToCursor(getsfenv.getgenv().MaxDistance)

		if closestPlayer and closestPlayer.Character:FindFirstChild(getsfenv.getgenv().AimPart) then
			local aimPartPosition = closestPlayer.Character:FindFirstChild(getsfenv.getgenv().AimPart).Position

			TweenService:Create(
				Camera,
				TweenInfo.new(getsfenv.getgenv().Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
				{
					CFrame = CFrame.new(Camera.CFrame.Position, aimPartPosition),
				}
			):Play()
		end
	end
end)

-- / ESP Logic
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- thank you depso (https://github.com/depthso/Roblox-Extremely-simple-esp)

HightLightPlayer = function(Player)
	if Player.Name == LocalPlayer.Name then
		return
	end

	local Character = Player.Character or Player.CharacterAdded:Wait()
	local Humanoid = Character:WaitForChild("Humanoid")
	local HightLighter = Instance.new("Highlight", Character)
	HightLighter.FillColor = (Player.TeamColor and Player.TeamColor.Color) or Color3.fromRGB(255, 48, 51)

	Humanoid.Changed:Connect(function()
		if Humanoid.Health <= 0 then
			HightLighter:Remove()
		end
	end)
end

HightLightFunc = function(Player)
	if Player.Character then
		HightLightPlayer(Player)
	end
	Player.CharacterAdded:Connect(function()
		HightLightPlayer(Player)
	end)
end

function LEx.ToggleESP(value)
	if value == true then
		local Players = getsfenv.GetService("Players")
		for _, Player in next, Players:GetPlayers() do
			HightLightFunc(Player)
		end
		Players.PlayerAdded:Connect(function(Player)
			HightLightFunc(Player)
		end)
	else
		local Players = getsfenv.GetService("Players")
		for _, Player in next, Players:GetPlayers() do
			local Character = Player.Character
			if Character then
				local HightLighter = Character:FindFirstChild("Highlight")
				if HightLighter and HightLighter:IsA("Highlight") then
					HightLighter:Remove()
				end
			end
		end
	end
end

-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- / Jailbreak Modify Vehicle
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local Jailbreak = {}

local function getvehiclepacket()
	for i, v in next, getgc(true) do
		if type(v) == "table" then
			if rawget(v, "Event") and rawget(v, "GetVehiclePacket") then
				Jailbreak.GetVehiclePacket = v.GetVehiclePacket
			end
		end
	end
end

function LEx.ModifyCar(what, value)
	getvehiclepacket()
	local vehiclePacket = Jailbreak.GetVehiclePacket()

	if what == "TurnSpeed" then
		vehiclePacket = vehiclePacket:GetVehiclePacket()
	end

	if vehiclePacket then
		if what == "Height" then
			vehiclePacket.Height = value
		elseif what == "TurnSpeed" then
			vehiclePacket.TurnSpeed = value
		elseif what == "GarageSpeed" then
			vehiclePacket.GarageEngineSpeed = value
		end
	end
end

-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- / Jailbreak Silent Aim
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function LEx.JailbreakSilentAim(bool)
	getsfenv.getgenv().SilentToggled = bool

	getsfenv.getgenv().old = getsfenv.getgenv().old
		or require(game:GetService("ReplicatedStorage").Module.RayCast).RayIgnoreNonCollideWithIgnoreList

	if getsfenv.getgenv().SilentToggled then
		require(getsfenv.GetService("ReplicatedStorage").Module.RayCast).RayIgnoreNonCollideWithIgnoreList = function(
			...
		)
			local nearestDistance, nearestEnemy = 600, nil
			for i, v in pairs(getsfenv.GetPlayers()) do
				if v.Team ~= LocalPlayer.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
					if
						(
							v.Character.HumanoidRootPart.Position
							- getsfenv.GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
						).Magnitude < nearestDistance
					then
						nearestDistance, nearestEnemy =
							(
								v.Character.HumanoidRootPart.Position
								- getsfenv.GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
							).Magnitude,
							v
					end
				end
			end
			local arg = { old(...) }
			if
				(tostring(getfenv(2).script) == "BulletEmitter" or tostring(getfenv(2).script) == "Taser")
				and nearestEnemy
			then
				arg[1] = nearestEnemy.Character.HumanoidRootPart
				arg[2] = nearestEnemy.Character.HumanoidRootPart.Position
			end
			return unpack(arg)
		end
	else
		require(game:GetService("ReplicatedStorage").Module.RayCast).RayIgnoreNonCollideWithIgnoreList =
			getsfenv.getgenv().old
	end
end
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- / In case user is playing Jailbreak
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function LEx.Jailbreak()
	local JBTab = Window:Tab("Jailbreak", 14945719978)
	local JBCombat = JBTab:Section("Combat Modifiers")

	JBCombat:Label("Combat Modifiers")
	JBCombat:Toggle("Silent Aim", function(value)
		LEx.JailbreakSilentAim(value)
	end)

	local JBVehicle = JBTab:Section("Vehicle Modifiers")
	JBVehicle:Label("Jailbreak Vehicle Modifiers (hi mom)")
	JBVehicle:Slider("Vehicle Height", 1, 300, function(value)
		LEx.ModifyCar("Height", value)
	end)
	JBVehicle:Slider("Vehicle Speed", 1, 300, function(value)
		LEx.ModifyCar("GarageSpeed", value)
	end)
	JBVehicle:Slider("Vehicle Turn Speed", 1, 300, function(value)
		LEx.ModifyCar("TurnSpeed", value)
	end)
end

if getsfenv.Index(game, "PlaceId") == 606849621 then
	LEx.Jailbreak()
end

-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- / Combat Section Beginning
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

local CombatTab = Window:Tab("Combat")

local MainAim = CombatTab:Section("Aimbot")

MainAim:Label("The classic Aimbot. (Camera)")
MainAim:Toggle("Enabled", function(value)
	getsfenv.getgenv().AimbotEnabled = value
end)
MainAim:Toggle("Team Check", function(value)
	getsfenv.getgenv().TeamCheck = value
end)
MainAim:Slider("Maximum Distance", 100, 10000, function(value)
	getsfenv.getgenv().MaxDistance = value
end)
MainAim:DropDown("Aim Part", { "Head", "HumanoidRootPart" }, function(value)
	getsfenv.getgenv().AimPart = value
end)

-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

-- / ESP Section Beginning
-- * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
local EspTab = Window:Tab("ESP")
local EspMain = EspTab:Section("ESP")

EspMain:Label("Simple ESP with Highlight")

EspMain:Toggle("Enabled", function(value)
	LEx.ToggleESP(value)
end)
