OPAL.BStickers = {}
OPAL.BSticker = SMODS.Sticker:extend{
    rarity = 1,
    inject = function(self)
        OPAL.BStickers[self.key] = self
        SMODS.Sticker.inject(self)
    end,
}

OPAL.Bsticker_rarities = {0.6, 0.2, 0.075}

function OPAL.BSticker:get_bsticker_rate(augment)
    augment = augment or 1
    local same_rarity_stickers = 0

    for k, v in pairs(OPAL.BStickers) do
        if v.rarity == self.rarity then
            same_rarity_stickers = same_rarity_stickers + 1
        end
    end
    
    return math.min(1, augment*OPAL.Bsticker_rarities[self.rarity]/same_rarity_stickers)
end

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
    rate = 0.06,
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
    rate = 0.06,
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

OPAL.BSticker{ -- Strong (The Arm)
    key = 'strong',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.1,
    needs_enable_flag = true,
    badge_colour = HEX('6865f3'),
    atlas = 'stickerAtlas',
    pos = {x = 3, y = 1},
    calculate = function(self, card, context)
        if context.after and context.cardarea == G.hand then
            if (G.GAME.chips + G.GAME.opal_strong_score) > G.GAME.blind.chips then
                return {
                    card = card,
                    level_up = -1
                }
            end
        end
    end,
}

OPAL.BSticker{ -- Sharp (The Flint)
    key = 'sharp',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.1,
    needs_enable_flag = true,
    badge_colour = HEX('e56a2f'),
    atlas = 'stickerAtlas',
    pos = {x = 1, y = 2},
    calculate = function(self, card, context)
        if context.initial_scoring_step and context.cardarea == G.play then
                return {
                    card = card,
                    xmult = 0.9,
                    xchips = 0.9
                }
        end
    end,
}

OPAL.BSticker{ -- Bleeding (Crimson Heart)
    key = 'bleeding',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 3,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('ac3232'),
    atlas = 'stickerAtlas',
    config = {extra = {debuffed_joker = nil}},
    pos = {x=2, y=2},
    calculate = function(self, card, context)
        if context.initial_scoring_step and context.cardarea == G.play then
            card.ability.opal_bleeding.debuffed_joker = pseudorandom_element(G.jokers.cards, pseudoseed('bs_b'))
            if card.ability.opal_bleeding.debuffed_joker then card.ability.opal_bleeding.debuffed_joker:set_debuff(true) end
        end
        if context.end_of_round then
            if card.ability.opal_bleeding.debuffed_joker then card.ability.opal_bleeding.debuffed_joker:set_debuff(false) end
            card.ability.opal_bleeding.debuffed_joker = nil
        end
    end
}

OPAL.BSticker{ -- Venomous (The Serpent)
    key = 'venomous',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('439a4f'),
    atlas = 'stickerAtlas',
    config = {extra = {debuffed_joker = nil}},
    pos = {x=5, y=0},
    calculate = function(self, card, context)
        if context.drawing_cards and context.cardarea == G.discard then
            return {cards_to_draw = context.amount - 1}
        end
    end
}

OPAL.BSticker{ -- Growing (Amber Acorn)
    key = 'growing',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 3,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('fda200'),
    atlas = 'stickerAtlas',
    config = {extra = {debuffed_joker = nil}},
    pos = {x=3, y=2},
    calculate = function(self, card, context)
        if context.cardarea == G.hand then
            if card.facing == 'front' then card:flip() end
        end
    end
}

OPAL.BSticker{ -- Intelligent (The Psychic)
    key = 'intelligent',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('efc03c'),
    atlas = 'stickerAtlas',
    pos = {x=4, y=1},
    calculate = function(self, card, context)
        if context.modify_scoring_hand and context.other_card == card then
            if #context.full_hand < 5 then
                return{remove_from_hand = true}
            end
        end
    end
}

OPAL.BSticker{ -- Homely (The House)
    key = 'homely',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('5186a8'),
    atlas = 'stickerAtlas',
    config = {extra = {keep_flipped = false}},
    pos = {x=5, y=1},
    calculate = function(self, card, context)
        if context.first_hand_drawn and context.hand_drawn then
            for k, v in ipairs(context.hand_drawn) do
                if v == card then
                    if card.facing == 'front' then card:flip() end
                    card.ability.opal_homely.keep_flipped = true
                end
            end
        end
        if context.cardarea == G.hand and card.ability.opal_homely.keep_flipped then
            if card.facing == 'front' then card:flip() end
        end
        if context.main_scoring and context.cardarea == G.play then
            if card.facing == 'back' then card:flip() end
        end
        if context.end_of_round then
            card.ability.opal_homely.keep_flipped = false
        end
    end
}

-- TO DO:
-- Verdant Leaf - Card is debuffed unless you have 1 empty Joker slot
-- Mouth - Card does not score if hand type is not (first handtype played)
-- Eye - Card does not score if hand type has been played this round
-- Fish - Card is drawn face-down if drawn after a hand was played
-- Wheel - 1 in 10 chance to be drawn face-down
-- Club/Goad/Window/Head - Card can never count as Club/Spade/Diamond/Heart
-- Wall/Violet Vessel - Increases Blind Requirement by x1.2/x1.5

function OPAL.update_bsticker_rates(augment)
    for k, v in pairs(SMODS.Stickers) do
        if OPAL.BStickers[k] then
            v.rate = v:get_bsticker_rate(augment)
            OPAL.BStickers[k].rate = v.rate
        end
    end
end

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

local sort_ref = CardArea.sort
function CardArea:sort(method) -- Growing functionality
    sort_ref(self, method)
    if self == G.hand then
        local growing_cards = {}
        local non_growing_cards = {}
        for k, v in ipairs(self.cards) do
            if v.ability.opal_growing and not v.debuff then
                growing_cards[#growing_cards+1] = v
            else
                non_growing_cards[#non_growing_cards+1] = v
            end
        end
        pseudoshuffle(growing_cards, pseudoseed('op_gr'))
        for k, v in ipairs(self.cards) do
            if growing_cards[k] then
                self.cards[k] = growing_cards[k]
            else
                self.cards[k] = non_growing_cards[k-#growing_cards]
            end
        end
    end
end