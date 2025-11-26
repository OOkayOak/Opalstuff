OPAL.level_thresholds = {10, 25, 50, 75}

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
    while OPAL.level_thresholds[G.GAME.opal_temp_level + 1] and G.GAME.opal_temperature >= OPAL.level_thresholds[G.GAME.opal_temp_level + 1] do
        G.GAME.opal_temp_level = G.GAME.opal_temp_level + 1
        OPAL.random_modifier()
    end
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
                local modifier = OPAL.add_modifier(modifier_chosen, true)
            return true
            end
        }))
    end
end