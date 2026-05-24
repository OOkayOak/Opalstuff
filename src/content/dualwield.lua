function OPAL.reset_alt_blinds() -- Reset alternative Blinds.
    for k, v in pairs(G.GAME.modifiers.opal_alt_blinds) do
        G.GAME.round_resets.alt_blind_choices[k] = get_new_boss()
    end
end

function create_UIBox_opal_alt_blind(type, run_info)
    local disabled = false
    type = type or 'Small'
    local blind_choice = {
        config = G.P_BLINDS[G.GAME.round_resets.alt_blind_choices[type]],
    }
    blind_choice.animation =  SMODS.create_sprite(0,0, 1.2, 1.2, SMODS.get_atlas(blind_choice.config.atlas) or  'blind_chips',   blind_choice.config.pos) 

    blind_choice.animation:define_draw_steps({
        {shader = 'dissolve', shadow_height = 0.05},
        {shader = 'dissolve'}
    })

    local stake_sprite = get_stake_sprite(G.GAME.stake or 1, 0.5)
    G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
    local obj = blind_choice.config
    local target = {type = 'raw_descriptions', key = blind_choice.config.key, set = 'Blind', vars = {}}
    if obj.loc_vars and _G['type'](obj.loc_vars) == 'function' then
        local res = obj:loc_vars() or {}
        target.vars = res.vars or target.vars
        target.key = res.key or target.key
        target.set = res.set or target.set
        target.scale = res.scale
        target.text_colour = res.text_colour
    end

    local card = Card(0, 0, 1.2, 1.2, G.P_CARDS.empty, G.P_CENTERS.c_base)
    card.children.center = blind_choice.animation
    blind_choice.animation:set_role({major = card, role_type = 'Minor', draw_major = card, xy_bond = 'Weak'})
    card.states.drag.can = true
    card.hover = function()
		if not G.CONTROLLER.dragging.target or G.CONTROLLER.using_touch then
			if not card.hovering and card.states.visible then
				card.config.h_popup = create_UIBox_blind_popup(blind_choice.config, true)
				card.config.h_popup_config = card:align_h_popup()
				Node.hover(card)
			end
		end
		card.stop_hover = function()
			card.hovering = false; Node.stop_hover(card)
		end
	end

    local loc_name = localize{type = 'name_text', key = target.key or blind_choice.config.key, set = target.set or 'Blind'}
    local text_table = G.localization.descriptions[target.set][target.key].text_parsed
    local blind_col = OPAL.get_alt_blind_colour(type)
    local blind_amt = get_blind_amount(G.GAME.round_resets.blind_ante)*blind_choice.config.mult*G.GAME.starting_params.ante_scaling

    local blind_state = G.GAME.round_resets.blind_states[type]
    local _reward = true

    local run_info_colour = run_info and (blind_state == 'Defeated' and G.C.GREY or blind_state == 'Skipped' and G.C.BLUE or blind_state == 'Upcoming' and G.C.ORANGE or blind_state == 'Current' and G.C.RED or G.C.GOLD)

    return {n=G.UIT.R, config={id = 'alt_blind_container', ref_table = _tag, align = "cm"}, nodes={
        {n=G.UIT.R, config={align = 'tm', minh = 0.65}, nodes={
            {n=G.UIT.T, config={text = localize('k_or'), scale = 0.55, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE, shadow = not disabled}},
        }},
        {n=G.UIT.R, config={align = "cm", colour = mix_colours(G.C.BLACK, G.C.L_BLACK, 0.5), r = 0.1, outline = 1, outline_colour = G.C.L_BLACK}, nodes={  
            {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                not run_info and {n=G.UIT.R, config={id = 'select_alt_blind_button', align = "cm", ref_table = blind_choice.config, colour = disabled and G.C.UI.BACKGROUND_INACTIVE or G.C.ORANGE, minh = 0.6, minw = 2.7, padding = 0.07, r = 0.1, shadow = true, hover = true, one_press = true, button = 'select_blind'}, nodes={
                    {n=G.UIT.T, config={ref_table = G.GAME.round_resets.loc_blind_states, ref_value = type, scale = 0.45, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.UI.TEXT_LIGHT, shadow = not disabled}}
                }} or 
                {n=G.UIT.R, config={id = 'select_alt_blind_button', align = "cm", ref_table = blind_choice.config, colour = run_info_colour, minh = 0.6, minw = 2.7, padding = 0.07, r = 0.1, emboss = 0.08}, nodes={
                    {n=G.UIT.T, config={text = localize(blind_state, 'blind_states'), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}}
                }}
            }},
            {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                {n=G.UIT.R, config={id = 'alt_blind_desc', align = "cm", padding = 0.05}, nodes={
                    {n=G.UIT.C, config={align = "cm"}, nodes={
                        {n=G.UIT.R, config={align = "cm", minh = 1.2}, nodes={
                            {n=G.UIT.O, config={object = card}},
                        }},
                    }},
                    {n=G.UIT.C, config={align = "cm",r = 0.1, padding = 0.05, minw = 1.5, colour = G.C.BLACK, emboss = 0.05}, nodes={
                        {n=G.UIT.R, config={align = "cm", minh = 0.6}, nodes={
                            {n=G.UIT.O, config={w=0.3,h=0.3, colour = G.C.BLUE, object = stake_sprite, hover = true, can_collide = false}},
                            {n=G.UIT.B, config={h=0.1,w=0.1}},
                            {n=G.UIT.T, config={text = number_format(blind_amt), scale = score_number_scale(0.7, blind_amt), colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.RED, shadow =  not disabled}}
                        }},
                        _reward and {n=G.UIT.R, config={align = "cm"}, nodes={
                            {n=G.UIT.T, config={text = blind_choice.config.dollars < 6 and (string.rep(localize("$"), blind_choice.config.dollars)..'+') or (localize("$")..blind_choice.config.dollars..'+'), scale = 0.35, colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.MONEY, shadow = not disabled}}
                        }} or nil,
                    }},
                }},
            }},
        }}
    }}
