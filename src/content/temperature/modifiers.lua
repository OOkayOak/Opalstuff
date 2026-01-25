OPAL.Modifiers = {
    ['all'] = {},
    ['good'] = {}, -- Good modifiers come from levelling up.
    ['bad'] = {}, -- Bad modifiers come from the Stake of Hyperdeath.
    ['informational'] = {} -- Informational modifiers are given when the run begins, i.e. in Challenge runs with certain rules.
}
OPAL.Modifier = SMODS.Center:extend{
    class_prefix = 'md',
    set = 'OpalModifier',
    unlocked = true,
    available = true,
    atlas = 'opal_modifierAtlas',
    pos = {x = 0, y = 0},
    display_size = OPAL.config.modifier_size == 2 and {w = 29, h = 30} or {w = 22, h = 23},
    config = {},
    opal_alignment = 'good',
    required_params = {'key'},
    pre_inject_class = function(self)
        G.P_CENTER_POOLS[self.set..'_good'] = {}
        G.P_CENTER_POOLS[self.set..'_bad'] = {}
    end,
    inject = function(self)
        if self.opal_alignment == 'informational' then self.display_size = {w = 22, h = 23} end
        if (self.opal_alignment ~= 'good' and self.opal_alignment ~= 'bad') then self.omit = true end
        if self.opal_alignment ~= 'excl' then OPAL.Modifiers[self.opal_alignment][self.key] = self end
        OPAL.Modifiers['all'][self.key] = self
        self.order = #OPAL.Modifiers['all']
        self.atlas = (G.opal_mod_shape == 1 or self.opal_alignment == 'informational') and self.atlas or self.atlas.."_square"
        G.P_CENTERS[self.key] = self
        if not self.omit then SMODS.insert_pool(G.P_CENTER_POOLS[self.set..'_'..self.opal_alignment], self) end
        for k, v in pairs(SMODS.ObjectTypes) do
            if ((self.pools and self.pools[k]) or (v.cards and v.cards[self.key])) then
                v:inject_card(self)
            end
        end
    end,
    get_obj = function(self, key)
        if key == nil then
            return nil
        end
        return self.obj_table[key] or SMODS.Center:get_obj(key)
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        if card and card.ability and card.ability.opal_md_temp_decrease and card.ability.opal_md_temp_decrease ~= 0 then info_queue[#info_queue+1] = {key = 'md_opal_temp_decrease', set = 'OpalModifier', vars = {card.ability.opal_md_temp_decrease}} end
        return SMODS.Center.generate_ui(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    end,
    set_card_type_badge = function(self, card, badges)
        if self.opal_alignment == 'informational' then
            badges[#badges+1] = create_badge(localize("k_opalindicator"), G.C.FILTER, G.C.WHITE)
        else
            local colour = OPAL.C.MODIFIER
            badges[#badges+1] = create_badge(localize("k_opalmodifier"), colour, G.C.WHITE)
        end
    end,
    in_pool = function(self, args)
        local duplicates = true
        if G.pack_cards and G.opal_booster_mods and G.opal_booster_mods[self.key] then duplicates = false end
        return true, {allow_duplicates = duplicates}
    end,
}

SMODS.DrawStep{ -- Counter to appear on modifiers
    key = 'opal_modifier_counter',
    order = 30,
    func = function(self)
        if self.children.opal_md_counter then self.children.opal_md_counter:draw() end
    end
}

SMODS.DrawStep{ -- Raiser Stake sprite
    key = 'opal_raiser_sprite',
    order = 29,
    func = function(self)
        if self.children.opal_raiser_sprite then self.children.opal_raiser_sprite:draw() end
    end
}

--[[local card_draw = Card.draw
function Card:draw(layer)
    if OPAL.config.modifier_count == 1 and self.ability.set == 'OpalModifier' and not self.children.opal_md_counter and not (self.config.center.opal_alignment == 'informational')
    and self.ability.opal_count > 1 then
        self.children.opal_md_counter = UIBox{
            definition = {n = G.UIT.R, config = {colour = G.C.BLACK, align = "cm", padding = 0.05, r = 0.1}, nodes = {
                {n=G.UIT.T, config = {text = tostring(self.ability.opal_count), scale = 0.3, colour = G.C.WHITE}}
            }},
            config = {align = "br", offset = {x=-0.3, y=-0.35}, parent = self}
        }
    end
    return card_draw(self, layer)
end]]

local card_hover = Card.hover
function Card:hover()
    if OPAL.config.modifier_count == 2 and self.ability.set == 'OpalModifier' and not self.children.opal_md_counter and not (self.config.center.opal_alignment == 'informational') then
        self.children.opal_md_counter = UIBox{
            definition = {n = G.UIT.R, config = {colour = G.C.BLACK, align = "cm", padding = 0.05, r = 0.1}, nodes = {
                {n=G.UIT.T, config = {text = tostring(self.ability.opal_count), scale = 0.3, colour = G.C.WHITE}}
            }},
            config = {align = "br", offset = {x=-0.3, y=-0.35}, parent = self}
        }
    end
    return card_hover(self)
end

local card_stop_hover = Card.stop_hover
function Card:stop_hover()
    if OPAL.config.modifier_count == 2 and self.ability.set == 'OpalModifier' and self.children.opal_md_counter then
        self.children.opal_md_counter:remove()
        self.children.opal_md_counter = nil
    end
    return card_stop_hover(self)
end

--[[function SMODS.current_mod.process_loc_text()
    -- will crash the game if removed (aye aye captain)
    G.localization.descriptions.OpalModifier = G.localization.descriptions.OpalModifier or {}
end]]

function OPAL.Modifier:calculate(card, context)
end

function OPAL.Modifier:apply(card)
end

function OPAL.Modifier:unapply(card)
end

OPAL.Modifier{ -- Recycler
    key = "recycler",
    name = 'Recycler',
    atlas = 'modifierAtlas',
    pools = {
        GoodModifiers = true
    },
    pos = {x = 0, y = 0},
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra}}
    end,
    apply = function(self, card)
        G.GAME.modifiers.money_per_discard = G.GAME.modifiers.money_per_discard or 0
        G.GAME.modifiers.money_per_discard = G.GAME.modifiers.money_per_discard + card.ability.extra
    end,
    unapply = function(self, card)
        G.GAME.modifiers.money_per_discard = G.GAME.modifiers.money_per_discard - card.ability.extra
        if G.GAME.modifiers.money_per_discard == 0 then G.GAME.modifiers.money_per_discard = nil end
    end,
    merge = function(self, card, count)
        card.ability.extra = card.ability.extra + count
        G.GAME.modifiers.money_per_discard = G.GAME.modifiers.money_per_discard + count
    end
}

OPAL.Modifier{ -- Handheld
    key = "handheld",
    name = 'Handheld',
    atlas = 'modifierAtlas',
    pools = {
        GoodModifiers = true
    },
    pos = {x = 1, y = 0},
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra}}
    end,
    apply = function(self, card)
        G.GAME.modifiers.money_per_hand = G.GAME.modifiers.money_per_hand or 1
        G.GAME.modifiers.money_per_hand = G.GAME.modifiers.money_per_hand + card.ability.extra
    end,
    unapply = function(self, card)
        G.GAME.modifiers.money_per_hand = G.GAME.modifiers.money_per_hand - card.ability.extra
    end,
    merge = function(self, card, count)
        card.ability.extra = card.ability.extra + count
        G.GAME.modifiers.money_per_hand = G.GAME.modifiers.money_per_hand + count
    end
}

