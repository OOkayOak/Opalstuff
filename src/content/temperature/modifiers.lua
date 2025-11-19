OPAL.Modifiers = {
    ['good'] = {},
    ['informational'] = {}
}
OPAL.Modifier = SMODS.Center:extend{
    class_prefix = 'md',
    set = 'OpalModifier',
    discovered = true,
    unlocked = true,
    available = true,
    atlas = 'opal_modifierAtlas',
    pos = {x = 0, y = 0},
    display_size = {w = 22, h = 22},
    config = {},
    opal_alignment = 'good',
    required_params = {'key'},
    pre_inject_class = function(self)
            G.P_CENTER_POOLS[self.set] = {}
    end,
    inject = function(self)
        OPAL.Modifiers[self.opal_alignment][self.key] = self
        self.order = #OPAL.Modifiers
        SMODS.Center.inject(self)
    end,
    get_obj = function(self, key)
        if key == nil then
            return nil
        end
        return self.obj_table[key] or SMODS.Center:get_obj(key)
    end,
    generate_UI = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        return SMODS.Center.generate_UI(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
    end,
    set_card_type_badge = function(self, card, badges)
        if self.opal_alignment == 'informational' then
            badges[#badges+1] = create_badge(localize("k_opalindicator"), G.C.FILTER, G.C.WHITE)
        else
            badges[#badges+1] = create_badge(localize("k_opalmodifier"), G.C.OPAL_PINK, G.C.WHITE)
        end
    end,
}

function SMODS.current_mod.process_loc_text()
    -- will crash the game if removed (aye aye captain)
    G.localization.descriptions.OpalModifier = G.localization.descriptions.OpalModifier or {}
end

function OPAL.Modifier:calculate(card, context)
end

function OPAL.Modifier:apply(card)
end

function OPAL.Modifier:unapply(card)
end

function OPAL.copy_funcs(card)
    function card:apply()
        local _center = card.config.center
        _center:apply(card)
    end
    function card:calculate(context)
        OPAL.Modifier.calculate(_center, card, context)
    end
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
        if G.GAME.modifiers.money_per_discard == 0 then G.GAME.modifiers.money_per_discard = 0 end
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
        return{vars = {card.ability.extra}}
    end,
    apply = function(self, card)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra
    end,
    unapply = function(self, card)
        G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra
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
        return{vars = {card.ability.extra.hands, card.ability.extra.hands_left}}
    end,
    calculate = function(self, card, context)
        if  context.before and context.cardarea == G.opal_heat_mods then
            card.ability.extra.hands_left = card.ability.extra.hands_left - 1
            if card.ability.extra.hands_left == 0 then
                card.ability.extra.hands_left = card.ability.extra.hands
                return {
                    card = card,
                    level_up = true,
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
}

OPAL.running_yolk_modifiers = {
    {item = {'mult'}, text = localize('k_mult'), colour = G.C.MULT},
    {item = {'chips'}, text = 'Chips', colour = G.C.CHIPS},
    {item = {'xmult', 'Xmult', 'x_mult'}, text = 'XMult', colour = G.C.MULT},
    {item = {'dollars', 'money'}, text = 'Money', colour = G.C.MONEY}
}

OPAL.Modifier{ -- Running Yolk
    key = "running_yolk",
    name = 'Running Yolk',
    atlas = 'modifierAtlas',
    pos = {x = 4, y = 0},
    config = {extra = {item = nil, text = 'value', colour = G.C.SECONDARY_SET.Tarot}},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.text, colours = {card.ability.extra.colour}}}
    end,
    apply = function(self, card)
        card.ability.extra = pseudorandom_element(OPAL.running_yolk_modifiers, pseudoseed('op_ry'))
        for k, v in ipairs(card.ability.extra.item) do
            G.GAME.opal_ry_scaling[v] = G.GAME.opal_ry_scaling[v] and G.GAME.opal_ry_scaling[v]+1 or 1
        end
    end,
    unapply = function(self, card)
        for k, v in ipairs(card.ability.extra.item) do
            G.GAME.opal_ry_scaling[v] = G.GAME.opal_ry_scaling[v] - 1
        end
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

OPAL.Modifier{ -- Informational - Blind Stickers enabled
    key = "info_bsticks",
    name = 'Blind Stickers',
    atlas = 'indicatorAtlas',
    opal_alignment = 'informational',
    pos = {x = 0, y = 0},
    config = {extra = {level = 1}},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.level}}
    end
}

function OPAL.add_modifier(modifier, apply, silent, area)
    if not G.GAME.modifiers.opal_no_mods then
    local _area = area or G.opal_heat_mods
    local _T = _area and _area.T or {x = G.ROOM.T.w/2 - G.CARD_W/2, y = G.ROOM.T.h/2 - G.CARD_H/2}
    local card = Card(_T.x, _T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[modifier],{discover = true, bypass_discovery_center = true, bypass_discovery_ui = true, bypass_back = G.GAME.selected_back.pos })
    card:start_materialize(nil, silent)
    OPAL.copy_funcs(card)
    if apply then card:apply() end
    if _area and card.ability.set == 'OpalModifier' then _area:emplace(card) end
    card.created_on_pause = nil
    G.opal_temperature_UI.alignment.offset.y = 1.7 - 0.6*(math.floor(math.max(#G.opal_heat_mods.cards - 1, 0)/4) + math.floor(math.max(#G.opal_indicators.cards - 1, 0)/4))
    G.E_MANAGER:add_event(Event({trigger = 'after',func = function()
        save_run()
    return true end}))
    return card
    end
end

function OPAL.random_modifier()
    if not G.GAME.modifiers.opal_no_mods then
    mod_keys = {}
    for k, v in pairs(OPAL.Modifiers['good']) do
        mod_keys[#mod_keys+1] = k
    end
    local modifier_chosen = pseudorandom_element(mod_keys, pseudoseed('add_opal_modifier'))
    G.E_MANAGER:add_event(Event({
        func = function()
            local modifier = OPAL.add_modifier(modifier_chosen, true)
        return true
        end
    }))
    else
        print("NO MODIFIERS GO AWAY PLEASE")
    end
end

function OPAL.remove_modifier(card)
    card.config.center:unapply(card)
    SMODS.destroy_cards(card, nil, nil, nil)
    G.opal_temperature_UI.alignment.offset.y = 2.1 - 0.6*math.floor(math.max(#G.opal_heat_mods.cards - 2, 0)/4)
end

function OPAL.Modifier:get_uibox_table(modifier_sprite)
    modifier_sprite = modifier_sprite or self.modifier_sprite
    local name_to_check, loc_vars = self.name, {}
    modifier_sprite.ability_UIBox_table = generate_card_ui(OPAL.Modifiers[self.key], nil, loc_vars, (self.hide_ability) and 'Undiscovered' or 'Modifier', nil, (self.hide_ability))
    return modifier_sprite
end