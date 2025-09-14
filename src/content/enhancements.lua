SMODS.Enhancement{ -- Cookie
    key = 'cookie',
    atlas = 'cardAtlas', pos = {x=0, y=1},
    config = {extra = { odds = 3, max_bites = 3, bites_left = 3}},
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'opal_cookie')
        return{ vars = { numerator, denominator, card.ability.extra.max_bites, card.ability.extra.bites_left, localize{type = 'name_text', set = 'Enhanced', key = 'm_opal_cookie'}}}
    end,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            card.cookie_trigger = false
            if SMODS.pseudorandom_probability(card, 'opal_cookie', 1, card.ability.extra.odds) then
                card.cookie_trigger = true

                local cards_to_score = {}
                local thisCard = nil
                for k = 1, #context.scoring_hand do
                    if not SMODS.has_enhancement(context.scoring_hand[k], 'm_opal_cookie') then
                        cards_to_score[#cards_to_score+1] = k
                    end
                    if context.scoring_hand[k] == card then
                        thisCard = k
                    end
                end

                card_eval_status_text(card, 'extra', nil, nil, nil, {message = (card.ability.extra.bites_left > 1 and localize('k_opal_chomp') or localize('k_opal_eaten')),})
                G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()

                    card.ability.extra.bites_left = card.ability.extra.bites_left - 1
                    if card.ability.extra.bites_left ~= 0 then
                        card.children.center:set_sprite_pos({x = math.min((3-card.ability.extra.bites_left),2), y=1})
                    end
                return true end}))

                return{
                    OPAL.cookie_rescore_cards(thisCard, cards_to_score, {cardarea = G.play, full_hand = context.full_hand, scoring_hand = context.scoring_hand, scoring_name = context.scoring_name, poker_hands = context.poker_hands})
                }
            end
        end
        if context.destroy_card and context.destroying_card == card and card.ability.extra.bites_left <= 1 then
            return { remove = true }
        end
    end,
    draw = function(self, card, layer)
        card.children.center:set_sprite_pos({x = math.min((3-card.ability.extra.bites_left),2), y=1})
    end,
}

function OPAL.cookie_rescore_cards(cookie, cards, context)
    G.GAME.opal_cookie_rescoring = true
    for k, v in ipairs(cards) do
        G.E_MANAGER:add_event(Event({trigger = 'immediate', func = function()
            context.scoring_hand[cookie]:juice_up()
        return true end}))
        SMODS.score_card(context.scoring_hand[v], context)
    end
    G.GAME.opal_cookie_rescoring = false
end