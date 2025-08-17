tankAngle = 0
tankSpeed = 0
function onCreate()
    if lowQuality == false then
        removeLuaSprite('clouds') -- Doind this so I can replace it with FlxTiledSprite
        createInstance('clouds', 'flixel.addons.display.FlxTiledSprite', {nil, 3200, 235, true, false})
        loadGraphic('clouds', 'tank/tankClouds')
        setObjectOrder('clouds', getObjectOrder('mountains') + 1)
        setScrollFactor('clouds', 0.25, 0.25)
        addLuaSprite('clouds')
        callMethod('clouds.setPosition', {-1100, 20})
        setProperty('clouds.velocity.x', 8)
    end

    tankAngle = getRandomInt(-90, 45)
    tankSpeed = getRandomFloat(5, 7)
end

function onUpdate(elapsed)
    -- Moving tank stuff 
    tankAngle = tankAngle + elapsed * tankSpeed
    setProperty('tankRolling.angle', tankAngle - 75)
    setProperty('tankRolling.x', 400 + math.cos(math.rad(tankAngle + 180)) * 1500)
    setProperty('tankRolling.y', 1300 + math.sin(math.rad(tankAngle + 180)) * 1100)
end

function onBeatHit()
    if curBeat % 2 == 0 then
        for i = 0, 5 do
            if luaSpriteExists('tankAudience'..i) then
                playAnim('tankAudience'..i, 'idle', true)
            end
        end
        if lowQuality == false then
            playAnim('watchtower', 'idle', true)
        end
    end
end
