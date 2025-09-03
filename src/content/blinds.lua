SMODS.Blind{
    key = 'stinger',
    atlas = 'blindAtlas', pos = {x=0, y=1},
    boss_colour = HEX('8c5d8d'),
    boss = ({min = 2}),
    press_play = function(self)
        local killThisCard = pseudorandom_element(G.hand.highlighted, pseudoseed('opal_stinger'))
        G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
            SMODS.destroy_cards(killThisCard)
        return true end}))
    end,
}