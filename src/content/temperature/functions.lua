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
    local count = 0
    for k, v in ipairs(G.opal_heat_mods.cards) do
        if OPAL.Modifiers['good'][v.config.center.key] then
            count = count + v.ability.opal_count
        end
        if v.ability.opal_is_starting_modifier then
            count = count - 1
        end
    end
    local mods_to_create = math.floor((G.GAME.opal_temperature/G.GAME.modifiers.opal_heat_for_mods) - count)
    for i = 1, mods_to_create do
    G.E_MANAGER:add_event(Event({
    trigger = 'before',
    delay = 0.3,
    func = function()
        OPAL.random_modifier(false, false, mods_to_create>5)
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
                OPAL.add_modifier('md_opal_info_'..k, false, true, G.opal_indicators)
            end
        end
    end
end

function OPAL.add_evil_modifier()
    mod_keys = {}
    for k, v in pairs(OPAL.Modifiers['bad']) do
        if not v.can_apply
        or (v:can_apply()) then
            mod_keys[#mod_keys+1] = k
        end
    end
    if #mod_keys > 0 then
        local modifier_chosen = pseudorandom_element(mod_keys, pseudoseed('add_opal_modifier'))
        G.E_MANAGER:add_event(Event({
            func = function()
                OPAL.add_modifier(modifier_chosen, true, false)
            return true
            end
        }))
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

    if not t.key then
        t.key = pseudorandom_element(OPAL.Modifiers[t.type], pseudoseed('mod_creation')).key
    end

    local _card = create_card('OpalModifier', t.area, nil, nil, t.skip_materialize, nil, t.key, t.key_append)
    _card.T.w = _card.T.w*2
    _card.T.h = _card.T.h*2
    return _card
end