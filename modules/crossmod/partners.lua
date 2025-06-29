Partner_API = SMODS.Mods['partner']

Partner_API.Partner{ -- The Stack
    key = "stack",
    atlas = "partnerAtlas",
    pos = {x = 0, y = 0},
    config = {extra = {xmult = 3}},
    individual_quips = true,
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue+1] = {key = "opal_stacked", set = "Other", vars = {}}
        return{vars = {card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local unstacked_cards = {}
            for k, v in ipairs(context.scoring_hand) do
                if not v.ability.opal_stacked then
                    unstacked_cards[#unstacked_cards+1] = v
                end
            end
            if #unstacked_cards > 0 then
                local card_to_stack = pseudorandom_element(unstacked_cards, "pnr_stack")
                G.E_MANAGER:add_event(Event({func = function()
                    card_to_stack.ability.opal_stacked = true
                    play_sound('card1')
                    card_to_stack:juice_up(0.8)
                return true end}))
                delay(0.7)
            end
            return{
                    message = localize{type = "variable", key = "a_xmult", vars = {card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult
                }
        end
    end
}

Partner_API.Partner{ -- The Snake
    key = "snake",
    atlas = "partnerAtlas",
    pos = {x = 1, y = 0},
    config = {extra = {cards = 4}},
    individual_quips = false,
    loc_vars = function(self,info_queue,card)
        return{vars = {card.ability.extra.cards}}
    end
}