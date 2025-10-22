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

function create_UIBox_your_collection_modifiers()
    local modifier_matrix = {
        {}
    }

    local modifier_tab = {}
    for k, v in pairs(G.P_MODIFIERS) do
        modifier_tab[#modifier_tab+1] = v
    end

    table.sort(modifier_tab, function (a, b) return a.order < b.order end)

    for k, v in ipairs(modifier_tab) do
    local discovered = v.discovered
    local _T = {x = G.ROOM.T.w/2 - G.CARD_W/2, y = G.ROOM.T.h/2 - G.CARD_H/2}
    local temp_modifier = G.P_CENTERS[v.key]
    if not v.discovered then temp_modifier.hide_ability = true end
    local temp_modifier_ui, temp_modifier_sprite = OPAL.generate_modifier_UI(temp_modifier)
    modifier_matrix[math.ceil((k-1)/6+0.001)][1+((k-1)%6)] = {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
      temp_modifier_ui,
    }}
    end

    local t = create_UIBox_generic_options({ back_func = 'your_collection_other_gameobjects', contents = {
    {n=G.UIT.C, config={align = "cm", r = 0.1, colour = G.C.BLACK, padding = 0.1, emboss = 0.05}, nodes={
      {n=G.UIT.C, config={align = "cm"}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.R, config={align = "cm"}, nodes=modifier_matrix[1]},
        }}
      }} 
    }}  
  }})
  return t
end

G.FUNCS.your_collection_modifiers = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu{
        definition = create_UIBox_your_collection_modifiers(),
    }
end

OPAL.custom_collection_tabs = function()
    return {UIBox_button({button = "your_collection_modifiers", label = {localize("b_opal_modifiers")}, minw = 5, id = "your_collection_modifiers"})}
end