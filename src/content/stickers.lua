OPAL.BStickers = {}
OPAL.BSticker = SMODS.Sticker:extend{
    rarity = 1,
    inject = function(self)
        OPAL.BStickers[self.key] = self
        SMODS.Sticker.inject(self)
    end,
}

OPAL.BSticker{ -- Stacked (The Pillar)
    key = 'stacked',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.2,
    needs_enable_flag = true,
    badge_colour = HEX('7e6752'),
    atlas = 'stickerAtlas',
    pos = {x = 0, y = 0}
}

OPAL.BSticker{ -- Hooked (The Hook)
    key = 'hooked',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.2,
    needs_enable_flag = true,
    badge_colour = HEX('a84024'),
    atlas = 'stickerAtlas',
    pos = {x = 1, y = 0},
}

OPAL.BSticker{ -- Chewed (The Tooth)
    key = 'chewed',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.2,
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

OPAL.BSticker{ -- Overgrown (The Plant)
    key = 'overgrown',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.15,
    needs_enable_flag = true,
    badge_colour = HEX('709284'),
    atlas = 'stickerAtlas',
    pos = {x = 3, y = 0},
}

OPAL.BSticker{ -- Trampled (The Ox)
    key = 'trampled',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.1,
    needs_enable_flag = true,
    badge_colour = HEX('b95b08'),
    atlas = 'stickerAtlas',
    pos = {x = 4, y = 0},
    config = {mph = 'most played Hand'},
    loc_vars = function(self, info_queue, card)
        OPAL.get_mph()
        card.ability.opal_trampled.mph = G.GAME.current_round.most_played_poker_hand
        return {vars = {card.ability.opal_trampled.mph ~= 'most played Hand' and localize(card.ability.opal_trampled.mph, 'poker_hands') or card.ability.opal_trampled.mph,(G.GAME and G.GAME.modifiers) and G.GAME.modifiers.opal_trampled_multiplier or "0.5"}}
    end,
    calculate = function(self,card,context)
        if context.before and context.cardarea == G.play and not card.trampled_triggered then
            OPAL.get_mph()
            card.ability.opal_trampled.mph = G.GAME.current_round.most_played_poker_hand
            if context.scoring_name == card.ability.opal_trampled.mph then
                ease_dollars(G.GAME.dollars*-(1-G.GAME.modifiers.opal_trampled_multiplier), true)
                card.trampled_triggered = true
                return{
                    message = localize{type = 'variable', key = 'a_xdollars', vars = {G.GAME.modifiers.opal_trampled_multiplier}},
                    colour = G.C.MONEY,
                    card = card
                }
            end
        end
        if context.after and card.trampled_triggered then
            OPAL.get_mph()
            card.ability.opal_trampled.mph = G.GAME.current_round.most_played_poker_hand
            card.trampled_triggered = nil
        end
    end
}

OPAL.get_mph = function()
    local _handname, _played, _order = 'High Card', -1, 100
        for k, v in pairs(G.GAME.hands) do
            if v.played > _played or (v.played == _played and _order > v.order) then 
                _played = v.played
                _handname = k
            end
        end
        G.GAME.current_round.most_played_poker_hand = _handname
end

OPAL.BSticker{ -- Bound (The Manacle)
    key = 'bound',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.1,
    needs_enable_flag = true,
    badge_colour = HEX('575757'),
    atlas = 'stickerAtlas',
    pos = {x = 1, y = 1},
    calculate = function(self,card,context)
        if context.hand_drawn then
            for k, v in ipairs(context.hand_drawn) do
                if v == card and v.ability.opal_bound and not v.ability.opal_bound_active then
                    v.ability.opal_bound_active = true
                    G.hand:change_size(-1)
                end
            end
        end
        if card.ability.opal_bound_active and ((context.before and context.cardarea == G.play) or
        (context.discard and context.other_card == card) or
        (context.end_of_round)) then
            card.ability.opal_bound_active = false
            G.hand:change_size(1)
        end
    end,
}

OPAL.BSticker{ -- Ringing (Cerulean Bell)
    key = 'ringing',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 3,
    rate = 0.03,
    needs_enable_flag = true,
    badge_colour = HEX('009cfd'),
    atlas = 'stickerAtlas',
    pos = {x = 0, y = 2}
}

OPAL.BSticker{ -- Prickly (The Needle)
    key = 'prickly',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('5c6e31'),
    atlas = 'stickerAtlas',
    pos = {x = 0, y = 1},
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            ease_hands_played(-1)
        end
    end,
}

OPAL.BSticker{ -- Soggy (The Water)
    key = 'soggy',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('c6e0eb'),
    atlas = 'stickerAtlas',
    pos = {x = 2, y = 1},
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            for k, v in ipairs(context.full_hand) do
                if v == card then
                    ease_discard(-1)
                end
            end
        end
    end,
}

-- TO DO:
-- Strong (The Arm) - Levels down the last played hand when held in hand at the end of the round
-- The Flint - X0.9 Chips, X0.9 Mult
-- Crimson Heart - When played, debuff a random Joker for the rest of the round
-- Serpent - After this card is played or discarded, draw 1 less card
-- Amber Acorn - Drawn face down, forced to be in the leftmost position

local drawn_to_hand_ref = Blind.drawn_to_hand
function Blind:drawn_to_hand() -- Ringing functionality
    local ringing_cards = {}
    local any_forced = nil
    for k, v in ipairs(G.hand.cards) do
        if not v.debuff then
            if v.ability.opal_ringing then
                ringing_cards[#ringing_cards+1] = v
            end
        end
        if v.ability.forced_selection then
            any_forced = true
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

local is_face_ref = Card.is_face
function Card:is_face(from_boss) -- Overgrown functionality
    if self.ability.opal_overgrown then
        return false
    end
    return is_face_ref(self, from_boss)
end


function Card:opal_stickers(max_rarity)
    max_rarity = max_rarity or 3
    for k, v in pairs(OPAL.BStickers) do
        if pseudorandom('opal_bst') < v.rate and v.rarity <= max_rarity then
            print('Applying '..k)
            self:add_sticker(k, true)
        end
    end
end