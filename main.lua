-- [환장 RPG: 최종 통합 스크립트]
local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. 전체 화면 덮기 (상단바 포함 빈틈없이)
local Screen = Instance.new("ScreenGui", PlayerGui)
Screen.IgnoreGuiInset = true
Screen.Name = "HwanjangRPG_Final"

local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 1

-- 2. 타이틀
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "환장 RPG"
Title.Size = UDim2.new(1, 0, 0, 100)
Title.Position = UDim2.new(0, 0, 0.4, -50)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 70
Title.Font = Enum.Font.SpecialElite

-- 3. 이름 설정창
local Input = Instance.new("이름을 선택해주세요..", MainFrame)
Input.Size = UDim2.new(0, 400, 0, 60)
Input.Position = UDim2.new(0.5, -200, 0.6, 0)
Input.PlaceholderText = "이름을 입력하세요..."
Input.Text = ""
Input.TextSize = 30
Input.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Input.TextColor3 = Color3.new(1, 1, 1)

-- [머리 위 LV.1 생성 함수]
local function CreateHeadUI(name)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local head = char:WaitForChild("Head")
    
    -- 기존에 혹시 있을지 모를 UI 제거
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
    l.Font = Enum.Font.SourceSansBold
end

-- [메인 글리치 로직]
local function RunGlitchSequence(targetMessage, isSuccess, originalName)
    -- 엔터 치자마자 입력창이랑 타이틀 없애기
    Input.Visible = false
    Title.Visible = false

    local GlitchLabel = Instance.new("TextLabel", MainFrame)
    GlitchLabel.Size = UDim2.new(1, 0, 0, 100)
    GlitchLabel.Position = UDim2.new(0, 0, 0.5, -50)
    GlitchLabel.BackgroundTransparency = 1
    GlitchLabel.TextSize = 45
    GlitchLabel.TextColor3 = Color3.fromRGB(0, 120, 255) -- 파란색 지지직
    GlitchLabel.Font = Enum.Font.Code

    local chars = {"!", "@", "#", "$", "%", "&", "X", "0", "1", "§"}
    
    -- 0.5초간 미친듯이 지지직 (0.05초 * 10회)
    for i = 1, 10 do
        local randomStr = ""
        for j = 1, #targetMessage do
            if math.random() > 0.6 then
                randomStr = randomStr .. chars[math.random(#chars)]
            else
                randomStr = randomStr .. string.sub(targetMessage, j, j)
            end
        end
        GlitchLabel.Text = randomStr
        GlitchLabel.Position = UDim2.new(0, math.random(-20, 20), 0.5, -50 + math.random(-10, 10))
        task.wait(0.05)
    end
    
    -- 글리치 끝, 정상 문구 출력
    GlitchLabel.Text = targetMessage
    GlitchLabel.Position = UDim2.new(0, 0, 0.5, -50)
    task.wait(0.6)

    if isSuccess then
        -- 화면 하얗게 변하기 (White-out)
        local WhiteFrame = Instance.new("Frame", Screen)
        WhiteFrame.Size = UDim2.new(1, 0, 1, 0)
        WhiteFrame.BackgroundColor3 = Color3.new(1, 1, 1)
        WhiteFrame.ZIndex = 10
        WhiteFrame.BackgroundTransparency = 1
        
        for i = 1, 0, -0.1 do
            WhiteFrame.BackgroundTransparency = i
            task.wait(0.02)
        end
        
        -- 검은 배경 제거
        MainFrame:Destroy()
        
        -- 다시 투명해지면서 월드 보이기
        for i = 0, 1, 0.1 do
            WhiteFrame.BackgroundTransparency = i
            task.wait(0.02)
        end
        WhiteFrame:Destroy()
        
        -- 머리 위에 이름만 딱!
        CreateHeadUI(originalName)
    else
        -- 닉네임 중복 시 다시 원상복구
        GlitchLabel:Destroy()
        Title.Visible = true
        Input.Visible = true
        Input.Text = ""
    end
end

-- [입력 감지]
Input.FocusLost:Connect(function(enterPressed)
    if not enterPressed then return end
    
    local name = Input.Text
    local forbidden = {["토끼공듀"] = true, ["녜힁"] = true}

    if forbidden[name] then
        RunGlitchSequence("이미 존재하는 닉네임입니다.", false, name)
    else
        RunGlitchSequence(name .. "님의 여행에 즐거움이 가득하시길..", true, name)
    end
end)

