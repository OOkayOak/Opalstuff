SMODS.Booster{ -- Test - Modifier Booster
    key = 'modifier1',
    atlas = 'boosterAtlas',
    pos = {x=0, y=0},
    config = {extra = 3, choose = 1},
    weight = 10000000,
    select_card = 'opal_heat_mods',
    group_key = 'modifier_pack',
    create_card = function(self, card)
        local newMod = OPAL.create_mod({type = 'bad', from_booster = true})
        G.opal_booster_mods = G.opal_booster_mods or {}
        G.opal_booster_mods[newMod.config.center.key] = true
        return newMod
    end,
}