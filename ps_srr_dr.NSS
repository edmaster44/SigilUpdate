/* Feat created by Agony_Aunt/Loki_999 for SCoD PW
adds DR effect to target */


//#include "nw_i0_spells"
#include "x2_inc_spellhook"

const int FEAT_DR_CI10 = 2290;
const int FEAT_DR_EVIL10 = 2291;
const int FEAT_DR_MAGIC10 = 2292;
const int FEAT_DR_MAGIC15 = 2293;
const int FEAT_DR_BLUDG15 = 2294;
const int FEAT_DR_LAW15 = 2295;
const int FEAT_DR_AS5 = 2296;
const int FEAT_DR_AS10 = 2297;
const int FEAT_DR_BLUDG5 = 2298;
const int FEAT_DR_SLASH5 = 2299;
const int FEAT_DR_PIERCE5 = 2321;
const int FEAT_DR_MAGIC3_15 = 2890;
const int FEAT_DR_GOOD_15 = 2891;
const int FEAT_DR_MAGIC5 = 2899;


void main()
{
	//SpeakString("Firing Aura");
    if (!X2PreSpellCastCode())
    {
	// If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    object oTarget = GetSpellTargetObject();

    if (!GetHasSpellEffect(GetSpellId(), oTarget))
	{
		int iFeat = GetSpellFeatId();
		int iAmount;
		int iType;
		int iSpecific;

		switch(iFeat)
		{
			case FEAT_DR_CI10: iAmount=10; iType=DR_TYPE_GMATERIAL; iSpecific = GMATERIAL_METAL_COLD_IRON; break;
			case FEAT_DR_EVIL10: iAmount=10; iType=DR_TYPE_ALIGNMENT; iSpecific = ALIGNMENT_EVIL; break;
			case FEAT_DR_MAGIC10: iAmount=10; iType=DR_TYPE_DMGTYPE; iSpecific = DAMAGE_TYPE_MAGICAL; break;
			case FEAT_DR_MAGIC15: iAmount=15; iType=DR_TYPE_DMGTYPE; iSpecific = DAMAGE_TYPE_MAGICAL; break; // check this to be used and not IP_CONST
			case FEAT_DR_BLUDG15: iAmount=15; iType=DR_TYPE_DMGTYPE; iSpecific = 0; break; // Bludgeoning
			case FEAT_DR_LAW15: iAmount=15; iType=DR_TYPE_ALIGNMENT; iSpecific = ALIGNMENT_LAWFUL; break;
			case FEAT_DR_AS5: iAmount=5; iType=DR_TYPE_GMATERIAL; iSpecific = GMATERIAL_METAL_ALCHEMICAL_SILVER; break;
			case FEAT_DR_AS10: iAmount=10; iType=DR_TYPE_GMATERIAL; iSpecific = GMATERIAL_METAL_ALCHEMICAL_SILVER; break;
			case FEAT_DR_BLUDG5: iAmount=5; iType=DR_TYPE_DMGTYPE; iSpecific = 0; break; // Bludgeoning
			case FEAT_DR_SLASH5: iAmount=5; iType=DR_TYPE_DMGTYPE; iSpecific = 2; break; // Slashing
			case FEAT_DR_PIERCE5: iAmount=5; iType=DR_TYPE_DMGTYPE; iSpecific = 1; break; // Piercing
			case FEAT_DR_MAGIC3_15: iAmount=15; iType=DR_TYPE_MAGICBONUS; iSpecific = DAMAGE_POWER_PLUS_THREE; break;
			case FEAT_DR_GOOD_15: iAmount=15; iType=DR_TYPE_ALIGNMENT; iSpecific = ALIGNMENT_GOOD; break;
			case FEAT_DR_MAGIC5: iAmount=5; iType=DR_TYPE_MAGICBONUS; iSpecific = DAMAGE_POWER_PLUS_ONE; break;
			default: 		SendMessageToPC(GetFirstPC(), "Problem! Feat ID is " + IntToString(iFeat)); break;
			

		}
	
		effect eRes = EffectDamageReduction(iAmount, iSpecific, 0, iType);
		eRes = ExtraordinaryEffect(eRes);
		ApplyEffectToObject(DURATION_TYPE_PERMANENT, eRes, oTarget);
	}	
}