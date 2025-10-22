OPAL.Modifier = SMODS.Center:extend{
    class_prefix = 'md',
    set = 'OpalModifier',
    discovered = true,
    unlocked = true,
    available = true,
    atlas = 'modifierAtlas',
    pos = {x = 0, y = 0},
    display_size = {w = 22, h = 22},
    config = {},
    required_params = {'key'},
    pre_inject_class = function(self)
            G.P_CENTER_POOLS[self.set] = {}
    end,
    inject = function(self)
        G.P_MODIFIERS = G.P_MODIFIERS or {}
        self.order = #G.P_MODIFIERS + 1
        G.P_MODIFIERS[self.key] = self
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
        badges[#badges+1] = create_badge(localize("k_opalmodifier"), G.C.OPAL_PINK, G.C.WHITE)
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


function OPAL.copy_funcs(card)
    function card:apply()
        local _center = card.config.center
        _center:apply(card)
    end
    function card:calculate(context)
        local _center = card.config.center
        OPAL.Modifier.calculate(_center, card, context)
    end
    print(type(card.calculate))
end

OPAL.Modifier{ -- Recycler
    key = "recycler",
    name = 'Recycler',
    atlas = 'modifierAtlas',
    pos = {x = 0, y = 0},
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra}}
    end,
    apply = function(self, card)
        G.GAME.modifiers.money_per_discard = G.GAME.modifiers.money_per_discard or 0
        G.GAME.modifiers.money_per_discard = G.GAME.modifiers.money_per_discard + card.ability.extra
    end
}

OPAL.Modifier{ -- Handheld
    key = "handheld",
    name = 'Handheld',
    atlas = 'modifierAtlas',
    pos = {x = 1, y = 0},
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra}}
    end,
    apply = function(self, card)
        G.GAME.modifiers.money_per_hand = G.GAME.modifiers.money_per_hand or 1
        G.GAME.modifiers.money_per_hand = G.GAME.modifiers.money_per_hand + card.ability.extra
    end
}

OPAL.Modifier{ -- Hilarious
    key = "hilarious",
    name = 'Hilarious',
    atlas = 'modifierAtlas',
    pos = {x = 2, y = 0},
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra}}
    end,
    apply = function(self, card)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra
    end
}

OPAL.Modifier{ -- Astronomy
    key = "astronomy",
    name = 'Astronomy',
    atlas = 'modifierAtlas',
    pos = {x = 3, y = 0},
    config = {extra = 1},
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra}}
    end,
    calculate = function(self, card, context)
        if  context.before and context.cardarea == G.opal_heat_mods and G.GAME.current_round.hands_played == 0 then
            return {
                card = card,
                level_up = true,
                message = localize('k_level_up_ex')
            }
        end
    end,
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

local start_run_ref = Game.start_run
function Game:start_run(args)
    local result = start_run_ref(self, args)
    if args and args.savetext and not G.GAME.modifiers.opal_no_mods then
        for k, v in ipairs(args.savetext.mods) do
            print(v)
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.opal_heat_mods = G.opal_heat_mods or CardArea(0,0,3,0.8,{card_limit = 1, highlight_limit = 0, type = 'title_2'})
                    OPAL.add_modifier(v, nil, true)
                return true
                end
            }))
        end
    end
end

function OPAL.add_modifier(modifier, apply, silent)
    if not G.GAME.modifiers.opal_no_mods then
    local _area = G.opal_heat_mods and G.opal_heat_mods or nil
    local _T = _area and _area.T or {x = G.ROOM.T.w/2 - G.CARD_W/2, y = G.ROOM.T.h/2 - G.CARD_H/2}
    local card = Card(_T.x, _T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[modifier],{discover = true, bypass_discovery_center = true, bypass_discovery_ui = true, bypass_back = G.GAME.selected_back.pos })
    card:start_materialize(nil, silent)
    OPAL.copy_funcs(card)
    print(type(card.apply))
    if apply then card:apply() end
    if _area and card.ability.set == 'OpalModifier' then _area:emplace(card) end
    card.created_on_pause = nil
    save_run()
    return card
    end
end

function OPAL.generate_modifier_UI(modifier, _size)
    _size = _size or 0.8

    local modifier_sprite_tab = nil

    local modifier_sprite = Sprite(0,0,_size*1,_size*1,G.ASSET_ATLAS[modifier.atlas], (modifier.hide_ability) and G.modifier_undiscovered.pos or modifier.pos)
    modifier_sprite.T.scale = 1
    modifier_sprite_tab = {n= G.UIT.C, config={align = "cm", ref_table = modifier, group = modifier.tally}, nodes={
        {n=G.UIT.O, config={w=_size*1,h=_size*1, colour = G.C.BLUE, object = modifier_sprite, focus_with_object = true}},
    }}
    modifier_sprite:define_draw_steps({
        {shader = 'dissolve', shadow_height = 0.05},
        {shader = 'dissolve'},
    })
    modifier_sprite.float = true
    modifier_sprite.states.hover.can = true
    modifier_sprite.states.drag.can = false
    modifier_sprite.states.collide.can = true
    modifier_sprite.config = {modifier = modifier, force_focus = true}

    modifier_sprite.hover = function(_modifier)
        if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then 
            if not _modifier.hovering and _modifier.states.visible then
                _modifier.hovering = true
                if _modifier == modifier_sprite then
                    _modifier.hover_tilt = 3
                    _modifier:juice_up(0.05, 0.02)
                    play_sound('paper1', math.random()*0.1 + 0.55, 0.42)
                    play_sound('tarot2', math.random()*0.1 + 0.55, 0.09)
                end

                modifier:get_uibox_table(modifier_sprite)
                _modifier.config.h_popup =  G.UIDEF.card_h_popup(_modifier)
                _modifier.config.h_popup_config ={align = 'cl', offset = {x=-0.1,y=0},parent = _modifier}
                Node.hover(_modifier)
                if _modifier.children.alert then 
                    _modifier.children.alert:remove()
                    _modifier.children.alert = nil
                    if modifier.key and G.P_MODIFIERS[modifier.key] then G.P_MODIFIERS[modifier.key].alerted = true end
                    G:save_progress()
                end
            end
        end
    end
    modifier_sprite.stop_hover = function(_modifier) _modifier.hovering = false; Node.stop_hover(_modifier); _modifier.hover_tilt = 0 end

    modifier_sprite:juice_up()
    modifier.modifier_sprite = modifier_sprite

    return modifier_sprite_tab, modifier_sprite
end

function OPAL.random_modifier()
    if not G.GAME.modifiers.opal_no_mods then
    mod_keys = {}
    for k, v in pairs(G.P_MODIFIERS) do
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

function OPAL.Modifier:get_uibox_table(modifier_sprite)
    modifier_sprite = modifier_sprite or self.modifier_sprite
    local name_to_check, loc_vars = self.name, {}
    modifier_sprite.ability_UIBox_table = generate_card_ui(G.P_MODIFIERS[self.key], nil, loc_vars, (self.hide_ability) and 'Undiscovered' or 'Modifier', nil, (self.hide_ability))
    return modifier_sprite
end