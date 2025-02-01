#include "ff_safevar"

#include "x0_i0_spells"

void main(string mode, string text)
{
	object oPC = OBJECT_SELF;
//	SendMessageToPC(oPC,"Debug Mode: "+mode);
//	SendMessageToPC(oPC,"Debug Text: "+text);

	float fDuration = 9.0f; //Adjust this if you want to adjust how long the bubbles stay up.
	
	if(PS_GetLocalInt(oPC,"TypeVFXDisabled") == 1) return;
	
	if(mode == "init") SetGlobalGUIVariable(oPC,300,"");
	else if(mode == "added") //You can add additional parameters here if you don't want bubbles showing on certain things.
	{
		if(GetIsDM(oPC) || GetIsDMPossessed(oPC)) CloseGUIScreen(oPC,"SCREEN_ADDBUDDY");
	}
	else if(mode == "S") PS_DeleteLocalInt(oPC,"WhisperMode"); 
	else if(mode == "W") PS_SetLocalInt(oPC,"WhisperMode",1); //Whisper mode by default doesn't do chat bubbles.
	else if(mode == "type" && text != "" && PS_GetLocalInt(oPC,"WhisperMode") == 0 && GetIsObjectValid(oPC) && 
	GetIsPC(oPC) && !GetIsPossessedFamiliar(oPC))
	{		
		string sInitial = GetStringLeft(text,1); int iLength = GetStringLength(text);
		if(PS_GetLocalInt(oPC,"TextLength") == iLength || sInitial == "/" || sInitial == ">") return;
	
		PS_SetLocalInt(oPC,"TextLength",iLength);
		
		if(GetHasSpellEffect(34050,oPC)) RefreshSpellEffectDurations(oPC,34050,fDuration);
		else
		{
			effect eVFX = EffectNWN2SpecialEffectFile("fx_chatbubble");
			eVFX = SetEffectSpellId(eVFX,34050);
			eVFX = ExtraordinaryEffect(eVFX);
			
			ApplyEffectToObject(DURATION_TYPE_TEMPORARY,eVFX,oPC,fDuration);
		}
	}
	else if(mode == "clear") RemoveAnySpellEffects(34050,oPC);
}