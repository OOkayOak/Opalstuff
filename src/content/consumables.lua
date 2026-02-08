SMODS.Consumable{ -- Voodoo
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

SMODS.Consumable{ -- Modify
    key = 'modify',
    set = 'Spectral',
    atlas = 'spectralAtlas', pos = {x=1,y=0},
    config = {extra = {max_removed = 3}},
    cost = 4,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.max_removed}}
    end,
    use = function(self, card, area)
        G.opal_heat_mods.config.highlighted_limit = 0
        local stackToRemove = math.min(card.ability.extra.max_removed, (G.consumeables.config.card_limit - #G.consumeables.cards), G.opal_heat_mods.highlighted[1].ability.opal_count)

        G.E_MANAGER:add_event(Event({
            func = function()
                local pleaseKill = G.opal_heat_mods.highlighted[1]
                G.opal_heat_mods:unhighlight_all()
                print(pleaseKill)
                OPAL.remove_mod({card = pleaseKill, num = stackToRemove})
            return true end
        }))
        for i = 1, stackToRemove do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        SMODS.add_card({set = 'Spectral'})
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end,
    calculate = function(self, card, context)
        G.opal_heat_mods.config.highlighted_limit = 1
    end,
    can_use = function(self, card)
        if #G.consumeables.cards < G.consumeables.config.card_limit and
            #G.opal_heat_mods.highlighted == 1 then
            return true
        else
            return false
        end
    end
}

SMODS.Consumable{ -- The Milk Churn
    key = 'churn',
    set = 'Tarot',
    atlas = 'spectralAtlas', pos = {x=0,y=1},
    config = {max_highlighted = 2, mod_conv = 'm_opal_cookie'},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS[card.ability.mod_conv]
        return { vars = { card.ability.max_highlighted, localize { type = 'name_text', set = 'Enhanced', key = card.ability.mod_conv } } }
    end,
}