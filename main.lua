
OPAL = SMODS.current_mod
Partner_API = SMODS.Mods['partner']

local Backapply_to_run_Ref = Back.apply_to_run
function Back:apply_to_run()
    Backapply_to_run_Ref(self)
    G.GAME.opal_dupes = 0
    G.GAME.modifiers.opal_chewed_loss = 1
    G.GAME.modifiers.opal_trampled_multiplier = 0.5
end

SMODS.Atlas{
    key = "jokerAtlas",
    px = 71,
    py = 95,
    path = "jokers.png"
}

SMODS.Atlas{
    key = "stickerAtlas",
    px = 71,
    py = 95,
    path = "stickers.png"
}

SMODS.Atlas{
    key = "partnerAtlas",
    px = 46,
    py = 58,
    path = "partners.png"
}

assert(SMODS.load_file("./modules/stickers.lua"))()
assert(SMODS.load_file("./modules/challenges.lua"))()
assert(SMODS.load_file("./modules/jokers.lua"))()

if (Partner_API or {}).can_load then
    assert(SMODS.load_file("./modules/crossmod/partners.lua"))()
end
