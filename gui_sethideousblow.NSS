#include "aaa_constants"

const int SPELL_I_HINDERING_BLAST=1130;
const int SPELL_I_BINDING_BLAST=1131;
const int SPELL_I_OTHERWORLDLY_WHISPERS = 1059;
//Changed script targets from oPC to GetFirstPC(0) to allow companions to utilize scripts. -Taigen
//Changed script to be more PW friendly - cryptc
void main()
{
	object oPC = OBJECT_SELF;

	if (GetHasSpell(SPELL_I_HIDEOUS_BLOW, oPC) || GetHasFeat(FEAT_WARLOCK_BLOW_ELDRTICH, oPC, TRUE)) 
	{
		SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","HideousBlow",FALSE); 
	
		if (GetHasSpell(SPELL_I_BRIMSTONE_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","BrimstoneBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","BrimstoneBlast",TRUE);
	
		if (GetHasSpell(SPELL_I_BEWITCHING_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","BewitchingBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","BewitchingBlast",TRUE);
	
		if (GetHasSpell(SPELL_I_BESHADOWED_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","BeshadowedBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","BeshadowedBlast",TRUE);
	
		if (GetHasSpell(SPELL_I_DRAINING_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","DrainingBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","DrainingBlast",TRUE);
	
		if (GetHasSpell(SPELL_I_FRIGHTFUL_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","FrightfulBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","FrightfulBlast",TRUE);
	
		if (GetHasSpell(SPELL_I_HELLRIME_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","HellrimeBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","HellrimeBlast",TRUE);
	
		if (GetHasSpell(SPELL_I_NOXIOUS_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","NoxiousBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","NoxiousBlast",TRUE);
	
		if (GetHasSpell(SPELL_I_UTTERDARK_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","UtterdarkBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","UtterdarkBlast",TRUE);
	
		if (GetHasSpell(SPELL_I_VITRIOLIC_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","VitriolicBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","VitriolicBlast",TRUE); 
	
		if (GetHasSpell(SPELL_I_BINDING_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","BindingBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","BindingBlast",TRUE); 
	
		if (GetHasSpell(SPELL_I_HINDERING_BLAST, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","HinderingBlast",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","HinderingBlast",TRUE); 
	}
	else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","HideousBlow",TRUE); 
	
	if (GetHasSpell(SPELL_I_RETRIBUTIVE_INVISIBILITY, oPC))
	{
		SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","WalkUnseen",FALSE); 
		SetGUITexture(oPC,"SCREEN_WARLOCK","WalkUnseen","is_retributiveinvis.tga");
	}
	else if (GetHasSpell(SPELL_I_WALK_UNSEEN, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","WalkUnseen",FALSE); 
		else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","WalkUnseen",TRUE); 
	
	if (GetHasSpell(SPELL_I_DARK_ONES_OWN_LUCK, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","TwentyFour",FALSE); 
	else if (GetHasSpell(SPELL_I_BEGUILING_INFLUENCE, oPC)) 
		{
			SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","TwentyFour",FALSE); 
			SetGUITexture(oPC,"SCREEN_WARLOCK","TwentyFour","is_beguileinfluence.tga");
		}
		else if (GetHasSpell(SPELL_I_ENTROPIC_WARDING, oPC)) 
			{
				SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","TwentyFour",FALSE); 
				SetGUITexture(oPC,"SCREEN_WARLOCK","TwentyFour","is_entropicwarding.tga");
			}
			else if (GetHasSpell(SPELL_I_DEVILS_SIGHT, oPC)) 
				{
					SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","TwentyFour",FALSE); 
					SetGUITexture(oPC,"SCREEN_WARLOCK","TwentyFour","is_devilsight.tga");
				}
				else if (GetHasSpell(SPELL_I_LEAPS_AND_BOUNDS, oPC)) 
					{
						SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","TwentyFour",FALSE); 
						SetGUITexture(oPC,"SCREEN_WARLOCK","TwentyFour","is_leapsbounds.tga");
					}
					else if (GetHasSpell(SPELL_I_SEE_THE_UNSEEN, oPC)) 
						{
							SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","TwentyFour",FALSE); 
							SetGUITexture(oPC,"SCREEN_WARLOCK","TwentyFour","is_seeunseen.tga");
						}
						else if (GetHasSpell(SPELL_I_OTHERWORLDLY_WHISPERS, oPC)) 
							{
								SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","TwentyFour",FALSE); 
								SetGUITexture(oPC,"SCREEN_WARLOCK","TwentyFour","is_otherwhispers.tga");
							}
							else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","TwentyFour",TRUE); 
		
	if (GetHasSpell(SPELL_I_FLEE_THE_SCENE, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","FleeTheScene",FALSE); 
	else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","FleeTheScene",TRUE); 
						
	if (GetHasSpell(SPELL_I_DARK_FORESIGHT, oPC)) SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","DarkForesight",FALSE); 
	else SetGUIObjectDisabled(oPC,"SCREEN_WARLOCK","DarkForesight",TRUE); 
	

}
	