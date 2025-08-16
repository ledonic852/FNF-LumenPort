function onCreate()
    if seenCutscene == false then
        makeLuaSprite('blackScreen')
        makeGraphic('blackScreen', screenWidth * 2, screenHeight * 2, '000000')
        setScrollFactor('blackScreen', 0, 0)
        addLuaSprite('blackScreen', true)
        addLuaScript('events/Set Camera Zoom') -- Doing this, or else I can't use the event.
    end
end

local stopCountdown = true
function onStartCountdown()
    if seenCutscene == false and stopCountdown == true then
        setVar('cutsceneMode', true) -- Camera event variable
        setProperty('inCutscene', true)
        setProperty('camHUD.visible', false)

        playSound('Lights_Turn_On')
        triggerEvent('Set Camera Target', 'None,400,-2050', '0')
        triggerEvent('Set Camera Zoom', '2.5', '0')
        
        doTweenAlpha('fadeOutScreen', 'blackScreen', 0, 0.7, 'linear')
        runTimer('startTweenOut', 0.8)
        return Function_Stop
    end
    return Function_Continue
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'startTweenOut' then
        setProperty('camHUD.visible', true)
        triggerEvent('Set Camera Zoom', '1,stage', '2.5,quadInOut')
        runTimer('startSong', 2.5)
    end
    if tag == 'startSong' then
        setVar('cutsceneMode', false) -- Need to disable to avoid issues
        stopCountdown = false
        startCountdown()
        triggerEvent('Set Camera Target', 'None,400,-2050', '0') -- Need to do that so that the camera stays focused there
    end
end

function onTweenCompleted(tag)
    if tag == 'fadeOutScreen' then
        removeLuaSprite('blackScreen')
    end
end