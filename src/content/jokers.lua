SMODS.Joker{ --Joost
    key = "joost",
    atlas = "jokerAtlas", pos = {x=0,y=0},
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card == context.scoring_hand[#context.scoring_hand] then
                return {
                    message = localize ("k_again_ex"),
                    repetitions = 1,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker{ --Hardlight
    key = "hardlight",
    atlas = "jokerAtlas", pos = {x=0, y=1},
    soul_pos = {x=1, y=1},
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    config = {duplicator = true, extra = { last_dupe = 'None' }},
    calculate = function(self, card, context)
        if context.end_of_round then
            if G.GAME.opal_dupes > 0 then
                for k, v in ipairs(G.jokers.cards) do
                    if v.ability.dupe then
                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.joker_buffer = 0
                            v:start_dissolve()
                            return true end }))
                        G.GAME.opal_dupes = G.GAME.opal_dupes - 1
                    end
                end
            end
        end
        if context.setting_blind then
            local can_duplicate = {} --these cards can be duplicated!!!
            for k, v in ipairs(G.jokers.cards) do
                if not (v.ability.duplicator or v.ability.dupe or ((SMODS.Mods.ChDp or {}).can_load and v.ability.chdp_singular)) then
                    can_duplicate[#can_duplicate+1] = v
                end
            end
            if #can_duplicate > 0 then
                G.GAME.opal_dupes = G.GAME.opal_dupes + 1 
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        local chosen = pseudorandom_element(can_duplicate, pseudoseed("opal_hardlight"))
                        local chosenName = chosen.ability.name
                        if string.find(chosenName, "j_") then
                            chosenName = localize{type = 'name_text', set = 'Joker', key = chosenName}
                        end
                        card.ability.extra.last_dupe = chosenName
                        local addcard = copy_card(chosen, nil, nil, nil, chosen.edition and chosen.edition.negative)
                        addcard:add_to_deck()
                        G.jokers:emplace(addcard)
                        addcard.ability.dupe = true
                        addcard:set_edition{negative = true}
                        addcard:set_eternal(false)
                        addcard:start_materialize()
                        addcard.sell_cost = 0
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Bamboozled!', colour = G.C.CHIPS})
            end
        end
    end
}

SMODS.Joker { --Shiny Rock
    key = 'shiny_rock',
    config = { extra = {odds = 20}},
    rarity = 2,
    atlas = 'jokerAtlas',
    pos = {x = 1, y = 0},
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'opal_sr1')
        return { vars = {numerator, denominator}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play then
            local chosencard = context.other_card
            if chosencard and not chosencard.edition and not chosencard.being_opaled and SMODS.pseudorandom_probability(card, 'opal_sr2', 1, card.ability.extra.odds) then
                chosencard.being_opaled = true
                G.E_MANAGER:add_event(Event({func = function()
                    local edition = poll_edition("opal", nil, true, true)
                    chosencard:set_edition(edition, true)
                return true end }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Edition!', colour = G.C.TAROT})
            end
        end
    end
  }

SMODS.Joker {--Kimochi Warui
    key = 'kimochi_warui',
    config = {extra = {odds = 3}},
    rarity = 1,
    atlas = "jokerAtlas",
    pos = {x = 2, y = 1},
    cost = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'opal_kw1')
        return { vars = { numerator, denominator }}
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local stickersIn = {}
            local stickersOut = {}
            local specialVal, specialCase = nil, nil
            for k, v in pairs(SMODS.Stickers) do
                if v.sets.Joker then -- do not remove sigma
                    if k ~= 'akyrs_sigma' then
                        stickersIn[#stickersIn+1] = k
                    end
                end
                if v.sets.Default and not string.find(k, '_clip') then -- no clips
                    stickersOut[#stickersOut+1] = k
                    if k == 'akyrs_oxidising' then
                        specialVal = pseudorandom_element({1,2,3}, pseudoseed('kimochi_akyrs'))
                        specialCase = k
                    end
                end
            end
            G.E_MANAGER:add_event(Event({ trigger = "after", func = function()
                local stickersFound = {}
                for k, v in ipairs(G.jokers.cards) do
                    for k2, v2 in ipairs(stickersIn) do
                        if v.ability[v2] then
                            stickersFound[#stickersFound+1] = {joker = v, sticker = v2}
                        end
                    end
                end
                if #stickersFound > 0 then
                    jokerToUnstick = pseudorandom_element(stickersFound, pseudoseed("kimochi_unstick"))
                    stickerToRemove = jokerToUnstick.sticker
                    jokerToUnstick = jokerToUnstick.joker
                    jokerToUnstick.ability[stickerToRemove] = false
                    card:juice_up(0.8)
                    jokerToUnstick:juice_up(0.8)
                    if SMODS.pseudorandom_probability(card, 'opal_kw2', 1, card.ability.extra.odds) then
                        cardToStick = pseudorandom_element(G.hand.cards, pseudoseed("kimochi_stick_1"))
                        stickerToGive = pseudorandom_element(stickersOut, pseudoseed("kimochi_stick_2"))
                        if specialCase then
                            cardToStick.ability[stickerToGive] = specialVal
                            if specialCase == 'akyrs_oxidising' then
                                cardToStick.ability.akyrs_oxidising_round = 2
                            end
                        else
                            cardToStick.ability[stickerToGive] = true
                        end
                        cardToStick:juice_up(0.8)
                    end
                end
            return true end }))
        end
    end
}

SMODS.Joker {--Holy, Holy
    key = 'holy_holy',
    config = {extra = {count = 0, chip_mod = 20, mult_mod = 5}},
    rarity = 1,
    atlas = "jokerAtlas",
    pos = {x = 3, y = 1},
    cost = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "c_magician", set = "Tarot", vars = {2,'Lucky Card'}}
        return { vars = {card.ability.extra.chip_mod, card.ability.extra.mult_mod, card.ability.extra.count*card.ability.extra.chip_mod, card.ability.extra.count*card.ability.extra.mult_mod}}
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.name == "The Magician" then
            card.ability.extra.count = card.ability.extra.count + to_big(1)
            return {
                message = "Holy, Holy!"
            }
        end
        if context.joker_main and to_big(card.ability.extra.count) > to_big(0) then
            return {
                chip_mod = card.ability.extra.count*card.ability.extra.chip_mod,
                mult_mod = card.ability.extra.count*card.ability.extra.mult_mod,
                message = "+"..card.ability.extra.count*card.ability.extra.chip_mod.." Chips, +"..card.ability.extra.count*card.ability.extra.mult_mod.." Mult"
            }
        end
    end
}

SMODS.Joker { --Oops! All 1/3s
    key = 'potluck',
    config = {extra = {prob_mod = 1/3}},
    rarity = 1,
    atlas = "jokerAtlas",
    pos = {x = 4, y = 1},
    cost = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.prob_mod}}
    end,
    calculate = function(self, card, context)
        if context.mod_probability then
            return {
                numerator = context.numerator + card.ability.extra.prob_mod
            }
        end
    end,
}

SMODS.Joker { -- Cultist
    key = 'cultist',
    rarity = 2,
    atlas = "jokerAtlas",
    pos = {x = 3, y = 4},
    cost = 7,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.open_booster and context.card.ability.name:find('Arcana') then
            G.E_MANAGER:add_event(Event({ trigger = "after", func = function()
                extra_card = create_card("Spectral", G.pack_cards, nil, nil, true, true, nil, 'cultist')
                extra_card:start_materialize()
                G.pack_cards:emplace(extra_card)
            return true end }))
        end
    end
}

SMODS.Joker { --Rolodex
    key = 'rolodex',
    config = {extra = {rerolls_required = 3, rerolls_left = 3, handsize_mod = 0}},
    rarity = 1,
    atlas = "jokerAtlas",
    pos = {x = 3, y = 4},
    cost = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.rerolls_required, card.ability.extra.rerolls_left, card.ability.extra.handsize_mod}}
    end,
    calculate = function(self, card, context)
        if context.reroll_shop then
            if card.ability.extra.rerolls_left > 1 then
                card.ability.extra.rerolls_left = card.ability.extra.rerolls_left - 1
            else
                card.ability.extra.rerolls_left = card.ability.extra.rerolls_required
                card.ability.extra.handsize_mod = card.ability.extra.handsize_mod + 1
                G.hand:change_size(1)
                return{
                    message = localize('k_upgrade_ex')
                }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss then
            card.ability.extra.rerolls_left = card.ability.extra.rerolls_required
            G.hand:change_size(-card.ability.extra.handsize_mod)
            card.ability.extra.handsize_mod = 0
            return{
                message = localize('k_reset'),
                color = G.C.RED
            }
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.hand:change_size(-card.ability.extra.handsize_mod)
    end,
    add_to_deck = function(self, card, from_debuff)
        G.hand:change_size(card.ability.extra.handsize_mod)
    end
}

