if JokerDisplay then
    local jd_def = JokerDisplay.Definitions
    jd_def['j_opal_hardlight'] = {
        reminder_text = {
            { text = "(" },
            { ref_table = "card.ability.extra", ref_value = "last_dupe", colour = G.C.ORANGE },
            { text = ")" }
        },
        calc_function = function(card)
        end
    }
    jd_def['j_opal_shiny_rock'] = {
        extra = {
            {{ text = '(' },
            { ref_table = 'card.joker_display_values', ref_value = 'odds' },
            { text = ')' }}
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function = function(card)
            local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'shiny_rock')
            card.joker_display_values.odds = localize {type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }
    jd_def['j_opal_holy_holy'] = {
        text = {
            {text = '+', colour = G.C.CHIPS},
            {ref_table = 'card.joker_display_values', ref_value = 'chips', retrigger_type = 'mult', colour = G.C.CHIPS},
            {text = ', '},
            {text = '+', colour = G.C.MULT},
            {ref_table = 'card.joker_display_values', ref_value = 'mult', retrigger_type = 'mult', colour = G.C.MULT}
        },
        calc_function = function(card)
            card.joker_display_values.chips = card.ability.extra.chip_mod * card.ability.extra.count
            card.joker_display_values.mult = card.ability.extra.mult_mod * card.ability.extra.count
        end
    }
    jd_def['j_opal_high_roller'] = {
        text = {
            { text = '+', colour = G.C.ORANGE },
            { ref_table = 'card.ability.extra', ref_value = 'handsize_mod', colour = G.C.ATTENTION }
        },
        reminder_text = {
            { text = '('},
            { ref_table = 'card.ability.extra', ref_value = 'rerolls_left'},
            { text = '/'},
            { ref_table = 'card.ability.extra', ref_value = 'rerolls_required'},
            { text = ')'}
        },
    }
end