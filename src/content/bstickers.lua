OPAL.BStickers = {}
OPAL.BSticker = SMODS.Sticker:extend{
    rarity = 1,
    inject = function(self)
        OPAL.BStickers[self.key] = self
        SMODS.Sticker.inject(self)
    end,
}

OPAL.Bsticker_rarities = {0.8, 0.35, 0.1}

function OPAL.BSticker:get_bsticker_rate(augment)
    augment = augment or 1
    local same_rarity_stickers = 0

    for k, v in pairs(OPAL.BStickers) do
        if v.rarity == self.rarity then
            same_rarity_stickers = same_rarity_stickers + 1
        end
    end

    if self.key == 'opal_overloaded' then
        return 1
    else
        return 0
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
    pos = {x = 0, y = 0},
    counterpart = 'bl_pillar'
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
    counterpart = 'bl_hook'
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
    counterpart = 'bl_tooth',
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
    counterpart = 'bl_plant'
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
    counterpart = 'bl_ox',
    loc_vars = function(self, info_queue, card)
        OPAL.get_mph()
        card.ability.opal_trampled.mph = G.GAME.current_round.most_played_poker_hand
        local _1 = card.ability.opal_trampled.mph ~= 'most played Hand' and localize(card.ability.opal_trampled.mph, 'poker_hands') 
        or (card and card.ability and card.ability.opal_trampled) and card.ability.opal_trampled.mph 
        or 'most played Hand'
        return {vars = {_1,(G.GAME and G.GAME.modifiers) and G.GAME.modifiers.opal_trampled_multiplier or "0.5"}}
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
    counterpart = 'bl_manacle',
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
        (context.end_of_round) or
        (context.cardarea == G.discard and context.other_card == card)) then
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
    pos = {x = 0, y = 2},
    counterpart = 'bl_final_bell'
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
    counterpart = 'bl_needle',
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
    counterpart = 'bl_water',
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
    counterpart = 'bl_arm',
    calculate = function(self, card, context)
        if context.after and context.cardarea == G.hand then
            if (G.GAME.chips + G.GAME.opal_strong_score) >= G.GAME.blind.chips then
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
    counterpart = 'bl_flint',
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
    counterpart = 'bl_final_heart',
    calculate = function(self, card, context)
        if context.initial_scoring_step and context.cardarea == G.play then
            card.ability.opal_bleeding.extra.debuffed_joker = pseudorandom_element(G.jokers.cards, pseudoseed('bs_b'))
            if card.ability.opal_bleeding.extra.debuffed_joker then card.ability.opal_bleeding.extra.debuffed_joker:set_debuff(true) end
        end
        if context.end_of_round then
            if card.ability.opal_bleeding.extra.debuffed_joker then card.ability.opal_bleeding.extra.debuffed_joker:set_debuff(false) end
            card.ability.opal_bleeding.extra.debuffed_joker = nil
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
    rarity = 3,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('439a4f'),
    atlas = 'stickerAtlas',
    pos = {x=5, y=0},
    counterpart = 'bl_serpent',
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
    pos = {x=3, y=2},
    counterpart = 'bl_final_acorn',
    calculate = function(self, card, context)
        if context.stay_flipped and context.to_area == G.hand then
            if context.other_card == card then return{stay_flipped = true} end
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
    counterpart = 'bl_psychic',
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
    counterpart = 'bl_house',
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            card.ability.opal_homely.extra.keep_flipped = false
        end
        if context.stay_flipped and context.to_area == G.hand then
            if context.other_card == card and card.ability.opal_homely.extra.keep_flipped then
                return{stay_flipped = true}
            end
        end
        if context.setting_blind then
            card.ability.opal_homely.extra.keep_flipped = true
        end
    end
}

OPAL.BSticker{ -- Envious (Verdant Leaf)
    key = 'envious',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 3,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('56a786'),
    atlas = 'stickerAtlas',
    pos = {x=4, y=2},
    counterpart = 'bl_final_leaf',
    calculate = function(self, card, context)
        if G.jokers and G.jokers.config.card_limit - #G.jokers.cards < 1 then
            card:set_debuff(true)
        end
    end
}

