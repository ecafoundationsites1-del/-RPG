-- [환장 RPG: 입력창 복구 및 최적화 통합본]
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. 화면 전체 덮기
local Screen = Instance.new("ScreenGui", PlayerGui)
Screen.IgnoreGuiInset = true
Screen.Name = "HwanjangRPG_Fixed"

local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 0

-- 2. 타이틀
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "환장 RPG"
Title.Size = UDim2.new(1, 0, 0, 100)
Title.Position = UDim2.new(0, 0, 0.4, -50)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 70
Title.Font = Enum.Font.SpecialElite

-- 3. 이름 설정창 (확실히 보이게 설정)
local Input = Instance.new("TextBox", MainFrame)
Input.Name = "NicknameInput"
Input.Size = UDim2.new(0, 400, 0, 60)
Input.Position = UDim2.new(0.5, -200, 0.6, 0)
Input.PlaceholderText = "이름을 입력하세요..."
Input.Text = ""
Input.TextSize = 30
Input.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Input.TextColor3 = Color3.new(1, 1, 1)
Input.Visible = true -- 처음 실행 시 무조건 보이게

-- [머리 위 LV.1 생성 함수]
local function CreateHeadUI(name)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    
    if head:FindFirstChild("HwanjangTag") then head.HwanjangTag:Destroy() end

    local bill = Instance.new("BillboardGui", head)
    bill.Name = "HwanjangTag"
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

-- [글리치 및 화면 전환 로직]
local function RunGlitchSequence(targetMessage, isSuccess, originalName)
    -- 엔터 치자마자 입력창 숨기기
    Input.Visible = false
    Title.Visible = false

    local GlitchLabel = Instance.new("TextLabel", MainFrame)
    GlitchLabel.Size = UDim2.new(1, 0, 0, 100)
    GlitchLabel.Position = UDim2.new(0, 0, 0.5, -50)
    GlitchLabel.BackgroundTransparency = 1
    GlitchLabel.TextSize = 45
    GlitchLabel.TextColor3 = Color3.fromRGB(0, 120, 255)
    GlitchLabel.Font = Enum.Font.Code

    local chars = {"!", "@", "#", "$", "%", "&", "X", "0", "1"}
    
    -- 0.5초 고속 글리치
    for i = 1, 10 do
        local randomStr = ""
        for j = 1, #targetMessage do
            randomStr = randomStr .. (math.random() > 0.6 and chars[math.random(#chars)] or string.sub(targetMessage, j, j))
        end
        GlitchLabel.Text = randomStr
        GlitchLabel.Position = UDim2.new(0, math.random(-20, 20), 0.5, -50 + math.random(-10, 10))
        task.wait(0.05)
    end
    
    GlitchLabel.Text = targetMessage
    GlitchLabel.Position = UDim2.new(0, 0, 0.5, -50)
    task.wait(0.6)

    if isSuccess then
        -- 화이트 아웃 연출
        local WhiteFrame = Instance.new("Frame", Screen)
        WhiteFrame.Size = UDim2.new(1, 0, 1, 0)
        WhiteFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        WhiteFrame.ZIndex = 10
        
        for i = 1, 0, -0.1 do
            WhiteFrame.BackgroundTransparency = i
            task.wait(0.02)
        end
        
        MainFrame:Destroy()
        
        for i = 0, 1, 0.1 do
            WhiteFrame.BackgroundTransparency = i
            task.wait(0.02)
        end
        WhiteFrame:Destroy()
        
        CreateHeadUI(originalName)
    else
        -- 실패 시(중복 닉네임): 메시지 지우고 입력창 다시 살리기
        GlitchLabel:Destroy()
        Title.Visible = true
        Input.Visible = true
        Input.Text = ""
        Input:CaptureFocus() -- 자동으로 입력창에 커서 가져다줌
    end
end

-- [입력 감지]
Input.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    
    local name = Input.Text
    if name == "" then 
        Input.Visible = true 
        return 
    end -- 빈 칸 방지

    local forbidden = {["토끼공듀"] = true, ["녜힁"] = true}

    if forbidden[name] then
        RunGlitchSequence("이미 있는 닉네임입니다.", false, name)
    else
        RunGlitchSequence(name .. "님의 모험을 응원합니다", true, name)
    end
end)

