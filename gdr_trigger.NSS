

//
// GDR - Grin, Duck and Run
//
// A generic test skill, move to A if pass else move to B and hurt
//
// Configured by local variables on the triggering object
//
// ------------------------------------------------------------------
//
// gdr_requires (string)
//
//      Tag of an object the PC must have to attempt the manouver
//
// gdr_requires_msg(string)
//
//      Issued if the required item is missing
//
// ------------------------------------------------------------------
//
// gdr_skill (int)
//
//      Skill Checks (skill + d20 >= dc)
//
//          Standard skill checks, dcs range from 15 (easy) to 45+ (very hard)
//
//      0   Tumble (Jumping, Climbing, Balancing etc...)
//      1   SpellCraft (Magical barriers)
//      2   Use Magical Device (Odd devices, Standing Stones)
//      3   Discipline (Alluring distractions)
//      4   Concentration (Distractions from a deadly path)
//      5   Perform (or die?)
//      6   Move Silently (Sneaking past something?)
//      7   Hide (Sneaking or hiding)
//      8   Disable Trap (Sneak through a big trap?)
//      9   Open Locks (jimmying a window)
//      10  Appraise (evaluating something)
//      11  Listen (hearing something)
//      12  Lore (knowing something)
//      13  Parry (deflecting an attack)
//      14  Search (finding something big)
//      15  Spot (finding something small)
//      16  Pickpocket (lifting or planting something)
//
//      Saves (save + d20 >= dc)
//
//          Standard saving throws, dcs typically range from 10 (very easy)
//          to 35 (very hard).
//
//      100 Fortitude (impact, attack of force)
//      101  vs ACID
//      102  vs CHAOS
//      103  vs COLD
//      104  vs DEATH
//      105  vs DISEASE
//      106  vs DIVINE
//      107  vs ELECTRICITY
//      108  vs EVIL
//      109  vs FEAR
//      110  vs FIRE
//      111  vs GOOD
//      112  vs LAW
//      113  vs MIND_SPELLS
//      114  vs NEGATIVE
//      115  vs POISON
//      116  vs POSITIVE
//      117  vs SONIC
//      118  vs SPELL
//      119  vs TRAP
//
//      200 Will (temptation, domination, confusion)
//      201  vs ACID
//      202  vs CHAOS
//      203  vs COLD
//      204  vs DEATH
//      205  vs DISEASE
//      206  vs DIVINE
//      207  vs ELECTRICITY
//      208  vs EVIL
//      209  vs FEAR
//      210  vs FIRE
//      211  vs GOOD
//      212  vs LAW
//      213  vs MIND_SPELLS
//      214  vs NEGATIVE
//      215  vs POISON
//      216  vs POSITIVE
//      217  vs SONIC
//      218  vs SPELL
//      219  vs TRAP
//
//      300 Reflex (dodge)
//      301  vs ACID
//      302  vs CHAOS
//      303  vs COLD
//      304  vs DEATH
//      305  vs DISEASE
//      306  vs DIVINE
//      307  vs ELECTRICITY
//      308  vs EVIL
//      309  vs FEAR
//      310  vs FIRE
//      311  vs GOOD
//      312  vs LAW
//      313  vs MIND_SPELLS
//      314  vs NEGATIVE
//      315  vs POISON
//      316  vs POSITIVE
//      317  vs SONIC
//      318  vs SPELL
//      319  vs TRAP
//
//      Ability Checks (stat + d20 > dc)
//
//          If you want the equivalent of (d20 <= stat), use a dc of 20.
//
//      400 Strength (moving, lifting, forcing)
//      401 Dexterity (tumble, but easy)
//      402 Constitution (holding breath? Swimming?)
//      403 Intelligence (puzzle?)
//      404 Wisdom (knowledge)
//      405 Charisma (charm? chutzpah?)
//
//      Automatic results (for unconditional effects)
//
//          These run silently and are useful if you just want to use the
//          script to trigger a bunch of effects or to teleport the player.
//          Normally the fail condition is used as the failure path has
//          a couple more options (damage and all hostile).
//
//      500 Always fails
//      501 Always passes
//
//      Alignment checks (value +/- d20 </> 50 +/- dc)
//
//          A low dc of (10 or so) will allow marginally opposed character
//          to pass (good with dc 10 requires alignment GE - d20 < 40, so
//          many neutral characters (35-65) will also pass).
//
//          A high dc (40+) will only pass those that are strictly aligned
//          (good with dc 40 require alignment GE - d20 < 10), so only those
//          of definelty good alignment (<30) have any chance of passing.
//
//          When checking for neutral alignments, uses dcs from 21 to 30.
//          Lower dcs are to hard, while higher ones are to easy.
//
//      600 Alignment Good                  (value - d20 < 50 - dc)
//      601 Alignment Good/Evil Neutral
//      602 Alignment Evil                  (value + d20 > 50 + dc)
//      603 Alignment Lawful
//      604 Alignment Lawful/Chaoti_Neutral
//      605 Alignment Chaotic
//
//      610 Alignment not Good              (value + d20 > 50 - dc)
//      611 Alignment not Good/Evil Neutral
//      612 Alignment not Evil              (value - d20 < 50 + dc);
//      613 Alignment not Lawful
//      614 Alignment not Lawful/Chaotic Neutral
//      615 Alignment not Chaotic
//
//      620 Alignment LG
//      621 Alignment LN
//      622 Alignment LE
//      623 Alignment NG
//      624 Alignment True Neutral
//      625 Alignment NE
//      626 Alignment CG
//      627 Alignment CN
//      628 Alignment CE
//
//      630 Alignment not LG
//      631 Alignment not LN
//      632 Alignment not LE
//      633 Alignment not NG
//      634 Alignment not True Neutral
//      635 Alignment not NE
//      636 Alignment not CG
//      637 Alignment not CN
//      638 Alignment not CE
//
//      Random Actions
//
//          A d%, mapped to the range 700 (no chance) to 799 (99%).
//
//      700 No chance
//      720 20% chance
//      750 50% chance
//      780 80% chance
//      799 99% chance
//
// gdr_dc (int)
//
//      DC for the skill check
//
//      11  Unskilled has a 50% chance of success
//      20  Skilled only
//      35  Really tough
//
// gdr_encumberance_penalty (int)
//
//      The ammount the dc is increased by if the PC is subject to a
//      movement speed decreased effect.
//
//      This affects both encumbered and sneaking characters, reflecting
//      the increased difficulty.
//
// ---------------------------------------------------------------------
//
// gdr_max_uses (int)
//
//      The maximum number of times the script can be triggered.  On the
//      last one the object is destroyed.
//
//      0 (the default) gives unlimited uses.
//
//      Mainly for use with one shot quests and objects that give
//      beneficial effects.
//
// gdr_usage_limit (int)
//
//      The maximum number of times the object will work for a particular
//      creature.
//
//      0 (default) gives unlimited uses.
//
//      Mainly for use with one shots and objects that buff.
//
// gdr_usage_token (string)
//
//      Indivudal usage is normally counted under the objects Tag.
//      This specifies a string to be used instead.  The usage limit
//      will be spread amongst all objects that have the same usage
//      token.
//
//      It ends up as the name of a local variable on the individual.
//
//      Mainly for use with choices and buffs.
//
// ---------------------------------------------------------------------
//
// gdr_pass_wp (string)
// gdr_fail_wp (string)
//
//      Tag of waypoint PC is transported to on success/failure.
//
// gdr_pass_msg (string)
// gdr_fail_msg (string)
//
//      Message sent to PCs window on success/failure.
//
// gdr_pass_effect (int)
// gdr_fail_effect (int)
//
//      Index of Visual effect applied to PC if they pass/fail
//
// gdr_pass_sound (string)
// gdr_fail_sound (string)
//
//      Tag of sound_object to be activated if passed/failed.
//      See NWN Main Data -> data/sounds.bif -> audio
//
// gdr_pass_annoy (string)
// gdr_fail_annoy (string)
//
//      Tag of creature whose faction will become hostile to the
//      PC if they pass/fail the check.
//
// gdr_pass_pacify (string)
// gdr_fail_pacify (string)
//
//      Tag of creature whose faction will become friendly to the
//      PC if they pass/fail the check.
//
// gdr_pass_alignGE (int)
// gdr_fail_alignGE (int)
//
//      Good/Evil alignment shift to apply to any that pass/fail the check.
//      +ve is towards evil, -ve is towards good.
//
// gdr_pass_alignLC (int)
// gdr_fail_alignLC (int)
//
//      Lawful/Chaotic alignment shift to apply to any that pass/fail the check.
//      +ve is towards chaotic, -ve is towards lawful.
//
// gdr_pass_activate_spawn_group (string)
// gdr_fail_activate_spawn_group (string)
//
//      Tag of a spawn group to be activated if the check is passed/failed.
//
//      Use with gdr_setup.
//
// gdr_pass_deativate_spawn_group (string)
// gdr_fail_deactivate_spawn_group (string)
//
//      Tag of a spawn group to be deactivated if the check is passed/failed.
//
//      Use with gdr_setup.
//
//
// gdr_pass_quiesce_spawn_group (string)
// gdr_fail_quiesce_spawn_group (string)
//
//      Tag of a spawn group to be deactivated if the check is passed/failed.
//
//      Use with gdr_setup.
//
// gdr_pass_port_to_mirror (string)
// gdr_fail_port_to_mirror (string)
//
//      Tag of an area to transfer PC to. PC appears at the same position
//      and facing in the destination area, so it had better have some
//      usable terrain at the same position.
//
// gdr_pass_drop (string)
// gdr_fail_drop (string)
//
//      Tag of an object in the characters inventory that will be put down (yes,
//      with the full animation) if the pass/fail the test.
//
// gdr_pass_trash (string)
// gdr_fail_trash (string)
//
//      Tag of an object in the characters inventory that will be destroyed
//      if the pass/fail the check.  Useful to dispose of trigger objects.
//
// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
//
// gdr_fail_dice (int)
//
//      Number of d6 damage taken if they fail
//      0 means no damage
//
// gdr_fail_damType (int)
//
//      0   Bludgeonig
//      1   Piercing
//      2   Slashing
//      3   Magical
//      4   Acid
//      5   Cold
//      6   Electrical
//      7   Divine
//      8   Fire
//      9   Negative
//      10  Positive
//      11  Sonic
//
// gdr_fail_damSoft (int)
//
//      0   Damage bypasses Soak and Sink (default)
//      1   Damage reduced by Soak and Sink
//
// gdr_fail_strip (int)
//
//      0   Strip Invisability and Stealth on a failure
//      1   Do not strip them
//
// gdr_fail_all_hostile (int)
//
//      If set to 1, then the player attitude ratings are adjusted so
//      that the player becomes hostile to all other players and they
//      all become hostile to him.  The player is also booted out of
//      whatever party they may be in.  Useful if combined with a
//      teleport around the corner, a polymorph into a troll and a
//      bunch of other trolls that become pacified.
//
// --------------------------------------------------------------------
//
// gdr_pass_animation (int)
// gdr_fail_animation (int)
//
//      The animation played if they pass or fail.
//
//      The default for pass is no animation, the default for fail is DEAD_FRONT.
//
//      0   Default
//      1   No animation
//      2   LOOPING_DEAD_FRONT
//      3   FIREFORGET_DODGE_DUCK
//      4   FIREFORGET_DODGE_SIDE
//      5   FIREFORGET_HEAD_TURN_LEFT
//      6   FIREFORGET_HEAD_TURN_RIGHT
//      7   FIREFORGET_PAUSE_BORED
//      8   PAUSE_SCRATCH_HEAD
//      9   FIREFORGET_READ
//      10  FIREFORGET_SPASM
//      11  FIREFORGET_TAUNT
//      12  LOOPING_CONJURE1
//      13  LOOPING_CONJURE2
//      14  LOOPING_CUSTOM1
//      15  LOOPING_CUSTOM2
//      16  LOOPING_DEAD_BACK
//      17  LOOPING_GET_LOW
//      18  LOOPING_GET_MID
//      19  LOOPING_LISTEN
//      20  LOOPING_LOOK_FAR
//      21  LOOPING_MEDITATE
//      22  LOOPING_PAUSE_DRUNK
//      23  ANIMATION_LOOPING_SPASM
//
//      FIREFORGET animations play once, LOOPING animations play for 6 seconds
//
// gdr_fail_spell (int)
// gdr_pass_spell (int)
//
//      Spell like effect applied on fail or pass
//
//      1   Decrease Strength           - Ammount
//      2   Decrease Dexterity          - Ammount
//      3   Decrease Constitution       - Ammount
//      4   Decrease Intelligence       - Ammount
//      5   Decrease Wisdom             - Ammount
//      6   Decrease Charisma           - Ammount
//      7   Decrease AC                 - Ammount
//      8   Decrease AB                 - Ammount
//      9   Blindness
//      10  Dazed
//      11  Deafness
//      12  Death                       * Permanent
//      13  Knockdown
//      14  Decrease Movement Speed     - Percentage
//      15  Level drain                 - Ammount
//      16  Paralyze
//      17  Silence
//      18  Sleep
//      19  Slow
//      20  Decrease Spell Resistance   - Percentage
//      21  Stunned
//      22  Disease                     - Disease type
//      23  Entangle
//      24  Fear/Turned
//      25  Petrify
//      26  Poison                      - Poison type
//      27  Spell Failure               - Percentage
//      28  Polymorph                   - Creature type
//      29  Dispel Magic All            - Caster level
//      30  Dispel Magic Best           - Caster level
//
//      101 Increase Strength           - Ammount
//      102 Increase Dexterity          - Ammount
//      103 Increase Constitution       - Ammount
//      104 Increase Intelligence       - Ammount
//      105 Increase Wisdom             - Ammount
//      106 Increase Charisma           - Ammount
//      107 Increase AC                 - Ammount
//      108 Increase AB                 - Ammount
//      109 Increase Movement Speed     - Ammount
//      110 Increase Spell Resistance   - Percentage
//      111 Haste
//      112 Increase Attacks            - Ammount
//      113 Sanctuary                   - Casters level
//      114 See Invisible
//      115 Temporary Hitpoints         - Ammount
//      116 True Seeing
//      117 Ultravision
//
// gdr_fail_spell_power (int)
// gdr_pass_spell_power (int)
//
//      Numeric parameter for effect strength, see second column above
//
//      Disease Types:
//
//      1   BLINDING_SICKNESS               Average     STR/Blindness
//      2   BURROW_MAGGOTS                  Strong      INT/WIS
//      3   CACKLE_FEVER                    Average     WIS
//      4   DEMON_FEVER                     Strong      CON
//      5   DEVIL_CHILLS                    Average     STR
//      6   DREAD_BLISTERS                  Weak        CHA/CON
//      7   FILTH_FEVER                     Weak        CON/INT
//      8   GHOUL_ROT                       Strong      CON/STR
//      9   MINDFIRE                        Weak        INT
//      10  MUMMY_ROT                       Strong      CON
//      11  RED_ACHE                        Average     STR
//      12  RED_SLAAD_EGGS                  Average     DEX/CON/STR/Summons
//      13  SHAKES                          Weak        STR
//      14  SLIMY_DOOM                      Average     DEX
//      15  SOLDIER_SHAKES                  Epic        Random
//      16  VERMIN_MADNESS                  Weak        INT/WIS/CHA
//      17  ZOMBIE_CREEP                    Average     DEX/CON
//
//      Poison Types:
//
//      1   ARANEA_VENOM                    Weak        STR
//      2   ARSENIC                         Weak        CON
//      3   BEBILITH_VENOM                  Strong      CON
//      4   BLACK_ADDER_VENOM               Weak        STR
//      5   BLACK_LOTUS_EXTRACT             Strong      CON
//      6   BLADE_BANE                      Average     STR/CON
//      7   BLOODROOT                       Weak        WIS/CON
//      8   BLUE_WHINNIS                    Weak        CON/Sleep
//      9   BURNT_OTHUR_FUMES               Strong      CON
//      10  CARRION_CRAWLER_BRAIN_JUICE     Weak        Paralization
//      11  CHAOS_MIST                      Average     WIS
//      12  POISON_COLOSSAL_SPIDER_VENOM    Epic        STR
//      13  POISON_DARK_REAVER_POWDER       Strong      CON
//      14  POISON_DEATHBLADES              Strong      CON
//      15  DRAGON_BILE                     V.Strong    STR
//      16  ETTERCAP_VENOM                  Weak        DEX
//      17  GARGANTUAN_SPIDER_VENOM         Epic        STR
//      18  GIANT_WASP_POISON               Strong      DEX
//      19  GREENBLOOD_OIL                  Weak        CON
//      20  HUGE_SPIDER_VENOM               V.Strong    STR
//      21  ID_MOSS                         Weak        INT
//      22  IRON_GOLEM                      Average     CON/Death
//      23  LARGE_SCORPION_VENOM            Average     STR
//      24  LARGE_SPIDER_VENOM              Average     STR
//      25  LICH_DUST                       Average     STR
//      26  MALYSS_ROOT_PASTE               Average     DEX
//      27  MEDIUM_SPIDER_VENOM             Weak        STR
//      28  NIGHTSHADE                      V.Weak      DEX
//      29  NITHARIT                        Weak        CON
//      30  OIL_OF_TAGGIT                   Average     Sleep
//      31  PHASE_SPIDER_VENOM              Average     CON
//      32  PIT_FIEND_ICHOR                 Strong      CON/Death
//      33  PURPLE_WORM_POISON              V.Strong    STR
//      34  QUASIT_VENOM                    Weak        DEX
//      35  SASSONE_LEAF_RESIDUE            Average     Acid/CON
//      36  SHADOW_ESSENCE                  Average     STR
//      37  SMALL_CENTIPEDE_POISON          V.Weak      DEX
//      38  SMALL_SPIDER_VENOM              V.Weak      STR
//      39  STRIPED_TOADSTOOL               V.Weak      WIS
//      40  TERINAV_ROOT                    Average     DEX
//      41  TINY_SPIDER_VENOM               Weak        STR
//      42  UNGOL_DUST                      Average     CHA
//      43  WRAITH_SPIDER_VENOM             V.Strong    CON/STR
//      44  WYVERN_POISON                   Average     CON
//
//      Creature Types:
//
//      0   BADGER
//      1   ANCIENT_BLUE_DRAGON
//      2   ANCIENT_GREEN_DRAGON
//      3   ANCIENT_RED_DRAGON
//      4   BALOR
//      5   BASILISK
//      6   BEHOLDER
//      7   BOAR
//      8   BROWN_BEAR
//      9   CELESTIAL_AVENGER
//      10  CHICKEN
//      11  COW
//      12  DEATH_SLAAD
//      13  DIRE_BADGER
//      14  DIRE_PANTHER
//      15  DIRE_WOLF
//      16  DIRE_TIGER
//      17  DOOM_KNIGHT
//      18  DRIDER
//      19  ELDER_AIR_ELEMENTAL
//      20  ELDER_EARTH_ELEMENTAL
//      21  ELDER_FIRE_ELEMENTAL
//      22  ELDER_WATER_ELEMENTAL
//      23  FEMALE_DROW
//      24  FIRE_GIANT
//      25  FROST_GIANT_FEMALE
//      26  FROST_GIANT_MALE
//      27  GARGOYLE
//      28  GIANT_SPIDER
//      29  GOLEM_AUTOMATON
//      30  HARPY
//      31  HEURODIS
//      32  HUGE_AIR_ELEMENTAL
//      33  HUGE_EARTH_ELEMENTAL
//      34  HUGE_FIRE_ELEMENTAL
//      35  HUGE_WATER_ELEMENTAL
//      36  IMP
//      37  IRON_GOLEM
//      38  JNAH_GIANT_FEMALE
//      39  JNAH_GIANT_MALE
//      40  MALE_DROW
//      41  MANTICORE
//      42  MEDUSA
//      43  MINDFLAYER
//      44  MINOTAUR
//      45  HUMAN
//      46  PANTHER
//      47  PENGUIN
//      48  PIXIE
//      49  QUASIT
//      50  RED_DRAGON
//      51  RISEN_LORD
//      52  SPECTRE
//      53  SUCCUBUS
//      54  SUPER_CHICKEN
//      55  TROLL
//      56  UMBER_HULK
//      57  VAMPIRE_FEMALE
//      58  VAMPIRE_MALE
//      59  VROCK
//      60  WERECAT
//      61  WERERAT
//      62  WEREWOLF
//      63  WOLF
//      64  WYRMLING_BLACK
//      65  WYRMLING_BLUE
//      66  WYRMLING_GREEN
//      67  WYRMLING_RED
//      68  WYRMLING_WHITE
//      69  YUANTI
//      70  ZOMBIE
//
// gdr_fail_spell_duration (float)
// gdr_pass_spell_duration (float)
//
//      Duration of spell effect in real time seconds
//      Specify -1.0 for permanent
//

