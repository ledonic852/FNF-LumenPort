function onCreate()
    if isStoryMode == true and seenCutscene == false then
        makeFlxAnimateSprite('gfCutscene', getCharacterX('gf') + 110, getCharacterY('gf') + 325)
        loadAnimateAtlas('gfCutscene', 'tank/cutscenes/picoAppears')
        addAnimationBySymbolIndices('gfCutscene', 'danceLeft', 'GF Dancing at Gunpoint', {30,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14})
        addAnimationBySymbolIndices('gfCutscene', 'danceRight', 'GF Dancing at Gunpoint', {15,16,17,18,19,20,21,22,23,24,25,26,27,28,29})
        addAnimationBySymbol('gfCutscene', 'idle', 'Pico Dual Wield on Speaker idle')
        addAnimationBySymbol('gfCutscene', 'anim1', 'GF Time to Die sequence')
        addAnimationBySymbol('gfCutscene', 'anim2', 'Pico Saves them sequence')
        setObjectOrder('gfCutscene', getObjectOrder('gfGroup'))
        addLuaSprite('gfCutscene')
        playAnim('gfCutscene', 'danceLeft')
        setProperty('gfCutscene.anim.curFrame', getProperty('gfCutscene.anim.length') - 1)
        
        makeFlxAnimateSprite('tankmanCutscene', getCharacterX('dad') + 420, getCharacterY('dad') + 465)
        loadAnimateAtlas('tankmanCutscene', 'tank/cutscenes/tankman')
        addAnimationBySymbol('tankmanCutscene', 'anim1', 'TANK TALK 3 P1 UNCUT')
        addAnimationBySymbol('tankmanCutscene', 'anim2', 'TANK TALK 3 P2 UNCUT')
        setObjectOrder('tankmanCutscene', getObjectOrder('dadGroup'))
        addLuaSprite('tankmanCutscene')
        playAnim('tankmanCutscene', 'anim1')
        callMethod('tankmanCutscene.anim.pause')

        makeAnimatedLuaSprite('boyfriendCutscene', 'characters/BOYFRIEND', getCharacterX('boyfriend') + 5, getCharacterY('boyfriend') + 370)
        addAnimationByPrefix('boyfriendCutscene', 'idle', 'BF idle dance', 24, false)
        setObjectOrder('boyfriendCutscene', getObjectOrder('boyfriendGroup'))
        addLuaSprite('boyfriendCutscene')

        precacheSound('stressCutscene')
        addLuaScript('events/Set Camera Zoom') -- Doing this, or else I can't use the event.
    end
end

local cutsceneFinished = false
function onStartCountdown()
    if isStoryMode == true and seenCutscene == false then
        if cutsceneFinished == false then
            setVar('cutsceneMode', true) -- Camera event variable
            setProperty('boyfriend.visible', false)
            setProperty('dad.visible', false)
            setProperty('gf.visible', false)
            setProperty('camHUD.visible', false)
            triggerEvent('Set Camera Target', 'Dad,-100,-25', '')
            triggerEvent('Set Camera Zoom', '1.2,stage', '1,quadInOut')
            playCutscene()
            return Function_Stop
        end
    end
    return Function_Continue
end

function onUpdatePost(elapsed)
    if isStoryMode == true and seenCutscene == false then
        if cutsceneFinished == false then
            if getProperty('boyfriend.animation.name') ~= 'idle' then
                if getProperty('boyfriend.animation.finished') then
                    playAnim('boyfriend', 'idle')
                end
            end
        end
    end
end

function playCutscene()
    runTimer('startCutscene', 0.1)
    runTimer('tankmenGunpointsGf', 15.3)
    runTimer('bfCatchesGf', 17.6)
    runTimer('tankmanMocksPico', 19.6)
    runTimer('camFocusTankman1', 20.1)
    runTimer('cringe', 31.3)
    runTimer('camFocusTankman2', 32.3)
    runTimer('endCutscene', 35.6)
end

local gfDanced = false
function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'beatHit' then
        if getProperty('gfCutscene.anim.finished') then
            if loopsLeft >= -38 then
                gfDanced = not gfDanced
                if gfDanced == true then
                    playAnim('gfCutscene', 'danceRight')
                else
                    playAnim('gfCutscene', 'danceLeft')
                end
            end
        end
        if loopsLeft < -54 then
            playAnim('gfCutscene', 'idle')
        end
    end
    if tag == 'startCutscene' then
        playAnim('boyfriendCutscene', 'idle')
        playAnim('gfCutscene', 'danceLeft')
        callMethod('boyfriendCutscene.animation.curAnim.finish')
        setProperty('gfCutscene.anim.curFrame', getProperty('gfCutscene.anim.length') - 1)
        playAnim('tankmanCutscene', 'anim1')
        playSound('stressCutscene')
        runTimer('beatHit', 60 / 158, 0)
    end
    if tag == 'tankmenGunpointsGf' then
        playAnim('gfCutscene', 'anim1')
        triggerEvent('Set Camera Target', 'GF,250,50', '1,sineOut')
        triggerEvent('Set Camera Zoom', '1.4,stage', '2.25,quadInOut')
    end
    if tag == 'bfCatchesGf' then
        playAnim('gfCutscene', 'anim2')
        playAnim('boyfriend', 'bfCatch')
        setProperty('boyfriend.visible', true)
        setProperty('boyfriendCutscene.visible', false)
        triggerEvent('Set Camera Target', 'GF,250,100', '0')
        triggerEvent('Set Camera Zoom', '0.8', '0')
    end
    if tag == 'tankmanMocksPico' then
        playAnim('tankmanCutscene', 'anim2')
    end
    if tag == 'camFocusTankman1' then
        triggerEvent('Set Camera Target', 'Dad,0,-25', '')
    end
    if tag == 'cringe' then
        playAnim('boyfriend', 'singUPmiss')
        triggerEvent('Set Camera Target', 'BF,100,50', '0')
        triggerEvent('Set Camera Zoom', '1.4,stage', '0')
    end
    if tag == 'camFocusTankman2' then
        triggerEvent('Set Camera Target', 'Dad,50,-25', '0')
        triggerEvent('Set Camera Zoom', '1.1,stage', '0')
    end
    if tag == 'endCutscene' then
        setVar('cutsceneMode', false) -- Need to disable to avoid issues
        cutsceneFinished = true
        soundFadeOut(nil, 1)
        setProperty('camHUD.visible', true)
        setProperty('dad.visible', true)
        setProperty('gf.visible', true)
        removeLuaSprite('boyfriendCutscene')
        removeLuaSprite('tankmanCutscene')
        removeLuaSprite('gfCutscene')
        triggerEvent('Set Camera Zoom', '1,stage', '16,quadInOut')
        startCountdown()
    end
end