SMODS.Challenge{ -- Oops! All Debuffs
    key = 'debuffs_1',
    rules = {
        custom = {
        },
        modifiers = {
        },
    },
    jokers = {
        {id = 'j_opal_intrusive', eternal = true},
        {id = 'j_opal_egocentric', eternal = true},
        {id = 'j_opal_wreckless', eternal = true},
        {id = 'j_opal_irritating', eternal = true}
    },
    restrictions = {
        banned_cards = {},
        banned_tags = {},
        banned_other = {}
    },
    button_colour = OPAL.badge_colour
}

SMODS.Challenge{ -- Pillar
    key = 'pillar_1',
    rules = {
        custom = {
            {id = 'opal_pillar'},
            {id = 'opal_disable_skipping'}
        },
        modifiers = {
        },
    },
    jokers = {
    },
    restrictions = {
        banned_cards = {},
        banned_tags = {},
        banned_other = {
            {type = "blind", id = "bl_pillar"}
        }
    },
    button_colour = OPAL.badge_colour
}

local DeckWithStickers = {}
local suits = {'S', 'D', 'C', 'H'}
local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
for k, v in ipairs(suits) do
    for k2, v2 in ipairs(ranks) do
        table.insert(DeckWithStickers,{s=v,r=v2,opal_stickers=true})
    end
end


SMODS.Challenge{
    key = 'stickers_1',
    rules = {
        custom = {
            {id = 'opal_enable_bl_stickers_cards'}
        },
        modifiers = {
        },
    },
    jokers = {
    },
    deck = {
        cards = DeckWithStickers,
        type = "Challenge Deck"
    },
    restrictions = {
        banned_cards = {},
        banned_tags = {},
        banned_other = {}
    },
    button_colour = OPAL.badge_colour
}

if (CHDP or {}).can_load then 
    SMODS.Challenge{
    key = 'dupes_1',
    rules = {
        custom = {
            {id = "enable_singular_jokers"}
        },
        modifiers = {
        },
    },
    jokers = {
        {id = 'j_opal_hardlight', eternal = true},
        {id = 'j_throwback', eternal = true, singular = true}
    },
    restrictions = {
        banned_cards = {},
        banned_tags = {},
        banned_other = {}
    },
    button_colour = OPAL.badge_colour
}

    local AKYRS = SMODS.Mods['aikoyorisshenanigans']
    SMODS.Challenge{
        key = 'stickers_2',
        rules = {
            custom = {
                {id = 'enable_eternal_jokers'},
                {id = 'enable_rental_jokers'},
                {id = 'enable_perishable_jokers'},
                (BUNCO or {}).can_load and {id = 'enable_scattering_jokers'} or {id = 'chdp_nothing'},
                (BUNCO or {}).can_load and {id = 'enable_reactive_jokers'} or {id = 'chdp_nothing'},
                (BUNCO or {}).can_load and {id = 'enable_hindered_jokers'} or {id = 'chdp_nothing'},
                {id = 'anaglyph', value = localize{type = 'name_text', set = 'Tag', key = 'tag_buffoon', nodes = {}}, tag = 'buffoon'},
                {id = 'cannot_sell_stickered'}
            }
        },
        jokers = (AKYRS or {}).can_load and {
            {id = 'j_opal_kimochi_warui', akyrs_sigma = true}
        } or {
            {id = 'j_opal_kimochi_warui', eternal = true}
        },
        button_colour = OPAL.badge_colour
    }
end