#include "NW_I0_GENERIC"
#include "NW_I0_SPELLS"


// Teleport a player to a waypoint

void playerToWP( object oPC, string wpName ) {

    object oTarget;
    location lTarget;

    oTarget = GetWaypointByTag(wpName);

    lTarget = GetLocation(oTarget);

    if (GetAreaFromLocation(lTarget) != OBJECT_INVALID) {

        AssignCommand(oPC, ClearAllActions());
        AssignCommand(oPC, ActionJumpToLocation(lTarget));
    } else {
        SendMessageToPC(oPC, "You can't find: " + wpName );
    }

    return;
}

// Perform a stat check for a player

int StatCheck(object oPC, int stat, int dc, string short) {

    int value = GetAbilityScore(oPC, stat);

    int roll = d20(1);

    string msg = "";

    msg = msg + short + ": " + IntToString(value);
    msg = msg +        " + " + IntToString(roll);
    msg = msg +    " vs DC " + IntToString(dc);

    if (value + roll >= dc) {
        msg = msg + ": Success";
        SendMessageToPC(oPC, msg);
        FloatingTextStringOnCreature(short + " *success*", oPC);
        return TRUE;
    }

    msg = msg + ": Failed";
    SendMessageToPC(oPC, msg);
    FloatingTextStringOnCreature(short + " *failure*", oPC);

    return FALSE;
}

