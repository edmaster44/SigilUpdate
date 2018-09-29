/******************************************************************************
*****                 Elechos_Esthetic_Crafter_Activate                   *****
*****                               V 0.2                                 *****
*****                             11/29/07                                *****
******************************************************************************/

//used on : activation of the el_esthetic_crafter item
//purpose : launch the nwnx_craft dialog between the PJ and Himself

void main()
{
    object oUser = GetItemActivator();
	
	//launch the dialog
	AssignCommand(oUser,ClearAllActions(TRUE));
	AssignCommand(oUser, ActionStartConversation(oUser, "dlg_nwnx_craft", TRUE, FALSE));
}