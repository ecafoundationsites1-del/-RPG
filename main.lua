local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- [UI 구성] 화면 전체 덮기
local Screen = Instance.new("ScreenGui", PlayerGui)
Screen.IgnoreGuiInset = true
Screen.Name = "HwanjangRPG_Fast"

local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 0

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "환장 RPG"
Title.Size = UDim2.new(1, 0, 0, 100)
Title.Position = UDim2.new(0, 0, 0.4, -50)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 70

local Input = Instance.new("TextBox", MainFrame)
Input.Size = UDim2.new(0, 400, 0, 60)
Input.Position = UDim2.new(0.5, -200, 0.6, 0)
Input.PlaceholderText = "이름 입력..."
Input.TextSize = 30
Input.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Input.TextColor3 = Color3.new(1, 1, 1)

-- [핵심: 0.5초 글리치 함수]
local function FastGlitch(targetText, isSuccess)
    Input.Visible = false
    Title.Visible = false

    local GlitchLabel = Instance.new("TextLabel", MainFrame)
    GlitchLabel.Size = UDim2.new(1, 0, 0, 100)
    GlitchLabel.Position = UDim2.new(0, 0, 0.5, -50)
    GlitchLabel.BackgroundTransparency = 1
    GlitchLabel.TextSize = 45
    GlitchLabel.TextColor3 = Color3.fromRGB(0, 120, 255)

    local chars = {"!", "@", "#", "$", "%", "^", "&", "*", "0", "1"}
    
    -- 0.5초 동안 총 10번 빠르게 텍스트 변경 (0.05 * 10 = 0.5s)
    for i = 1, 10 do
        local str = ""
        for j = 1, #targetText do
            str = str .. (math.random() > 0.6 and chars[math.random(#chars)] or string.sub(targetText, j, j))
        end
        GlitchLabel.Text = str
        GlitchLabel.Position = UDim2.new(0, math.random(-15, 15), 0.5, -50 + math.random(-10, 10))
        task.wait(0.05)
    end
    
    -- 결과 텍스트 고정
    GlitchLabel.Text = targetText
    GlitchLabel.Position = UDim2.new(0, 0, 0.5, -50)
    task.wait(0.5) -- 고정된 문구 잠깐 보여주기

    if isSuccess then
        -- 화이트 아웃 페이드
        local Flash = Instance.new("Frame", Screen)
        Flash.Size = UDim2.new(1, 0, 1, 0)
        Flash.BackgroundColor3 = Color3.new(1, 1, 1)
        Flash.ZIndex = 10
        
        -- 빠르게 하얘짐
        for i = 1, 0, -0.1 do
            Flash.BackgroundTransparency = i
            task.wait(0.02)
        end
        
        MainFrame:Destroy()
        
        -- 빠르게 투명해짐
        for i = 0, 1, 0.1 do
            Flash.BackgroundTransparency = i
            task.wait(0.02)
        end
        Flash:Destroy()
        
        -- 머리 위 칭호 생성 (이름만 추출)
        local rawName = targetText:gsub("님의 모험을 응원합니다", "")
        CreateHeadUI(rawName)
    else
        -- 중복 닉네임 시 다시 입력창 복구
        GlitchLabel:Destroy()
        Title.Visible = true
        Input.Visible = true
        Input.Text = ""
    end
end

-- [이벤트 연결]
Input.FocusLost:Connect(function(enter)
    if not enter then return end
    local name = Input.Text
    if name == "토끼공듀" or name == "녜힁" then
        FastGlitch("이미 있는 닉네임입니다.", false)
    else
        FastGlitch(name .. "님의 모험을 응원합니다", true)
    end
end)

function CreateHeadUI(name)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    local bill = Instance.new("BillboardGui", head)
    bill.Size = UDim2.new(0, 200, 0, 50)
    bill.StudsOffset = Vector3.new(0, 3, 0)
    bill.AlwaysOnTop = true
    
    local l = Instance.new("TextLabel", bill)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = "LV.1 " .. name
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextStrokeTransparency = 0
    l.TextScaled = true
end

