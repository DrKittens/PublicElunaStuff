--Script that removes the target gameobject from inventory when the prospecting spell casts successfully without waiting
--Untested - May cause excess components to be removed - should be fine

local PLAYER_EVENT_ON_SPELL_CAST = 5

local function ProspectingBug(event, player, spell, skipCheck)  
    --Check if prospecting is cast, if its not then end the function
    if(spell:GetEntry() ~= 31252) then
        return
    end
    
    --Check the spell is actually casting ie passed the check
    if(player:IsCasting()) then
        --Get ObjectID Of Materials
        materials = spell:GetTarget():GetEntry()
        --Complete the Spell Cast
        spell:Finish()
        --Delete the Material Components from the player immediately
        player:RemoveItem(materials, 5)
    end
end

--Register our event
RegisterPlayerEvent(PLAYER_EVENT_ON_SPELL_CAST, ProspectingBug)