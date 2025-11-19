function create_uibox_opal_temperature() -- Temperature UI reworked
    local heat_UI = {}
    local top_row = {}
    if not G.GAME.modifiers.opal_no_heat then
    local heat_stat = {n = G.UIT.C, config = {colour = G.C.UI.TRANSPARENT_DARK, align = "cm", padding = 0.2, r = 0.1, minw = 1}, nodes = {
                            {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'opal_temperature', suffix = '°'}}, colours = {OPAL.get_temp_colour()}, font = G.LANGUAGES['en-us'].font, shadow = false,spacing = 2, bump = true, scale = 0.3 }), id = 'opal_temperature_text_UI', }},
                        }}
    table.insert(top_row, heat_stat)
    end
    local button = {n = G.UIT.C, config = {colour = G.C.CLEAR, align = "cm", padding = 0, r = 0.1}, nodes = {
                            UIBox_button{button = 'opal_mod_info', label = {'?'}, minh = 0.4, minw = 0.4, scale = 0.3},
                        }}
    table.insert(top_row, button)
    local top_row = {n=G.UIT.R, config = {colour = G.C.CLEAR, align = "cm", padding = 0.1, r = 0.1}, nodes = top_row}
    table.insert(heat_UI, top_row)
    
    G.opal_indicators = G.opal_indicators or CardArea(0,0,2.1,0.5,{card_limit = 1, highlight_limit = 0, type = 'opal_mods', opal_per_row = 4})
        local indicators = {n=G.UIT.R, config = {colour = G.C.CLEAR, padding = 0.1, r = 0.1}, nodes = {
                        {n=G.UIT.C, config = {colour = G.C.UI.TRANSPARENT_DARK, r = 0.1}, nodes = {
                            {n=G.UIT.O, config={object = G.opal_indicators}}
                        }},
                    }}
        table.insert(heat_UI, indicators)

    if not G.GAME.modifiers.opal_no_mods then
        G.opal_heat_mods = G.opal_heat_mods or CardArea(0,0,2.1,0.5,{card_limit = 1, highlight_limit = 0, type = 'opal_mods', opal_per_row = 4})
        local heat_mods = {n=G.UIT.R, config = {colour = G.C.CLEAR, padding = 0.1, r = 0.1}, nodes = {
                        {n=G.UIT.C, config = {colour = G.C.UI.TRANSPARENT_DARK, r = 0.1}, nodes = {
                            {n=G.UIT.O, config={object = G.opal_heat_mods}}
                        }},
                    }}
        table.insert(heat_UI, heat_mods)            
    end
    return {n = G.UIT.ROOT, config = {colour = G.C.CLEAR, align = "cm", padding = 0.05, r = 0.1}, nodes = heat_UI}
end

function create_UIBox_opal_info(args)
    local back_func = args.back_func or 'exit_overlay_menu'
    local set = args.set or 'heat'
    local r = {}
        local heat_info = {{n = G.UIT.R, config = {colour = G.C.CLEAR, align = 'cm'}, nodes = {
            {n=G.UIT.T, config = {text = localize('opal_'..set), scale = 0.5, colour = G.C.WHITE}}
        }}}
        local text_holder = {n = G.UIT.R, config = {colour = G.C.BLACK, r = 0.1, padding = 0.1, align = 'cm'}, nodes = {}}
        for i = 1, #(G.localization.opal_info[set]) do
            local small = args.small_lines and (args.small_lines <= i) or false
            new_line = {n = G.UIT.R, config = {colour = G.C.CLEAR, align = 'cm'}, nodes = {
                {n=G.UIT.T, config = {text = localize({type = 'opal_info', set = set, key = i}), scale = small and args.small_size or 0.35, colour = G.C.WHITE}}
            }}
            table.insert(text_holder.nodes, new_line)
        end
        table.insert(heat_info, text_holder)
        for i = 1, #heat_info do
            table.insert(r, heat_info[i])
        end

    local t = create_UIBox_generic_options({ back_func = back_func, minw = 0, contents = {
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = 'cm', padding = 0.1}, nodes = r}
    }})
    return t
end

function create_UIBox_opal_mod_info()
    local r = {}
    if not G.GAME.modifiers.opal_no_heat then
        local new_button = {n = G.UIT.R, config = {colour = G.C.CLEAR}, nodes = {
            UIBox_button{button = 'opal_heat_info', label = {localize('opal_heat')}}
        }}
        table.insert(r,new_button)
    end

    local new_button = {n = G.UIT.R, config = {colour = G.C.CLEAR}, nodes = {UIBox_button{button = 'opal_indicator_info', label = {localize('opal_indicators')}}}}
    table.insert(r,new_button)

    if not G.GAME.modifiers.opal_no_mods then
        local new_button = {n = G.UIT.R, config = {colour = G.C.CLEAR}, nodes = {UIBox_button{button = 'opal_modifier_info', label = {localize('opal_mods')}}}}
        table.insert(r,new_button)
    end

    local t = create_UIBox_generic_options({ back_func = 'exit_overlay_menu', contents = {
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = 'cm', padding = 0.1}, nodes = r}
    }})
    return t
end

function G.FUNCS.opal_mod_info()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_opal_mod_info()
    }
