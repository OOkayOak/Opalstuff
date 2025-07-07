SMODS.Stake{
    key = 'pillar',
    prefix_config = { applied_stakes = {mod = false}},
    applied_stakes = {'white'},
    atlas = 'stakeAtlas',
    pos = {x=0,y=0},
    sticker_atlas = 'stakeStickerAtlas',
    sticker_pos = {x=0,y=0},
    modifiers = function()
        G.GAME.modifiers.opal_pillar = true
    end,
}