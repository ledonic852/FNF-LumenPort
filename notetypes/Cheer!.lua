-- Works exactly like the 'Hey!' notetype, but it plays the 'cheer' animation instead.
function goodNoteHit(index, noteData, noteType, isSustain)
    if noteType == 'Cheer!' then
        local character = 'boyfriend'
        if getPropertyFromGroup('notes', index, 'gfNote') == true then
            character = 'gf'
        end

        if callMethod(character..'.hasAnimation', {'cheer'}) then
            playAnim(character, 'cheer', true)
            setProperty(character..'.specialAnim', true)
            setProperty(character..'.heyTimer', 0.6)
        end
    end
end

function opponentNoteHit(index, noteData, noteType, isSustain)
    if noteType == 'Cheer!' then
        if callMethod('dad.hasAnimation', {'cheer'}) then
            playAnim('dad', 'cheer', true)
            setProperty('dad.specialAnim', true)
            setProperty('dad.heyTimer', 0.6)
        end
    end
end