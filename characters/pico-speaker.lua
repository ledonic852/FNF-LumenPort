function onCreatePost()
    addLuaScript('characters/props/speaker')
    callScript('characters/props/speaker', 'createSpeaker', {'pico-speaker', -215, 438}) -- {characterName, offsetX, offsetY}
end