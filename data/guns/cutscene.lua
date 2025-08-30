function onCreate()
    if isStoryMode == true and seenCutscene == false then
        makeFlxAnimateSprite('tankmanCutscene', getCharacterX('dad') + 420, getCharacterY('dad') + 465)
        loadAnimateAtlas('tankmanCutscene', 'tank/cutscenes/tankman')
        addAnimationBySymbol('tankmanCutscene', 'anim', 'TANK TALK 2')
        setObjectOrder('tankmanCutscene', getObjectOrder('dadGroup'))
        addLuaSprite('tankmanCutscene')
        playAnim('tankmanCutscene', 'anim')
        callMethod('tankmanCutscene.anim.pause')

        precacheMusic('DISTORTO')
        precacheSound('tankSong2')
        addLuaScript('events/Set Camera Zoom') -- Doing this, or else I can't use the event.
    end
end

local cutsceneFinished = false
function onStartCountdown()
    if isStoryMode == true and seenCutscene == false then
        if cutsceneFinished == false then
            setVar('cutsceneMode', true) -- Camera event variable
            setProperty('dad.visible', false)
            setProperty('camHUD.visible', false)
            triggerEvent('Set Camera Target', 'Dad,-100,-25', '')
            triggerEvent('Set Camera Zoom', '1.2,stage', '4,quadInOut')
            playCutscene()
            return Function_Stop
        end
    end
    return Function_Continue
end

local isGfCrying = false
function onUpdatePost(elapsed)
    if cutsceneFinished == false and isGfCrying == true then
        playAnim('gf', 'sad')
    end
end

function onSongStart()
    if cutsceneFinished == true then
        setProperty('dad.visible', true)
        removeLuaSprite('tankmanCutscene')
    end
end

function playCutscene()
    playMusic('DISTORTO')
    runTimer('startCutscene', 0.1)
    runTimer('gfCries', 4.1)
    runTimer('cameraZoom2', 4.6)
    runTimer('endCutscene', 11.5)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'startCutscene' then
        playAnim('tankmanCutscene', 'anim')
        playSound('tankSong2')
    end
    if tag == 'gfCries' then
        isGfCrying = true
        triggerEvent('Set Camera Zoom', '1.3,stage', '0.5,quadInOut')
    end
    if tag == 'cameraZoom2' then
        triggerEvent('Set Camera Zoom', '1.2,stage', '1,quadInOut')
    end
    if tag == 'endCutscene' then
        setVar('cutsceneMode', false) -- Need to disable to avoid issues
        cutsceneFinished = true
        soundFadeOut(nil, 1)
        setProperty('camHUD.visible', true)
        triggerEvent('Set Camera Zoom', '1,stage', '16,quadInOut')
        startCountdown()
    end
end