SMODS.Joker { --Corkboard
    key = 'corkboard',
    config = {extra = 1.5},
    rarity = 2,
    atlas = "jokerAtlas",
    pos = {x = 1, y = 2},
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra}}
    end,
    add_to_deck = function(self, card, from_debuff)
    end,
    remove_from_deck = function(self, card, from_debuff)
    end,
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker ~= card then
            local other_joker_has_sticker = false
            for k, v in pairs(SMODS.Stickers) do
                 if context.other_joker.ability[k] and context.other_joker.ability[k] == true then
                    other_joker_has_sticker = true
                 end
            end
            if (context.other_joker.pinned or other_joker_has_sticker) then
                G.E_MANAGER:add_event(Event({func = function()
                    context.other_joker:juice_up(0.5, 0.5)
                    return true end}))
                return {
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra}},
                    Xmult_mod = card.ability.extra
                }
            end
        end
    end
}

SMODS.Joker { -- Grandma
    key = 'grandma',
    config = {extra = {mult = 4, count = 0}},
    rarity = 1,
    atlas = "jokerAtlas",
    pos = {x = 3, y = 4},
    cost = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_opal_cookie
        return { vars = {card.ability.extra.mult, localize{type = 'name_text', set = 'Enhanced', key = 'm_opal_cookie'}, card.ability.extra.mult*card.ability.extra.count}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.cookie_trigger then
            card.ability.extra.count = card.ability.extra.count + 1
            return{
                message = localize('k_upgrade_ex'),
                card = card
            }
        end
        if context.joker_main and to_big(card.ability.extra.count) > to_big(0) then
            return {
                mult_mod = card.ability.extra.count*card.ability.extra.mult,
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.count*card.ability.extra.mult}}
            }
        end
    end
}