OPAL.BSticker{ -- Hungry (The Mouth)
    key = 'hungry',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('ae718e'),
    atlas = 'stickerAtlas',
    pos = {x=6, y=0},
    config = {extra = {only_hand = false}},
    counterpart = 'bl_mouth',
    loc_vars = function(self, info_queue, card)
        return{vars = {(card and card.ability and card.ability.opal_hungry and card.ability.opal_hungry.extra.only_hand) and localize(card.ability.opal_hungry.extra.only_hand, 'poker_hands') or 'first played Hand'}}
    end,
    calculate = function(self, card, context)
        if context.main_scoring and not card.ability.opal_hungry.extra.only_hand then
            card.ability.opal_hungry.extra.only_hand = context.scoring_name
        end
        if context.modify_scoring_hand and context.other_card == card then
            if not card.ability.opal_hungry.extra.only_hand then return end
            if context.scoring_name == card.ability.opal_hungry.extra.only_hand then return end
            return {remove_from_hand = true}
        end
        if context.end_of_round then
            card.ability.opal_hungry.extra.only_hand = false
        end
    end
}

OPAL.BSticker{ -- Witness (The Eye)
    key = 'witness',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('4b71e4'),
    atlas = 'stickerAtlas',
    pos = {x=6, y=1},
    counterpart = 'bl_eye',
    config = {extra = {played_hands = {}}},
    calculate = function(self, card, context)
        if context.modify_scoring_hand and context.other_card == card then
            local checkHand = false
            for k, v in ipairs(card.ability.opal_witness.extra.played_hands) do
                if v == context.scoring_name then
                    checkHand = true
                end
            end
            if checkHand == true then
                return {remove_from_hand = true}
            end
        end
        if context.end_of_round then
            card.ability.opal_witness.extra.played_hands = {}
        end
        if context.main_scoring then
            local checkHand = false
            for k, v in ipairs(card.ability.opal_witness.extra.played_hands) do
                if v == context.scoring_name then
                    checkHand = true
                end
            end
            if checkHand == false then
                card.ability.opal_witness.extra.played_hands[#card.ability.opal_witness.extra.played_hands+1] = context.scoring_name
            end
        end
    end
}

OPAL.BSticker{ -- Suspicious (The Fish)
    key = 'suspicious',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('94bbda'),
    atlas = 'stickerAtlas',
    pos = {x=6, y=2},
    counterpart = 'bl_fish',
    config = {extra = {flip = false}},
    calculate = function(self, card, context)
        if context.main_scoring then
            card.ability.opal_suspicious.extra.flip = true
        end
        if context.stay_flipped and context.to_area == G.hand then
            if context.other_card == card and card.ability.opal_suspicious.extra.flip then
                return{stay_flipped = true}
            end
        end
        if context.hand_drawn or context.end_of_round then
            card.ability.opal_suspicious.extra.flip = false
        end
    end
}

OPAL.BSticker{ -- Dizzy (The Wheel)
    key = 'dizzy',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('50bf7c'),
    atlas = 'stickerAtlas',
    pos = {x=5, y=2},
    counterpart = 'bl_wheel',
    config = {extra = {odds = 7}},
    loc_vars = function(self, info_queue, card)
        local n, d = 1, 7
        if card then n, d = SMODS.get_probability_vars(card, 1, card.ability.opal_dizzy.extra.odds, 'opal_bsticker_dizzy') end
        return{vars = {n, d}}
    end,
    calculate = function(self, card, context)
        if context.stay_flipped and context.to_area == G.hand then
            if context.other_card == card and SMODS.pseudorandom_probability(card, 'op_dz', 1, card.ability.opal_dizzy.extra.odds, 'opal_bsticker_dizzy') then
                return{stay_flipped = true}
            end
        end
    end
}

OPAL.BSticker{ -- Stained (The Mark)
    key = 'stained',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('6a3847'),
    atlas = 'stickerAtlas',
    pos = {x=7, y=1},
    counterpart = 'bl_mark',
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            for k, v in ipairs(G.hand.cards) do
                if v:is_face(true) then v:flip() end
            end
        end
    end
}

OPAL.BSticker{ -- Brutal (The Club)
    key = 'brutal',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.15,
    needs_enable_flag = true,
    badge_colour = HEX('b9cb92'),
    atlas = 'stickerAtlas',
    pos = {x = 2, y = 3},
    counterpart = 'bl_club'
}

OPAL.BSticker{ -- Backstabbing (The Goad)
    key = 'backstabbing',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.15,
    needs_enable_flag = true,
    badge_colour = HEX('b95c96'),
    atlas = 'stickerAtlas',
    pos = {x = 3, y = 3},
    counterpart = 'bl_goad'
}

OPAL.BSticker{ -- Insular (The Head)
    key = 'insular',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.15,
    needs_enable_flag = true,
    badge_colour = HEX('ac9db4'),
    atlas = 'stickerAtlas',
    pos = {x = 4, y = 3},
    counterpart = 'bl_head'
}

OPAL.BSticker{ -- Pointy (The Window)
    key = 'pointy',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 1,
    rate = 0.15,
    needs_enable_flag = true,
    badge_colour = HEX('a9a295'),
    atlas = 'stickerAtlas',
    pos = {x = 5, y = 3},
    counterpart = 'bl_window'
}

OPAL.BSticker{ -- Tall (The Wall)
    key = 'tall',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.15,
    needs_enable_flag = true,
    badge_colour = HEX('8a59a5'),
    atlas = 'stickerAtlas',
    pos = {x = 6, y = 3},
    counterpart = 'bl_wall',
    config = {extra = {increase = 1.05}},
    loc_vars = function(self, info_queue, card)
        return{vars = {(card and card.ability and card.ability.opal_tall) and card.ability.opal_tall.extra.increase or 1.05}}
    end,
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.play then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            G.GAME.blind.chips = G.GAME.blind.chips * card.ability.opal_tall.extra.increase
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            play_sound('tarot1')
            card:juice_up(1)
            return true end}))
        end
    end
}

