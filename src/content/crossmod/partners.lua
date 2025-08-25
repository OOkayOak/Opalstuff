Partner_API = SMODS.Mods['partner']

if (Partner_API or {}).can_load then
Partner_API.Partner{ -- The Stack
    key = "stack",
    atlas = "partnerAnimAtlas",
    pos = {x = 0, y = 0},
    blind_animated = true,
    config = {extra = {xmult = 3}},
    individual_quips = true,
    loc_vars = function(self,info_queue,card)
        info_queue[#info_queue+1] = {key = "opal_stacked", set = "Other", vars = {}}
        return{vars = {card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local unstacked_cards = {}
            for k, v in ipairs(context.scoring_hand) do
                if not v.ability.opal_stacked then
                    unstacked_cards[#unstacked_cards+1] = v
                end
            end
            if #unstacked_cards > 0 then
                local card_to_stack = pseudorandom_element(unstacked_cards, pseudoseed("pnr_stack"))
                G.E_MANAGER:add_event(Event({func = function()
                    card_to_stack.ability.opal_stacked = true
                    play_sound('card1')
                    card_to_stack:juice_up(0.8)
                return true end}))
                delay(0.7)
            end
            return{
                    message = localize{type = "variable", key = "a_xmult", vars = {card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult
                }
        end
    end
}

Partner_API.Partner{ -- The Snake
    key = "snake",
    atlas = "partnerAnimAtlas",
    blind_animated = true,
    pos = {x = 0, y = 1},
    config = {extra = {cards = 3}},
    individual_quips = false,
    calculate = function(self, card, context)
    end,
    loc_vars = function(self,info_queue,card)
        return{vars = {card.ability.extra.cards}}
    end
}

Partner_API.Partner{ -- The Keyhole
    key = "keyhole",
    atlas = "partnerAnimAtlas",
    blind_animated = true,
    pos = {x = 0, y = 2},
    config = {extra = {blind_size = 0.75}},
    individual_quips = false,
    loc_vars = function(self,info_queue,card)
        return{vars = {card.ability.extra.blind_size}}
    end,
    calculate = function(self, card, context)
    end,
    calculate_begin = function(self, card)
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * card.ability.extra.blind_size
    end
}

Partner_API.Partner{ -- The Branch
    key = "branch",
    atlas = "partnerAnimAtlas",
    blind_animated = true,
    pos = {x = 0, y = 3},
    config = {extra = {odds = 4, xmult = 1, xmult_mod = 0.25}},
    individual_quips = false,
    loc_vars = function(self,info_queue,card)
        return{vars = {(G.GAME.probabilities.normal or 1), card.ability.extra.odds, card.ability.extra.xmult_mod, card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.before then 
            local handlevel = G.GAME.hands[context.scoring_name].level
            if pseudorandom('opal_branch') < ((G.GAME.probabilities.normal or 1)/card.ability.extra.odds) and handlevel > to_big(1) then
            level_up_hand(card, context.scoring_name, false, -1)
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
            local max_quips = 0
            G.E_MANAGER:add_event(Event({func = function()
                for k, v in pairs(G.localization.misc.quips) do
                    if string.find(k, "pnr_opal_hand_decrease") then
                        max_quips = max_quips + 1
                    end
                end
                card:juice_up(0.8)
                card:add_partner_speech_bubble("pnr_opal_hand_decrease_"..math.random(1, max_quips))
                card:partner_say_stuff(5)
            return true end}))
            end
        end
        if context.joker_main and card.ability.extra.xmult > 1 then
            return{
                    message = localize{type = "variable", key = "a_xmult", vars = {card.ability.extra.xmult}},
                    Xmult_mod = card.ability.extra.xmult
                }
        end
    end
}

Partner_API.Partner{ -- The Rampart
    key = "rampart",
    atlas = "partnerAnimAtlas",
    blind_animated = true,
    pos = {x = 0, y = 4},
    config = {extra = {joker_slots = 2, blind_size = 2}},
    individual_quips = false,
    loc_vars = function(self,info_queue,card)
        return{vars = {card.ability.extra.joker_slots, card.ability.extra.blind_size}}
    end,
    calculate = function(self, card, context)
    end,
    calculate_begin = function(self, card)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.joker_slots
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * card.ability.extra.blind_size
    end
}

CRYPTID = SMODS.Mods['Cryptid']
if (CRYPTID or {}).can_load then

    function opal_cap_score(score)
        if G.GAME.blind.name == G.P_BLINDS['bl_cry_tax'].name and not G.GAME.blind.disabled then return math.floor(math.min(score, 0.4*G.GAME.blind.chips)) end
        return math.floor(math.min(score, (G.GAME.selected_partner_card.ability.extra.max_score)*G.GAME.blind.chips))
    end

    function opal_return_score(score)
        if G.GAME.modifiers.opal_tariff then 
            return opal_cap_score(math.floor(score))
        elseif G.GAME.blind.cry_cap_score then
            return G.GAME.blind:cry_cap_score(math.floor(hand_chips*mult))
        else
            return math.floor(hand_chips*mult)
        end
    end

    Partner_API.Partner{ -- The Tariff
    key = "tariff",
    atlas = "partnerAnimAtlas",
    blind_animated = true,
    pos = {x = 0, y = 5},
    config = {extra = {reward_mult = 2,max_score = 0.7}},
    individual_quips = true,
    loc_vars = function(self,info_queue,card)
        return{vars = {card.ability.extra.reward_mult,card.ability.extra.max_score*100}}
    end,
    calculate = function(self, card, context)
    end,
    calculate_begin = function(self, card)
        G.GAME.modifiers.opal_tariff = true
    end
    }
end


local game_update_ref = Game.update
opal_pnr_dt = 0
function Game:update(dt) --animated blind partner implementation
    game_update_ref(self, dt)
    opal_pnr_dt = opal_pnr_dt + dt
    if G.P_CENTERS and G.P_CENTERS.pnr_opal_stack and opal_pnr_dt > 0.095 then
        opal_pnr_dt = 0
        for k, v in pairs(G.P_CENTERS) do
            local obj = nil
            if v.blind_animated then
                local obj = v
                obj.atlas = obj.atlas or "partnerAnimAtlas"
                if obj.pos.x < 20 then
                    obj.pos.x = obj.pos.x + 1
                else
                    obj.pos.x = 0
                end
            end
        end
    end
end

local set_blind_ref = Blind.set_blind
function Blind:set_blind(blind, reset, silent)
    local result = set_blind_ref(self, blind, reset, silent)
    if G.GAME.selected_partner == "pnr_opal_keyhole" and not reset then 
        self.hands_sub = G.GAME.round_resets.hands - 1
        ease_hands_played(-self.hands_sub)
    end
    if G.GAME.selected_partner == "pnr_opal_tariff" and not reset then
        self.dollars = self.dollars * G.GAME.selected_partner_card.ability.extra.reward_mult
    end
    return result
end
end