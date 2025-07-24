SMODS.Sticker{ -- Stacked (The Pillar)
    key = 'stacked',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rate = 0.5,
    needs_enable_flag = true,
    badge_colour = HEX('7e6752'),
    atlas = 'stickerAtlas',
    pos = {x = 0, y = 0}
}

SMODS.Sticker{ -- Hooked (The Hook)
    key = 'hooked',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rate = 0.5,
    needs_enable_flag = true,
    badge_colour = HEX('a84024'),
    atlas = 'stickerAtlas',
    pos = {x = 1, y = 0},
}

SMODS.Sticker{ -- Chewed (The Tooth)
    key = 'chewed',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rate = 0.5,
    needs_enable_flag = true,
    badge_colour = HEX('b52d2d'),
    atlas = 'stickerAtlas',
    pos = {x = 2, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {(G.GAME and G.GAME.modifiers) and G.GAME.modifiers.opal_chewed_loss or "1"}}
    end,
    calculate = function(self,card,context)
        if context.main_scoring and context.cardarea == G.play then
            ease_dollars(-G.GAME.modifiers.opal_chewed_loss)
        end
    end
}

SMODS.Sticker{ -- Trampled (The Ox)
    key = 'trampled',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rate = 0.2,
    needs_enable_flag = true,
    badge_colour = HEX('b95b08'),
    atlas = 'stickerAtlas',
    pos = {x = 4, y = 0},
    loc_vars = function(self, info_queue, card)
        return {vars = {(G.GAME and G.GAME.current_round) and G.GAME.current_round.most_played_poker_hand or "most played Hand",(G.GAME and G.GAME.modifiers) and G.GAME.modifiers.opal_trampled_multiplier or "0.5"}}
    end,
    calculate = function(self,card,context)
        if context.before and context.cardarea == G.play and not card.trampled_triggered then
            if G.GAME.opal_trampled_check then
                ease_dollars(G.GAME.dollars*-(1-G.GAME.modifiers.opal_trampled_multiplier), true)
                card.trampled_triggered = true
            end
        end
        if context.after and card.trampled_triggered then
            card.trampled_triggered = nil
        end
    end
}

SMODS.Sticker{ -- Ringing (Cerulean Bell)
    key = 'ringing',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('009cfd'),
    atlas = 'stickerAtlas',
    pos = {x = 0, y = 2}
}

SMODS.Sticker{ -- Bound (The Manacle)
    key = 'bound',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rate = 0.2,
    needs_enable_flag = true,
    badge_colour = HEX('575757'),
    atlas = 'stickerAtlas',
    pos = {x = 1, y = 1},
    calculate = function(self,card,context)
        if context.before and context.cardarea == G.play and card.ability.opal_bound_active then
            card.ability.opal_bound_active = false
            G.hand:change_size(1)            
        end
        if context.discard and context.other_card.ability.opal_bound_active then
            context.other_card.ability.opal_bound_active = false
            G.hand:change_size(1) 
        end
        if context.end_of_round and card.ability.opal_bound_active == true then
            card.ability.opal_bound_active = false
            G.hand:change_size(1)
        end
    end,
}

local debuff_hand_ref = Blind.debuff_hand
function Blind:debuff_hand(cards, hand, handname, check) -- Trampled functionality
    G.GAME.opal_trampled_check = false
    if not check then
        if handname == G.GAME.current_round.most_played_poker_hand then
            G.GAME.opal_trampled_check = true
        end
    end
    local result = debuff_hand_ref(self,cards, hand, handname, check)
    return result
end

local drawn_to_hand_ref = Blind.drawn_to_hand
function Blind:drawn_to_hand() -- Ringing / Bound functionality
    local ringing_cards = {}
    local non_bound_cards = {}
    local bound_cards = 0
    local any_forced = nil
    for k, v in ipairs(G.hand.cards) do
        if not v.debuff then
            if v.ability.opal_ringing then
                ringing_cards[#ringing_cards+1] = v
            end
            if v.ability.opal_bound and not v.ability.opal_bound_active then
                bound_cards = bound_cards + 1
                v.ability.opal_bound_active = true
            else
                non_bound_cards[#non_bound_cards+1] = v
            end
        end
        if v.ability.forced_selection then
            any_forced = true
        end
    end
    G.hand:change_size(-bound_cards)
    if bound_cards > 0 then
        for i = 1, bound_cards do
            local cardSelected = nil
            G.E_MANAGER:add_event(Event({ trigger = "before", func = function()
            local cardSelected, removeThis = pseudorandom_element(non_bound_cards,pseudoseed("bound_discard"))
            G.hand:add_to_highlighted(cardSelected)
            table.remove(non_bound_cards, removeThis)
            G.FUNCS.discard_cards_from_highlighted(nil, true)
            return true end }))
        end
    end
    if not any_forced and #ringing_cards>0 then
        G.E_MANAGER:add_event(Event({ trigger = "after", func = function()
            local forced_card = pseudorandom_element(ringing_cards,"opal_ringing")
            forced_card.ability.forced_selection = true
            G.hand:add_to_highlighted(forced_card)
        return true end }))
    end
    local result = drawn_to_hand_ref(self)
    return result
end

local press_play_ref = Blind.press_play
function Blind:press_play() -- Hooked functionality
    local opal_hooked_cards = 0
    for k, v in ipairs(G.hand.highlighted) do
        if not v.debuff then
            if v.ability.opal_hooked == true then
                opal_hooked_cards = opal_hooked_cards + 1
            end
        end
    end
    if opal_hooked_cards > 0 then
        G.E_MANAGER:add_event(Event({ func = function()
            local any_selected = nil
            local _cards = {}
            for k, v in ipairs(G.hand.cards) do
                _cards[#_cards+1] = v
            end
            for i = 1, opal_hooked_cards do
                if G.hand.cards[i] then 
                    local selected_card, card_key = pseudorandom_element(_cards, pseudoseed('opal_hooked'))
                    G.hand:add_to_highlighted(selected_card, true)
                    table.remove(_cards, card_key)
                    any_selected = true
                    play_sound('card1', 1)
                end
            end
            if any_selected then G.FUNCS.discard_cards_from_highlighted(nil, true) end
        return true end }))
        delay(0.7)
    end
    local result = press_play_ref(self)
    return result
end
