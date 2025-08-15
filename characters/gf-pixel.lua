local gfComboAnim = nil
local animOptions = {Disabled = 'none', Psych = 'psych', Vanilla = 'vanilla'}
function onCreate()
    --[[
        This is how the script recognizes which option you chose to use.
        However, if you decide to take GF inside another mod,
        the 'gfComboAnim' variable will default to 'none' to avoid any bugs or issues.
        If that's the case, you can manually choose which option to pick by putting a string from 'animOptions'.
    ]]
    for optionName, optionStr in pairs(animOptions) do
        if getModSetting('comboAnims') == optionName then
            gfComboAnim = optionStr
        elseif getModSetting('comboAnims') == nil then
            gfComboAnim = 'none'
        end
    end
end

--[[
    If you ever want to use the Speaker on another character,
    just copy and paste this below, and change what's between '{}'.
    
    WARNING: The speaker can only get attached to BF, Dad, or GF type characters.
    Else, the offsets act as simple x and y positions, and will not be attached to any character.
]]
function onCreatePost()
    addLuaScript('characters/props/speaker-pixel')
    callScript('characters/props/speaker-pixel', 'createSpeaker', {'gf-pixel', -314, 76}) -- {characterName, offsetX, offsetY}
end

-- Everything from this point is useless, but I'm keeping it still in case the animations ever get added.
function goodNoteHit(membersIndex, noteData, noteType, isSustainNote)
    if gfComboAnim ~= 'none' then
        if gfComboAnim == 'vanilla' then
            if combo == 50 then
                --playAnim('gf', 'cheer')
                --setProperty('gf.specialAnim', true)
            end
        end
        lastCombo = combo
    end
end

function noteMiss(membersIndex, noteData, noteType, isSustainNote)
    if gfComboAnim ~= 'none' then
        if gfComboAnim == 'vanilla' then
            if lastCombo >= 70 then
                --playAnim('gf', 'sad')
                --setProperty('gf.specialAnim', true)
            end
        end
        if gfComboAnim == 'psych' then
            if lastCombo > 5 then
                --playAnim('gf', 'sad')
                --setProperty('gf.specialAnim', true)
            end
        end
        lastCombo = 0
    end
end

function noteMissPress(direction)
    if gfComboAnim ~= 'none' then
        if gfComboAnim == 'vanilla' then
            if lastCombo >= 70 then
                --playAnim('gf', 'sad')
                --setProperty('gf.specialAnim', true)
            end
        end
        if gfComboAnim == 'psych' then
            if lastCombo > 5 then
                --playAnim('gf', 'sad')
                --setProperty('gf.specialAnim', true)
            end
        end
        lastCombo = 0
    end
end