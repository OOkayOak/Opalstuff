function OPAL.ease_temp(mod, instant)
    if not G.GAME.modifiers.opal_no_heat then
    local function _mod(mod)
        local opal_temp_UI = G.opal_temperature_UI:get_UIE_by_ID('opal_temperature_text_UI')
        mod = mod or 0
        local text = '+'
        local suffix = '°'
        local col = G.C.RED
        if mod < 0 then
            text = '-'
            col = G.C.BLUE
        end
        --Ease from current chips to the new number of chips
        G.GAME.opal_temperature = G.GAME.opal_temperature + mod
        --check_for_unlock({type = 'money'})
        opal_temp_UI.config.object:update()
        opal_temp_UI.config.object.colours = {OPAL.get_temp_colour()}
        G.HUD:recalculate()
        --Popup text next to the chips in UI showing number of chips gained/lost
        
        attention_text({
          text = text..tostring(math.abs(mod))..suffix,
          scale = 0.8, 
          hold = 0.7,
          cover = opal_temp_UI.parent,
          cover_colour = col,
          align = 'cm',
          })

        OPAL.check_heat()
        play_sound('generic1', 0.9 + math.random() * 0.1)
    end
    if instant then
        _mod(mod)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(mod)
            return true
        end
        }))
    end
    end
end

function OPAL.check_heat() -- Checks if you need a modifier/level up
    G.GAME.opal_mtags_made = G.GAME.opal_mtags_made or 0
    local count = 0
    for k, v in ipairs(G.opal_heat_mods.cards) do
        if OPAL.Modifiers['good'][v.config.center.key] then
            count = count + v.ability.opal_count
        end
        if v.ability.opal_is_starting_modifier then
            count = count - 1
        end
        if v.ability.count_from_booster then
            count = count - v.ability.count_from_booster
        end
    end
    local mods_to_create = math.floor((G.GAME.opal_temperature/G.GAME.modifiers.opal_heat_for_mods) - (count+G.GAME.opal_mtags_made))
    for i = 1, mods_to_create do
    G.E_MANAGER:add_event(Event({
    trigger = 'before',
    delay = 1,
    func = function()
        if G.GAME.opal_tag_instead_of_mod then
            add_tag({key = 'tag_opal_modified'})
            G.GAME.opal_mtags_made = G.GAME.opal_mtags_made + 1
        else
            OPAL.add_mod({type = 'good', silent = (i ~= mods_to_create and mods_to_create<=5), dont_create = true})
        end
    return true end}))
    end
    G.E_MANAGER:add_event(Event({func = function()
        save_run()
        if mods_to_create>5 then
            play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
        end
        return true end}))
end

function OPAL.get_temp_colour()
    if G.GAME.opal_temperature < 10 then
        return(mix_colours(G.C.RED, G.C.WHITE, math.max(0,math.min((G.GAME.opal_temperature)/10,1))))
    elseif G.GAME.opal_temperature < 25 then
        return(mix_colours(G.C.ORANGE, G.C.RED, math.max(0,math.min((G.GAME.opal_temperature-10)/15,1))))
    elseif G.GAME.opal_temperature < 50 then
        return(mix_colours(G.C.BLUE, G.C.ORANGE, math.max(0,math.min((G.GAME.opal_temperature-25)/25,1))))
    else
        return(mix_colours(mix_colours(G.C.PURPLE, G.C.WHITE, 0.7), G.C.BLUE, math.max(0,math.min((G.GAME.opal_temperature-50)/25,1))))
    end
end

function OPAL.add_indicators()
    if not G.GAME.modifiers.opal_no_mods then
        for k, v in pairs(G.GAME.modifiers) do
            if OPAL.Modifiers['informational']['md_opal_info_'..k] then
                OPAL.add_mod({key = 'md_opal_info_'..k, area = G.opal_indicators, silent = true})
            end
        end
    end
end

function OPAL.get_temp_x()
    local _x = 17.35
    if CardSleeves then
        _x = _x - 0.175
    end
    return _x
