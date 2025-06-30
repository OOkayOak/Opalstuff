Partner_API = SMODS.Mods['partner']

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
    calculate_begin = function(self, card)
        G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * card.ability.extra.blind_size
    end
}

local game_update_ref = Game.update
opal_pnr_dt = 0
function Game:update(dt) --animated blind partner implementation
    game_update_ref(self, dt)
    opal_pnr_dt = opal_pnr_dt + dt
    if G.P_CENTERS and G.P_CENTERS.pnr_opal_stack and G.P_CENTERS.pnr_opal_snake and opal_pnr_dt > 0.095 then
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
    return result
end