--[[SMODS.Joker { --
    key = 'a',
    config = {extra = {prob_mod = 30/3}},
    rarity = 1,
    atlas = "jokerAtlas",
    pos = {x = 3, y = 4},
    cost = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.prob_mod}}
    end,
    add_to_deck = function(self, card, from_debuff)
    end,
    remove_from_deck = function(self, card, from_debuff)
    end,
    calculate = function(self, card, context)
    end
}]]


-- LEGENDARIES


--[[SMODS.Joker {--uhh... i'd like to buy a vowel please
    key = 'opal',
    config = { extra = {}},
    rarity = 4,
    atlas = 'jokerAtlas',
    pos = { x = 0, y = 4},
    soul_pos = {x=1, y=4},
    cost = 20,
    blueprint_compat = true
}]]


-- ANNOYING SUIT JOKERS


SMODS.Joker { --Intrusive Joker
    key = 'intrusive',
    config = { extra = { Xmult = 2 }},
    rarity = 3,
    atlas = 'jokerAtlas',
    pos = { x = 2, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
            for k, v in ipairs(G.playing_cards) do
                if v:is_suit('Diamonds') then
                    v.debuff = true
                end
            end
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
}
  
SMODS.Joker { --Egocentric Joker
    key = 'egocentric',
    config = { extra = { Xmult = 2 }},
    rarity = 3,
    atlas = 'jokerAtlas',
    pos = { x = 3, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
        for k, v in ipairs(G.playing_cards) do
            if v:is_suit('Hearts') then
                v.debuff = true
            end
        end
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
}
  
SMODS.Joker {--Irritating Joker
    key = 'irritating',
    config = { extra = { Xmult = 2 }},
    rarity = 3,
    atlas = 'jokerAtlas',
    pos = { x = 4, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
        for k, v in ipairs(G.playing_cards) do
            if v:is_suit('Spades') then
                v.debuff = true
            end
        end
        end
        if context.joker_main then
            return {
                Xmult_mod = card.ability.extra.Xmult,
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
}
  
SMODS.Joker {--Wreckless Joker
    key = 'wreckless',
    config = { extra = { Xmult = 2 }},
    rarity = 3,
    atlas = 'jokerAtlas',
    pos = { x = 5, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
            for k, v in ipairs(G.playing_cards) do
                if v:is_suit('Clubs') then
                    v.debuff = true
                end
            end
        end
        if context.joker_main then
            return {
            Xmult_mod = card.ability.extra.Xmult,
            message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
}


local MintyCheck = SMODS.Mods['MintysSillyMod']
if (MintyCheck or {}).can_load then
    SMODS.Joker {--Indulgent Joker
    key = 'indulgent',
    config = { extra = { Xmult = 1.5 }},
    rarity = 3,
    atlas = 'crossJokerAtlas',
    pos = { x = 0, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult }}
    end,
    in_pool = function(self, args)
        return MINTY.threeSuit_in_pool()
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge("Minty's Mod", HEX('CA7CA7'), HEX('FFFFFF'), 0.8)
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
        for k, v in ipairs(G.playing_cards) do
            if v:is_3() then
                v.debuff = true
            end
        end
        end
        if context.joker_main then
            return {
            Xmult_mod = card.ability.extra.Xmult,
            message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
    }
end

local BUNCO = SMODS.Mods['Bunco']
if (BUNCO or {}).can_load then
    SMODS.Joker {--Emulous Joker
    key = 'emulous',
    config = { extra = { Xmult = 1.5 }},
    rarity = 3,
    atlas = 'crossJokerAtlas',
    pos = { x = 1, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult }}
    end,
    in_pool = function(self, args)
        if G.GAME and G.GAME.Exotic then
            return true
        else
            return false
        end
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge("Bunco", HEX('666665'), HEX('FFFFFF'), 0.8)
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
        for k, v in ipairs(G.playing_cards) do
            if v:is_suit("bunc_Fleurons") then
                v.debuff = true
            end
        end
        end
        if context.joker_main then
            return {
            Xmult_mod = card.ability.extra.Xmult,
            message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
    }
    SMODS.Joker {--Flamboyant Joker
    key = 'flamboyant',
    config = { extra = { Xmult = 1.5 }},
    rarity = 3,
    atlas = 'crossJokerAtlas',
    pos = { x = 2, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult }}
    end,
    in_pool = function(self, args)
        if G.GAME and G.GAME.Exotic then
            return true
        else
            return false
        end
    end,
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge("Bunco", HEX('666665'), HEX('FFFFFF'), 0.8)
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
        for k, v in ipairs(G.playing_cards) do
            if v:is_suit("bunc_Halberds") then
                v.debuff = true
            end
        end
        end
        if context.joker_main then
            return {
            Xmult_mod = card.ability.extra.Xmult,
            message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
    }
end

local PAPERBACK = SMODS.Mods['paperback']
if (PAPERBACK or {}).can_load then
    SMODS.Joker {-- Dissident Joker
    key = 'dissident',
    config = { extra = { Xmult = 1.5 }},
    rarity = 3,
    atlas = 'crossJokerAtlas',
    pos = { x = 3, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult }}
    end,
    paperback = {
        requires_stars = true,
    },
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge("Paperback", HEX('8B61AD'), HEX('FFFFFF'), 0.8)
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
        for k, v in ipairs(G.playing_cards) do
            if v:is_suit("paperback_Stars") then
                v.debuff = true
            end
        end
        end
        if context.joker_main then
            return {
            Xmult_mod = card.ability.extra.Xmult,
            message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
    }
    SMODS.Joker {-- Deceptive Joker
    key = 'deceptive',
    config = { extra = { Xmult = 1.5 }},
    rarity = 3,
    atlas = 'crossJokerAtlas',
    pos = { x = 4, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult }}
    end,
    paperback = {
        requires_crowns = true,
    },
    set_badges = function(self, card, badges)
        badges[#badges+1] = create_badge("Paperback", HEX('8B61AD'), HEX('FFFFFF'), 0.8)
    end,
    calculate = function(self, card, context)
        if not context.check_enhancement then
        for k, v in ipairs(G.playing_cards) do
            if v:is_suit("paperback_Crowns") then
                v.debuff = true
            end
        end
        end
        if context.joker_main then
            return {
            Xmult_mod = card.ability.extra.Xmult,
            message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
            }
        end
    end
    }
end