// Call back for dispel magic

void GDROnDispelEffect( object oTarget ) {

	// Do nothing for now
		
	return;
}


// Apply a spell like effect to a PC

void Enchant(object oPC, int spell, int power, float duration)
{

    effect eEffect;

    int valid = TRUE;

    int durType = DURATION_TYPE_TEMPORARY;

    if (duration < 0.0) {
       durType = DURATION_TYPE_PERMANENT;
    }

    if (duration < 6.0) {
        duration = 6.0;
    }

    switch (spell) {

        default:

            valid = FALSE;
            break;

        case 1:
            eEffect = EffectAbilityDecrease(ABILITY_STRENGTH, power);
            break;

        case 2:
            eEffect = EffectAbilityDecrease(ABILITY_DEXTERITY, power);
            break;

        case 3:
            eEffect = EffectAbilityDecrease(ABILITY_CONSTITUTION, power);
            break;

        case 4:
            eEffect = EffectAbilityDecrease(ABILITY_INTELLIGENCE, power);
            break;

        case 5:
            eEffect = EffectAbilityDecrease(ABILITY_WISDOM, power);
            break;

        case 6:
            eEffect = EffectAbilityDecrease(ABILITY_CHARISMA, power);
            break;

        case 7:
            eEffect = EffectACDecrease(power);
            break;

        case 8:
            eEffect = EffectAttackDecrease(power);
            break;

        case 9:
            eEffect = EffectBlindness();
            break;

        case 10:
            eEffect = EffectDazed();
            break;

        case 11:
            eEffect = EffectDeaf();
            break;

        case 12:
            eEffect = EffectDeath();
            durType = DURATION_TYPE_PERMANENT;
            break;

        case 13:
            eEffect = EffectKnockdown();
            break;

        case 14:
            eEffect = EffectMovementSpeedDecrease(power);
            break;

        case 15:
            eEffect = EffectNegativeLevel(power);
            break;

        case 16:
            eEffect = EffectParalyze();
            break;

        case 17:
            eEffect = EffectSilence();
            break;

        case 18:
            eEffect = EffectSleep();
            break;

        case 19:
            eEffect = EffectSlow();
            break;

        case 20:
            eEffect = EffectSpellResistanceDecrease(power);
            break;

        case 21:
            eEffect = EffectStunned();
            break;

        case 22:

            switch(power) {

                default:
                case 1:
                    eEffect = EffectDisease(DISEASE_BLINDING_SICKNESS);
                    break;

                case 2:
                    eEffect = EffectDisease(DISEASE_BURROW_MAGGOTS);
                    break;

                case 3:
                    eEffect = EffectDisease(DISEASE_CACKLE_FEVER);
                    break;

                case 4:
                    eEffect = EffectDisease(DISEASE_DEMON_FEVER);
                    break;

                case 5:
                    eEffect = EffectDisease(DISEASE_DEVIL_CHILLS);
                    break;

                case 6:
                    eEffect = EffectDisease(DISEASE_DREAD_BLISTERS);
                    break;

                case 7:
                    eEffect = EffectDisease(DISEASE_FILTH_FEVER);
                    break;

                case 8:
                    eEffect = EffectDisease(DISEASE_GHOUL_ROT);
                    break;

                case 9:
                    eEffect = EffectDisease(DISEASE_MINDFIRE);
                    break;

                case 10:
                    eEffect = EffectDisease(DISEASE_MUMMY_ROT);
                    break;

                case 11:
                    eEffect = EffectDisease(DISEASE_RED_ACHE);
                    break;

                case 12:
                    eEffect = EffectDisease(DISEASE_RED_SLAAD_EGGS);
                    break;

                case 13:
                    eEffect = EffectDisease(DISEASE_SHAKES);
                    break;

                case 14:
                    eEffect = EffectDisease(DISEASE_SLIMY_DOOM);
                    break;

                case 15:
                    eEffect = EffectDisease(DISEASE_SOLDIER_SHAKES);
                    break;

                case 16:
                    eEffect = EffectDisease(DISEASE_VERMIN_MADNESS);
                    break;

                case 17:
                    eEffect = EffectDisease(DISEASE_ZOMBIE_CREEP);
                    break;
            }

            break;

        case 23:
            eEffect = EffectEntangle();
            break;

        case 24:
            eEffect = EffectFrightened();
            break;

        case 25:
            eEffect = EffectPetrify();
            break;

        case 26:

            switch(power) {

                default:
                case 1:

                    eEffect = EffectPoison(POISON_ARANEA_VENOM);
                    break;

                case 2:

                    eEffect = EffectPoison(POISON_ARSENIC);
                    break;

                case 3:
                    eEffect = EffectPoison(POISON_BEBILITH_VENOM);
                    break;

                case 4:

                    eEffect = EffectPoison(POISON_BLACK_ADDER_VENOM);
                    break;

                case 5:

                    eEffect = EffectPoison(POISON_BLACK_LOTUS_EXTRACT);
                    break;

                case 6:

                    eEffect = EffectPoison(POISON_BLADE_BANE);
                    break;

                case 7:

                    eEffect = EffectPoison(POISON_BLOODROOT);
                    break;

                case 8:

                    eEffect = EffectPoison(POISON_BLUE_WHINNIS);
                    break;

                case 9:

                    eEffect = EffectPoison(POISON_BURNT_OTHUR_FUMES);
                    break;

                case 10:

                    eEffect = EffectPoison(POISON_CARRION_CRAWLER_BRAIN_JUICE);
                    break;

                case 11:

                    eEffect = EffectPoison(POISON_CHAOS_MIST);
                    break;

                case 12:

                    eEffect = EffectPoison(POISON_COLOSSAL_SPIDER_VENOM);
                    break;

                case 13:

                    eEffect = EffectPoison(POISON_DARK_REAVER_POWDER);
                    break;

                case 14:

                    eEffect = EffectPoison(POISON_DEATHBLADE);
                    break;

                case 15:

                    eEffect = EffectPoison(POISON_DRAGON_BILE);
                    break;

                case 16:

                    eEffect = EffectPoison(POISON_ETTERCAP_VENOM);
                    break;

                case 17:

                    eEffect = EffectPoison(POISON_GARGANTUAN_SPIDER_VENOM);
                    break;

                case 18:

                    eEffect = EffectPoison(POISON_GIANT_WASP_POISON);
                    break;

                case 19:

                    eEffect = EffectPoison(POISON_GREENBLOOD_OIL);
                    break;

                case 20:

                    eEffect = EffectPoison(POISON_HUGE_SPIDER_VENOM);
                    break;

                case 21:

                    eEffect = EffectPoison(POISON_ID_MOSS);
                    break;

                case 22:

                    eEffect = EffectPoison(POISON_IRON_GOLEM);
                    break;

                case 23:

                    eEffect = EffectPoison(POISON_LARGE_SCORPION_VENOM);
                    break;

                case 24:

                    eEffect = EffectPoison(POISON_LARGE_SPIDER_VENOM);
                    break;

                case 25:

                    eEffect = EffectPoison(POISON_LICH_DUST);
                    break;

                case 26:

                    eEffect = EffectPoison(POISON_MALYSS_ROOT_PASTE);
                    break;

                case 27:

                    eEffect = EffectPoison(POISON_MEDIUM_SPIDER_VENOM);
                    break;

                case 28:

                    eEffect = EffectPoison(POISON_NIGHTSHADE);
                    break;

                case 29:

                    eEffect = EffectPoison(POISON_NITHARIT);
                    break;

                case 30:

                    eEffect = EffectPoison(POISON_OIL_OF_TAGGIT);
                    break;

                case 31:

                    eEffect = EffectPoison(POISON_PHASE_SPIDER_VENOM);
                    break;

                case 32:

                    eEffect = EffectPoison(POISON_PIT_FIEND_ICHOR);
                    break;

                case 33:

                    eEffect = EffectPoison(POISON_PURPLE_WORM_POISON);
                    break;

                case 34:

                    eEffect = EffectPoison(POISON_QUASIT_VENOM);
                    break;

                case 35:

                    eEffect = EffectPoison(POISON_SASSONE_LEAF_RESIDUE);
                    break;

                case 36:

                    eEffect = EffectPoison(POISON_SHADOW_ESSENCE);
                    break;

                case 37:

                    eEffect = EffectPoison(POISON_SMALL_CENTIPEDE_POISON);
                    break;

                case 38:

                    eEffect = EffectPoison(POISON_SMALL_SPIDER_VENOM);
                    break;

                case 39:

                    eEffect = EffectPoison(POISON_STRIPED_TOADSTOOL);
                    break;

                case 40:

                    eEffect = EffectPoison(POISON_TERINAV_ROOT);
                    break;

                case 41:

                    eEffect = EffectPoison(POISON_TINY_SPIDER_VENOM);
                    break;

                case 42:

                    eEffect = EffectPoison(POISON_UNGOL_DUST);
                    break;

                case 43:

                    eEffect = EffectPoison(POISON_WRAITH_SPIDER_VENOM);
                    break;

                case 44:

                    eEffect = EffectPoison(POISON_WYVERN_POISON);
                    break;

            }

            break;

        case 27:
            eEffect = EffectSpellFailure(power);
            break;

        case 28:

            switch (power) {

                default:
                case 0:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_BADGER);
                    break;

                case 1:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_ANCIENT_BLUE_DRAGON);
                    break;

                case 2:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_ANCIENT_GREEN_DRAGON);
                    break;

                case 3:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_ANCIENT_RED_DRAGON);
                    break;

                case 4:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_BALOR);
                    break;

                case 5:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_BASILISK);
                    break;

                case 6:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_BEHOLDER);
                    break;

                case 7:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_BOAR);
                    break;

                case 8:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_BROWN_BEAR);
                    break;

                case 9:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_CELESTIAL_AVENGER);
                    break;

                case 10:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_CHICKEN);
                    break;

                case 11:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_COW);
                    break;

                case 12:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_DEATH_SLAAD);
                    break;

                case 13:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_DIRE_BADGER);
                    break;

                case 14:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_DIRE_PANTHER);
                    break;

                case 15:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_DIRE_WOLF);
                    break;

                case 16:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_DIRETIGER);
                    break;

                case 17:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_DOOM_KNIGHT);
                    break;

                case 18:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_DRIDER);
                    break;

                case 19:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_ELDER_AIR_ELEMENTAL);
                    break;

                case 20:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_ELDER_EARTH_ELEMENTAL);
                    break;

                case 21:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_ELDER_FIRE_ELEMENTAL);
                    break;

                case 22:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_ELDER_WATER_ELEMENTAL);
                    break;

                case 23:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_FEMALE_DROW);
                    break;

                case 24:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_FIRE_GIANT);
                    break;

                case 25:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_FROST_GIANT_FEMALE);
                    break;

                case 26:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_FROST_GIANT_MALE);
                    break;

                case 27:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_GARGOYLE);
                    break;

                case 28:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_GIANT_SPIDER);
                    break;

                case 29:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_GOLEM_AUTOMATON);
                    break;

                case 30:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_HARPY);
                    break;

                case 31:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_HEURODIS);
                    break;

                case 32:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_HUGE_AIR_ELEMENTAL);
                    break;

                case 33:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_HUGE_EARTH_ELEMENTAL);
                    break;

                case 34:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_HUGE_FIRE_ELEMENTAL);
                    break;

                case 35:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_HUGE_WATER_ELEMENTAL);
                    break;

                case 36:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_IMP);
                    break;

                case 37:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_IRON_GOLEM);
                    break;

                case 38:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_JNAH_GIANT_FEMAL);
                    break;

                case 39:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_JNAH_GIANT_MALE);
                    break;

                case 40:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_MALE_DROW);
                    break;

                case 41:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_MANTICORE);
                    break;

                case 42:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_MEDUSA);
                    break;

                case 43:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_MINDFLAYER);
                    break;

                case 44:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_MINOTAUR);
                    break;

                case 45:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_NULL_HUMAN);
                    break;

                case 46:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_PANTHER);
                    break;

                case 47:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_PENGUIN);
                    break;

                case 48:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_PIXIE);
                    break;

                case 49:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_QUASIT);
                    break;

                case 50:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_RED_DRAGON);
                    break;

                case 51:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_RISEN_LORD);
                    break;

                case 52:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_SPECTRE);
                    break;

                case 53:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_SUCCUBUS);
                    break;

                case 54:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_SUPER_CHICKEN);
                    break;

                case 55:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_TROLL);
                    break;

                case 56:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_UMBER_HULK);
                    break;

                case 57:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_VAMPIRE_FEMALE);
                    break;

                case 58:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_VAMPIRE_MALE);
                    break;

                case 59:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_VROCK);
                    break;

                case 60:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_WERECAT);
                    break;

                case 61:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_WERERAT);
                    break;

                case 62:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_WEREWOLF);
                    break;

                case 63:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_WOLF);
                    break;

                case 64:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_WYRMLING_BLACK);
                    break;

                case 65:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_WYRMLING_BLUE);
                    break;

                case 66:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_WYRMLING_GREEN);
                    break;

                case 67:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_WYRMLING_RED);
                    break;

                case 68:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_WYRMLING_WHITE);
                    break;

                case 69:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_YUANTI);
                    break;

                case 70:

                    eEffect = EffectPolymorph(POLYMORPH_TYPE_ZOMBIE);
                    break;

            }

            break;

        case 29:
            eEffect = EffectDispelMagicAll(power, GDROnDispelEffect(oPC));
            break;

        case 30:
            eEffect = EffectDispelMagicBest(power, GDROnDispelEffect(oPC));
            break;


        case 101:
            eEffect = EffectAbilityIncrease(ABILITY_STRENGTH, power);
            break;

        case 102:
            eEffect = EffectAbilityIncrease(ABILITY_DEXTERITY, power);
            break;

        case 103:
            eEffect = EffectAbilityIncrease(ABILITY_CONSTITUTION, power);
            break;

        case 104:
            eEffect = EffectAbilityIncrease(ABILITY_INTELLIGENCE, power);
            break;

        case 105:
            eEffect = EffectAbilityIncrease(ABILITY_WISDOM, power);
            break;

        case 106:
            eEffect = EffectAbilityIncrease(ABILITY_CHARISMA, power);
            break;

        case 107:
            eEffect = EffectACIncrease(power);
            break;

        case 108:
            eEffect = EffectAttackIncrease(power);
            break;

        case 109:
            eEffect = EffectMovementSpeedIncrease(power);
            break;

        case 110:
            eEffect = EffectSpellResistanceIncrease(power);
            break;

        case 111:
            eEffect = EffectHaste();
            break;

        case 112:
            eEffect = EffectModifyAttacks(power);
            break;

        case 113:
            eEffect = EffectSanctuary(power);
            break;

        case 114:
            eEffect = EffectSeeInvisible();
            break;

        case 115:
            eEffect = EffectTemporaryHitpoints(power);
            break;

        case 116:
            eEffect = EffectTrueSeeing();
            break;

        case 117:
            eEffect = EffectUltravision();
            break;
    }

    if (valid) {
        if (durType = DURATION_TYPE_PERMANENT) {
            ApplyEffectToObject(durType, eEffect, oPC);
        } else {
            ApplyEffectToObject(durType, eEffect, oPC, duration);
        }
    }

    return;
}