end

function OPAL.depower_modifier(card, count)
    card.ability.opal_md_temp_decrease = card.ability.opal_md_temp_decrease or 0
    card.ability.opal_md_temp_decrease = card.ability.opal_md_temp_decrease + count
    if card.config.center.merge and type(card.config.center.merge) == "function" then card.config.center:merge(card, -count) end
    if OPAL.config.modifier_count == 1 then OPAL.update_modifier_count(card) end
end

function OPAL.power_modifier_up(card, count)
    card.ability.opal_md_temp_decrease = card.ability.opal_md_temp_decrease or 0
    card.ability.opal_md_temp_decrease = card.ability.opal_md_temp_decrease - count
    if card.config.center.merge and type(card.config.center.merge) == "function" then card.config.center:merge(card, count) end
    if OPAL.config.modifier_count == 1 then OPAL.update_modifier_count(card) end
end

function OPAL.create_mod(t)
    t = t or {}
    t.area = t.area or G.opal_heat_mods
    t.type = t.type or 'good'

    G.opal_existing_mods = G.opal_existing_mods or {}

    if not t.key then
        t.key = pseudorandom_element(get_current_pool('OpalModifier_'..t.type), pseudoseed('mod_creation'))
        local it = 1
        while t.key == 'UNAVAILABLE' or (t.unique and G.opal_existing_mods[t.key]) do
            it = it + 1
            t.key = pseudorandom_element(get_current_pool('OpalModifier_'..t.type), pseudoseed('mod_creation_resample_'..it))
        end
    end

    G.opal_existing_mods[t.key] = true

    local _T = t.area.T
    local _card = Card(_T.x, _T.y, G.CARD_W, G.CARD_H, G.P_CARDS.empty, G.P_CENTERS[t.key],{discover = t.bypass_discovery or true, bypass_discovery_center = t.bypass_discovery or true, bypass_discovery_ui = t.bypass_discovery or true, bypass_back = G.GAME.selected_back.pos })
    if not t.no_preapp then
        if _card.config.center.pre_apply then _card.preapp_table = _card.config.center:pre_apply() end
        if _card.preapp_table and _card.preapp_table['type'] == 'item' then
            _card.config.center:set_item(_card, _card.preapp_table['item'])
        end
    end
    if t.from_tag then
        _card.from_tag = true
    end
    if t.from_booster then 
        _card.T.w = _card.T.w*2
        _card.T.h = _card.T.h*2
        _card.from_booster = true 
    elseif t.uncounted then
        _card.from_booster = true
    end
    _card:set_sprites(nil, nil)
    return _card
end

