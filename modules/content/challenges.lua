SHOWDOWN = SMODS.Mods['showdown']
UNSTABLE = SMODS.Mods['UnStable']

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
        {id = 'j_opal_irritating', eternal = true}
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
                {id = 'opal_pillar'},
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

if (MINTY or BUNCO or INKANDCOLOR or SIX or PAPERBACK or {}).can_load and (UNSTABLE or SHOWDOWN or {}).can_load then -- if modded suit AND modded rank
    local DeckWithOtherSuits = {}
    local suits = {'S', 'D', 'C', 'H'}
    local ranks = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}
    if (MINTY or {}).can_load then suits[#suits+1] = "minty_THREE" end
    if (BUNCO or {}).can_load then
        suits[#suits+1] = 'bunc_HALBERD'
        suits[#suits+1] = 'bunc_FLEURON'
    end
    if (INKANDCOLOR or {}).can_load then
        suits[#suits+1] = 'ink_Cink'
        suits[#suits+1] = 'ink_Ccolor'
    end
    if (SIX or {}).can_load then
        suits[#suits+1] = 'six_MOON'
        suits[#suits+1] = 'six_STAR'
    end
    if (PAPERBACK or {}).can_load then
        suits[#suits+1] = 'paperback_CROWNS'
        suits[#suits+1] = 'paperback_STARS'
    end
    if (UNSTABLE or {}).can_load then
        ranks[#ranks+1] = 'unstb_0'
        ranks[#ranks+1] = 'unstb_0.5'
        ranks[#ranks+1] = 'unstb_1'
        ranks[#ranks+1] = 'unstb_R'
        ranks[#ranks+1] = 'unstb_E'
        ranks[#ranks+1] = 'unstb_P'
        ranks[#ranks+1] = 'unstb_?'
        ranks[#ranks+1] = 'unstb_21'
        ranks[#ranks+1] = 'unstb_11'
        ranks[#ranks+1] = 'unstb_12'
        ranks[#ranks+1] = 'unstb_13'
        ranks[#ranks+1] = 'unstb_25'
        ranks[#ranks+1] = 'unstb_161'
    end
    if (SHOWDOWN or {}).can_load then
        ranks[#ranks+1] = 'showdown_Z'
        ranks[#ranks+1] = 'showdown_W'
        ranks[#ranks+1] = 'showdown_F'
        ranks[#ranks+1] = 'showdown_E'
        ranks[#ranks+1] = 'showdown_B'
        ranks[#ranks+1] = 'showdown_P'
        ranks[#ranks+1] = 'showdown_L'
    end
    for k, v in ipairs(suits) do
        for k2, v2 in ipairs(ranks) do
            table.insert(DeckWithOtherSuits,{s=v,r=v2})
        end
    end

    SMODS.Challenge{
        key = 'debuffs_2',
        rules = {
            custom = {
            },
            modifiers = {
                {id = 'hand_size', value = 50}
            },
        },
        jokers = {
        },
        deck = {
                type = "Challenge Deck",
                cards = DeckWithOtherSuits
            },
        restrictions = {
            banned_cards = {},
            banned_tags = {},
            banned_other = {}
        },
    }
end

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