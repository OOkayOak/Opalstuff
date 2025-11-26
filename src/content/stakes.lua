SMODS.Stake{ -- Travel
    key = 'travel',
    prefix_config = {applied_stakes = {mod = false}},
    applied_stakes = {'white'},
    atlas = 'stakeAtlas',
    pos = {x=1,y=0},
    sticker_atlas = 'stakeStickerAtlas',
    sticker_pos = {x=1,y=0},
    colour = HEX('78a7e0'),
    opalstuff_alt = true,
    modifiers = function()
        G.GAME.modifiers.enable_eternals_in_shop = true
        G.GAME.modifiers.enable_perishables_in_shop = true
        G.GAME.modifiers.enable_rentals_in_shop = true
        G.GAME.modifiers.opal_alt_stake = true
    end,
}

SMODS.Stake{ -- Sour
    key = 'sour',
    applied_stakes = {'opal_travel'},
    atlas = 'stakeAtlas',
    pos = {x=2,y=0},
    sticker_atlas = 'stakeStickerAtlas',
    sticker_pos = {x=2,y=0},
    colour = HEX('fdff68'),
    opalstuff_alt = true,
    modifiers = function()
        G.GAME.modifiers['enable_opal_hooked'] = true
        G.GAME.modifiers['enable_opal_chewed'] = true
    end,
}

SMODS.Stake{ -- Heavy
    key = 'heavy',
    applied_stakes = {'opal_sour'},
    atlas = 'stakeAtlas',
    pos = {x=0,y=0},
    sticker_atlas = 'stakeStickerAtlas',
    sticker_pos = {x=0,y=0},
    colour = HEX('a3a3a3'),
    opalstuff_alt = true,
    modifiers = function()
        G.GAME.modifiers.opal_no_skipping_big = true
    end,
}


SMODS.Stake{ -- Quantum
    key = 'quantum',
    applied_stakes = {'opal_heavy'},
    atlas = 'stakeAtlas',
    pos = {x=0,y=1},
    sticker_atlas = 'stakeStickerAtlas',
    sticker_pos = {x=3,y=0},
    colour = quantum_gradient,
    opalstuff_alt = true,
    modifiers = function()
        G.GAME.win_ante = G.GAME.win_ante + 1
    end,
}

SMODS.Stake{ -- Reject
    key = 'reject',
    applied_stakes = {'opal_quantum'},
    atlas = 'stakeAtlas',
    pos = {x=1,y=1},
    sticker_atlas = 'stakeStickerAtlas',
    sticker_pos = {x=4,y=0},
    colour = HEX('464646'),
    opalstuff_alt = true,
    modifiers = function()
        G.GAME.modifiers['enable_opal_trampled'] = true
        G.GAME.modifiers['enable_opal_bound'] = true
    end,
}

SMODS.Stake{ -- Pillar
    key = 'pillar',
    applied_stakes = {'opal_reject'},
    atlas = 'stakeAtlas',
    pos = {x=2,y=1},
    sticker_atlas = 'stakeStickerAtlas',
    sticker_pos = {x=0,y=1},
    colour = HEX('7e6752'),
    opalstuff_alt = true,
    modifiers = function()
        G.GAME.modifiers.opal_pillar = true
        G.GAME.banned_keys["bl_pillar"] = true
    end,
}

SMODS.Stake{ -- Double Down
    key = 'double_down',
    applied_stakes = {'opal_pillar'},
    atlas = 'stakeAtlas',
    pos = {x=0,y=2},
    sticker_atlas = 'stakeStickerAtlas',
    sticker_pos = {x=1,y=1},
    colour = HEX('7A3AAB'),
    opalstuff_alt = true,
    modifiers = function()
        G.GAME.win_ante = G.GAME.win_ante + 1
        G.GAME.modifiers.opal_disable_skipping = true
    end,
}

SMODS.Stake{ -- Hyperdeath
    key = 'hyperdeath',
    prefix_config = {applied_stakes = {mod = false}},
    applied_stakes = {'opal_double_down'},
    atlas = 'stakeAtlas',
    pos = {x=1,y=2},
    sticker_atlas = 'stakeStickerAtlas',
    sticker_pos = {x=4,y=2},
    colour = HEX('ff0000'),
    opalstuff_alt = true,
    calculate = function(self, context)
        if context.end_of_round and not G.GAME.opal_hyperdeath_triggered then
            G.GAME.opal_hyperdeath_triggered = true
            OPAL.add_evil_modifier()
        end
        if context.ending_shop and G.GAME.opal_hyperdeath_triggered then
            G.GAME.opal_hyperdeath_triggered = nil
        end
    end
}

function OPAL.opalstuff_stakes()
    local min = 0
    local max = 0
    for k, v in pairs(G.P_CENTER_POOLS.Stake) do
        if v.key and v.key == 'stake_opal_travel' then
            min = k
        elseif v.key and v.key == 'stake_opal_hyperdeath' then
            max = k
        end
    end
    return {min = min, max = max}
end