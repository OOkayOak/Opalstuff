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
                if context.debuff_card and context.debuff_card.area == G.opal_heat_mods then
                    if context.debuff_card.ability.opal_overload_chosen then
                        if context.debuff_card.ability.opal_count > 1 then
                            if not context.debuff_card.ability.opal_md_temp_overload_decreased then
                                OPAL.depower_modifier(context.debuff_card, 1)
                                context.debuff_card.ability.opal_md_temp_overload_decreased = true
                            end
                        else
                            return{
                                debuff = true
                            }
                        end
                    end
                end
                if context.press_play then
                    blind.triggered = true
                    blind.prepped = true
                end
                if (context.hand_drawn and blind.prepped) then
                    local possible_mods = {}
                    local fallback_mods = {}
                    local prev_chosen = {}
                    for i = 1, #G.opal_heat_mods.cards do
                        if G.opal_heat_mods.cards[i].ability.opal_overload_chosen then
                            prev_chosen[G.opal_heat_mods.cards[i]] = true
                            G.opal_heat_mods.cards[i].ability.opal_overload_chosen = nil
                            if G.opal_heat_mods.cards[i].debuff then 
                                SMODS.recalc_debuff(G.opal_heat_mods.cards[i])
                            else
                                OPAL.power_modifier_up(G.opal_heat_mods.cards[i], 1)
                                G.opal_heat_mods.cards[i].ability.opal_md_temp_overload_decreased = nil
                            end
                        end
                    end
                    for i = 1, #G.opal_heat_mods.cards do
                        if not G.opal_heat_mods.cards[i].debuff then
                            if not prev_chosen[G.opal_heat_mods.cards[i]] then
                                possible_mods[#possible_mods+1] = G.opal_heat_mods.cards[i]
                            end
                            table.insert(fallback_mods, G.opal_heat_mods.cards[i])
                        end
                    end
                    if #possible_mods == 0 then possible_mods = fallback_mods end
                    local _card = pseudorandom_element(possible_mods, 'opal_overload')
                    if _card then
                        _card.ability.opal_overload_chosen = true
                        SMODS.recalc_debuff(_card)
                        _card:juice_up()
                        blind:wiggle()
                    end
                end
            end
        if context.hand_drawn then
            blind.prepped = nil
        end
    end,
    disable = function(self)
        for i = 1, #G.opal_heat_mods.cards do
            if G.opal_heat_mods.cards[i].ability.opal_overload_chosen then
                G.opal_heat_mods.cards[i].ability.opal_overload_chosen = false
                if not G.opal_heat_mods.cards[i].debuff then
                    OPAL.power_modifier_up(G.opal_heat_mods.cards[i], 1)
                    G.opal_heat_mods.cards[i].ability.opal_md_temp_overload_decreased = nil
                end
            end
        end
    end,
    defeat = function(self)
        for i = 1, #G.opal_heat_mods.cards do
            if G.opal_heat_mods.cards[i].ability.opal_overload_chosen then
                G.opal_heat_mods.cards[i].ability.opal_overload_chosen = false
                if not G.opal_heat_mods.cards[i].debuff then
                    OPAL.power_modifier_up(G.opal_heat_mods.cards[i], 1)
                    G.opal_heat_mods.cards[i].ability.opal_md_temp_overload_decreased = nil
                end
            end
        end
    end
}