/*ga_enchant_enhance
by Dedic8ed 5/7/11 for Sigil: City of Doors PW
Essence distillation action pulled from a conversation.

Note: to make this work, I had to jury-rig things to enable the distillation to be performed by
the actual PC rather than the NPC. It does this by creating a Mortar & Pestle in the PC's inventory
and giving them an Alchemy skill increase of 30, enough to enable anything to be distilled. As soon
as the distillation is performed (and the gold taken), the Mortar & Pestle is removed from the PC's
inventory and the Alchemy bonus effect removed. It is recommended to set the NPC's conversation to
"multiplayer cutscene" in order to prevent any possible exploit or abuse.

	nAmount: the cost of performing distillation

*/

#include "ginc_param_const"
#include "x2_inc_itemprop"
#include "ginc_crafting"
#include "nw_i0_plot"

void main(int nAmount)
{
	object oPC = (GetPCSpeaker()==OBJECT_INVALID?OBJECT_SELF:GetPCSpeaker());
	object oItem = GetFirstItemInInventory(oPC);
	object oNPC = OBJECT_SELF;
    
	while(GetIsObjectValid(oItem))
    {
	if(TestStringAgainstPattern("N2_CRFT_DIST**",GetTag(oItem)))
		{
		CreateItemOnObject("mortar", oPC, 1,"mortar",FALSE);
		
		effect eAlchemy = EffectSkillIncrease(27,15);
		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAlchemy, oPC, 10.0f);
		TakeGoldFromCreature(nAmount, oPC);
		DoDistillation(oItem, oPC);
		TakeNumItems(oPC, "mortar", 1);
		RemoveEffect(oPC, eAlchemy);
		return;
		}
     oItem = GetNextItemInInventory(oPC);
    }

}