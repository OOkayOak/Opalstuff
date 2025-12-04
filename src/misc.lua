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

G.opal_mod_shape = OPAL.config.modifier_display
G.opal_mod_size = OPAL.config.modifier_size

G.FUNCS.opal_change_modifier_shape = function(e)
    OPAL.config.modifier_display = e.to_key
    local modifier_example = Sprite(0,0,0.6,0.6,G.ASSET_ATLAS[OPAL.config.modifier_display == 1 and "opal_modifierAtlas" or "opal_modifierAtlas_square"], {x=4, y=2})
    local object = G.OVERLAY_MENU:get_UIE_by_ID('modifier_shape_indicator')
    modifier_example.T = object.config.object.T
    object.config.object = modifier_example
end

G.FUNCS.opal_change_modifier_size = function(e)
    OPAL.config.modifier_size = e.to_key
end

OPAL.config_tab = function()
    local modifier_example = Sprite(0,0,0.6,0.6,G.ASSET_ATLAS[OPAL.config.modifier_display == 1 and "opal_modifierAtlas" or "opal_modifierAtlas_square"], {x=4, y=2})

    local optional_features = {
    { n = G.UIT.R, config = {colour = G.C.L_BLACK, padding = 0.1, r = 0.2}, nodes = {
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
            {n = G.UIT.R, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
                {n = G.UIT.T, config = {text = localize('opal_optional_features'), colour = G.C.BLACK, scale = 0.3}},
            }},
            {n = G.UIT.R, config = {colour = G.C.BLACK, align = "cr", r = 0.2, padding = 0.1, minw = 5, emboss = 0.05}, nodes = {
                create_toggle({ label = localize('opal_heat'), ref_table = OPAL.config, ref_value = 'heat_system', callback = function() end}),
                create_toggle({ label = localize('b_opal_modifiers'), ref_table = OPAL.config, ref_value = 'modifiers', callback = function() end})
            }}
        }}
        }
    },
    { n = G.UIT.R, config = {colour = G.C.L_BLACK, padding = 0.1, r = 0.2}, nodes = {
        { n = G.UIT.C, config = {colour = G.C.CLEAR}, nodes = {
            {n = G.UIT.R, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
                {n = G.UIT.T, config = {text = localize('opal_appearance'), colour = G.C.BLACK, scale = 0.3}},
            }},
            {n = G.UIT.R, config = {colour = G.C.BLACK, align = "cm", r = 0.2, padding = 0.1, emboss = 0.05}, nodes = {
                {n = G.UIT.R, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
                    {n = G.UIT.T, config = {text = localize('b_opal_modifiers_appearance'), colour = G.C.UI.TEXT_LIGHT, scale = 0.3}},
                }},
                {n = G.UIT.R, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
                    {n = G.UIT.C, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
                        create_option_cycle({w = 3.4,scale = 0.8, options = localize('k_opal_modifier_shapes'), opt_callback = 'opal_change_modifier_shape', current_option = OPAL.config.modifier_display}),
                    }},
                    {n = G.UIT.C, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
                        {n = G.UIT.O, config = {w=0.6,h=0.6 , object = modifier_example, id = 'modifier_shape_indicator'}}
                    }},
                }},
                {n = G.UIT.R, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
                    {n = G.UIT.C, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
                        create_option_cycle({w = 3.4,scale = 0.8, options = localize('k_opal_modifier_sizes'), opt_callback = 'opal_change_modifier_size', current_option = OPAL.config.modifier_size}),
                    }},
                }},
                {n = G.UIT.R, config = {colour = G.C.CLEAR, align = "cm"}, nodes = {
                    {n = G.UIT.T, config = {text = localize('k_opal_restart_required'), colour = G.C.UI.TEXT_LIGHT, scale = 0.2}},
                }},
            }},
        }}
    }}
}
    return {n = G.UIT.ROOT, config = {colour = G.C.BLACK, align = "cm", r = 0.2, minh = 6, minw = 6, emboss = 0.05}, nodes = {
        {n = G.UIT.C, config = {colour = G.C.CLEAR, align = "cm", padding = 0.2, r = 0.2}, nodes = optional_features}
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

if not (CHDP or {}).can_load then -- steal the reworked force sticker/ban edition code
    local set_edition_ref = Card.set_edition
    function Card:set_edition(edition, immediate, silent)
        G.GAME.modifiers.chdp_force_stickers = G.GAME.modifiers.chdp_force_stickers or {}
        G.GAME.modifiers.no_editions = G.GAME.modifiers.no_editions or {jokers = {}, cards = {}}
        if self.ability.set == "Joker" then
            for k, v in pairs(G.GAME.modifiers.chdp_force_stickers) do
                self:add_sticker(k, true)
            end
        end
        local run = true

        if edition then
            if G.GAME.modifiers.no_edition_jokers and self.ability.set == "Joker" then
                run = false
            end
            if G.GAME.modifiers.no_edition_cards and not(self.ability.set == "Joker") then
                run = false
            end

            local _edition = edition
            if type(edition) == "table" then
                for k, v in pairs(edition) do
                    _edition = 'e_'..k
                end
            end

            if G.GAME.modifiers.no_editions.jokers[_edition] and self.ability.set == 'Joker'
            or G.GAME.modifiers.no_editions.cards[_edition] and not(self.ability.set == 'Joker') then
                run = false
            end

            if run then
                return set_edition_ref(self, edition, immediate, silent)
            else
                play_sound('tarot2', 0.76, 0.4)
                play_sound('tarot2', 1, 0.4)
                self:juice_up(0.3,0.5)
            end
        end
    end
end