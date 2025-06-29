SMODS.Joker{ --Joost
    key = "joost",
    atlas = "jokerAtlas", pos = {x=0,y=0},
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.repetition and not context.repetition_only then
            if context.other_card == context.scoring_hand[#context.scoring_hand] then
                return {
                    message = localize ("k_again_ex"),
                    repetitions = 1,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker{ --Hardlight
    key = "hardlight",
    atlas = "jokerAtlas", pos = {x=0, y=1},
    soul_pos = {x=1, y=1},
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    config = {duplicator = true},
    calculate = function(self, card, context)
        if context.end_of_round then
            if G.GAME.opal_dupes > 0 then
                for k, v in ipairs(G.jokers.cards) do
                    if v.ability.dupe then
                        G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                        G.E_MANAGER:add_event(Event({func = function()
                            G.GAME.joker_buffer = 0
                            v:start_dissolve()
                            return true end }))
                        G.GAME.opal_dupes = G.GAME.opal_dupes - 1
                    end
                end
            end
        end
        if context.setting_blind then
            local can_duplicate = {} --these cards can be duplicated!!!
            for k, v in ipairs(G.jokers.cards) do
                if not (v.ability.duplicator or v.ability.dupe or ((SMODS.Mods.ChDp or {}).can_load and v.ability.chdp_singular)) then
                    can_duplicate[#can_duplicate+1] = v
                end
            end
            if #can_duplicate > 0 then
                G.GAME.opal_dupes = G.GAME.opal_dupes + 1 
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    func = function()
                        local chosen = pseudorandom_element(can_duplicate, pseudoseed("opal_hardlight"))
                        local addcard = copy_card(chosen, nil, nil, nil, chosen.edition and chosen.edition.negative)
                        addcard:add_to_deck()
                        G.jokers:emplace(addcard)
                        addcard.ability.dupe = true
                        addcard:set_edition{negative = true}
                        addcard:set_eternal(false)
                        addcard:start_materialize()
                        addcard.sell_cost = 0
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Bamboozled!', colour = G.C.CHIPS})
            end
        end
    end
}

SMODS.Joker { --Shiny Rock
    key = 'shiny_rock',
    config = { extra = {odds = 20}},
    rarity = 2,
    atlas = 'jokerAtlas',
    pos = {x = 1, y = 0},
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
      return { vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds}}
    end,
    calculate = function(self, card, context)
        if context.cardarea == G.play then
            local chosencard = context.other_card
            if chosencard and not chosencard.edition and not chosencard.being_opaled and pseudorandom('opal') < (G.GAME.probabilities.normal or 1)/card.ability.extra.odds then
                chosencard.being_opaled = true
                G.E_MANAGER:add_event(Event({func = function()
                    local edition = poll_edition("opal", nil, true, true)
                    chosencard:set_edition(edition, true)
                return true end }))
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = 'Edition!', colour = G.C.TAROT})
            end
        end
    end
  }

SMODS.Joker { --Intrusive Joker
    key = 'intrusive',
    config = { extra = { Xmult = 2 }},
    rarity = 3,
    atlas = 'jokerAtlas',
    pos = { x = 2, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
      for k, v in ipairs(G.playing_cards) do
        if v:is_suit('Diamonds') then
          v.debuff = true
        end
      end
      if context.joker_main then
        return {
          Xmult_mod = card.ability.extra.Xmult,
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
        }
      end
    end
}
  
SMODS.Joker { --Egocentric Joker
    key = 'egocentric',
    config = { extra = { Xmult = 2 }},
    rarity = 3,
    atlas = 'jokerAtlas',
    pos = { x = 3, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
      for k, v in ipairs(G.playing_cards) do
        if v:is_suit('Hearts') then
          v.debuff = true
        end
      end
      if context.joker_main then
        return {
          Xmult_mod = card.ability.extra.Xmult,
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
        }
      end
    end
}
  
SMODS.Joker {--Irritating Joker
    key = 'irritating',
    config = { extra = { Xmult = 2 }},
    rarity = 3,
    atlas = 'jokerAtlas',
    pos = { x = 4, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
      for k, v in ipairs(G.playing_cards) do
        if v:is_suit('Spades') then
          v.debuff = true
        end
      end
      if context.joker_main then
        return {
          Xmult_mod = card.ability.extra.Xmult,
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
        }
      end
    end
}
  
SMODS.Joker {--Wreckless Joker
    key = 'wreckless',
    config = { extra = { Xmult = 2 }},
    rarity = 3,
    atlas = 'jokerAtlas',
    pos = { x = 5, y = 0 },
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.Xmult }}
    end,
    calculate = function(self, card, context)
      for k, v in ipairs(G.playing_cards) do
        if v:is_suit('Clubs') then
          v.debuff = true
        end
      end
      if context.joker_main then
        return {
          Xmult_mod = card.ability.extra.Xmult,
          message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.Xmult } }
        }
      end
    end
}