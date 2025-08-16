local pauseMusic = ''
function onCreate()
	-- Default Game Over.
	setPropertyFromClass('substates.GameOverSubstate', 'characterName', 'bf-pixel-dead')
	setPropertyFromClass('substates.GameOverSubstate', 'deathSoundName', 'fnf_loss_sfx-pixel')
	setPropertyFromClass('substates.GameOverSubstate', 'loopSoundName', 'gameOver-pixel')
	setPropertyFromClass('substates.GameOverSubstate', 'endSoundName', 'gameOverEnd-pixel')

	-- Pause Music turns into its 'Pixel' variant, if there's one.
	pauseMusic = getPropertyFromClass('backend.ClientPrefs', 'data.pauseMusic')
	fileName = pauseMusic:gsub(' ', '-'):lower()
    if checkFileExists('music/'..fileName..'-pixel.ogg') then
        setPropertyFromClass('backend.ClientPrefs', 'data.pauseMusic', pauseMusic..' Pixel')
    end
end

function onCreatePost()
    trailSetup()
    if shadersEnabled == true and lowQuality == false then
        initLuaShader('wiggle')
        wiggleData = {
            treesEvilBG = {speed = 2 * 0.8, frequency = 4 * 0.4, amplitude = 0.011},
            schoolEvil = {speed = 2, frequency = 4, amplitude = 0.017},
            streetEvil = {speed = 2, frequency = 4, amplitude = 0.007},
            treesEvil = {speed = 2, frequency = 4, amplitude = 0.007}
        }

        for object, data in pairs(wiggleData) do
		    setSpriteShader(object, 'wiggle')
		    setShaderFloat(object, 'uSpeed', data.speed)
		    setShaderFloat(object, 'uFrequency', data.frequency)
		    setShaderFloat(object, 'uWaveAmplitude', data.amplitude)
		    setShaderInt(object, 'effectType', 0)
		end
    end
end

function onDestroy()
	-- Resets the Pause Music to its original version, else it'll apply everywhere.
	setPropertyFromClass('backend.ClientPrefs', 'data.pauseMusic', pauseMusic)
end

-- Sets up the sprites for the 'Trigger BG Ghouls' event if it's present in the chart.
local eventInitialized = false
function onEventPushed(event, value1, value2, strumTime)
    if event == 'Trigger BG Ghouls' and lowQuality == false and eventInitialized == false then
		makeAnimatedLuaSprite('girlfreaksEvil', 'weeb/bgGhouls', -646, 222)
		addAnimationByPrefix('girlfreaksEvil', 'anim', 'BG freaks glitch instance', 24, false)
		scaleObject('girlfreaksEvil', 6, 6)
		addLuaSprite('girlfreaksEvil')
		setProperty('girlfreaksEvil.antialiasing', false)
		setProperty('girlfreaksEvil.visible', false)
		eventInitialized = true
    end
end

-- Simple thing to update the wiggle shader for every object.
local elapsedTime = 0
function onUpdate(elapsed)
	if shadersEnabled == true and lowQuality == false then
		elapsedTime = elapsedTime + elapsed
        for i, object in ipairs({'treesEvilBG', 'schoolEvil', 'streetEvil', 'treesEvil'}) do
		    setShaderFloat(object, 'uTime', elapsedTime)
        end
	end
end

-- Everything from this point is for the 'Trigger BG Ghouls' event
function onEvent(eventName, value1, value2, strumTime)
	if eventName == 'Trigger BG Ghouls' then
		if lowQuality == false then
            cancelTimer('freaksAnimLength') -- Just in case
			playAnim('girlfreaksEvil', 'anim', true)
			setProperty('girlfreaksEvil.visible', true)
			runTimer('freaksAnimLength', getProperty('girlfreaksEvil.animation.curAnim.numFrames') / 24)
		end
	end
	if eventName == 'Change Character' then
		trailSetup()
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'freaksAnimLength' then
		setProperty('girlfreaksEvil.visible', false)
	end
end

function trailSetup()
	runHaxeCode([[
		import flixel.math.FlxAngle;
		import flixel.addons.effects.FlxTrail;

		if (game.dadTrail != null) {
			game.dadTrail.destroy(); // Cleanly destroy the old trail
			game.remove(game.dadTrail); // Optional: also remove from scene graph
			game.dadTrail = null;
		}

		// Add new trail
		var newTrail:FlxTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069);
		game.dadTrail = newTrail;
		insert(members.indexOf(game.dadGroup), game.dadTrail);
	]])
end
