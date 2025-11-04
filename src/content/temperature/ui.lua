function create_uibox_opal_temperature() -- Temperature UI
    G.opal_heat_mods = G.opal_heat_mods or CardArea(0,0,3,0.8,{card_limit = 1, highlight_limit = 0, type = 'title_2'})
    local heat_UI = {}
    if not G.GAME.modifiers.opal_no_heat then
    local heat_stat = {n=G.UIT.R, config = {colour = G.C.UI.TRANSPARENT_DARK, r = 0.1}, nodes = {
                        {n = G.UIT.R, config = {colour = G.C.CLEAR, align = "cm", padding = 0.2, r = 0.1}, nodes = {
                            {n=G.UIT.C, config = {colour = G.C.CLEAR}, nodes = {
                                {n=G.UIT.T, config={text = localize('b_temperature'), scale = 0.65, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                            }},
                        }},
                        {n = G.UIT.R, config = {colour = G.C.UI.TRANSPARENT_DARK, align = "cm", padding = 0.2, r = 0.1, minw = 3}, nodes = {
                            {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'opal_temperature', suffix = '°'}}, colours = {OPAL.get_temp_colour()}, font = G.LANGUAGES['en-us'].font, shadow = false,spacing = 2, bump = true, scale = 0.8 }), id = 'opal_temperature_text_UI', }},
                        }},
                    }}
    table.insert(heat_UI, heat_stat)
    end
    
    if not G.GAME.modifiers.opal_no_mods then
    local heat_mods = {n=G.UIT.C, config = {colour = G.C.UI.TRANSPARENT_DARK, r = 0.1}, nodes = {
                        {n=G.UIT.R, config = {colour = G.C.CLEAR, align = "cm", padding = 0.2}, nodes = {
                            {n=G.UIT.T, config={text = localize('b_opal_modifiers'), scale = 0.65, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
                        }},
                        {n=G.UIT.R, config = {colour = G.C.CLEAR, id = 'opal_heat_mods_UI'}, nodes = {
                            {n=G.UIT.O, config={object = G.opal_heat_mods}}
                        }},
                    }}
    table.insert(heat_UI, heat_mods)            
    end
    return {n = G.UIT.ROOT, config = {colour = G.C.CLEAR, align = "cr", padding = 0.2, r = 0.1, maxh = 1.6}, nodes = heat_UI}
end

function create_UIBox_your_collection_modifiers_contents(page)
    page = page or 1
    local modifier_matrix = {
    }

    local modifier_tab = {}
    local counter = 0
    for k, v in pairs(OPAL.Modifiers) do
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

    local t = create_UIBox_generic_options({ back_func = 'your_collection_other_gameobjects', contents = {
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
            no_pips = true
        })
      }}
  }})
  return t
end

function create_UIBox_your_collection_modifiers()
    return{
        n = G.UIT.O,
        config = { object = UIBox{
            definition = create_UIBox_your_collection_modifiers_contents(),
            config = { offset = {x=0,y=0}, align = 'cm'}
        }, id = 'your_collection_modifiers', align = 'cm'},
    }
end

G.FUNCS.your_collection_modifiers = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_your_collection_modifiers()
    }
end

G.FUNCS.your_collection_modifiers_page = function(args)
    print(args.cycle_config.current_option)
    local page = args.cycle_config.current_option or 1
    local t = create_UIBox_your_collection_modifiers_contents(page)
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
                    if modifier.key and OPAL.Modifiers[modifier.key] then OPAL.Modifiers[modifier.key].alerted = true end
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