end

function G.FUNCS.opal_heat_info()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_opal_info({back_func = 'opal_mod_info', set = 'heat', small_lines = 4, small_size = 0.25})
    }
end

function G.FUNCS.opal_modifier_info()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_opal_info({back_func = 'opal_mod_info', set = 'mods', small_lines = 3, small_size = 0.5})
    }
end

function G.FUNCS.opal_indicator_info()
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_opal_info({back_func = 'opal_mod_info', set = 'indicators', small_lines = 9, small_size = 0.25})
    }
end

function create_UIBox_your_collection_modifiers_contents(page, type)
    type = type or 'all'
    page = page or 1
    local modifier_matrix = {
    }

    local modifier_tab = {}
    local counter = 0
    for k, v in pairs(OPAL.Modifiers[type]) do
        modifier_tab[#modifier_tab+1] = v
        counter = counter + 1
    end

    for i = 1, math.ceil(counter/6) do
        table.insert(modifier_matrix, {})
    end

    table.sort(modifier_tab, function (a, b) return a.order < b.order end)

    for k, v in ipairs(modifier_tab) do
        if k <= 24*(page-1) then elseif k > 24*page then break else
            local discovered = v.discovered
            local _T = {x = G.ROOM.T.w/2 - G.CARD_W/2, y = G.ROOM.T.h/2 - G.CARD_H/2}
            local temp_modifier = G.P_CENTERS[v.key]
            if not v.discovered then temp_modifier.hide_ability = true end
            local temp_modifier_ui, temp_modifier_sprite = OPAL.generate_modifier_UI(temp_modifier)
            modifier_matrix[math.ceil((k-1)/6+0.001)][1+((k-1)%6)] = {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
            temp_modifier_ui,
            }}
        end
    end

    local table_nodes = {}
    for i = 1, math.ceil(counter/6) do
        table.insert(table_nodes, {n=G.UIT.R, config={align = "cm"}, nodes=modifier_matrix[i]})
    end

    local page_options = {}
    for i = 1, math.ceil(counter/24) do
        table.insert(page_options, localize('k_page')..' '..tostring(i)..'/'..tostring(math.ceil(counter/24)))
    end

    local t = create_UIBox_generic_options({ back_func = 'your_collection_modifiers', contents = {
    {n=G.UIT.R, config={align = "cm", r = 0.1, colour = G.C.BLACK, padding = 0.1, emboss = 0.05}, nodes={
      {n=G.UIT.C, config={align = "cm"}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes=table_nodes}
      }},
    }},
    {n=G.UIT.R, config = {align = 'cm'}, nodes = {
        create_option_cycle({
            options = page_options,
            w = 4.5,
            cycle_shoulders = true,
            opt_callback = 'your_collection_modifiers_page',
            focus_args = {snap_to = true, nav = 'wide'},
            current_option = page,
            type = type,
            no_pips = true
        })
      }}
  }})
  return t
end

function create_UIBox_your_collection_modifiers(type)
    return{
        n = G.UIT.O,
        config = { object = UIBox{
            definition = create_UIBox_your_collection_modifiers_contents(nil, type),
            config = { offset = {x=0,y=0}, align = 'cm'}
        }, id = 'your_collection_modifiers', align = 'cm'},
    }
end

G.FUNCS.your_collection_modifiers_good = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_your_collection_modifiers('good')
    }
end

G.FUNCS.your_collection_modifiers_informational = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_your_collection_modifiers('informational')
    }
end

G.FUNCS.your_collection_modifiers = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_your_collection_modifiers_types()
    }
end

function create_UIBox_your_collection_modifiers_types()
    local r = {}
    local new_button = {n = G.UIT.R, config = {colour = G.C.CLEAR}, nodes = {UIBox_button{button = 'your_collection_modifiers_good', label = {localize('opal_mods')}}}}
    table.insert(r,new_button)

    local new_button = {n = G.UIT.R, config = {colour = G.C.CLEAR}, nodes = {UIBox_button{button = 'your_collection_modifiers_informational', label = {localize('opal_indicators')}}}}
    table.insert(r,new_button)

    local t = create_UIBox_generic_options({ back_func = 'exit_overlay_menu', contents = {
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = 'cm', padding = 0.1}, nodes = r}
    }})
    return t
end

G.FUNCS.your_collection_modifiers_page = function(args)
    print(args.cycle_config.current_option)
    local page = args.cycle_config.current_option or 1
    local type = args.cycle_config.type or 'all'
    local t = create_UIBox_your_collection_modifiers_contents(page, type)
    local e = G.OVERLAY_MENU:get_UIE_by_ID('your_collection_modifiers')
    if e.config.object then e.config.object:remove() end
    e.config.object = UIBox{
        definition = t,
        config = {offset = {x=0,y=0}, align = 'cm', parent = e}
    }
end

OPAL.custom_collection_tabs = function()
    return {UIBox_button({button = "your_collection_modifiers", label = {localize("b_opal_modifiers")}, minw = 5, id = "your_collection_modifiers"})}
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
                    if modifier.key and OPAL.Modifiers['all'][modifier.key] then OPAL.Modifiers['all'][modifier.key].alerted = true end
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