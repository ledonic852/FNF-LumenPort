function onCreate()
    if isStoryMode == true and seenCutscene == false then
        makeFlxAnimateSprite('tankmanCutscene', getCharacterX('dad') + 420, getCharacterY('dad') + 465)
        loadAnimateAtlas('tankmanCutscene', 'tank/cutscenes/tankman')
        addAnimationBySymbol('tankmanCutscene', 'anim1', 'TANK TALK 1 P1')
        addAnimationBySymbol('tankmanCutscene', 'anim2', 'TANK TALK 1 P2')
        setObjectOrder('tankmanCutscene', getObjectOrder('dadGroup'))
        addLuaSprite('tankmanCutscene')
        playAnim('tankmanCutscene', 'anim1')
        callMethod('tankmanCutscene.anim.pause')

        precacheMusic('DISTORTO')
        for i, sound in ipairs({'wellWellWell', 'killYou', 'bfBeep'}) do
            precacheSound(sound)
        end
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
            triggerEvent('Set Camera Target', 'Dad,-100,-25', '0')
            triggerEvent('Set Camera Zoom', '1.2,stage', '0')
            playCutscene()
            return Function_Stop
        end
    end
    return Function_Continue
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
    runTimer('moveCamera1', 3)
    runTimer('beep!', 4.5)
    runTimer('moveCamera2', 6)
    runTimer('endCutscene', 12)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'startCutscene' then
        playAnim('tankmanCutscene', 'anim1')
        playSound('wellWellWell')
    end
    if tag == 'moveCamera1' then
        triggerEvent('Set Camera Target', 'BF,50,25')
    end
    if tag == 'beep!' then
        playAnim('boyfriend', 'singUP')
        playSound('bfBeep')
    end
    if tag == 'moveCamera2' then
        triggerEvent('Set Camera Target', 'Dad,-100,-25')
        playAnim('tankmanCutscene', 'anim2')
        playSound('killYou')
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