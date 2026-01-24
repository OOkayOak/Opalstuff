if CardSleeves then
   CardSleeves.Sleeve{
    key = 'opals',
    atlas = 'sleeveAtlas', pos = {x=0, y=0},
    config = {extra = {opalstuff_cards = nil, triggered = false}},
    unlocked = false,
    unlock_condition = {deck = 'b_opal_opals_stuff', stake = 'stake_opal_sour'},
    loc_vars = function(self)
        local key = self.key
        if self.get_current_deck_key() == "b_opal_opals_stuff" then
            key = key.."_alt"
            self.config.extra = {opalstuff_deck = true}
        else
            key = key
        end
        return { key = key }
    end,
    apply = function(self, sleeve)
        CardSleeves.Sleeve.apply(self)
        if self.get_current_deck_key() == "b_opal_opals_stuff" then
            print("Opal's Stuff!!!")
        else
            self.config.extra.opalstuff_cards = OPAL.get_stuff()
        end
    end,
    calculate = function(self, sleeve, context)
        if context.end_of_round and not self.config.extra.opalstuff_deck then
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
            if #item_area.cards < item_area.config.card_limit and
            self.config.extra.triggered == false then
                self.config.extra.triggered = true
                G.E_MANAGER:add_event(Event({trigger = 'after', func = function()
                    local opalstuff_card = create_card(opalstuff_item.type, item_area, nil, nil, nil, nil, opalstuff_item.key, 'opal_opals_stuff')
                    opalstuff_card:add_to_deck()
                    item_area:emplace(opalstuff_card)
                return true end}))
            end
        end
        if context.setting_blind and not self.config.extra.opalstuff_deck then
            self.config.extra.triggered = false
        end
    end,
   }

   CardSleeves.Sleeve{
    key = 'cookie',
    atlas = 'sleeveAtlas', pos = {x=1, y=0},
    config = {extra = {cookies_to_create = 2, card_keys = nil, triggered = false}},
    unlocked = false,
    unlock_condition = {deck = 'b_opal_cookie', stake = 'stake_opal_sour'},
    loc_vars = function(self)
        local key = self.key
        local vars = {}
        if self.get_current_deck_key() == "b_opal_cookie" then
            key = key.."_alt"
            self.config.extra = {odds = 3}
            vars = {1, localize{type = 'name_text', set = 'Enhanced', key = 'm_opal_cookie'}, self.config.extra.odds}
        else
            key = key
            vars = {self.config.extra.cookies_to_create, localize{type = 'name_text', set = 'Enhanced', key = 'm_opal_cookie'}}
        end
        return { key = key, vars = vars }
    end,
    apply = function(self, sleeve)
        CardSleeves.Sleeve.apply(self)
        if self.get_current_deck_key() == "b_opal_cookie" then
            G.GAME.starting_params.opal_cookies = true
        end
    end,
    calculate = function(self, sleeve, context)
        if context.end_of_round and not (self.config.extra.triggered or self.get_current_deck_key() == "b_opal_cookie") then
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
        if context.setting_blind and not self.get_current_deck_key() == "b_opal_cookie" then
            self.config.extra.triggered = false
        end
    end,
   }

   CardSleeves.Sleeve{
    key = 'modified',
    atlas = 'sleeveAtlas', pos = { x=2,y=0 },
    unlocked = false,
    unlock_condition = {deck = 'b_opal_modified', stake = 'stake_opal_sour'},
    config = {extra = {starting_mods = 2, heat_for_mods = 5}},
    loc_vars = function(self, info_queue, sleeve)
        local key = self.key
        local vars = {}
        if self.get_current_deck_key() == "b_opal_modified" then
            key = key.."_alt"
            self.config.extra = {starting_mods = 2, heat_inc = 2, triggered = false}
            vars = {self.config.extra.starting_mods, self.config.extra.heat_inc}
        else
            key = key
            vars = {self.config.extra.starting_mods,  self.config.extra.heat_for_mods}
        end
        return { key = key, vars = vars }
    end,
    apply = function(self, sleeve)
        for i = 1, self.config.extra.starting_mods do
            G.E_MANAGER:add_event(Event({
                func = function()
                    OPAL.add_mod({type = 'good', unique = true, silent = true, as_starting = true})
                return true end
            }))
        end
        if not self.get_current_deck_key() == "b_opal_modified" then G.GAME.modifiers.opal_heat_for_mods = self.config.extra.heat_for_mods
        else G.GAME.modifiers.opal_heat_per_round = self.config.extra.heat_inc end
        G.GAME.modifiers.opal_starting_mods = G.GAME.modifiers.opal_starting_mods and G.GAME.modifiers.opal_starting_mods + 2 or 2
    end
}
end