function OPAL.add_mod(t)
    local ret = {}
    local card = t.card and t.card or not(t.dont_create) and OPAL.create_mod(t) or nil
    t.area = t.area or G.opal_heat_mods

    local merge_instead = nil
    local preapp_table = nil
    if not(t.dont_create) then
        if card.from_booster then 
            card.T.w = card.T.w/2
            card.T.h = card.T.h/2
            G.opal_booster_mods = nil
        end
        local preapp_table = card.preapp_table or {}
        for k, v in ipairs(G.opal_heat_mods.cards) do
            if v.ability.opal_count and v.config.center == card.config.center and v.config.center.merge and
                (not preapp_table['type'] or preapp_table['type'] == 'item' and preapp_table['item'] == v.ability.extra) then
                merge_instead = k
            end
        end
    else
        merge_instead, preapp_table = OPAL.pre_poll_mod(t)
    end
    OPAL.existing_modifiers = OPAL.existing_modifiers or {}
    if card then OPAL.existing_modifiers[card.config.center.key] = true end

    if merge_instead then
        local _card = G.opal_heat_mods.cards[merge_instead]
        local _count = t.count or 1
        _card.config.center:merge(_card, _count)
        _card.ability.opal_count = _card.ability.opal_count + _count
        _card:juice_up()
        if card and card.from_booster then 
            if not card.from_tag then _card.ability.count_from_booster = _card.ability.count_from_booster and _card.ability.count_from_booster + _count or _count end
            ret.dont_dissolve = false
        end
        if card then SMODS.destroy_cards(card, nil, nil, nil) end
        if _card.children.opal_md_counter then _card.children.opal_md_counter:remove() end
            _card.children.opal_md_counter = UIBox{
            definition = {n = G.UIT.R, config = {colour = G.C.BLACK, align = "cm", padding = 0.05, r = 0.1}, nodes = {
                {n=G.UIT.T, config = {text = tostring(_card.ability.opal_count), scale = 0.3, colour = G.C.WHITE}}
            }},
            config = {align = "br", offset = {x=-0.3, y=-0.35}, parent = _card}
            }
    else
        if t.dont_create then
            local _t = t
            _t.no_preapp = true
            card = OPAL.create_mod(_t)
            if preapp_table and preapp_table['type'] == 'item' then
                card.config.center:set_item(card, preapp_table['item'])
            end
        end
        card:start_materialize(nil, t.silent)
        card:add_to_deck()
        t.area:emplace(card)
        if t.area == G.opal_heat_mods then
            if card.config.center.apply then card.config.center:apply(card) end
            card.ability.opal_count = 1
            card.ability.opal_md_temp_decrease = 0
            if card.from_booster then
                if not card.from_tag then card.ability.count_from_booster = 1 end
                ret.dont_dissolve = true
            elseif t.as_starting then
                card.ability.opal_is_starting_modifier = true
            end
        end
    end
    OPAL.update_modifier_menu()
    if not t.silent then play_sound('holo1', 1.2 + math.random() * 0.1, 0.4) end
    return ret
end

function OPAL.pre_poll_mod(t)
    if not t.key then
        t.key = pseudorandom_element(get_current_pool('OpalModifier_'..t.type), pseudoseed('mod_creation'))
        local it = 1
        while t.key == 'UNAVAILABLE' or (t.unique and G.opal_existing_mods[t.key]) do
            it = it + 1
            t.key = pseudorandom_element(get_current_pool('OpalModifier_'..t.type), pseudoseed('mod_creation_resample_'..it))
        end
    end

    local card = G.P_CENTERS[t.key]
    local preapp_table = {}
    if card.pre_apply then preapp_table = card:pre_apply() end

    local merge_instead = nil
    for k, v in ipairs(G.opal_heat_mods.cards) do
        if v.ability.opal_count and v.config.center == card and v.config.center.merge and
            (not preapp_table['type'] or preapp_table['type'] == 'item' and preapp_table['item'] == v.ability.extra) then
            merge_instead = k
        end
    end
    OPAL.existing_modifiers = OPAL.existing_modifiers or {}
    OPAL.existing_modifiers[card.key] = true
    return merge_instead, preapp_table
end

function OPAL.remove_mod(t)
    t.num = t.num or 1
    if not t.card then
        t.card = pseudorandom_element(G.opal_heat_mods.cards, 'mod_removal')
    end

    if t.num >= t.card.ability.opal_count or not(t.card.config.center.merge and type(t.card.config.center.merge) == "function") then
        t.card.config.center:unapply(t.card)
        SMODS.destroy_cards(t.card, nil, nil, nil)
    else
        t.card.config.center:merge(t.card, -(t.num))
        t.card.ability.opal_count = t.card.ability.opal_count - t.num
        if t.card.children.opal_md_counter then t.card.children.opal_md_counter:remove() end
            t.card.children.opal_md_counter = UIBox{
            definition = {n = G.UIT.R, config = {colour = G.C.BLACK, align = "cm", padding = 0.05, r = 0.1}, nodes = {
                {n=G.UIT.T, config = {text = tostring(t.card.ability.opal_count), scale = 0.3, colour = G.C.WHITE}}
            }},
            config = {align = "br", offset = {x=-0.3, y=-0.35}, parent = t.card}
            }
    end
end