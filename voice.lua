if(csExists) then -- CS handles this itself. 
    return
end

-- bug: If the player's character is set to Waluigi in the djui menu, Toad's voice will be lower pitched. 
-- It's a feature now, I think it's funny. 
---@param m MarioState
---@param characterSound integer
function character_sound(m, characterSound)
    return gCharacters[CHAR_NUM_DEFAULT].sounds[characterSound + 1] -- remaps the intended character sound to the default character's sounds. The + 1 is for smlua indexing confusion reasons
end


hook_event(HOOK_CHARACTER_SOUND, character_sound)