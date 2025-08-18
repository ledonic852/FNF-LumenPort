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

    makeAnimatedLuaSprite('tankmanBodyLeft', 'characters/speaker/tankman-body')
    addAnimationByPrefix('tankmanBodyLeft', 'idle', 'tankmanBody', 24, false)
    if characterType ~= '' then
        setObjectOrder('tankmanBodyLeft', getObjectOrder(characterType..'Group'))
    end
    addLuaSprite('tankmanBodyLeft')

    makeAnimatedLuaSprite('tankmanHeadLeft', 'characters/speaker/tankman-head1')
    addAnimationByPrefix('tankmanHeadLeft', 'idle', 'tankmanTop1', 24, false)
    if characterType ~= '' then
        setObjectOrder('tankmanHeadLeft', getObjectOrder(characterType..'Group') + 1)
    end
    addLuaSprite('tankmanHeadLeft')

    makeAnimatedLuaSprite('tankmanBodyRight', 'characters/speaker/tankman-body')
    addAnimationByPrefix('tankmanBodyRight', 'idle', 'tankmanBody', 24, false)
    if characterType ~= '' then
        setObjectOrder('tankmanBodyRight', getObjectOrder(characterType..'Group'))
    end
    addLuaSprite('tankmanBodyRight')
    setProperty('tankmanBodyRight.flipX', true)

    makeAnimatedLuaSprite('tankmanHeadRight', 'characters/speaker/tankman-head2')
    addAnimationByPrefix('tankmanHeadRight', 'idle', 'tankmanTop2', 24, false)
    if characterType ~= '' then
        setObjectOrder('tankmanHeadRight', getObjectOrder(characterType..'Group') + 1)
    end
    addLuaSprite('tankmanHeadRight')
    setProperty('tankmanHeadRight.flipX', true)

    makeAnimatedLuaSprite('speakerTank', 'characters/speaker_assets')
    addAnimationByPrefix('speakerTank', 'idle', 'bumpBox', 24, false)
    if characterType ~= '' then
        setObjectOrder('speakerTank', getObjectOrder(characterType..'Group'))
    end
    addLuaSprite('speakerTank')

    
    if characterType ~= '' then
        runHaxeCode([[
            function shaderCheck(character:String, object:String) return getLuaObject(object).shader == getAttachedCharacter(character).shader;
            function applyShader(character:String, object:String) getLuaObject(object).shader = getAttachedCharacter(character).shader;
            
            function getAttachedCharacter(character:String) {
                switch(character) {
                    case 'boyfriend':
                        return game.boyfriend;
                    case 'dad':
                        return game.dad;
                    case 'gf':
                        return game.gf;
                    default:
                        return getLuaObject('speakerTank');
                }
            }
        ]])
    end
    
    if characterName ~= '' then
        if _G[characterType..'Name'] ~= characterName then
            setProperty('speakerTank.visible', false)
            for i, side in ipairs({'Left', 'Right'}) do
                setProperty('tankmanBody'..side..'.visible', false)
                setProperty('tankmanHead'..side..'.visible', false)
            end
        end
    end
end

-- This is to prevent the speaker from still appearing when the attached character's gone.
function onEvent(eventName, value1, value2, strumTime)
    if eventName == 'Change Character' then
        if getCharacterType(value2) == characterType and value2 ~= characterName then
            setProperty('speakerTank.visible', false)
            for i, side in ipairs({'Left', 'Right'}) do
                setProperty('tankmanBody'..side..'.visible', false)
                setProperty('tankmanHead'..side..'.visible', false)
            end
        elseif characterName ~= '' then
            setProperty('speakerTank.visible', true)
            for i, side in ipairs({'Left', 'Right'}) do
                setProperty('tankmanBody'..side..'.visible', true)
                setProperty('tankmanHead'..side..'.visible', true)
            end
            if characterType == '' then
                characterType = getCharacterType(characterName)
                setProperty('speakerTank.x', getProperty(characterType..'.x') + offsetData[1])
                setProperty('speakerTank.y', getProperty(characterType..'.y') + offsetData[2])
                updateTankmenProperty('x')
                updateTankmenProperty('y')
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
        playAnim('speakerTank', 'idle', true)
        for i, side in ipairs({'Left', 'Right'}) do
            playAnim('tankmanBody'..side, 'idle', true)
            playAnim('tankmanHead'..side, 'idle', true)
        end
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
                    setProperty('speakerTank.'..propertyName, propertyValue + offsetData[property])
                else
                    setProperty('speakerTank.'..propertyName, propertyValue)
                end
                updateTankmenProperty(propertyName)
            end
        end
    end
    if characterType ~= '' then
        if runHaxeFunction('shaderCheck', {characterType, 'speakerTank'}) == false then
            runHaxeFunction('applyShader', {characterType, 'speakerTank'})
            for i, side in ipairs({'Left', 'Right'}) do
                runHaxeFunction('applyShader', {characterType, 'tankmanBody'..side})
                runHaxeFunction('applyShader', {characterType, 'tankmanHead'..side})
            end
        end
    end
end

function updateTankmenProperty(property)
    if property == 'x' then
        setProperty('tankmanBodyLeft.'..property, getProperty('speakerTank.'..property) + 510)
        setProperty('tankmanHeadLeft.'..property, getProperty('tankmanBodyLeft.'..property) - 77)
        setProperty('tankmanBodyRight.'..property, getProperty('speakerTank.'..property) - 93)
        setProperty('tankmanHeadRight.'..property, getProperty('tankmanBodyRight.'..property) - 17)
    elseif property == 'y' then
        setProperty('tankmanBodyLeft.'..property, getProperty('speakerTank.'..property) - 85)
        setProperty('tankmanHeadLeft.'..property, getProperty('tankmanBodyLeft.'..property) - 123)
        setProperty('tankmanBodyRight.'..property, getProperty('speakerTank.'..property) - 84)
        setProperty('tankmanHeadRight.'..property, getProperty('tankmanBodyRight.'..property) - 123)
    else
        setProperty('tankmanBodyLeft.'..property, getProperty('speakerTank.'..property))
        setProperty('tankmanHeadLeft.'..property, getProperty('speakerTank.'..property))
        setProperty('tankmanBodyRight.'..property, getProperty('speakerTank.'..property))
        setProperty('tankmanHeadRight.'..property, getProperty('speakerTank.'..property))
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