OPAL.BSticker{ -- Looming (Violet Vessel)
    key = 'looming',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 3,
    rate = 0.15,
    needs_enable_flag = true,
    badge_colour = HEX('7354e5'),
    atlas = 'stickerAtlas',
    pos = {x = 7, y = 0},
    counterpart = 'bl_final_vessel',
    config = {extra = {increase = 1.2}},
    loc_vars = function(self, info_queue, card)
        return{vars = {card and card.ability and card.ability.opal_looming and card.ability.opal_looming.extra.increase or 1.2}}
    end,
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.play then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            G.GAME.blind.chips = G.GAME.blind.chips * card.ability.opal_looming.extra.increase
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            play_sound('tarot1')
            card:juice_up(1)
            return true end}))
        end
    end
}

OPAL.BSticker{ -- Snappy (The Stinger)
    key = 'snappy',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('8c5d8d'),
    atlas = 'stickerAtlas',
    pos = {x=0, y=3},
    counterpart = 'bl_opal_stinger',
    config = {extra = {odds = 5}},
    loc_vars = function(self, info_queue, card)
        local n, d = 1, 5
        if card then n, d = SMODS.get_probability_vars(card, 1, card.ability.opal_snappy.extra.odds, 'opal_bsticker_snappy') end
        return{vars = {n, d}}
    end,
    calculate = function(self, card, context)
        if context.modify_scoring_hand and context.scoring_name and context.other_card == card then
            if context.other_card == card and SMODS.pseudorandom_probability(card, 'op_sn', 1, card.ability.opal_snappy.extra.odds, 'opal_bsticker_snappy') then
                SMODS.destroy_cards(card, true, true, false)
            end
        end
    end
}

