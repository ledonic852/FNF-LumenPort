function onEvent(event, value1, value2, strumTime)
    if event == 'Cheer!' then
        local character = nil
        if value1 == '0' or string.lower(value1) == 'bf' or string.lower(value1) == 'boyfriend' then
            character = 'boyfriend'
        elseif value1 == '1' or string.lower(value1) == 'dad' or string.lower(value1) == 'opponent' then
            character = 'dad'
        elseif value1 == '2' or string.lower(value1) == 'gf' or string.lower(value1) == 'girlfriend' then
            character = 'gf'
        end
        
        local heyTimer = 0
        if value2 == '' then
            heyTimer = 0.6
        else
            heyTimer = tonumber(value2)
        end
        
        if character ~= nil then
            playAnim(character, 'cheer', true)
            setProperty(character..'.specialAnim', true)
            setProperty(character..'.heyTimer', heyTimer)
        end
    end
end