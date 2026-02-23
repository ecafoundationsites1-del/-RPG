local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. 전체 화면 검은색 배경 생성
local Screen = Instance.new("ScreenGui", PlayerGui)
Screen.Name = "HwanjangRPG_UI"

local Background = Instance.new("Frame", Screen)
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.new(0, 0, 0)
Background.ZIndex = 1

-- 2. 중앙 타이틀 '환장 RPG'
local Title = Instance.new("TextLabel", Background)
Title.Text = "환장 RPG"
Title.Size = UDim2.new(0, 400, 0, 100)
Title.Position = UDim2.new(0.5, -200, 0.4, -50)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 60

-- 3. 닉네임 입력창
local Input = Instance.new("TextBox", Background)
Input.Size = UDim2.new(0, 300, 0, 50)
Input.Position = UDim2.new(0.5, -150, 0.6, 0)
Input.PlaceholderText = "이름을 입력하세요..."
Input.Text = ""

-- 4. 지지직 메시지 라벨
local Msg = Instance.new("TextLabel", Background)
Msg.Size = UDim2.new(0, 500, 0, 50)
Msg.Position = UDim2.new(0.5, -250, 0.7, 0)
Msg.BackgroundTransparency = 1
Msg.Text = ""
Msg.TextSize = 25

-- [메인 로직] 이름 입력 후 엔터 쳤을 때
Input.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    
    local name = Input.Text
    local forbidden = {["토끼공듀"] = true, ["녜힁"] = true}

    -- 지지직 연출 함수
    local function GlitchEffect(txt, isSuccess)
        Msg.TextColor3 = Color3.fromRGB(0, 100, 255) -- 파란색
        for i = 1, 20 do
            Msg.Text = txt
            Msg.Position = UDim2.new(0.5, -250 + math.random(-5, 5), 0.7, math.random(-3, 3))
            task.wait(0.05)
        end
        
        if isSuccess then
            task.wait(1)
            Background:Destroy() -- 검은 화면 제거
            CreateHeadUI(name)   -- 머리 위 칭호 생성
        end
    end

    if forbidden[name] then
        GlitchEffect("이미 있는 닉네임입니다.", false)
    else
        GlitchEffect(name .. "님의 모험을 응원합니다", true)
    end
end)

-- 5. 머리 위 LV.1 (이름) 생성 함수
function CreateHeadUI(name)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    
    local billboard = Instance.new("BillboardGui", head)
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.Adornee = head
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "LV.1 " .. name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
end
