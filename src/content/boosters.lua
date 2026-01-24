G.STATES.OPAL_MODIFIER_PACK = 74601

SMODS.Booster{ -- Modifier Booster
    key = 'modifier1',
    atlas = 'boosterAtlas',
    pos = {x=0, y=0},
    config = {extra = 3, choose = 1},
    weight = 0.6,
    select_card = 'opal_heat_mods',
    group_key = 'k_opal_modifier_pack',
    create_card = function(self, card)
        local newMod = OPAL.create_mod({type = 'good', from_booster = true})
        G.opal_booster_mods = G.opal_booster_mods or {}
        G.opal_booster_mods[newMod.config.center.key] = true
        return newMod
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.OPAL_MODIFIER_PACK)
    end,
    in_pool = function(self, args)
        return(G.GAME.opal_md_boosters or false), {allow_duplicates = true}
    end,
}