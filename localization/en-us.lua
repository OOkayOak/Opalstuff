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
                    '{C:red}Debuffs{} all {C:diamonds}Diamonds'
                }
            },
            j_opal_egocentric = {
                name = 'Egocentric Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red}Debuffs{} all {C:hearts}Hearts'
                }
            },
            j_opal_irritating = {
                name = 'Irritating Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red}Debuffs{} all {C:spades}Spades'
                }
            },
            j_opal_wreckless = {
                name = 'Intrusive Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red}Debuffs{} all {C:clubs}Clubs'
                }
            },
            j_opal_indulgent = {
                name = 'Indulgent Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red}Debuffs{} all {C:minty_3s}3s{}'
                }
            },
            j_opal_emulous = {
                name = 'Emulous Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red}Debuffs{} all {C:bunc_fleurons}Fleurons'
                }
            },
            j_opal_flamboyant = {
                name = 'Flamboyant Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red}Debuffs{} all {C:bunc_halberds}Halberds'
                }
            },
            j_opal_dissident = {
                name = 'Dissident Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red}Debuffs{} all {C:paperback_stars}Stars'
                }
            },
            j_opal_deceptive = {
                name = 'Deceptive Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{C:red}Debuffs{} all {C:paperback_crowns}Crowns'
                }
            },
            j_opal_kimochi_warui = {
                name = 'Kimochi Warui',
                text = {
                    'When first Hand is drawn, removes a {C:attention}Sticker{} from',
                    'random {C:attention}Joker{}, {C:green}#1# in #2#{} chance to add a {C:attention}Sticker{}',
                    'to random {C:attention}Playing Card{} held in Hand'
                }
            },
            j_opal_holy_holy = {
                name = 'Holy, Holy',
                text = {
                    'Gains {C:chips}+#1#{} Chips when',
                    '{C:attention,T:c_magician}The Magician{} is used',
                    '{C:inactive,s:0.8}(Currently {C:chips,s:0.8}+#2#{C:inactive,s:0.8})'
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
            },
            opal_pillar_sticker = {
                name = "Pillar Stake",
                text = {
                    "Used this Joker to win",
                    "on Pillar Stake"
                }
            }
        },
        Partner = {
            pnr_opal_branch = {
                name = "The Branch",
                text = {
                    "{C:green}#1# in #2#{} chance to decrease level",
                    "of played Poker Hand, and gain {X:red,C:white}X#3#{}",
                    "{C:inactive,s:0.8}(Currently gives {X:red,C:white,s:0.8}X#4#{C:inactive,s:0.8})"
                }
            },
            pnr_opal_keyhole = {
                name = "The Keyhole",
                text = {
                    "Blind Requirement {C:red}X#1#",
                    "Only 1 Hand per round"
                }
            },
            pnr_opal_rampart = {
                name = "The Rampart",
                text = {
                    "{X:dark_edition,C:white}+#1#{} Joker Slots,",
                    "{C:red}X#2#{} Blind Requirement"
                }
            },
            pnr_opal_snake = {
                name = "The Snake",
                text = {
                    "Always draw {C:attention}#1#{} cards",
                    "after Play or Discard"
                }
            },
            pnr_opal_stack = {
                name = "The Stack",
                text = {
                    "{X:red,C:white}X#1#{} Mult, applies {C:attention,T:opal_stacked}Stacked{}",
                    "to a random card in played {C:attention}Hand"
                }
            },
            pnr_opal_tariff = {
                name = "The Tariff",
                text = {
                    "Blind Rewards {X:money,C:white}X#1#{},",
                    "Max score per {C:blue}Hand{} is {C:red}#2#%{} of",
                    "Blind Requirement"
                }
            },
        },
        Stake = {
            stake_opal_pillar = {
                name = "Pillar Stake",
                text = {
                    "Cards previously scored in an Ante",
                    "are debuffed for that Ante",
                    "{s:0.8,C:inactive}({C:dark_edition,s:0.8}Opalstuff{s:0.8,C:inactive} Stake)"
                }
            }
        }
    },
    misc = {
        challenge_names = {
            c_opal_debuffs_1 = "Oops! All Debuffs",
            c_opal_dupes_1 = "Mirage",
            c_opal_stickers_1 = "Blind Stickers",
            c_opal_stickers_2 = "Stick it to the... Hand",
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
            ch_c_opal_pillar = {"{C:attention}Played Cards{} are {C:red}debuffed{} until the end of the Ante"},
            ch_c_pillar_quip = {"{C:inactive,s:0.8}Wait... {C:attention,s:0.8}The Pillar{C:inactive,s:0.8}? Is that you?"},
            ch_c_pillar_quip_2 = {"{C:attention,s:0.8}The Pillar{C:inactive,s:0.8}! It really is you!"},
            ch_c_pillar_quip_3 = {"{C:inactive,s:0.8}... What the fuck?"}
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
            pnr_opal_tariff_1 = {
                "Make this quick, I've got",
                "a meeting in 30, 'kay?"
            },
            pnr_opal_tariff_2 = {
                "Hey, no funny business."
            },
            pnr_opal_tariff_3 = {
                "Y'know Joker stocks are in",
                "decline, right? No? Ugh..."
            },
            pnr_opal_tariff_4 = {
                "Another run? Really? I don't...",
                "eh, whatever."
            },
            pnr_opal_pillar_reaction_1 = { -- Used for the Stack reacting to the Pillar
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
            },
            pnr_opal_tax_reaction_1 = { -- Used for the Tariff, reacting to the Tax
                "Who the fuck does this",
                "guy think they are?"
            },
            pnr_opal_tax_reaction_2 = {
                "C'mon, I'm trying to",
                "do something here!"
            },
            pnr_opal_tax_reaction_3 = {
                "Urgh... I hate this guy."
            },
            pnr_opal_hand_decrease_1 = { -- Used for the Branch
                "Yummers."
            },
            pnr_opal_hand_decrease_2 = {
                "Thanks for the meal!"
            },
            pnr_opal_hand_decrease_3 = {
                "I was so hungry...",
                "Thank you!"
            }
        }
    }
}