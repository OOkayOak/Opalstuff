-- talisman.
to_big = to_big or function(x)
    return x
end

to_number = to_number or function(x)
    return x
end

local Backapply_to_run_Ref = Back.apply_to_run
function Back:apply_to_run()
    Backapply_to_run_Ref(self)
    G.GAME.opal_dupes = 0
    G.GAME.modifiers.opal_chewed_loss = 1
    G.GAME.modifiers.opal_trampled_multiplier = 0.5
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

OPAL.light_suits = {'Hearts', 'Diamonds', 'paperback_Stars', 'minty_3s'}
OPAL.dark_suits = {'Spades', 'Clubs', 'paperback_Crowns', 'gb_Eyes'}