OPAL.BSticker{ -- Overloaded (The Overload)
    key = 'overloaded',
    sets = {
        Joker = false,
        Default = true,
        Enhanced = true
    },
    rarity = 2,
    rate = 0.05,
    needs_enable_flag = true,
    badge_colour = HEX('b43117'),
    atlas = 'stickerAtlas',
    pos = {x=1, y=3},
    counterpart = 'bl_opal_overload',
    config = {extra = {debuffed_modifier = nil}},
    calculate = function(self, card, context)
        if context.initial_scoring_step and context.cardarea == G.play then
            local _mods = {}
            for k, v in ipairs(G.opal_heat_mods.cards) do
                if OPAL.Modifiers['good'][v.config.center.key] and v.ability.opal_md_temp_decrease < v.ability.opal_count then
                    _mods[#_mods+1] = v
                end
            end
            card.ability.opal_overloaded.extra.debuffed_modifier = pseudorandom_element(_mods, pseudoseed('bs_b'))
            if card.ability.opal_overloaded.extra.debuffed_modifier then
                OPAL.depower_modifier(card.ability.opal_overloaded.extra.debuffed_modifier, 1)
            end
        end
        if context.end_of_round then
            if card.ability.opal_overloaded.extra.debuffed_modifier then
                OPAL.power_modifier_up(card.ability.opal_overloaded.extra.debuffed_modifier, 1)
            end
            card.ability.opal_overloaded.extra.debuffed_modifier = nil
        end
    end
}

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

local is_suit_ref = Card.is_suit
function Card:is_suit(suit, bypass_debuff, flush_calc)
    if self.ability.opal_backstabbing and suit == 'Spades' or
    self.ability.opal_brutal and suit == 'Clubs' or
    self.ability.opal_insular and suit == 'Hearts' or 
    self.ability.opal_pointy and suit == 'Diamonds' then
        return false
    end
    return is_suit_ref(self, suit, bypass_debuff, flush_calc)
end


function Card:opal_stickers(max_rarity)
    max_rarity = max_rarity or 3
    for k, v in pairs(OPAL.BStickers) do
        if pseudorandom('opal_bst') < v.rate and v.rarity <= max_rarity then
            self:add_sticker(k, true)
        end
    end
end

function OPAL.get_sticker_from_blind(blind)
    for k, v in pairs(OPAL.BStickers) do
        if v.counterpart == blind then
            return k
        end
    end
    return nil
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

-- exclude BStickers from your collection of stickers
local yc_stickers_ref = create_UIBox_your_collection_stickers
create_UIBox_your_collection_stickers = function(table, bfunc)
    if not table then
        return yc_stickers_ref()
    else
        return SMODS.card_collection_UIBox(table, { 5, 5 }, {
            snap_back = true,
            hide_single_page = true,
            collapse_single_page = true,
            center = 'c_base',
            h_mod = 1.03,
            back_func = bfunc or 'your_collection_stickers',
            modify_card = function(card, center)
                card.ignore_pinned = true
                center:apply(card, true)
            end,
        })
    end
end

function OPAL.stickers_no_b() -- Returns a table of Stickers with no BStickers.
    local result = {}
    for k, v in pairs(SMODS.Stickers) do
        if not OPAL.BStickers[k] and
        not (PB_UTIL and PB_UTIL.is_paperclip(k)) then
            result[k] = v
        end
    end
    return result
end

G.FUNCS.your_collection_stickers = function(e)
    G.SETTINGS.paused = true
    if not G.ACTIVE_MOD_UI or (G.ACTIVE_MOD_UI and modsCollectionTally(OPAL.BStickers).of > 0) then
        G.FUNCS.overlay_menu{
            definition = create_UIBox_your_collection_stickers_types(),
        }
    else
        G.FUNCS.overlay_menu{
            definition = create_UIBox_your_collection_stickers(SMODS.Stickers, 'your_collection_other_gameobjects'),
        }
    end
end

G.FUNCS.your_collection_stickers_normal = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_your_collection_stickers(OPAL.stickers_no_b()),
    }
end

G.FUNCS.your_collection_bstickers = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_your_collection_stickers(OPAL.BStickers),
    }
end

function create_UIBox_your_collection_stickers_types()
    local r = {}
    local new_button = {n = G.UIT.R, config = {colour = G.C.CLEAR, align = 'cl', padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = 'cl'}, nodes = {
            UIBox_button{button = 'your_collection_stickers_normal', label = {localize('b_stickers')}}
        }}
    }}
    table.insert(r,new_button)

    local new_button = {n = G.UIT.R, config = {colour = G.C.CLEAR, align = 'cl', padding = 0.1}, nodes = {
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = 'cl'}, nodes = {
            UIBox_button{button = 'your_collection_bstickers', label = {localize('opal_bstickers')}, colour = OPAL.badge_colour}
        }},
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = 'cm'}, nodes = {
            UIBox_button{button = 'opal_bstickers_info', label = {'?'}, minh = 0.4, minw = 0.4, scale = 0.3}
        }}
    }}
    table.insert(r,new_button)

    local t = create_UIBox_generic_options({ back_func = 'your_collection_other_gameobjects', contents = {
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = 'cm', padding = 0.1}, nodes = r}
    }})
    return t
end

function G.FUNCS.opal_bstickers_info()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_opal_info({back_func = 'your_collection_stickers', set = 'bstickers', small_lines = 9, small_size = 0.25})
    }
end