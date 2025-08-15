local characterType = ''
local characterName = ''
local offsetData = {0, 0}
local propertyTracker = {
    {'x', nil},
    {'y', nil},
    {'color', nil},
    {'scrollFactor.x', nil},
    {'scrollFactor.y', nil},
    {'angle', nil},
    {'alpha', nil},
    {'antialiasing', nil},
    {'visible', nil}
}
--[[
    Self explanatory, creates the speaker based on if if's attached to a character or not,
    and the inputted offsets. Wait, why did I explain it still?
    Because it also syncs up the speaker's shader with the character's, if it's attached to one.
]]
function createSpeaker(attachedCharacter, offsetX, offsetY)
    characterName = attachedCharacter
    offsetData = {offsetX, offsetY}
    if getCharacterType(attachedCharacter) ~= nil then
        characterType = getCharacterType(attachedCharacter)
    end

    makeAnimatedLuaSprite('speakerChristmas', 'characters/speaker_assets')
    addAnimationByPrefix('speakerChristmas', 'idle', 'bumpBox', 24, false)
    if characterType ~= '' then
        setObjectOrder('speakerChristmas', getObjectOrder(characterType..'Group'))
    end
    addLuaSprite('speakerChristmas')

    makeAnimatedLuaSprite('christmasLights', 'characters/speaker/lights')
    addAnimationByPrefix('christmasLights', 'idle', 'glow', 24, false)
    if characterType ~= '' then
        setObjectOrder('christmasLights', getObjectOrder(characterType..'Group'))
    end
    addLuaSprite('christmasLights')
    
    if characterType ~= '' then
        runHaxeCode([[
            function shaderCheck(character:String) return getLuaObject('speakerChristmas').shader == getAttachedCharacter(character).shader;
            function applyShader(character:String) {
                getLuaObject('speakerChristmas').shader = getAttachedCharacter(character).shader;
                getLuaObject('christmasLights').shader = getAttachedCharacter(character).shader;
            }
            
            function getAttachedCharacter(character:String) {
                switch(character) {
                    case 'boyfriend':
                        return game.boyfriend;
                    case 'dad':
                        return game.dad;
                    case 'gf':
                        return game.gf;
                    default:
                        return getLuaObject('speakerChristmas');
                }
            }
        ]])
    end
    
    if characterName ~= '' then
        if _G[characterType..'Name'] ~= characterName then
            setProperty('speakerChristmas.visible', false)
            setProperty('christmasLights.visible', false)
        end
    end
end

-- This is to prevent the speaker from still appearing when the attached character's gone.
function onEvent(eventName, value1, value2, strumTime)
    if eventName == 'Change Character' then
        if getCharacterType(value2) == characterType and value2 ~= characterName then
            setProperty('speakerChristmas.visible', false)
            setProperty('christmasLights.visible', false)
        elseif characterName ~= '' then
            setProperty('speakerChristmas.visible', true)
            setProperty('christmasLights.visible', true)
            if characterType == '' then
                characterType = getCharacterType(characterName)
                setProperty('speakerChristmas.x', getProperty(characterType..'.x') + offsetData[1])
                setProperty('speakerChristmas.y', getProperty(characterType..'.y') + offsetData[2])
                setProperty('christmasLights.x', getProperty('speakerChristmas.x') - 83)
                setProperty('christmasLights.y', getProperty('speakerChristmas.y') - 40)
            end
        end
    end
end

function onBeatHit()
    --[[
        Makes the speaker bop at the same time as the character.
        Ex: If the character only bops their head when the beat is even,
        then the speaker will also do the same.
    ]]
    if characterType == 'gf' then
        characterSpeed = getProperty('gfSpeed')
    else
        characterSpeed = 1
    end
    if characterType ~= '' then
        danceEveryNumBeats = getProperty(characterType..'.danceEveryNumBeats')
    else
        danceEveryNumBeats = 1
    end
    if curBeat % (danceEveryNumBeats * characterSpeed) == 0 then
        playAnim('speakerChristmas', 'idle', true)
        playAnim('christmasLights', 'idle', true)
    end
end

-- Makes the speaker have the same properties as the character, if attached to one.
function onUpdatePost(elapsed)
    for property = 1, #propertyTracker do
        if characterType ~= '' then
            if propertyTracker[property][2] ~= getProperty(characterType..'.'..propertyTracker[property][1]) then
                propertyTracker[property][2] = getProperty(characterType..'.'..propertyTracker[property][1])    
                
                local propertyName = propertyTracker[property][1]
                local propertyValue = propertyTracker[property][2]
                if property < 3 then
                    setProperty('speakerChristmas.'..propertyName, propertyValue + offsetData[property])
                    if propertyName == 'x' then
                        setProperty('christmasLights.'..propertyName, getProperty('speakerChristmas.'..propertyName) - 83)
                    else
                        setProperty('christmasLights.'..propertyName, getProperty('speakerChristmas.'..propertyName) - 40)
                    end
                else
                    setProperty('speakerChristmas.'..propertyName, propertyValue)
                    setProperty('christmasLights.'..propertyName, getProperty('speakerChristmas.'..propertyName))
                end
            end            
        end
    end
    if characterType ~= '' then
        if runHaxeFunction('shaderCheck', {characterType}) == false then
            runHaxeFunction('applyShader', {characterType})
        end
    end
end

function getCharacterType(characterName)
    if boyfriendName == characterName then
        return 'boyfriend'
    elseif dadName == characterName then
        return 'dad'
    elseif gfName == characterName then
        return 'gf'
    end
end