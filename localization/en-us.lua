return{
    descriptions = {
        Back = {
            b_opal_opals_stuff = {
                name = "Opal's Stuff",
                text = {
                    "When a {C:attention}Blind{} is defeated,",
                    "obtain a random {C:opal_pink}Opalstuff{C:attention} Joker{}",
                    "or {C:attention}Consumable",
                    "{C:inactive,s:0.8}(Must have room)"
                }
            },
            b_opal_cookie = {
                name = "Cookie Deck",
                text = {
                    "When a {C:attention}Blind{} is defeated,",
                    "creates {C:attention}#1# {C:attention,T:m_opal_cookie}#2#{}{C:attention}s",
                }
            },
            b_opal_modified = {
                name = "Modified Deck",
                text = {
                    "Begin with {C:attention}#1# {C:opal_pink}Modifiers",
                    "Gain a new {C:opal_pink}Modifier{C:attention} every",
                    "{C:attention}#2# Heat"
                }
            }
        },
        Blind = {
            bl_opal_stinger = {
                name = 'The Stinger',
                text = {
                    "Destroys a random card",
                    "in played Hand",
                }
            },
            bl_opal_overload = {
                name = 'The Overload',
                text = {
                    "Disables a random Modifier",
                    "per Hand"
                }
            }
        },
        Enhanced = {
            m_opal_cookie = {
                name = 'Cookie Card',
                text = {
                    'When played, {C:green}#1# in #2#{} chance to',
                    "{C:attention}rescore{} played cards",
                    '{C:inactive}(except #5#s){}, destroys',
                    'in {C:attention}#3#{C:inactive} (#4#){} triggers'
                    
                }
            }
        },
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
                    '{X:mult,C:white}-X#2#{} for each {C:diamonds}Diamond{} drawn'
                }
            },
            j_opal_egocentric = {
                name = 'Egocentric Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{X:mult,C:white}-X#2#{} for each {C:hearts}Heart{} drawn'
                }
            },
            j_opal_irritating = {
                name = 'Irritating Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{X:mult,C:white}-X#2#{} for each {C:spades}Spade{} drawn'
                }
            },
            j_opal_wreckless = {
                name = 'Wreckless Joker',
                text = {
                    '{X:mult,C:white}X#1# {} Mult',
                    '{X:mult,C:white}-X#2#{} for each {C:clubs}Club{} drawn'
                }
            },
            j_opal_kimochi_warui = {
                name = 'Kimochi Warui',
                text = {{
                    'When first Hand is drawn, removes',
                    'a {C:attention}Sticker{} from a random',
                    'owned {C:attention}Joker'
                },
                {
                    'When triggered, {C:green}#1# in #2#{} chance to',
                    'add a {C:attention}Sticker{} to a random',
                    '{C:attention}Playing Card{} held in Hand'
                }}
            },
            j_opal_holy_holy = {
                name = 'Holy, Holy',
                text = {
                    'Gains {C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult when',
                    '{C:attention,T:c_magician}The Magician{} is used',
                    '{C:inactive,s:0.8}(Currently {C:chips,s:0.8}+#3#{C:inactive,s:0.8} and {C:mult,s:0.8}+#4#{C:inactive,s:0.8})'
                }
            },
            j_opal_potluck = {
                name = 'Oops! All 1/3s',
                text = {
                    '{C:green}+#1#{} to all listed',
                    '{C:green,E:1,S:1.1}probabilities',
                    '{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}1.33 in 3{C:inactive})'
                }
            },
            j_opal_cultist = {
                name = 'Cultist',
                text = {
                    'A Bonus {C:attention}Spectral{} Card will',
                    'appear in every {C:attention}Arcana Pack'
                }
            },
            j_opal_rolodex = {
                name = 'Rolodex',
                text = {
                    '{C:attention}+1{} Hand Size every',
                    '{C:attention}#1# {C:inactive}(#2#){} Shop Rerolls this Ante',
                    '{C:inactive}(Currently {C:attention}+#3#{C:inactive} Hand Size)'
                }
            },
            j_opal_corkboard = {
                name = 'Corkboard',
                text = {
                    '{C:attention}Jokers{} with {C:attention}Stickers',
                    'each give {X:mult,C:white}X#1#{} Mult'
                }
            },
            j_opal_grandma = {
                name = 'Grandma',
                text = {
                    'This Joker gains {C:mult}#1#{} Mult',
                    'every time a {C:attention,T:m_opal_cookie}#2#{}',
                    '{C:green}successfully{} triggers',
                    '{C:inactive}(Currently {C:mult}#3#{C:inactive} Mult)'
                }
            },
            j_opal_biscuit_tin = {
                name = 'Biscuit Tin',
                text = {
                    'Retrigger all',
                    '{C:attention,T:m_opal_cookie}#1#{}{C:attention}s',
                }
            },
            j_opal_coffee = {
                name = 'Flat White',
                text = {{
                            'The next {C:attention}#1# {C:attention,T:m_opal_cookie}#2#{}{C:attention}#3#',
                            'are {C:red}destroyed{} after scoring'
                        },
                        {
                            'For each {C:attention}#2#{} destroyed', 
                            'by this Joker, create a',
                            'random {C:attention}Tag'
                        }}
            },
            j_opal_sombre = {
                name = 'Sombre Joker',
                text = {

                }
            },
            j_opal_wonkee = {
                name = 'Wonkee Loves U',
                text = {
                    'When #3# {C:hearts}Hearts{} are played,',
                    '{C:attention}duplicate #1#{} at random and',
                    '{C:attention}add new #2#{} to deck'
                }
            },
            j_opal_hot_chip = {
                name = 'Hot Chip',
                text = {
                    '{C:red}+#1# Heat{} at {C:attention}end',
                    '{C:attention}of round, {C:red}-#2#',
                    'when {C:attention}triggered'
                }
            },
            j_opal_alive = {
                name = 'Alive 2007',
                text = {
                    'Prevents death {C:attention}once,',
                    'removes {C:red}#1#% of Modifiers',
                    'and {E:1,C:red}self-destructs',
                    '{S:0.8,C:inactive}(Can remove up to #2#)'
                }
            },
            j_opal_bottle = {
                name = 'Hot Water Bottle',
                text = {
                    'Gives {C:mult}+1{} Mult for every',
                    '{C:attention}#1#{} Heat',
                    '{C:inactive,S:0.8}(Currently {C:mult,S:0.8}+#2#{C:inactive,S:0.8})'
                }
            },
            j_opal_overseer = {
                name = "Philosopher's Stone",
                text = {
                    'When {C:attention}using{} a {C:spectral}Spectral{} card,',
                    '{C:green}#1# in #2#{} chance to create',
                    'a {C:green}positive {C:opal_pink}Modifier'
                }
            },
            j_opal_party_mix = {
                name = 'Party Mix',
                text = {{
                        '{C:green}#1# in #2#{} chance to give',
                        '{C:chips}+#3#{} Chips, {C:mult}+#4#{} Mult',
                        'or {C:money}+$#5#{C:inactive,S:0.8} (randomly)',
                        'when played to each',
                        '{C:attention}scored card{} in played hand',
                    },
                    {
                        'Can trigger for {C:attention}#6#{} more',
                        'hands'
                    }
                }
            }
        },
        OpalModifier = {
            md_opal_recycler = {
                name = 'Recycler',
                text = {
                    '{C:money}+$#1#{} per {C:attention}Discard',
                    'at end of round'
                }
            },
            md_opal_handheld = {
                name = 'Handheld',
                text = {
                    '{C:money}+$#1#{} per {C:attention}Hand',
                    'at end of round'
                }
            },
            md_opal_hilarious = {
                name = 'Punchline',
                text = {
                    '{C:attention}+1{} Joker Slot'
                }
            },
            md_opal_astronomy = {
                name = 'Astronomy',
                text = {
                    'Level up played {C:attention}poker hand',
                    'every {C:attention}#1#{C:inactive} (#2#){} hands played'
                }
            },
            md_opal_running_yolk = {
                name = 'Running Yolk',
                text = {
                    'Jokers with Scaling {V:1}#1#{}',
                    'gain {C:attention}twice{} as much'
                }
            },
            md_opal_rigged = {
                name = 'Rigged',
                text = {
                    '{X:green,C:white}X#1#{} to all listed',
                    '{C:green,E:1,S:1.1}probabilities',
                    '{C:inactive}(ex: {C:green}1 in 3{C:inactive} -> {C:green}1.5 in 3{C:inactive})'
                }
            },
            md_opal_sticky = {
                name = 'Sticky',
                text = {
                    'Cards can appear',
                    'with {C:attention}#1#'
                }
            },
            md_opal_skipless = {
                name = 'Skipless',
                text = {
                    'Skipping is {C:red}disabled',
                    'Until {C:attention}#1#'
                }
            },
            md_opal_raiser = {
                name = 'Raiser',
                text = {
                    'Enable the effects of',
                    '{C:attention}#1#',
                    '{C:inactive}(Does not apply other Stakes)'
                }
            },

            -- Informational Modifiers
            md_opal_info_opal_enable_bl_stickers = {
                name = 'Blind Stickers',
                text = {
                    '{C:attention}Blind Stickers{} with max',
                    'rarity {C:attention}#1#{} may appear'
                }
            },
            md_opal_info_opal_blinds_give_stickers = {
                name = 'Blinds Give Stickers',
                text = {
                    '{C:attention}Blinds{} give their respective',
                    '{C:attention}Blind Stickers{} to all cards',
                    'in winning Hand when defeated',
                    '{C:inactive,s:0.8}(if possible)'
                }
            },
            md_opal_info_opal_disable_skipping = {
                name = 'No Skipping',
                text = {
                    'You {C:red}can not{}',
                    'skip {C:attention}Blinds'
                }
            },
            md_opal_info_opal_pillar = {
                name = 'Pillar Forever',
                text = {
                    '{C:attention}Played Cards{} are',
                    '{C:red}debuffed{} for the rest',
                    'of the {C:attention}Ante'
                }
            },
            md_opal_undiscovered={
                name="Not Discovered",
                text={
                    "Acquire this",
                    "modifier in an",
                    "unseeded run to",
                    "learn what it does",
                },
            },
        },
        Other = {
            opal_bound = {
                name = 'Bound',
                text = {
                    "While in Hand, {C:attention}-1",
                    "Hand Size"

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
                    "This card can never",
                    "count as {C:attention}Face Card"
                }
            },
            opal_prickly = {
                name = "Prickly",
                text = {
                    "{C:red}-1{C:blue} Hand",
                    "when discarded"
                }
            },
            opal_ringing = {
                name = "Ringing",
                text = {
                    "One {C:blue}Ringing{} card is",
                    "randomly {C:attention}force-selected"
                }
            },
            opal_soggy = {
                name = "Soggy",
                text = {
                    "{C:red}-1 Discard",
                    "when played"
                }
            },
            opal_stacked = {
                name = "Stacked",
                text = {
                    "When scored, {C:red}debuff",
                    "for {C:attention}rest of Ante"
                }
            },
            opal_trampled = {
                name = "Trampled",
                text = {
                    "When part of {C:attention}#1#,",
                    "{C:money}Money{} multiplied by {X:money,C:white}X#2#"
                }
            },
            opal_strong = {
                name = 'Strong',
                text = {
                    'Levels {C:red}down {C:attention}last played',
                    'Hand if held in Hand',
                    'at {C:attention}end of round'
                }
            },
            opal_sharp = {
                name = 'Sharp',
                text = {
                    '{X:chips,C:white}X0.9{} Chips and',
                    '{X:mult,C:white}X0.9{} Mult when scored',
                }
            },
            opal_bleeding = {
                name = 'Bleeding',
                text = {
                    'When played, {C:red}debuff{} a',
                    '{C:attention}random Joker{} for the',
                    'rest of the Round'
                }
            },
            opal_venomous = {
                name = 'Venomous',
                text = {
                    'After this card is {C:attention}played{} or',
                    '{C:attention}discarded{}, {C:red}draw 1 less card'
                }
            },
            opal_growing = {
                name = 'Growing',
                text = {
                    'Permanently {C:attention}flipped{} and',
                    'shuffled to {C:attention}left of hand'
                }
            },
            opal_intelligent = {
                name = 'Intelligent',
                text = {
                    'Does not count in {C:attention}Hand',
                    'if played with less than {C:attention}5{} cards',
                    'in played Hand'
                }
            },
            opal_homely = {
                name = 'Homely',
                text = {
                    'If drawn in {C:attention}first Hand,',
                    '{C:attention}flip{} this card'
                }
            },
            opal_envious = {
                name = 'Envious',
                text = {
                    'This card is {C:red}debuffed',
                    'if all {C:attention}Joker Slots',
                    'are full'
                }
            },
            opal_hungry = {
                name = 'Hungry',
                text = {
                    'This card {C:red}will not score',
                    'when played if {C:attention}Hand',
                    'is not {C:attention}#1#'
                }
            },
            opal_witness = {
                name = 'Witness',
                text = {
                    'This card {C:red}will not score',
                    'if played in a {C:attention}Hand',
                    'previously played in Round',
                }
            },
            opal_suspicious = {
                name = 'Suspicious',
                text = {
                    'If {C:attention}drawn{} after a {C:attention}Hand',
                    'played, {C:red}draw face down'
                }
            },
            opal_dizzy = {
                name = 'Dizzy',
                text = {
                    '{C:green}#1# in #2#{} chance',
                    'to {C:red}draw face down'
                }
            },
            opal_brutal = {
                name = 'Brutal',
                text = {
                    "This card can never",
                    "count as a {C:clubs}Club"
                }
            },
            opal_backstabbing = {
                name = 'Backstabbing',
                text = {
                    "This card can never",
                    "count as a {C:spades}Spade"
                }
            },
            opal_insular = {
                name = 'Insular',
                text = {
                    "This card can never",
                    "count as a {C:hearts}Heart"
                }
            },
            opal_pointy = {
                name = 'Pointy',
                text = {
                    "This card can never",
                    "count as a {C:diamonds}Diamond"
                }
            },
            opal_tall = {
                name = 'Tall',
                text = {
                    "When scored, {C:red}increase Blind",
                    "{C:red}Requirement{} by {C:attention}X#1#"
                }
            },
            opal_looming = {
                name = 'Looming',
                text = {
                    "When scored, {C:red}increase Blind",
                    "{C:red}Requirement{} by {C:attention}X#1#"
                }
            },
            opal_stained = {
                name = 'Stained',
                text = {
                    "When scored, {C:attention}flip",
                    "all {C:attention}Face Cards"
                }
            },
            opal_snappy = {
                name = 'Snappy',
                text = {
                    '{C:green}#1# in #2#{} chance',
                    'to be {C:red}destroyed{} when',
                    'played'
                }
            },
            opal_overloaded = {
                name = 'Overloaded',
                text = {
                    'When played, {C:red}debuff{} a',
                    '{C:attention}random Modifier{} for the',
                    'rest of the Round'
                }
            },

            opal_double_down_sticker = {
                name = "Double Down Stake",
                text = {
                    "Used this Joker to win",
                    "on Double Down Stake"
                }
            },
            opal_heavy_sticker = {
                name = "Heavy Stake",
                text = {
                    "Used this Joker to win",
                    "on Heavy Stake"
                }
            },
            opal_hyperdeath_sticker = {
                name = "Stake of Hyperdeath",
                text = {
                    "Used this Joker to win",
                    "on Stake of Hyperdeath"
                }
            },
            opal_pillar_sticker = {
                name = "Pillar Stake",
                text = {
                    "Used this Joker to win",
                    "on Pillar Stake"
                }
            },
            opal_reject_sticker = {
                name = "Reject Stake",
                text = {
                    "Used this Joker to win",
                    "on Reject Stake"
                }
            },
            opal_sour_sticker = {
                name = "Sour Stake",
                text = {
                    "Used this Joker to win",
                    "on Sour Stake"
                }
            },
            opal_travel_sticker = {
                name = "Travel Stake",
                text = {
                    "Used this Joker to win",
                    "on Travel Stake"
                }
            },
            opal_quantum_sticker = {
                name = "Quantum Stake",
                text = {
                    "Used this Joker to win",
                    "on Quantum Stake"
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
        Sleeve = {
            sleeve_opal_opals = {
                name = "Starry Sleeve",
                text = {
                    "When a {C:attention}Blind{} is defeated,",
                    "obtain a random {C:opal_pink}Opalstuff{C:attention} Joker{}",
                    "or {C:attention}Consumable",
                    "{C:inactive,s:0.8}(Must have room)"
                }
            },
            sleeve_opal_opals_alt = {
                name = "Starry Sleeve",
                text = {
                    "{C:opal_pink}Opal's Stuff{C:attention} does not",
                    "require room to give an item"
                }
            },
            sleeve_opal_cookie = {
                name = "Cookie Sleeve",
                text = {
                    "When a {C:attention}Blind{} is defeated,",
                    "creates {C:attention}#1# {C:attention,T:m_opal_cookie}#2#{}{C:attention}s",
                }
            },
            sleeve_opal_cookie_alt = {
                name = "Cookie Sleeve",
                text = {
                    "Start with {C:green}#1# in #3#{} Playing Cards",
                    "converted into {C:attention,T:m_opal_cookie}#2#{}{C:attention}s",
                }
            },
            sleeve_opal_modified = {
                name = "Modified Sleeve",
                text = {
                    "Begin with {C:attention}#1# {C:opal_pink}Modifiers",
                    "Gain a new {C:opal_pink}Modifier{C:attention} every",
                    "{C:attention}#2# Heat"
                }
            },
            sleeve_opal_modified_alt = {
                name = "Modified Sleeve",
                text = {
                    "Begin with {C:attention}#1#{} more {C:opal_pink}Modifiers",
                    "Gain {C:red}+#2# Heat{} when a {C:attention}Blind{} is",
                    "defeated"
                }
            }
        },
        Spectral = {
            c_opal_voodoo = {
                name = 'Voodoo',
                text = {
                    'Apply {C:dark_edition}Polychrome{} and',
                    '{C:attention}Pinned{} to a',
                    'random {C:attention}Joker',
                }
            }
        },
        Stake = {
            stake_opal_double_down = {
                name = "Double Down Stake",
                text = {
                    "Win at {C:attention}Ante 10, {C:red}AND",
                    "No {C:attention}Skipping Blinds",
                    "{s:0.8}(Applies Pillar Stake, {C:dark_edition,s:0.8}Opalstuff{s:0.8} Stake)"
                }
            },
            stake_opal_heavy = {
                name = "Heavy Stake",
                text = {
                    "No {C:attention}Skipping Big Blinds",
                    "{s:0.8}(Applies Sour Stake, {C:dark_edition,s:0.8}Opalstuff{s:0.8} Stake)"
                }
            },
            stake_opal_hyperdeath = {
                name = 'Stake of Hyperdeath',
                text = {
                    "A random {C:red}Bad Modifier{} is added",
                    "after a Blind is completed",
                    "{s:0.8}(Applies Double Down Stake, {C:dark_edition,s:0.8}Opalstuff{s:0.8} Stake)"
                }
            },
            stake_opal_pillar = {
                name = "Pillar Stake",
                text = {
                    "Cards previously scored in an Ante",
                    "are debuffed for that Ante",
                    "{s:0.8}(Applies Reject Stake, {C:dark_edition,s:0.8}Opalstuff{s:0.8} Stake)"
                }
            },
            stake_opal_reject = {
                name = "Reject Stake",
                text = {
                    "Shop can have {C:attention}Trampled{} and",
                    "{C:attention}Bound{} Playing Cards",
                    "{s:0.6,C:inactive}(Trampled Cards halve money when played with the most played Hand,",
                    "{s:0.6,C:inactive}Bound Cards reduce hand size by 1 when drawn)",
                    "{s:0.8}(Applies Quantum Stake, {C:dark_edition,s:0.8}Opalstuff{s:0.8} Stake)"
                }
            },
            stake_opal_sour = {
                name = 'Sour Stake',
                text = {
                    "Shop can have {C:attention}Hooked{} and",
                    "{C:attention}Chewed{} Playing Cards",
                    "{s:0.6,C:inactive}(Hooked Cards discard a card held in hand when played,",
                    "{s:0.6,C:inactive}Chewed Cards lose $1 when scored)",
                    "{s:0.8}(Applies Travel Stake, {C:dark_edition,s:0.8}Opalstuff{s:0.8} Stake)"
                }
            },
            stake_opal_travel = {
                name = 'Travel Stake',
                text = {
                    "Shop can have {C:attention}Eternal{},",
                    "{C:attention}Perishable{} and {C:attention}Rental{} Jokers",
                    "{s:0.8}(Applies White Stake, {C:dark_edition,s:0.8}Opalstuff{s:0.8} Stake)"
                }
            },
            stake_opal_quantum = {
                name = 'Quantum Stake',
                text = {
                    "Win at {C:attention}Ante 9",
                    "{s:0.8}(Applies Heavy Stake, {C:dark_edition,s:0.8}Opalstuff{s:0.8} Stake)"
                }
            }
        },
        Tarot = {
            c_opal_churn = {
                name = 'The Milk Churn',
                text = {
                    "Enhances {C:attention}#1#",
                    "selected cards to",
                    "{C:attention}#2#s"
                }
            }
        }
    },
    opal_info = {
        heat = {
            'Heat is a new metric, rewarded for winning a blind.',
            'Winning any Blind rewards you with one Heat.',
            'If your hand one-shots the Blind, you will receive one Heat',
            'for every multiple of 2 it beats the blind by.',
            '(e.g: if a Blind requires 300 Score, you would receive 2 Heat for a Hand that scores 600.)'
        },
        mods = {
            'Modifiers are passively earned as Heat increases.',
            'You can gain 4 in normal gameplay, one at each of these Heat values:',
            '10, 25, 50, 75.'
        },
        indicators = {
            'Indicators are used to display information.',
            'These are displayed separately from Modifiers, and are given',
            'when certain effects are in place.'
        },
        bad = {
            'These are Bad Modifiers that only appear',
            'when playing on the Stake of Hyperdeath.',
            'They do not appear in normal gameplay.'
        },
        bstickers = {
            'Blind Stickers are Stickers that correspond',
            'to a certain Blind. They can appear on',
            'Playing Cards only.'
        }
    },
    misc = {
        challenge_names = {
            c_opal_debuffs_1 = "Oops! All Debuffs",
            c_opal_dupes_1 = "Mirage",
            c_opal_pillar_1 = "Pillar",
            c_opal_stickers_1 = "Decorated Cards",
            c_opal_stickers_2 = "Restoration Project",
        },
        hardcore_challenge_names = {
            hc_opal_stickers_3 = 'Decorated Cards II'
        },
        dictionary = {
            b_temperature = 'Heat',
            b_opal_modifiers = 'Modifiers',
            b_opal_modifiers_appearance = 'Modifier Appearance',
            b_opal_temp_info = 'Set Score on fire to gain Heat!',
            b_opal_open_temp = 'TAB to open Heat',
            k_opal_chomp = 'Chomp!',
            k_opal_eaten = 'Eaten!',
            k_opal_modifier = '+ Modifier!',
            k_opalmodifier = 'Modifier',
            k_opalindicator = 'Indicator',
            k_opal_restart_required = 'Restart Required',
            opal_alive_save = 'One More Time!',

            k_opal_modifier_shapes = {
                'Hexagonal',
                'Square'
            },
            k_opal_modifier_sizes = {
                'Small',
                'Large'
            },

            opal_optional_features = 'OPTIONAL FEATURES',
            opal_appearance = 'APPEARANCE OPTIONS',
            opal_heat = 'Heat System',
            opal_mods = 'Modifiers',
            opal_indicators = 'Indicators',
            opal_bad = 'Bad Modifiers',
            opal_bstickers = 'Blind Stickers',
        },
        labels = {
            opal_bound = "Bound",
            opal_chewed = "Chewed",
            opal_hooked = "Hooked",
            opal_overgrown = "Overgrown",
            opal_ringing = "Ringing",
            opal_stacked = "Stacked",
            opal_trampled = "Trampled",
            opal_soggy = 'Soggy',
            opal_prickly = 'Prickly',
            opal_strong = 'Strong',
            opal_sharp = 'Sharp',
            opal_bleeding = 'Bleeding',
            opal_venomous = 'Venomous',
            opal_growing = 'Growing',
            opal_intelligent = 'Intelligent',
            opal_homely = 'Homely',
            opal_envious = 'Envious',
            opal_hungry = 'Hungry',
            opal_witness = 'Witness',
            opal_suspicious = 'Suspicious',
            opal_dizzy = 'Dizzy',
            opal_brutal = 'Brutal',
            opal_backstabbing = 'Backstabbing',
            opal_insular = 'Insular',
            opal_pointy = 'Pointy',
            opal_tall = 'Tall',
            opal_looming = 'Looming',
            opal_stained = 'Stained',
            opal_snappy = 'Snappy',
            opal_overloaded = 'Overloaded',
        },
        v_dictionary = {
            a_xdollars = 'X#1# Dollars',
            a_money = '+$#1# Dollars',
            a_antes_left = '#1# Ante Remaining',
            a_heat = '+#1# Heat'
        },
        v_text = {
            ch_c_opal_pillar = {"{C:attention}Played Cards{} are {C:red}debuffed{} until the end of the Ante"},
            ch_c_opal_disable_skipping = {"{C:attention}Skipping Blinds{} is {C:red}disabled"},

            ch_c_opal_enable_bl_stickers = {"Every {C:attention}Blind Sticker{} for {C:attention}Cards{} is enabled{C:inactive} (Opalstuff)"},
            ch_c_opal_bstick_rate = {"{C:attention}Blind Stickers{} appear {C:red}X#1#{} more{C:inactive} (Opalstuff)"},
            ch_c_opal_blinds_give_stickers = {"Defeated {C:attention}Boss Blinds{} give stickers to winning {C:attention}Hand{C:inactive} (Opalstuff)"},

            ch_c_opal_no_heat = {"Heat is{C:red} disabled{C:inactive} (Opalstuff)"},
            ch_c_opal_no_mods = {"Modifiers are {C:red}disabled{C:inactive} (Opalstuff)"},
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