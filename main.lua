assert(SMODS.load_file("./modules/atlasses.lua"))() -- atlasses
assert(SMODS.load_file("./modules/misc.lua"))() -- other mods, talisman funcs, etc 

assert(SMODS.load_file("./modules/content/blinds.lua"))()
assert(SMODS.load_file("./modules/content/challenges.lua"))()
assert(SMODS.load_file("./modules/content/jokers.lua"))()
assert(SMODS.load_file("./modules/content/stakes.lua"))()
assert(SMODS.load_file("./modules/content/stickers.lua"))()

if (Partner_API or {}).can_load then
    assert(SMODS.load_file("./modules/content/crossmod/partners.lua"))()
end
