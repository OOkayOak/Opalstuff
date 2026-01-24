SMODS.Voucher{ -- Diamond In The Rough
    key = 'modifier_1',
    atlas = 'voucherAtlas',
    pos = {x=0, y=0},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "tag_opal_modified", set = "Tag"}
        info_queue[#info_queue+1] = {key = "p_opal_modifier1", set = "Other", vars = {1, 3}}
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({ func = function()
            G.GAME.opal_tag_instead_of_mod = true
            return true end}))
    end,
}

SMODS.Voucher{ -- Modifier Merchant?
    key = 'modifier_2',
    atlas = 'voucherAtlas',
    pos = {x=1, y=0},
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = {key = "p_opal_modifier1", set = "Other", vars = {1, 3}}
    end,
    requires = {'v_opal_modifier_1'},
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({ func = function()
            G.GAME.opal_md_boosters = true
            return true end}))
    end,
}