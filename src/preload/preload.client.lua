-- Services.
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")

-- Disables default red screen.
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Health, false)

-- Player and its gui folder.
local player = Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Base screen gui.
local screen = Instance.new("ScreenGui")
screen.Name = "loading"
screen.IgnoreGuiInset = true
screen.Parent = gui

-- Black screen.
local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.fromScale(1, 1)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.Parent = screen

-- Gets rid of default loading screen.
ReplicatedFirst:RemoveDefaultLoadingScreen()