// Check if a PC passes the action condition

int runTest(object oPC) {

    // What are we testing?

    int test = GetLocalInt(OBJECT_SELF, "gdr_skill");

    // Home run?

    if (test == 500) {
        return FALSE;
    }

    if (test == 501) {
        return TRUE;
    }

    // How hard?

    int dc = GetLocalInt(OBJECT_SELF, "gdr_dc");
	int nShadowAdept = GetHasFeat(294, OBJECT_SELF, TRUE);

    if (dc <= 0) {
        dc = 16;
    }
	if (nShadowAdept = TRUE)
	{
		dc = dc - 2;
	}

    int enc_pen = GetLocalInt(OBJECT_SELF, "gdr_encumberance_penalty");

    if (enc_pen > 0) {
	
	    if (GetHasEffect(EFFECT_TYPE_MOVEMENT_SPEED_DECREASE, oPC) 
		||  GetStealthMode(oPC) == STEALTH_MODE_ACTIVATED) {
            dc = dc + enc_pen;
        }
    }

    // Time to make the check...

    int pass = FALSE;

    if (test < 100) {

        // Skill check

        int skill = 0;

        switch (test) {

            default:
            case 0:
                skill = SKILL_TUMBLE;
                break;

            case 1:
                skill = SKILL_SPELLCRAFT;
                break;

            case 2:
                skill = SKILL_USE_MAGIC_DEVICE;
                break;

            case 3:
                skill = SKILL_DISCIPLINE;
                break;

            case 4:
                skill = SKILL_CONCENTRATION;
                break;

            case 5:
                skill = SKILL_PERFORM;
                break;

            case 6:
                skill = SKILL_MOVE_SILENTLY;
                break;

            case 7:
                skill = SKILL_HIDE;
                break;

            case 8:
                skill = SKILL_DISABLE_TRAP;
                break;

            case 9:
                skill = SKILL_OPEN_LOCK;
                break;

            case 10:
                skill = SKILL_APPRAISE;
                break;

            case 11:
                skill = SKILL_LISTEN;
                break;

            case 12:
                skill = SKILL_LORE;
                break;

            case 13:
                skill = SKILL_PARRY;
                break;

            case 14:
                skill = SKILL_SEARCH;
                break;

            case 15:
                skill = SKILL_SPOT;
                break;

            case 16:
                skill = SKILL_SLEIGHT_OF_HAND;
                break;
        }

        // Make the check

        pass = GetIsSkillSuccessful(oPC, skill, dc);

    } else if (test < 200) {

        // Fortitude save

        switch (test) {

            default:
            case 100:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_NONE);

                break;

            case 101:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_ACID);

                break;

            case 102:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_CHAOS);

                break;

            case 103:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_COLD);

                break;

            case 104:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_DEATH);

                break;

            case 105:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_DISEASE);

                break;

            case 106:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_DIVINE);

                break;

            case 107:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_ELECTRICITY);

                break;

            case 108:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_EVIL);

                break;

            case 109:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_FEAR);

                break;

            case 110:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_FIRE);

                break;

            case 111:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_GOOD);

                break;

            case 112:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_LAW);

                break;

            case 113:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_MIND_SPELLS);

                break;

            case 114:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_NEGATIVE);

                break;

            case 115:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_POISON);

                break;

            case 116:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_POSITIVE);

                break;

            case 117:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_SONIC);

                break;

            case 118:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_SPELL);

                break;

            case 119:

                pass = FortitudeSave(oPC, dc, SAVING_THROW_TYPE_TRAP);

                break;

        }

    } else if ( test < 300) {

        // Willpower

        switch (test) {

            default:
            case 200:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_NONE);

                break;

            case 201:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_ACID);

                break;

            case 202:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_CHAOS);

                break;

            case 203:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_COLD);

                break;

            case 204:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_DEATH);

                break;

            case 205:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_DISEASE);

                break;

            case 206:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_DIVINE);

                break;

            case 207:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_ELECTRICITY);

                break;

            case 208:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_EVIL);

                break;

            case 209:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_FEAR);

                break;

            case 210:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_FIRE);

                break;

            case 211:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_GOOD);

                break;

            case 212:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_LAW);

                break;

            case 213:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_MIND_SPELLS);

                break;

            case 214:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_NEGATIVE);

                break;

            case 215:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_POISON);

                break;

            case 216:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_POSITIVE);

                break;

            case 217:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_SONIC);

                break;

            case 218:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_SPELL);

                break;

            case 219:

                pass = WillSave(oPC, dc, SAVING_THROW_TYPE_TRAP);

                break;

        }

    } else if (test < 400) {

        // Reflex

        switch (test) {

            default:
            case 300:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_NONE);

                break;

            case 301:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_ACID);

                break;

            case 302:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_CHAOS);

                break;

            case 303:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_COLD);

                break;

            case 304:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_DEATH);

                break;

            case 305:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_DISEASE);

                break;

            case 306:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_DIVINE);

                break;

            case 307:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_ELECTRICITY);

                break;

            case 308:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_EVIL);

                break;

            case 309:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_FEAR);

                break;

            case 310:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_FIRE);

                break;

            case 311:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_GOOD);

                break;

            case 312:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_LAW);

                break;

            case 313:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_MIND_SPELLS);

                break;

            case 314:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_NEGATIVE);

                break;

            case 315:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_POISON);

                break;

            case 316:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_POSITIVE);

                break;

            case 317:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_SONIC);

                break;

            case 318:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_SPELL);

                break;

            case 319:

                pass = ReflexSave(oPC, dc, SAVING_THROW_TYPE_TRAP);

                break;

        }

    } else if (test < 500) {

        // Stat check

        switch (test) {

            default:
            case 400:

                pass = StatCheck(oPC, ABILITY_STRENGTH, dc, "STR");

                break;

            case 401:

                pass = StatCheck(oPC, ABILITY_DEXTERITY, dc, "DEX");

                break;

            case 402:

                pass = StatCheck(oPC, ABILITY_CONSTITUTION, dc, "CON");

                break;

            case 403:

                pass = StatCheck(oPC, ABILITY_INTELLIGENCE, dc, "INT");

                break;

            case 404:

                pass = StatCheck(oPC, ABILITY_WISDOM, dc, "WIS");

                break;

            case 405:

                pass = StatCheck(oPC, ABILITY_CHARISMA, dc, "CHR");

                break;

        }

    } else if (test < 600) {

        // Always pass/fail, already checked

    } else if (test < 700) {

        // Alignment check (silent)

        int alignGE = GetGoodEvilValue(oPC);
        int alignLC = GetLawChaosValue(oPC);

        int dc_low = 50 - dc;
        int dc_high = 50 + dc;

        switch (test) {

            // General alignments

            default:
            case 600:       // Alignmenet Good

                pass = (alignGE - d20() < dc_low);

                break;

            case 601:       // Alignment Good/Evil Neutral

                pass = (alignGE + d20() > dc_low) & (alignGE - d20() < dc_high);

                break;

            case 602:       // Alignment Evil

                pass = (alignGE + d20() > dc_high);

                break;

            case 603:       // Alignment Lawful

                pass = (alignLC - d20() < dc_low);

                break;

            case 604:       // Alignment Lawful/Chaotic_Neutral

                pass = (alignLC + d20() > dc_low) & (alignLC - d20() < dc_high);

                break;

            case 605:       // Alignment Chaotic

                pass = (alignLC + d20() > dc_low);

                break;

            // Negative general alignments

            case 610:       // Alignment not Good

                pass = (alignGE + d20() > dc_low);

                break;

            case 611:       // Alignment not Good/Evil Neutral

                pass = (alignGE - d20() < dc_low) | (alignGE + d20() > dc_high);

                break;

            case 612:       // Alignment not Evil

                pass = (alignGE - d20() < dc_high);

                break;

            case 613:       // Alignment not Lawful

                pass = (alignLC + d20() > dc_low);

                break;

            case 614:       // Alignment not Lawful/Chaotic Neutral

                pass = (alignLC - d20() < dc_low) | (alignLC + d20() > dc_high);

                break;

            case 615:       // Alignment not Chaotic

                pass = (alignLC + d20() > dc_high);

                break;

            // Specific alignments

            case 620:       // Alignment LG

                pass = (alignGE - d20() < dc_low) & (alignLC - d20() < dc_low);

                break;

            case 621:       // Alignment LN

                pass = (alignGE + d20() > dc_low) & (alignGE - d20() < dc_high) & (alignLC - d20() < dc_low);

                break;

            case 622:       // Alignment LE

                pass = (alignGE + d20() > dc_high) & (alignLC - d20() < dc_low);

                break;

            case 623:       // Alignment NG

                pass = (alignGE - d20() < dc_low) & (alignLC + d20() > dc_low) & (alignLC - d20() < dc_high);

                break;

            case 624:       // Alignment True Neutral

                pass = (alignGE + d20() > dc_low) & (alignGE - d20() < dc_high);

                pass = pass & (alignLC + d20() > dc_low) & (alignLC - d20() < dc_high);

                break;

            case 625:       // Alignment NE

                pass = (alignGE + d20() > dc_high) & (alignLC + d20() > dc_low) & (alignLC - d20() < dc_high);

                break;

            case 626:       // Alignment CG

                pass = (alignGE - d20() < dc_low) & (alignLC + d20() > dc_high);

                break;

            case 627:       // Alignment CN

                pass = (alignGE + d20() > dc_low) & (alignGE - d20() < dc_high) & (alignLC + d20() > dc_high);

                break;

            case 628:       // Alignment CE

                pass = (alignGE + d20() > dc_high) & (alignLC + d20() > dc_high);

                break;

            // Negative specific alignments

            case 630:       // Alignment not LG

                pass = (alignGE + d20() > dc_low) | (alignLC + d20() > dc_low);

                break;

            case 631:       // Alignment not LN

                pass = (alignGE - d20() < dc_low) | (alignGE + d20() > dc_high) | (alignLC + d20() > dc_low);

                break;

            case 632:       // Alignment not LE

                pass = (alignGE - d20() < dc_high) | (alignLC + d20() > dc_low);

                break;

            case 633:       // Alignment not NG

                pass = (alignGE + d20() > dc_low) | (alignLC - d20() < dc_low) | (alignLC + d20() > dc_high);

                break;

            case 634:       // Alignment not True Neutral

                pass = (alignGE - d20() < dc_low) | (alignGE + d20() > dc_high);

                pass = pass | (alignLC  - d20() < dc_low) | (alignLC + d20() > dc_high);

                break;

            case 635:       // Alignment not NE

                pass = (alignGE - d20() < dc_high) | (alignLC - d20() < dc_low) | (alignLC + d20() > dc_high);

                break;

            case 636:       // Alignment not CG

                pass = (alignGE + d20() > dc_low) | (alignLC - d20() < dc_high);

                break;

            case 637:       // Alignment not CN

                pass = (alignGE - d20() < dc_low) | (alignGE + d20() > dc_high) | (alignLC - d20() < dc_high);

                break;

            case 638:       // Alignment not CE

                pass = (alignGE - d20() < dc_high) | (alignLC - d20() < dc_high);

                break;

        }

    } else if (test < 800) {

        // Random percentage (700 = 0, 799 = 99%)

        pass = (d100() < (test - 700));

    }

    return pass;
}