end

function OPAL.get_alt_blind_colour(blind)
    local disabled = false
    blind = blind or ''
    if blind == 'Boss' or blind == 'Small' or blind == 'Big' then
        G.GAME.round_resets.blind_states = G.GAME.round_resets.blind_states or {}
        if G.GAME.round_resets.blind_states[blind] == 'Defeated' or G.GAME.round_resets.blind_states[blind] == 'Skipped' then disabled = true end
        blind = G.GAME.round_resets.alt_blind_choices[blind]
    end
    return (disabled or not G.P_BLINDS[blind]) and G.C.BLACK or
    G.P_BLINDS[blind].boss_colour or
    (blind == 'bl_small' and mix_colours(G.C.BLUE, G.C.BLACK, 0.6) or
    blind == 'bl_big' and mix_colours(G.C.ORANGE, G.C.BLACK, 0.6)) or G.C.BLACK
end

function OPAL.calculate_alt_blinds()
    print('FUCK')
    local _ret = {}
    if G.GAME and (G.GAME.selected_back_key.key == 'b_opal_selector' or G.GAME.selected_sleeve == 'sleeve_opal_selector') then
        _ret.Boss = true
    end
    if G.GAME and (G.GAME.selected_back_key.key == 'b_opal_selector' and G.GAME.selected_sleeve == 'sleeve_opal_selector') then
        _ret.Big = true
    end
    for k, v in ipairs(G.jokers.cards) do
        if v.config.center.key == 'j_opal_dual_wield' then
            _ret.Big = true
        end
    end
    G.GAME.modifiers.opal_alt_blinds = _ret
    OPAL.remove_missing_alt_blinds()
end

function OPAL.remove_missing_alt_blinds()
    for k, v in pairs(G.GAME.round_resets.alt_blind_choices) do
        if not G.GAME.modifiers.opal_alt_blinds[k] then
            G.GAME.bosses_used[G.GAME.round_resets.alt_blind_choices[k]] = G.GAME.bosses_used[G.GAME.round_resets.alt_blind_choices[k]] - 1
            G.GAME.round_resets.alt_blind_choices[k] = nil
            local lower = string.lower(k)
            G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                local par = G.blind_select_opts[lower].parent

                G.blind_select_opts[lower]:remove()
                G.blind_select_opts[lower] = UIBox{
                T = {par.T.x, 0, 0, 0, },
                definition =
                    {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
                        UIBox_dyn_container({create_UIBox_blind_choice(k)},false,get_blind_main_colour(k), k == 'Boss' and mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8) or nil)
                    }},
                config = {align="bmi",
                        offset = {x=0,y=G.ROOM.T.y + 9},
                        major = par,
                        xy_bond = 'Weak'
                    }
                }
                par.config.object = G.blind_select_opts[lower]
                par.config.object:recalculate()
                G.blind_select_opts[lower].parent = par
                G.blind_select_opts[lower].alignment.offset.y = 0

                save_run()
                    return true
                end)
            }))
        end
    end
end