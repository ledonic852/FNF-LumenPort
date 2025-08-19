local shootNotes = {}
local runTankmen = {}
function onCreate()
    -- Creates the table using the 'picospeaker' chart.
    local songFormat = callMethodFromClass('backend.Paths', 'formatToSongPath', {songPath})
    local shootChart = callMethodFromClass('backend.Song', 'getChart', {'picospeaker', songFormat})
    for _, section in pairs(shootChart.notes) do
        for _, note in pairs(section.sectionNotes) do
            table.insert(shootNotes, note)
        end
    end

    -- Randomly spawns all the running tankmen for the song.
    if lowQuality == false then
        local tankNum = 0 -- Using this so that the table doesn't have empty values
        for i = 1, #shootNotes do
            if getRandomBool(16) then
                tankNum = tankNum + 1
                local offset = getRandomInt(50, 100)
                createTankman('tankmanRun'..tankNum, -2000, 200 + offset, shootNotes[i][2] < 2)
                runTankmen[tankNum] = {
                    strumTime = shootNotes[i][1],
                    goingRight = shootNotes[i][2] > 1,
                    endingOffset = getRandomFloat(50, 200),
                    speed = getRandomFloat(0.6, 1),
                    isDead = false
                }
            end
        end
    end
end

-- Shooting and tankmen running behavior.
function onUpdatePost(elapsed)
    updateTankman()
    if #shootNotes > 0 and getSongPosition() > shootNotes[1][1] then
        noteData = 1 + getRandomInt(0, 1)
        if shootNotes[1][2] > 2 then
            noteData = 3 + getRandomInt(0, 1)
        end
        playAnim('gf', 'shoot'..noteData, true)
        setProperty('gf.specialAnim', true)
        table.remove(shootNotes, 1)
    end
end

function createTankman(tag, x, y, facingRight)
    local antialisConfig = getPropertyFromClass('backend.ClientPrefs', 'data.antialiasing')
    local shotAlt = getRandomInt(1, 2)
    makeAnimatedLuaSprite(tag, 'tank/tankmanKilled1', x, y)
    addAnimationByPrefix(tag, 'run', 'tankman running')
    addAnimationByPrefix(tag, 'shot', 'John Shot '..shotAlt, 24, false)
    addOffset(tag, 'shot', 300, 200)
    setObjectOrder(tag, getObjectOrder('ground'))
    addLuaSprite(tag)

    local startFrame = getRandomInt(0, getProperty(tag..'.animation.curAnim.numFrames') - 1)
    playAnim(tag, 'run', true, false, startFrame)
    setProperty(tag..'.antialiasing', antialisConfig)
    setProperty(tag..'.flipX', not facingRight)
end

function updateTankman()
    for tankNum = 1, #runTankmen do
        local tag = 'tankmanRun'..tankNum
        if luaSpriteExists(tag) then
            local visible = (getProperty(tag..'.x') > -1 * screenWidth) and (getProperty(tag..'.x') < 1.5 * screenWidth)
            setProperty(tag..'.visible', visible)

            if getProperty(tag..'.animation.curAnim.name') == 'run' then
                local curSpeed = (getSongPosition() - runTankmen[tankNum].strumTime) * runTankmen[tankNum].speed
                if runTankmen[tankNum].goingRight == true then
                    setProperty(tag..'.x', (0.02 * screenWidth - runTankmen[tankNum].endingOffset) + curSpeed)
                else
                    setProperty(tag..'.x', (0.74 * screenWidth + runTankmen[tankNum].endingOffset) - curSpeed)
                end
            elseif getProperty(tag..'.animation.finished') then
                removeLuaSprite(tag)
            end

            if getSongPosition() > runTankmen[tankNum].strumTime then
                if runTankmen[tankNum].isDead == false then
                    playAnim(tag, 'shot', true)
                    runTankmen[tankNum].isDead = true
                end
            end
        end
    end
end