OPAL.Modifier{ -- Hilarious
    key = "hilarious",
    name = 'Hilarious',
    atlas = 'modifierAtlas',
    pools = {
        GoodModifiers = true
    },
    pos = {x = 2, y = 0},
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra}, key = (card.ability.extra > 1 or card.ability.extra < -1) and self.key..'_plural' or self.key}
    end,
    apply = function(self, card)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra
    end,
    unapply = function(self, card)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra
    end,
    merge = function(self, card, count)
        card.ability.extra = card.ability.extra + count
        G.jokers.config.card_limit = G.jokers.config.card_limit + count
    end
}

OPAL.Modifier{ -- Astronomy
    key = "astronomy",
    name = 'Astronomy',
    atlas = 'modifierAtlas',
    pools = {
        GoodModifiers = true
    },
    pos = {x = 3, y = 0},
    config = {extra = {levels = 1, hands = 3, hands_left = 3}},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.hands, card.ability.extra.hands_left, card.ability.extra.levels}, key = card.ability.extra.levels > 1 and self.key.."_plural" or self.key}
    end,
    calculate = function(self, card, context)
        if  context.before and context.cardarea == G.opal_heat_mods then
            card.ability.extra.hands_left = card.ability.extra.hands_left - 1
            if card.ability.extra.hands_left == 0 then
                card.ability.extra.hands_left = card.ability.extra.hands
                return {
                    card = card,
                    level_up = card.ability.extra.levels,
                    message = localize('k_level_up_ex')
                }
            else
                return {
                    card = card,
                    message = localize{type='variable',key='loyalty_inactive',vars={card.ability.extra.hands_left}}
                }
            end
        end
    end,
    can_apply = function(self)
        OPAL.existing_modifiers = OPAL.existing_modifiers or {}
        return not(OPAL.existing_modifiers['md_opal_astronomy'])
    end,
    in_pool = function(self, args)
        OPAL.existing_modifiers = OPAL.existing_modifiers or {}
        return not(OPAL.existing_modifiers['md_opal_astronomy'])
    end
}

