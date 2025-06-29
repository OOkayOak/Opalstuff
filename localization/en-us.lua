return{
    descriptions = {
        Joker = {
            j_opal_joost = {
                name = "Joost Joker",
                text = {
                    "Retriggers final {C:attention}card ",
                    "in played hand"
                }
            },
            j_opal_hardlight = {
                name = "Hardlight",
                text = {
                    "When selecting {C:attention}Blind{}, create a",
                    "{C:dark_edition}Negative{} Temporary copy of",
                    "a random owned {C:attention}Joker",
                    "{C:inactive,s:0.8}(Removed at end of round, excludes Hardlight)"
                }
            },
            j_opal_shiny_rock = {
                name = "Shiny Rock",
                text = {
                    '{C:green}#1# in #2#{} chance to give',
                    'a playing card an {C:dark_edition}Edition',
                    'when scored'
                }
            },
            j_opal_intrusive = {
                name = 'Intrusive Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red} Debuffs all Diamonds{}'
                }
            },
            j_opal_egocentric = {
                name = 'Egocentric Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red} Debuffs all Hearts{}'
                }
            },
            j_opal_irritating = {
                name = 'Irritating Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red} Debuffs all Spades{}'
                }
            },
            j_opal_wreckless = {
                name = 'Intrusive Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red} Debuffs all Clubs{}'
                }
            }
        },
        Other = {
            opal_bound = {
                name = 'Bound',
                text = {
                    "While in Hand, {C:attention}-1 Hand size,",
                    "discard excess card"

                }
            },
            opal_chewed = {
                name = "Chewed",
                text = {
                    "When played, lose {C:money}$#1#{}"
                }
            },
            opal_hooked = {
                name = "Hooked",
                text = {
                    "When played, discard",
                    "a card held in hand"
                }
            },
            opal_overgrown = {
                name = "Overgrown",
                text = {
                    "This card is Debuffed",
                    "{s:0.8}Only on Face Cards"
                }
            },
            opal_ringing = {
                name = "Ringing",
                text = {
                    "One Ringing card is",
                    "randomly force-selected"
                }
            },
            opal_stacked = {
                name = "Stacked",
                text = {
                    "When scored, debuff",
                    "for rest of Ante"
                }
            },
            opal_trampled = {
                name = "Trampled",
                text = {
                    "When part of {C:attention}#1#,",
                    "{C:money}Money{} multiplied by {X:money,C:white}X#2#"
                }
            }
        },
        Partner = {
            pnr_opal_snake = {
                name = "The Snake",
                text = {
                    "{X:red,C:white}X#1#{} Mult, always draw",
                    "{C:attention}#2#{} cards after play or discard"
                }
            },
            pnr_opal_stack = {
                name = "The Stack",
                text = {
                    "{X:red,C:white}X#1#{} Mult, applies {C:attention,T:opal_stacked}Stacked{}",
                    "to a random card in played {C:attention}Hand"
                }
            },
        }
    },
    misc = {
        challenge_names = {
            c_opal_blind_stickers_1 = "Blind Stickers",
            c_opal_debuffs_1 = "Oops! All Debuffs",
            c_opal_dupes_1 = "Mirage",
            c_opal_pillar_1 = "Stack",
            c_opal_pillar_2 = "Pillar",
            c_opal_pillar_3 = "Obelisk",
        },
        labels = {
            opal_bound = "Bound",
            opal_chewed = "Chewed",
            opal_hooked = "Hooked",
            opal_overgrown = "Overgrown",
            opal_ringing = "Ringing",
            opal_stacked = "Stacked",
            opal_trampled = "Trampled"
            
        },
        v_text = {
            ch_c_opal_all_pillars = {"Every {C:attention}Boss Blind{} is {C:attention}The Pillar"},
        },
        quips = {
            pnr_opal_stack_1 = {
                "Pilar"
            },
            pnr_opal_stack_2 = {
                "Oblisk"
            },
            pnr_opal_stack_3 = {
                "Ston"
            },
            pnr_opal_stack_4 = {
                "Rook"
            },
            pnr_opal_pillar_reaction_1 = {
                "What the fuck. No.",
                "No, no, no. That's not me."
            },
            pnr_opal_pillar_reaction_2 = {
                "Holy fuck. This cannot be",
                "fucking happening. Who the",
                "fuck are you."
            },
            pnr_opal_pillar_reaction_3 = {
                "What."
            }
        }
    }
}