// Original beholder script modified for player beholders by Agony_Aunt
// designed to run off feats.
// spells in range 1357 to 1363


#include "x0_i0_spells"


void DoBeholderPetrify(int nDuration,object oSource, object oTarget, int nSpellID);
void GiveImmunityFeedback(object oTarget, string sType){

	string sMessage = "Target immune to " + sType + ".";
	FloatingTextStringOnCreature(sMessage, oTarget); 
}

void main()
{

    int     nSpell = GetSpellId();
    object  oTarget = GetSpellTargetObject();
    int     nSave, bSave;
    int     nSaveDC = 12 + GetTotalLevels(OBJECT_SELF, TRUE)/2 + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    float   fDelay;
    effect  e1, eLink, eVis, eDur;
	int		iLevels = GetTotalLevels(OBJECT_SELF, TRUE);
	int		iBeam;
	int		iPart;
	
    switch (nSpell)
    {
         case 1357:
								if (GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH, OBJECT_SELF)){
									GiveImmunityFeedback(oTarget, "death spells");
									return;
								}
                                  nSave = SAVING_THROW_FORT;      //BEHOLDER_RAY_DEATH
								  iBeam = VFX_BEAM_EVIL;
								  iPart = BODY_NODE_MONSTER_1;
                                  break;

        case  1358:
								if (GetIsImmune(oTarget, IMMUNITY_TYPE_KNOCKDOWN ,OBJECT_SELF)){
									GiveImmunityFeedback(oTarget, "knockdown");
									return;
								}
                                  nSave = SAVING_THROW_WILL;     //BEHOLDER_RAY_TK
								  iBeam = VFX_BEAM_ILLUSION;
								  iPart = BODY_NODE_MONSTER_2;
                                  break;

        case 1359:              
								if (GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS ,OBJECT_SELF)){
									GiveImmunityFeedback(oTarget, "petrification");
									return;
								}									//BEHOLDER_RAY_PETRI
                                  nSave = SAVING_THROW_FORT;
								  iBeam = VFX_BEAM_TRANSMUTATION;
								  iPart = BODY_NODE_MONSTER_3;
                                  break;

        case 1360:              if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS ,OBJECT_SELF) ||
									GetIsImmune(oTarget, IMMUNITY_TYPE_CHARM, OBJECT_SELF)){
									GiveImmunityFeedback(oTarget, "charm spells");
									return;
								}
								// BEHOLDER_RAY_CHARM
                                  nSave = SAVING_THROW_WILL;
								  iBeam = VFX_BEAM_ENCHANTMENT;
								  iPart = BODY_NODE_MONSTER_4;
                                  break;

        case 1361:              if (GetIsImmune(oTarget, IMMUNITY_TYPE_SLOW ,OBJECT_SELF)){
									GiveImmunityFeedback(oTarget, "slow spells");
									return;
								}                                   //BEHOLDER_RAY_SLOW
                                  nSave = SAVING_THROW_WILL;
								  iBeam = VFX_BEAM_MAGIC;
								  iPart = BODY_NODE_MONSTER_1;
                                  break;

       case 1362: 				if (GetIsImmune(oTarget, IMMUNITY_TYPE_DEATH, OBJECT_SELF)){
									GiveImmunityFeedback(oTarget, "death spells");
									return;
								}// was 783 - gap of 2 from above.
                                  nSave = SAVING_THROW_FORT;        //BEHOLDER_RAY_WOUND
								  iBeam = VFX_BEAM_NECROMANCY;
								  iPart = BODY_NODE_MONSTER_2;
                                  break;

       case 1363: 				if (GetIsImmune(oTarget, IMMUNITY_TYPE_MIND_SPELLS ,OBJECT_SELF) ||
									GetIsImmune(oTarget, IMMUNITY_TYPE_FEAR, OBJECT_SELF)){
									GiveImmunityFeedback(oTarget, "fear");
									return;
								}// was 784                       				// BEHOLDER_RAY_FEAR
                                  nSave = SAVING_THROW_WILL;
								  iBeam = VFX_BEAM_MIND;
								  iPart = BODY_NODE_MONSTER_0;
                                  break;
    }

    SignalEvent(oTarget,EventSpellCastAt(OBJECT_SELF,GetSpellId(),TRUE));
    fDelay  = 0.0f;  //old -- GetSpellEffectDelay(GetLocation(oTarget),OBJECT_SELF);
    if (nSave == SAVING_THROW_WILL)
    {
        bSave = MySavingThrow(SAVING_THROW_WILL,oTarget, nSaveDC,SAVING_THROW_TYPE_ALL,OBJECT_SELF,fDelay) >0;
    }
    else if (nSave == SAVING_THROW_FORT)
    {
      bSave = MySavingThrow(SAVING_THROW_FORT,oTarget, nSaveDC,SAVING_THROW_TYPE_ALL,OBJECT_SELF,fDelay) >0;
    }

	effect eRay = EffectBeam(iBeam, OBJECT_SELF, iPart, FALSE);
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 2.0);
	
	
    if (!bSave)
    {

      switch (nSpell)
      {
         case 1357:                 e1 = EffectDeath(TRUE);
                                   eVis = EffectVisualEffect(VFX_IMP_DEATH);
                                   eLink = EffectLinkEffects(e1,eVis);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget);
                                   break;

          case 1358:                e1 = ExtraordinaryEffect(EffectKnockdown());
                                   eVis = EffectVisualEffect(VFX_IMP_STUN);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,6.0f);
                                   break;

          // Petrify for one round per SaveDC
          case 1359:                eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   DoBeholderPetrify(nSaveDC,OBJECT_SELF,oTarget,GetSpellId());
                                   break;


          case 1360:                e1 = EffectCutsceneDominated();
                                   eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);
								   if (!GetIsImmune(oTarget,IMMUNITY_TYPE_DOMINATE, OBJECT_SELF) && !GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS, OBJECT_SELF))
								   {
                                  	 ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                  	 ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,RoundsToSeconds(iLevels));
								   }
								   else
								   {
								   	SendMessageToPC(OBJECT_SELF, "The target is immune to this effect.");
								   }
                                   break;


          case 1361:                e1 = EffectSlow();
                                   eVis = EffectVisualEffect(VFX_IMP_SLOW);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,RoundsToSeconds(iLevels));
                                   break;

          case 1362:                e1 = EffectDamage(d8(iLevels)+iLevels);
                                   eVis = EffectVisualEffect(VFX_COM_BLOOD_REG_RED);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,e1,oTarget);
                                   break;


          case 1363:
                                   e1 = EffectFrightened();
                                   eVis = EffectVisualEffect(VFX_IMP_FEAR_S);
                                   eDur = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
                                   e1 = EffectLinkEffects(eDur,e1);
                                   ApplyEffectToObject(DURATION_TYPE_INSTANT,eVis,oTarget);
                                   ApplyEffectToObject(DURATION_TYPE_TEMPORARY,e1,oTarget,RoundsToSeconds(1+d4()));
                                   break;


       }

    }
    else
    {
         switch (nSpell)
         {
               case 1357:         e1 = EffectDamage((d8(iLevels)+iLevels)/2);
                                 eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
                                 eLink = EffectLinkEffects(e1,eVis);
                                 ApplyEffectToObject(DURATION_TYPE_INSTANT,eLink,oTarget);
        }
    }
}



void DoBeholderPetrify(int nDuration,object oSource, object oTarget, int nSpellID)
{

    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF) && !GetIsDead(oTarget))
    {
        // * exit if creature is immune to petrification
        if (spellsIsImmuneToPetrification(oTarget) == TRUE)
        {
            return;
        }
        //float fDifficulty = 0.0;
        int bIsPC = GetIsPC(oTarget);
       // int bShowPopup = FALSE;

        // * calculate Duration based on difficulty settings
      
        effect ePetrify = EffectPetrify();
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eLink = EffectLinkEffects(eDur, ePetrify);


        /// * The duration is permanent against NPCs but only temporary against PCs
        if (bIsPC == TRUE || GetPlotFlag(oTarget) == TRUE)
        {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(GetTotalLevels(oSource, TRUE)));
        }
        else
        {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
		// kill after 30 seconds so that XP is granted
		DelayCommand(30.0, SendMessageToPC(oSource, "The petrified " + GetName(oTarget) + " has crumbled and died."));
		DelayCommand(30.0, ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, TRUE, TRUE, TRUE), oTarget));
    	}
	}
}