OPAL.Modifier{ -- Running Yolk
    key = "running_yolk",
    name = 'Running Yolk',
    atlas = 'modifierAtlas',
    pos = {x = 4, y = 0},
    config = {extra = {increase = 1}},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.increase}}
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false then
            local _joker = pseudorandom_element(G.jokers.cards, pseudoseed('opal_running_yolk'))
            _joker.ability.extra_value = _joker.ability.extra_value + card.ability.extra.increase
            _joker:set_cost()
            return {
                message = localize('k_val_up'),
                colour = G.C.MONEY,
                card = _joker
            }
        end
    end,
    merge = function(self, card, count)
        card.ability.extra.increase = card.ability.extra.increase + count
    end
}

OPAL.Modifier{ -- Rigged
    key = "rigged",
    name = 'Rigged',
    atlas = 'modifierAtlas',
    pos = {x = 3, y = 1},
    config = {extra = {prob_mod = 1.25}},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.prob_mod}}
    end,
    calculate = function(self, card, context)
        if context.mod_probability then
            return {
                numerator = context.numerator * card.ability.extra.prob_mod
            }
        end
    end,
    merge = function(self, card, count)
        card.ability.extra.prob_mod = card.ability.extra.prob_mod * (1.25^count)
    end
}

--[[
OPAL.Modifier{ -- Experimental (does random shit)
    key = "experimental",
    name = 'Experimental',
    atlas = 'modifierAtlas',
    pos = {x = 0, y = 0},
    config = {extra = 1},
    calculate = function(self, card, context)
        if context.individual and context.full_hand and context.cardarea == G.play and not context.other_card.opal_experimental_used then

            local change_card = context.other_card -- function violently ripped from Strength tarot
            context.other_card.opal_experimental_used = true
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() change_card:flip();play_sound('card1', percent);change_card:juice_up(0.3, 0.3);return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                    local card = change_card
                    local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                    local possible_changes = {card.base.id+1, card.base.id-1}
                    local rank_suffix = pseudorandom_element(possible_changes, pseudoseed('opx'))
                    if rank_suffix == 15 then rank_suffix = 2; elseif rank_suffix == 1 then rank_suffix = 14 end
                    if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                    elseif rank_suffix == 10 then rank_suffix = 'T'
                    elseif rank_suffix == 11 then rank_suffix = 'J'
                    elseif rank_suffix == 12 then rank_suffix = 'Q'
                    elseif rank_suffix == 13 then rank_suffix = 'K'
                    elseif rank_suffix == 14 then rank_suffix = 'A'
                    end
                    card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() change_card:flip();play_sound('card1', percent);change_card:juice_up(0.3, 0.3);return true end }))
        end
        if context.individual and context.end_of_round and context.other_card.opal_experimental_used then
            context.other_card.opal_experimental_used = false
        end
    end
}]]

