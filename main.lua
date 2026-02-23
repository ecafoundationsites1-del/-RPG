-- [설정 데이터]
local GameState = "TITLE" -- TITLE, CHECKING, STARTING, PLAYING
local playerName = ""
local displayMessage = ""
local isGlitching = false

-- 중복/금지 닉네임 리스트
local existingNames = {["토끼공듀"] = true, ["녜힁"] = true, ["운영자"] = true}

-----------------------------------------------------------
-- 1. 로직 업데이트 함수 (매 프레임 실행)
-----------------------------------------------------------
function Update(dt)
    if GameState == "CHECKING" then
        if existingNames[playerName] then
            displayMessage = "이미 있는 닉네임입니다."
            isGlitching = true
            -- 잠시 후 다시 입력 상태로 복구 (예: 2초 뒤)
            delay(2, function() GameState = "TITLE" end)
        else
            displayMessage = playerName .. "님의 모험을 응원합니다"
            isGlitching = true
            -- 3초 연출 후 실제 게임 시작
            delay(3, function() GameState = "PLAYING" end)
        end
    end
end

-----------------------------------------------------------
-- 2. 화면 그리기 함수 (Render)
-----------------------------------------------------------
function Draw()
    -- 배경은 언제나 칠흑 같은 검은색
    FillScreen(0, 0, 0)

    if GameState == "TITLE" or GameState == "CHECKING" then
        -- 중앙 타이틀
        DrawText("환장 RPG", CenterX, CenterY - 100, "White", 40)
        
        -- 이름 입력창 (GUI)
        DrawInputBox(CenterX, CenterY)
        
        -- 지지직거리는 파란색 메시지 연출
        if isGlitching then
            local rx, ry = math.random(-3, 3), math.random(-3, 3)
            DrawText(displayMessage, CenterX + rx, CenterY + 100 + ry, "DeepBlue", 20)
        end

    elseif GameState == "PLAYING" then
        -- 캐릭터와 머리 위 텍스트
        RenderPlayer()
        local pPos = GetPlayerScreenPos()
        -- 캐릭터 머리 위 LV.1 (이름) 표시
        DrawText("LV.1 " .. playerName, pPos.x, pPos.y - 50, "White", 15)
    end
end
