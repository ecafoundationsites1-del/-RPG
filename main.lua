local Player = game.Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- 1. 화면 전체를 완전히 덮는 검은색 프레임
local Screen = Instance.new("ScreenGui", PlayerGui)
Screen.IgnoreGuiInset = true -- 화면 위쪽(상단바)까지 빈틈없이 덮음
Screen.Name = "HwanjangRPG_Core"

local MainFrame = Instance.new("Frame", Screen)
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 1

-- 2. 중앙 타이틀
local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "환장 RPG"
Title.Size = UDim2.new(1, 0, 0, 100)
Title.Position = UDim2.new(0, 0, 0.4, -50)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 70
Title.Font = Enum.Font.SpecialElite -- 기괴한 느낌의 폰트

-- 3. 입력창 설정
local Input = Instance.new("TextBox", MainFrame)
Input.Size = UDim2.new(0, 400, 0, 60)
Input.Position = UDim2.new(0.5, -200, 0.6, 0)
Input.PlaceholderText = "이름을 입력하라..."
Input.Text = ""
Input.TextSize = 30
Input.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Input.TextColor3 = Color3.new(1, 1, 1)

-- [글리치 텍스트 효과 함수]
local function PlayGlitchEffect(targetText, isFinal)
    Input.Visible = false -- 입력창 즉시 제거
    Title.Visible = false -- 타이틀 제거 (가운데 메시지에 집중)

    local GlitchLabel = Instance.new("TextLabel", MainFrame)
    GlitchLabel.Size = UDim2.new(1, 0, 0, 100)
    GlitchLabel.Position = UDim2.new(0, 0, 0.5, -50)
    GlitchLabel.BackgroundTransparency = 1
    GlitchLabel.TextSize = 40
    GlitchLabel.TextColor3 = Color3.fromRGB(0, 160, 255) -- 파란색 지지직

    local glitchChars = {"#", "?", "!", "0", "1", "X", "§", "※"}
    
    -- 치치직 거리는 연출
    for i = 1, 30 do
        local randomText = ""
        for j = 1, #targetText do
            if math.random() > 0.7 then
                randomText = randomText .. glitchChars[math.random(#glitchChars)]
            else
                randomText = randomText .. string.sub(targetText, j, j)
            end
        end
        GlitchLabel.Text = randomText
        GlitchLabel.Position = UDim2.new(0, math.random(-10, 10), 0.5, -50 + math.random(-5, 5))
        task.wait(0.05)
    end
    
    GlitchLabel.Text = targetText -- 최종 텍스트 고정
    task.wait(1)

    if isFinal then
        -- 화면이 하얀색으로 점점 변하는 효과 (White-out)
        local Flash = Instance.new("Frame", Screen)
        Flash.Size = UDim2.new(1, 0, 1, 0)
        Flash.BackgroundColor3 = Color3.new(1, 1, 1)
        Flash.BackgroundTransparency = 1
        Flash.ZIndex = 10

        for i = 1, 0, -0.05 do
            Flash.BackgroundTransparency = i
            task.wait(0.03)
        end
        
        MainFrame:Destroy() -- 검은 화면 제거
        
        -- 다시 투명해지며 복구
        for i = 0, 1, 0.05 do
            Flash.BackgroundTransparency = i
            task.wait(0.03)
        end
        Flash:Destroy()
        
        CreateHeadUI(targetText:match("(.-)님의")) -- 이름만 추출해서 칭호 생성
    else
        -- 중복 닉네임일 경우 다시 입력창 띄움
        GlitchLabel:Destroy()
        Title.Visible = true
        Input.Visible = true
        Input.Text = ""
    end
end

-- [입력 이벤트]
Input.FocusLost:Connect(function(enter)
    if not enter then return end
    local name = Input.Text
    local forbidden = {["토끼공듀"] = true, ["녜힁"] = true}

    if forbidden[name] then
        PlayGlitchEffect("이미 있는 닉네임입니다.", false)
    else
        PlayGlitchEffect(name .. "님의 모험을 응원합니다", true)
    end
end)

-- [머리 위 LV.1 UI 생성]
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
    l.TextStrokeTransparency = 0 -- 글자 테두리 추가
    l.TextScaled = true
end
