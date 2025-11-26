SMODS.Blind{
    key = 'stinger',
    atlas = 'blindAtlas', pos = {x=0, y=1},
    boss_colour = HEX('8c5d8d'),
    boss = ({min = 4}),
    press_play = function(self)
        local killThisCard = pseudorandom_element(G.hand.highlighted, pseudoseed('opal_stinger'))
        G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
            SMODS.destroy_cards(killThisCard)
        return true end}))
    end,
}

SMODS.Blind{
    key = 'overload',
    atlas = 'blindAtlas', pos = {x=0, y=2},
    boss_colour = HEX('b43117'),
    boss = ({min = 2}),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.press_play then
                blind.prepped = true
            end
            if (context.hand_drawn and blind.prepped) or context.first_hand_drawn then
                local possible_mods = {}
                for k, v in ipairs(G.opal_heat_mods.cards) do
                    v.ability.opal_overload_chosen = false
                    blind:debuff_card(v)
                    if v.config.center.opal_alignment == 'good' then
                        possible_mods[#possible_mods+1] = v
                    end
                end
                debuff_this_card = pseudorandom_element(possible_mods, pseudoseed('bl_opal_overload'))
                debuff_this_card.ability.opal_overload_chosen = true
                blind:debuff_card(debuff_this_card)
                blind.prepped = nil
            end
        end
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.ability.opal_overload_chosen
    end,
    in_pool = function(self)
        if G.GAME then
            if G.GAME.round_resets.ante > 2 then
                if G.opal_heat_mods and G.opal_heat_mods[1] then
                    return true
                end
            end
        end
        return false
    end
}