-- talisman.
to_big = to_big or function(x)
    return x
end

to_number = to_number or function(x)
    return x
end

OPAL.optional_features = function()
	return {
		cardareas = {
            deck = true,
            discard = true
        }
	}
end

OPAL.config_tab = function()
    local optional_features = { n = G.UIT.C, config = {colour = G.C.L_BLACK, padding = 0.1, r = 0.2}, nodes = {
        {n = G.UIT.R, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
            {n = G.UIT.T, config = {text = localize('opal_optional_features'), colour = G.C.BLACK, scale = 0.3}},
        }},
        {n = G.UIT.R, config = {colour = G.C.BLACK, align = "cm", r = 0.2, emboss = 0.05}, nodes = {
            create_toggle({
                label = localize('opal_heat'),
                ref_table = OPAL.config,
                ref_value = 'heat_system',
                callback = function()
                end
            }),
            create_toggle({
                label = localize('b_opal_modifiers'),
                ref_table = OPAL.config,
                ref_value = 'modifiers',
                callback = function()
                end
            })
        }}
    }
    }
    return {n = G.UIT.ROOT, config = {colour = G.C.BLACK, align = "cm", r = 0.2, minh = 6, minw = 6, emboss = 0.05}, nodes = {
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = "cm", r = 0.2}, nodes = {
            optional_features
        }}
    }}
end

local Backapply_to_run_Ref = Back.apply_to_run
function Back:apply_to_run()
    Backapply_to_run_Ref(self)
    G.GAME.opal_dupes = 0
    G.GAME.modifiers.opal_chewed_loss = 1
    G.GAME.modifiers.opal_trampled_multiplier = 0.8
    OPAL.update_bsticker_rates(type(G.GAME.modifiers.opal_bstick_rate) == "number" and G.GAME.modifiers.opal_bstick_rate or 1)
end

function opal_return_score(score)
    if G.GAME.modifiers.opal_tariff then 
        return opal_cap_score(math.floor(score))
    elseif (SMODS.Mods['Cryptid'] or {}).can_load and G.GAME.blind.cry_cap_score then
        return G.GAME.blind:cry_cap_score(math.floor(hand_chips*mult))
    else
        return math.floor(hand_chips*mult)
    end
end

quantum_gradient = SMODS.Gradient{ --Quantum Gradient
    key = 'quantum_gradient',
    colours = {
        HEX('7a3aab'),
        HEX('2a7dc6')
    }
}

loc_colour()
G.ARGS.LOC_COLOURS["opal_pink"] = OPAL.badge_colour