-- Bad Modifiers
OPAL.Modifier{ -- Sticky
    key = "sticky",
    name = 'Sticky',
    atlas = 'modifierAtlas',
    opal_alignment = 'bad',
    opal_requires = 'sticker',
    pos = {x = 0, y = 1},
    config = {extra = {sticker = nil}},
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.sticker then info_queue[#info_queue+1] = {key = card.ability.extra.sticker, set = "Other", vars = {}} end
        return{vars = {card.ability.extra.sticker and localize(card.ability.extra.sticker, 'labels') or 'A Random Sticker'}}
    end,
    in_pool = function(self)
         local possibleStickers = {}
        for k, v in pairs(SMODS.Stickers) do
            if not (G.GAME.modifiers['enable_'..k] or G.GAME.modifiers['enable_'..k..'s_in_shop']) and not (k == 'pinned') and not v.opal_good then
                possibleStickers[#possibleStickers+1] = k
            end
        end
        return #possibleStickers > 0, {allow_duplicates = true}
    end,
    pre_apply = function(self, card)
        local possibleStickers = {}
        for k, v in pairs(SMODS.Stickers) do
            if not (G.GAME.modifiers['enable_'..k] or G.GAME.modifiers['enable_'..k..'s_in_shop'] or v.opal_good or k == 'pinned') then
                possibleStickers[#possibleStickers+1] = k
            end
        end
        card.ability.extra.sticker = pseudorandom_element(possibleStickers)
    end,
    apply = function(self, card)
        if SMODS.Stickers[card.ability.extra.sticker].rarity then OPAL.BStickers[card.ability.extra.sticker]:get_bsticker_rate(5) end
        if card.ability.extra.sticker == 'eternal' or card.ability.extra.sticker == 'perishable' or card.ability.extra.sticker == 'rental' then 
            G.GAME.modifiers['enable_'..card.ability.extra.sticker..'s_in_shop'] = true
        else
            G.GAME.modifiers['enable_'..card.ability.extra.sticker] = true
        end
    end,
    unapply = function(self, card)
        if card.ability.extra.sticker == 'eternal' or card.ability.extra.sticker == 'perishable' or card.ability.extra.sticker == 'rental' then 
            G.GAME.modifiers['enable_'..card.ability.extra.sticker..'s_in_shop'] = false
        else
            G.GAME.modifiers['enable_'..card.ability.extra.sticker] = false
        end
        card.ability.extra.sticker = nil
    end
}

OPAL.Modifier{ -- Skipless
    key = "skipless",
    name = 'Skipless',
    atlas = 'modifierAtlas',
    opal_alignment = 'bad',
    opal_requires = 'no_dupes',
    pos = {x = 1, y = 1},
    config = {extra = {ante = nil}},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.ante and 'Ante '..card.ability.extra.ante or '2 Antes later'}}
    end,
    apply = function(self, card)
        card.ability.extra.ante = G.GAME.round_resets.ante + 2
        G.GAME.modifiers.opal_disable_skipping = true
    end,
    unapply = function(self, card)
        G.GAME.modifiers.opal_disable_skipping = false
    end,
    in_pool = function(self)
        return not(G.GAME.modifiers.opal_disable_skipping), {allow_duplicates = false}
    end,
    calculate = function(self, card, context)
        if context.ante_change and G.GAME.round_resets.ante >= card.ability.extra.ante then
            OPAL.remove_modifier(card)
        end
    end
}

OPAL.Modifier{ -- Raiser
    key = "raiser",
    name = 'Raiser',
    atlas = 'modifierAtlas',
    opal_alignment = 'bad',
    opal_requires = 'unapplied_stake',
    pos = {x = 2, y = 1},
    config = {extra = {stake = nil}},
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.stake and not G.localization.descriptions.Other[card.ability.extra.stake] then
            G.localization.descriptions.Other[card.ability.extra.stake] = G.localization.descriptions.Stake[card.ability.extra.stake]
        end
        if card.ability.extra.stake then info_queue[#info_queue+1] = {key = G.P_STAKES[card.ability.extra.stake].key, set = 'Other', vars = {1}}  end
        return{vars = {card.ability.extra.stake and G.localization.descriptions.Stake[card.ability.extra.stake].name or 'A Random Stake'}}
    end,
    in_pool = function(self)
        return #G.P_CENTER_POOLS['Stake'] > #G.GAME.applied_stakes, {allow_duplicates = true}
    end,
    pre_apply = function(self, card)
        local possibleStakes = {}
        for k, v in pairs(G.P_STAKES) do
            local stakeApplied = false
            for k2, v2 in ipairs(G.GAME.applied_stakes) do
                if v2 == v.order then stakeApplied = true end
            end
            if not stakeApplied then
                possibleStakes[#possibleStakes+1] = k
            end
        end

        card.ability.extra.stake = pseudorandom_element(possibleStakes, pseudoseed('opal_raiser'))
            local _size = G.opal_mod_size == 1 and 0.4 or 0.6
            card.children.opal_raiser_sprite = UIBox{
                definition = {n = G.UIT.R, config = {colour = G.C.CLEAR, align = "cm", padding = 0, r = 0}, nodes = {
                    {n = G.UIT.O, config = {object = Sprite(card.T.x, card.T.y, _size, _size, G.ASSET_ATLAS[G.P_STAKES[card.ability.extra.stake].atlas], G.P_STAKES[card.ability.extra.stake].pos)}},
                }},
                config = {align = "cm", offset = {x=0, y=0}, parent = card}
            }
    end,
    apply = function(self, card)

        if card.ability.extra.stake then
            if G.P_STAKES[card.ability.extra.stake].order then table.insert(G.GAME.applied_stakes, G.P_STAKES[card.ability.extra.stake].order) end
            if G.P_STAKES[card.ability.extra.stake].modifiers then
                OPAL.raiser_update_game(card)
            end
        else
            OPAL.remove_modifier(card)
        end
    end,
    calculate = function(self, card, context)
        if card.ability.extra.stake and G.P_STAKES[card.ability.extra.stake].calculate and context then
            G.P_STAKES[card.ability.extra.stake]:calculate(context)
        end
    end
}

OPAL.raiser_param_table = { -- Table to tell raiser_update_game what to target.
    -- If for some reason you want to add to this:
    -- param_key - the key in starting_params to look for.
    -- target_table - the table in G.GAME to look for target_key in. Leave blank to just use G.GAME
    -- target_key - the key to look in G.GAME[target_table] (or G.GAME) for.
    -- type - for special cases (i.e. cardarea size)
    {param_key = 'discards', target_table = 'round_resets', target_key = 'discards'},
    {param_key = 'hands', target_table = 'round_resets', target_key = 'hands'},
    {param_key = 'reroll_cost', target_table = 'round_resets', target_key = 'reroll_cost'},
    {param_key = 'hand_size', type = 'cardarea_size', target_key = 'hand'},
    {param_key = 'joker_slots', type = 'cardarea_size', target_key = 'jokers'},
    {param_key = 'consumable_slots', type = 'cardarea_size', target_key = 'consumeables'},
    {param_key = 'boosters_in_shop', type = 'starting_params'},
    {param_key = 'vouchers_in_shop', type = 'starting_params'},
    {param_key = 'ante_scaling', type = 'starting_params_mult'},
    {param_key = 'play_limit', type = 'hlimit_play'},
    {param_key = 'discard_limit', type = 'hlimit_discard'},
}

function OPAL.raiser_update_game(card) -- update stuff when a Stake is added
    G.E_MANAGER:add_event(Event({trigger = 'after',func = function()
        local storeStuff = { starting_params = G.GAME.starting_params }
        G.GAME.starting_params = {}
        for k, v in pairs(storeStuff.starting_params) do
            if type(v) == "boolean" then
                G.GAME.starting_params[k] = false
            elseif type(v) == "string" then
                G.GAME.starting_params[k] = ""
            elseif type(v) == "number" then
                G.GAME.starting_params[k] = 0
                if k == 'ante_scaling' then G.GAME.starting_params[k] = 1 end
            else
                G.GAME.starting_params[k] = nil
            end
        end
        G.P_STAKES[card.ability.extra.stake].modifiers()
        storeStuff.starting_paramsNew = G.GAME.starting_params
        G.GAME.starting_params = storeStuff.starting_params
        local sparams_change = storeStuff.starting_paramsNew

        for k, v in ipairs(OPAL.raiser_param_table) do
            if v.type == 'cardarea_size' then
                G[v.target_key].config.card_limit = G[v.target_key].config.card_limit + sparams_change[v.param_key]
            elseif v.type =='starting_params' then
                G.GAME.starting_params[v.param_key] = G.GAME.starting_params[v.param_key] + sparams_change[v.param_key]
            elseif v.type =='starting_params_mult' then
                G.GAME.starting_params[v.param_key] = G.GAME.starting_params[v.param_key] * sparams_change[v.param_key]
            elseif v.type == 'hlimit_play' then
                SMODS.change_play_limit(sparams_change[v.param_key])
                elseif v.type == 'hlimit_discard' then
                SMODS.change_discard_limit(sparams_change[v.param_key])
            elseif sparams_change[v.param_key] then
                if v.target_table and G.GAME[v.target_table] and G.GAME[v.target_table][v.target_key] then
                    G.GAME[v.target_table][v.target_key] = G.GAME[v.target_table][v.target_key] + sparams_change[v.param_key]
                elseif G.GAME[v.target_key] then
                    G.GAME[v.target_key] = G.GAME[v.target_key] + sparams_change[v.param_key]
                end
            end
        end
    return true end}))
end

-- Informational Modifiers - corresponds to a G.GAME.modifiers value

OPAL.Modifier{
    key = "info_opal_enable_bl_stickers",
    name = 'Blind Stickers',
    discovered = true,
    atlas = 'indicatorAtlas',
    opal_alignment = 'informational',
    pos = {x = 0, y = 0},
    loc_vars = function(self, info_queue, card)
        return{vars = {G.GAME.modifiers.opal_bl_stickers_level}}
    end
}
OPAL.Modifier{
    key = "info_opal_blinds_give_stickers",
    name = 'Blinds Give Stickers',
    discovered = true,
    atlas = 'indicatorAtlas',
    opal_alignment = 'informational',
    pos = {x = 1, y = 0}
}
OPAL.Modifier{
    key = "info_opal_disable_skipping",
    name = 'No Skipping',
    discovered = true,
    atlas = 'indicatorAtlas',
    opal_alignment = 'informational',
    pos = {x = 2, y = 0}
}
OPAL.Modifier{
    key = "info_opal_pillar",
    name = 'Permanent Pillar',
    discovered = true,
    atlas = 'indicatorAtlas',
    opal_alignment = 'informational',
    pos = {x = 3, y = 0}
}
OPAL.Modifier{
    key = "undiscovered",
    name = 'Undiscovered',
    discovered = true,
    atlas = 'modifierAtlas',
    opal_alignment = 'excl',
    pos = {x = 4, y = 2}
}
OPAL.Modifier{
    key = "temp_decrease",
    name = 'Temp Decrease',
    discovered = true,
    atlas = 'modifierAtlas',
    config = {extra = 1},
    opal_alignment = 'excl',
    pos = {x = 4, y = 2},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra}}
    end,
}

function OPAL.remove_modifier(card)
    card.config.center:unapply(card)
    SMODS.destroy_cards(card, nil, nil, nil)
    OPAL.update_modifier_menu()
end

function OPAL.update_modifier_menu()
    local modMult = G.opal_mod_shape == 1 and 0.56 or 0.6
    modMult = G.opal_mod_size == 2 and 1.35*modMult or modMult
    G.opal_temperature_UI.alignment.offset.y = 1.7 - modMult*(math.floor(math.max(#G.opal_heat_mods.cards - 1, 0)/G.opal_heat_mods.config.opal_per_row)) + 0.6*(math.floor(math.max(#G.opal_indicators.cards - 1, 0)/4))
    if OPAL.config.modifier_count == 1 then
        for k, v in ipairs(G.opal_heat_mods.cards) do
            if v.ability.opal_count > 1 and not v.children.opal_md_counter then
                v.children.opal_md_counter = UIBox{
                    definition = {n = G.UIT.R, config = {colour = G.C.BLACK, align = "cm", padding = 0.05, r = 0.1}, nodes = {
                        {n=G.UIT.T, config = {text = tostring(v.ability.opal_count), scale = 0.3, colour = G.C.WHITE}}
                    }},
                    config = {align = "br", offset = {x=-0.3, y=-0.35}, parent = v}
                }
            end
        end
    end
end

function OPAL.handleKeys(controller, key)
    if controller.hovering.target and controller.hovering.target:is(Card) then
        local _card = controller.hovering.target
        if _card.ability.set == 'OpalModifier' then
            if key == 'c' then
                local new_card = copy_card(_card, nil, nil)
                new_card:add_to_deck()
                new_card.config.center:apply(new_card)
                G.opal_heat_mods:emplace(new_card)
            end
            if key == "r" then
                OPAL.remove_modifier(_card)
            end
            if G.STAGE == G.STAGES.RUN then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        OPAL.update_modifier_menu()
                    return true end
                }))
            end
        end
    else
        local _element = controller.hovering.target
        if _element and _element.config and _element.config.modifier then
            local _modifier = _element.config.modifier
            if key == "2" then
                OPAL.Modifiers['all'][_modifier.key].unlocked = true
                OPAL.Modifiers['all'][_modifier.key].discovered = true
                OPAL.Modifiers['all'][_modifier.key].alerted = true
                OPAL.Modifiers[_modifier.opal_alignment][_modifier.key].unlocked = true
                OPAL.Modifiers[_modifier.opal_alignment][_modifier.key].discovered = true
                OPAL.Modifiers[_modifier.opal_alignment][_modifier.key].alerted = true
                _modifier.hide_ability = false
                set_discover_tallies()
                G:save_progress()
                _element:set_sprite_pos(_modifier.pos)
            end
            if key == "3" or key == "c" then
                if G.STAGE == G.STAGES.RUN and G.opal_heat_mods then
                    OPAL.add_modifier(_modifier.key, true, false)
                end
            end
            if G.STAGE == G.STAGES.RUN then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    func = function()
                        OPAL.update_modifier_menu()
                    return true end
                }))
            end
        end
    end
end