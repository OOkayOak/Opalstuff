OPAL = SMODS.current_mod
AKYRS = SMODS.Mods['aikoyorisshenanigans']
BUNCO = SMODS.Mods['Bunco']
CHDP = SMODS.Mods['ChDp']
INKANDCOLOR = SMODS.Mods['InkAndColor']
MINTY = SMODS.Mods['MintysSillyMod']
PAPERBACK = SMODS.Mods['paperback']
Partner_API = SMODS.Mods['partner']
SIX = SMODS.Mods['SixSuits']


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
