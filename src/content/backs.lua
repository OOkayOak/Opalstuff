SMODS.Back{
    key = 'opals_stuff',
    atlas = 'cardAtlas', pos = { x=1,y=0 },
    config = {extra = {opalstuff_cards = nil, triggered = false, requires_room = true}},
    apply = function(self, back)
        self.config.extra.opalstuff_cards = OPAL.get_stuff()
    end,
    calculate = function(self, back, context)
        if context.end_of_round then
            if G.GAME.selected_sleeve and G.GAME.selected_sleeve == "sleeve_opal_opals" then
                self.config.extra.requires_room = false
            end
            if not self.config.extra.opalstuff_cards then
                self.config.extra.opalstuff_cards = OPAL.get_stuff()
            end

            local tier_to_use = 4 -- choose the tier of Opalstuff item to generate
            local choose_tier = pseudorandom('opal_opals_stuff')
            if choose_tier < 0.2 then
                tier_to_use = 3
            elseif choose_tier < 0.5 then
                tier_to_use = 2
            else
                tier_to_use = 1
            end

            local opalstuff_item = pseudorandom_element(self.config.extra.opalstuff_cards[tier_to_use])
            local item_area = (opalstuff_item.type == 'Joker' and G.jokers or G.consumeables)
            if (#item_area.cards < item_area.config.card_limit or not(self.config.extra.requires_room)) and
            self.config.extra.triggered == false then
                self.config.extra.triggered = true
                G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
                    local opalstuff_card = create_card(opalstuff_item.type, item_area, nil, nil, nil, nil, opalstuff_item.key, 'opal_opals_stuff')
                    opalstuff_card:add_to_deck()
                    item_area:emplace(opalstuff_card)
                return true end}))
            end
        end
        if context.setting_blind then
            self.config.extra.triggered = false
        end
    end,
}

function OPAL.get_stuff()
    local cardsAll = {}
    local cardsT1, cardsT2, cardsT3 = cardsAll, cardsAll, cardsAll -- create 3 empty arrays for tiers of cards

    for k2, v2 in pairs(G.P_CENTER_POOLS.Joker) do
        if string.find(v2.key, 'j_opal_') then
            cardsAll[#cardsAll+1] = {key = v2.key, type = 'Joker'}
            if v2.rarity == 1 then
                cardsT1[#cardsT1+1] = {key = v2.key, type = 'Joker'}
            elseif v2.rarity == 2 then
                cardsT2[#cardsT2+1] = {key = v2.key, type = 'Joker'}
            elseif v2.rarity == 3 then
                cardsT3[#cardsT3+1] = {key = v2.key, type = 'Joker'}
            end
        end
    end
    for k2, v2 in pairs(G.P_CENTER_POOLS.Consumeables) do
        if string.find(v2.key, 'c_opal_') then
            print(v2.type.key)
            cardsAll[#cardsAll+1] = {key = v2.key, type = 'Consumeables'}
            if v2.type.key == 'Tarot' then
                cardsT2[#cardsT2+1] = {key = v2.key, type = 'Consumeables'}
            elseif v2.type.key == 'Spectral' then
                cardsT3[#cardsT3+1] = {key = v2.key, type = 'Consumeables'}
            end
        end
    end
    cards = {cardsT1, cardsT2, cardsT3, cardsAll}

    return(cards)
end

SMODS.Back{
    key = 'cookie',
    atlas = 'cardAtlas', pos = { x=0,y=0 },
    config = {extra = {cookies_to_create = 2, card_keys = nil, triggered = false}},
    loc_vars = function(self, info_queue, back)
        return{vars = {self.config.extra.cookies_to_create, localize{type = 'name_text', set = 'Enhanced', key = 'm_opal_cookie'}}}
    end,
    calculate = function(self, back, context)
        if context.end_of_round and not self.config.extra.triggered then
            self.config.extra.triggered = true
            if not self.config.extra.card_keys then
                self.config.extra.card_keys = OPAL.get_suits_and_ranks()
            end
            for i=1, self.config.extra.cookies_to_create do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function() 
                        local cards = {}
                            cards[i] = true
                            local _suit, _rank = nil, nil
                            _rank = pseudorandom_element(self.config.extra.card_keys.ranks, pseudoseed('opal_cookie_create'))
                            _suit = pseudorandom_element(self.config.extra.card_keys.suits, pseudoseed('opal_cookie_create'))
                            _suit = _suit or 'S'; _rank = _rank or 'A'
                            local cen_pool = {}
                            for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                                if v.key == 'm_opal_cookie' then 
                                    cen_pool[#cen_pool+1] = v
                                end
                            end
                            create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = cen_pool[1]}, G.deck, nil, i ~= 1, {G.C.BLUE})
                        playing_card_joker_effects(cards)
                        return true end }))
            end
        end
        if context.setting_blind then
            self.config.extra.triggered = false
        end
    end,
}

function OPAL.get_suits_and_ranks()
    local suits = {}
    local ranks = {}
    for k, v in pairs(SMODS.Ranks) do
        if v.card_key ~= "paperback_APOSTLE" then
            ranks[#ranks+1] = v.card_key
        end
    end
    for k, v in pairs(SMODS.Suits) do
        if v.card_key ~= "gb_EYES" then
            suits[#suits+1] = v.card_key
        end
    end
    return{ suits = suits, ranks = ranks }
end

if OPAL.config.modifiers and OPAL.config.heat_system then
SMODS.Back{
    key = 'modified',
    atlas = 'cardAtlas', pos = { x=2,y=0 },
    config = {extra = {starting_mods = 2, heat_for_mods = 5}},
    loc_vars = function(self, info_queue, back)
        return{vars = {self.config.extra.starting_mods, self.config.extra.heat_for_mods}}
    end,
    apply = function(self, back)
        for i = 1, self.config.extra.starting_mods do
            G.E_MANAGER:add_event(Event({
                func = function()
                    OPAL.add_mod({type = 'good', unique = true, silent = true, as_starting = true})
                return true end
            }))
        end
        G.GAME.modifiers.opal_heat_for_mods = self.config.extra.heat_for_mods
        G.GAME.modifiers.opal_starting_mods = G.GAME.modifiers.opal_starting_mods and G.GAME.modifiers.opal_starting_mods + 2 or 2
    end
}
end