// Port an object to a mirror position

void PortToMirror(object oPC, string dTag) {

    vector vPos = GetPosition(oPC);

    float fFacing = GetFacing(oPC);

    object oArea = GetObjectByTag(dTag);

    location lNew = Location(oArea, vPos, fFacing);

    AssignCommand(oPC, JumpToLocation(lNew));

    return;
}

// Play an animation

void AnimatePC(object oPC, int animation) {

    switch (animation) {

        default:
        case 1:
            break;

        case 2:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_FRONT, 1.0f, 6.0f));
            break;

        case 3:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_DUCK, 1.0f, 6.0f));
            break;

        case 4:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_DODGE_SIDE, 1.0f, 6.0f));
            break;

        case 5:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_LEFT, 1.0f, 6.0f));
            break;

        case 6:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_HEAD_TURN_RIGHT, 1.0f, 6.0f));
            break;

        case 7:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_BORED, 1.0f, 6.0f));
            break;

        case 8:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_PAUSE_SCRATCH_HEAD, 1.0f, 6.0f));
            break;

        case 9:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_READ, 1.0f, 6.0f));
            break;

        case 10:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_SPASM, 1.0f, 6.0f));
            break;

        case 11:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_FIREFORGET_TAUNT, 1.0f, 6.0f));
            break;

        case 12:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE1, 1.0f, 6.0f));
            break;

        case 13:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CONJURE2, 1.0f, 6.0f));
            break;

        case 14:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM1, 1.0f, 6.0f));
            break;

        case 15:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_CUSTOM2, 1.0f, 6.0f));
            break;

        case 16:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_DEAD_BACK, 1.0f, 6.0f));
            break;

        case 17:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0f, 6.0f));
            break;

        case 18:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0f, 6.0f));
            break;

        case 19:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_LISTEN, 1.0f, 6.0f));
            break;

        case 20:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_LOOK_FAR, 1.0f, 6.0f));
            break;

        case 21:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE, 1.0f, 6.0f));
            break;

        case 22:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_PAUSE_DRUNK, 1.0f, 6.0f));
            break;

        case 23:
            AssignCommand(oPC, ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0f, 6.0f));
            break;
    }

    return;
}

