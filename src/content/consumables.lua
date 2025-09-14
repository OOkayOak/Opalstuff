SMODS.Consumable{
    key = 'voodoo',
    set = 'Spectral',
    atlas = 'spectralAtlas', pos = {x=0,y=0},
    cost = 4,
    use = function(self, card, area)
        local other_card = pseudorandom_element(card.eligible_editionless_jokers, 'opal_voodoo')
        G.E_MANAGER:add_event(Event({
            trigger = "after", delay = 0.4, func = function()
                play_sound('tarot1')
                card:juice_up(0.3,0.5)
            return true end}))
            
        G.E_MANAGER:add_event(Event({
            func = function()
                    other_card.pinned = true
                    other_card:set_edition({polychrome = true}, true)
            return true end}))

        G.E_MANAGER:add_event(Event({func = function() 
            G.jokers:unhighlight_all() 
        return true end}))
    end,
    can_use = function(self, card)
        if next(card.eligible_editionless_jokers) then
            return true
        else
            return false
        end
    end,
    update = function(self, card, dt)
        if G and G.jokers and G.jokers.cards then
        card.eligible_editionless_jokers = EMPTY(card.eligible_editionless_jokers)
        for k, v in pairs(G.jokers.cards) do
            if v.ability.set == 'Joker' and not(v.edition) then
                table.insert(card.eligible_editionless_jokers, v)
            end
        end
        end
    end
}

SMODS.Consumable{ -- The Milk Churn
    key = 'churn',
    set = 'Tarot',
    atlas = 'spectralAtlas', pos = {x=1,y=0},
    config = {max_highlighted = 2, mod_conv = 'm_opal_cookie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}