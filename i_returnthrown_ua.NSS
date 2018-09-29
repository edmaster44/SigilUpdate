// Script for the thrown weapons created by returning sets.
// Destroys the items if they are ever lost.
// By Electrohydra
// michel.remillard1@gmail.com

// Created 02/12/2018
// Last Edit 02/12/2018

void main()
{
    // * This code runs when the item is unacquired
    object oPC      = GetModuleItemLostBy();
    object oItem    = GetModuleItemLost();

 	DestroyObject(oItem, 0.0f);
}