// Unsuspend a suspended object...

void unsuspend_gdr(object trigger) {

    // Sanity check

    if (!GetIsObjectValid(trigger)) {
        return;
    }

    // Clear the suspended flag

    SetLocalInt(OBJECT_SELF, "gdr_suspended", 0);

    // All done

    return;
}

// Check pre-reqs, make check, apply pass/fail results...

void main() {

    int iVal1, iVal2, iVal3;

    string sTag, sMsg;

    object oThing;

    // Who or What is trying to use me?

    object oPC = GetClickingObject();

    if (oPC == OBJECT_INVALID) {
        oPC = GetEnteringObject();

        if (oPC == OBJECT_INVALID) {
            oPC = GetExitingObject();

            if (oPC == OBJECT_INVALID) {
                oPC = GetLastUsedBy();
            }
        }
    }

    // Is it valid?

    if (!GetIsObjectValid(oPC)) {
        return;
    }

    // Bail if we're suspended

    if (GetLocalInt(OBJECT_SELF, "gdr_suspended") == 1) {
        return;
    }

    // Got the required item?

    sTag = GetLocalString(OBJECT_SELF, "gdr_requires");

    if (sTag != "") {

        if (GetItemPossessedBy(oPC, sTag) == OBJECT_INVALID) {

            // Send player message

            sMsg = GetLocalString(OBJECT_SELF, "gdr_requires_msg");

            if (sMsg != "") {
                SendMessageToPC(oPC, sMsg);
            }

            FloatingTextStringOnCreature("*Refused*", oPC);

            return;
        }
    }

    // Check triggerer total usage...

    iVal1 = GetLocalInt(OBJECT_SELF, "gdr_usage_limit");

    if (iVal1 > 0) {

        sTag = GetLocalString(OBJECT_SELF, "gdr_usage_token");

        if (sTag == "") {

            sTag =  GetTag(OBJECT_SELF);
        }

        iVal2 = GetLocalInt(oPC, sTag);

        if (iVal2 >= iVal1) {

            // Send player message

            sMsg = GetLocalString(OBJECT_SELF, "gdr_usage_msg");

            if (sMsg != "") {
                SendMessageToPC(oPC, sMsg);
            }

            FloatingTextStringOnCreature("", oPC);

            return;
        }

        iVal2 = iVal2 + 1;

        SetLocalInt(oPC, sTag, iVal2);

    }

    // Time for some consequences...

    if (!runTest(oPC)) {

        // Jump to waypoint

        sTag = GetLocalString(OBJECT_SELF, "gdr_fail_wp");

        if (sTag != "" ) {
            playerToWP( oPC, sTag );
        }

        // Loose invisability & stealth

        if (GetLocalInt(OBJECT_SELF, "gdr_fail_strip") != 1) {

            RemoveSpecificEffect(EFFECT_TYPE_INVISIBILITY, oPC);

            SetActionMode(oPC, ACTION_MODE_STEALTH, FALSE);
        }

        // Apply visual effect

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_fail_effect");

        if (iVal1 != 0) {
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iVal1), oPC));
        }

        // Sound effects?

        sTag = GetLocalString(OBJECT_SELF, "gdr_fail_sound");

        if (sTag != "") {
            oThing = GetObjectByTag(sTag);

            if (oThing != OBJECT_INVALID) {
                SoundObjectPlay(oThing);
            }
        }

        // How much damage?

        int fDice = GetLocalInt(OBJECT_SELF, "gdr_fail_dice");

        if (fDice > 0) {

            // Damage Type

            int dType, dSave;

            switch (GetLocalInt(OBJECT_SELF, "gdr_fail_damtype")) {

                default:
                    dType = DAMAGE_TYPE_BLUDGEONING;
                    dSave = SAVING_THROW_TYPE_TRAP;
                    break;

                case 1:
                    dType = DAMAGE_TYPE_PIERCING;
                    dSave = SAVING_THROW_TYPE_TRAP;
                    break;

                case 2:
                    dType = DAMAGE_TYPE_SLASHING;
                    dSave = SAVING_THROW_TYPE_TRAP;
                    break;

                case 3:
                    dType = DAMAGE_TYPE_MAGICAL;
                    dSave = SAVING_THROW_TYPE_SPELL;
                    break;

                case 4:
                    dType = DAMAGE_TYPE_ACID;
                    dSave = SAVING_THROW_TYPE_ACID;
                    break;

                case 5:
                    dType = DAMAGE_TYPE_COLD;
                    dSave = SAVING_THROW_TYPE_COLD;
                    break;

                case 6:
                    dType = DAMAGE_TYPE_ELECTRICAL;
                    dSave = SAVING_THROW_TYPE_ELECTRICITY;
                    break;

                case 7:
                    dType = DAMAGE_TYPE_DIVINE;
                    dSave = SAVING_THROW_TYPE_DIVINE;
                    break;

                case 8:
                    dType = DAMAGE_TYPE_FIRE;
                    dSave = SAVING_THROW_TYPE_FIRE;
                    break;

                case 9:
                    dType = DAMAGE_TYPE_NEGATIVE;
                    dSave = SAVING_THROW_TYPE_NEGATIVE;
                    break;

                case 10:
                    dType = DAMAGE_TYPE_POSITIVE;
                    dSave = SAVING_THROW_TYPE_POSITIVE;
                    break;

                case 11:
                    dType = DAMAGE_TYPE_SONIC;
                    dSave = SAVING_THROW_TYPE_SONIC;
                    break;
            }

            // Soft or hard damage?

            int dPower;

            if (GetLocalInt(OBJECT_SELF, "gdr_fail_damSoft") == 1) {
                dPower = DAMAGE_POWER_NORMAL;
            } else {
                dPower = DAMAGE_POWER_PLUS_TWENTY;
            }

            effect eEffect = EffectDamage(d6(fDice), dType, dPower);

            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, eEffect, oPC));

        }

        // Any spell like effects?

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_fail_spell");

        if (iVal1 > 0) {
            Enchant(oPC, iVal1, GetLocalInt(OBJECT_SELF, "gdr_fail_spell_power"),
                                GetLocalFloat(OBJECT_SELF, "gdr_fail_spell_duration"));
        }

        // Play an animation...

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_fail_animation");

        if (iVal1 == 0) {
            iVal1 = 2;
        }

        AnimatePC(oPC, iVal1);

        // Tell them they failed...

        sMsg = GetLocalString(OBJECT_SELF, "gdr_fail_msg");

        if (sMsg != "") {
            SendMessageToPC(oPC, sMsg);
        }

        // Who do we annoy?

        sTag = GetLocalString(OBJECT_SELF, "gdr_fail_annoy");

        if (sTag != "") {

            oThing = GetObjectByTag(sTag);

            if (oThing != OBJECT_INVALID) {
                if (GetObjectType(oThing) == OBJECT_TYPE_CREATURE) {
                    AdjustReputation(oPC, oThing, -100);
                }
            }
        }

        // Who do we pacify?

        sTag = GetLocalString(OBJECT_SELF, "gdr_fail_pacify");

        if (sTag != "") {

            oThing = GetObjectByTag(sTag);

            if (oThing != OBJECT_INVALID) {
                if (GetObjectType(oThing) == OBJECT_TYPE_CREATURE) {
                    AdjustReputation(oPC, oThing, 100);
                }
            }
        }

        // Alignment shift

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_fail_alignGE");

        if (iVal1 > 0) {
            AdjustAlignment(oPC, ALIGNMENT_EVIL, iVal1);
        } else if (iVal1 < 0) {
            AdjustAlignment(oPC, ALIGNMENT_GOOD, -iVal1);
        }

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_fail_alignLC");

        if (iVal1 > 0) {
            AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, iVal1);
        } else if (iVal1 < 0) {
            AdjustAlignment(oPC, ALIGNMENT_LAWFUL, -iVal1);
        }

        // Enable & Disable spawn groups

        

        // Port to mirror area?

        sTag = GetLocalString(OBJECT_SELF, "gdr_fail_port_to_mirror");

        if (sTag != "") {
            PortToMirror(oPC, sTag);
        }

        // Drop an object

        sTag = GetLocalString(OBJECT_SELF, "gdr_fail_drop");

        if (sTag != "") {

            oThing = GetItemPossessedBy(oPC, sTag);

            if (oThing != OBJECT_INVALID) {

                AssignCommand( oPC, DelayCommand(6.0, ActionPutDownItem(oThing)));

            }
        }

        // Trash an object

        sTag = GetLocalString(OBJECT_SELF, "gdr_fail_trash");

        if (sTag != "") {

            oThing = GetItemPossessedBy(oPC, sTag);

            if (oThing != OBJECT_INVALID) {

                DestroyObject(oThing);

            }
        }

        // Angry hordes

        if (GetLocalInt(OBJECT_SELF, "gdr_fail_all_hostile") == 1) {

            // Kick out of party

            RemoveFromParty(oPC);

            // Make all players hostile...

            oThing = GetFirstPC();

            while (GetIsObjectValid(oPC) == TRUE) {

                if (oPC != oThing) {

                    if (!GetIsEnemy(oThing, oPC)) {
                        SetPCDislike(oPC, oThing);
                    }

                    if (!GetIsEnemy(oPC, oThing)) {
                        SetPCDislike(oThing, oPC);
                    }
                }

                oThing = GetNextPC();
            }
        }

    } else {

        // Jump to waypoint

        sTag = GetLocalString(OBJECT_SELF, "gdr_pass_wp");

        if (sTag != "") {
            playerToWP(oPC, sTag);
        }

        // Apply passing fx

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_pass_effect");

        if (iVal1 != 0) {
            DelayCommand(1.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(iVal1), oPC));
        }

        // Sound effects?

        sTag = GetLocalString(OBJECT_SELF, "gdr_pass_sound");

        if (sTag != "") {
            oThing = GetObjectByTag(sTag);

            if (oThing != OBJECT_INVALID) {
                SoundObjectPlay(oThing);
            }
        }

        // Any spell like effects?

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_pass_spell");

        if (iVal1 > 0) {
            Enchant(oPC, iVal1, GetLocalInt(OBJECT_SELF, "gdr_pass_spell_power"),
                                GetLocalFloat(OBJECT_SELF, "gdr_pass_spell_duration"));
        }

        // Send player message

        sMsg = GetLocalString(OBJECT_SELF, "gdr_pass_msg");

        if (sMsg != "") {
            SendMessageToPC(oPC, sMsg);
        }

        // Play an animation...

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_pass_animation");

        if (iVal1 == 0) {
            iVal1 = 1;
        }

        AnimatePC(oPC, iVal1);

        // Who do we annoy?

        sTag = GetLocalString(OBJECT_SELF, "gdr_pass_annoy");

        if (sTag != "") {

            oThing = GetObjectByTag(sTag);

            if (oThing != OBJECT_INVALID) {
                if (GetObjectType(oThing) == OBJECT_TYPE_CREATURE) {
                    AdjustReputation(oPC, oThing, -100);
                }
            }
        }

        // Who do we pacify?

        sTag = GetLocalString(OBJECT_SELF, "gdr_pass_pacify");

        if (sTag != "") {

            oThing = GetObjectByTag(sTag);

            if (oThing != OBJECT_INVALID) {
                if (GetObjectType(oThing) == OBJECT_TYPE_CREATURE) {
                    AdjustReputation(oPC, oThing, 100);
                }
            }
        }

        // Alignment shift

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_pass_alignGE");

        if (iVal1 > 0) {
            AdjustAlignment(oPC, ALIGNMENT_EVIL, iVal1);
        } else if (iVal1 < 0) {
            AdjustAlignment(oPC, ALIGNMENT_GOOD, -iVal1);
        }

        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_pass_alignLC");

        if (iVal1 > 0) {
            AdjustAlignment(oPC, ALIGNMENT_CHAOTIC, iVal1);
        } else if (iVal1 < 0) {
            AdjustAlignment(oPC, ALIGNMENT_LAWFUL, -iVal1);
        }

        // Enable & Disable spawn_groups

        
        // Port to mirror area?

        sTag = GetLocalString(OBJECT_SELF, "gdr_pass_port_to_mirror");

        if (sTag != "") {
            PortToMirror(oPC, sTag);
        }

        // Drop an object

        sTag = GetLocalString(OBJECT_SELF, "gdr_pass_drop");

        if (sTag != "") {

            oThing = GetItemPossessedBy(oPC, sTag);

            if (oThing != OBJECT_INVALID) {

                AssignCommand( oPC, DelayCommand(6.0, ActionPutDownItem(oThing)));

            }
        }

        // Trash an object

        sTag = GetLocalString(OBJECT_SELF, "gdr_pass_trash");

        if (sTag != "") {

            oThing = GetItemPossessedBy(oPC, sTag);

            if (oThing != OBJECT_INVALID) {

                DestroyObject(oThing);

            }
        }

    }

    // Check total usage

    iVal1 = GetLocalInt(OBJECT_SELF, "gdr_uses_left");

    if (iVal1 == 0) {
        iVal1 = GetLocalInt(OBJECT_SELF, "gdr_max_uses");
    }

    if (iVal1 > 1) {
        iVal1 = iVal1 - 1;
        SetLocalInt(OBJECT_SELF, "gdr_uses_left", iVal1);
    } else if (iVal1 == 1) {

        // Suspend indefinetly...

        SetLocalInt(OBJECT_SELF, "gdr_suspended", 1);
        SetLocalInt(OBJECT_SELF, "gdr_uses_left", 0);
    }

    // Suspend for a while?

    iVal1 = GetLocalInt(OBJECT_SELF, "gdr_reuse_delay_min");

    if (iVal1 > 0) {

        iVal3 = iVal1;

        iVal2 = GetLocalInt(OBJECT_SELF, "gdr_reuse_delay_max");

        if (iVal2 > iVal1) {
           iVal3 += Random(iVal2 - iVal1) + 1;
        }

        // Schedule unsuspend

        DelayCommand(IntToFloat(iVal3), unsuspend_gdr(OBJECT_SELF));

        // Mark suspended

        SetLocalInt(OBJECT_SELF, "gdr_suspended", 1);
    }

    // All done

    return;
}