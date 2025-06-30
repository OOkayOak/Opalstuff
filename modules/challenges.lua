local CHDP = SMODS.Mods['ChDp']
local BUNCO = SMODS.Mods['Bunco']

SMODS.Challenge{
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
        {id = 'j_opal_irritating', eternal = true},
    },
    restrictions = {
        banned_cards = {},
        banned_tags = {},
        banned_other = {}
    },
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
}
    SMODS.Challenge{
        key = 'pillar_1',
        rules = {
            custom = {
                {id = 'chdp_pillar'},
                {id = 'pillar_quip'}
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
    }
    SMODS.Challenge{
        key = 'pillar_2',
        rules = {
            custom = {
                {id = 'chdp_pillar'},
                {id = 'disable_skipping'},
                {id = 'pillar_quip_2'}
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
    }
    SMODS.Challenge{
        key = 'pillar_3',
        rules = {
            custom = {
                {id = 'chdp_pillar'},
                {id = 'disable_skipping'},
                {id = 'chdp_third_boss'},
                {id = 'pillar_quip_3'}
            },
            modifiers = {
            },
        },
        jokers = {
            {id = 'j_obelisk'}
        },
        restrictions = {
            banned_cards = {},
            banned_tags = {},
            banned_other = {
                {type = "blind", id = "bl_pillar"}
            }
        },
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
                {id = 'enable_bl_stickers_cards'}
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
    }

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
    }
end