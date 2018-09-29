/*
	On enter script for caltrops bomb AoE.
	Slow effect plus possible damage.
*/

#include "gl_grenades_inc"
#include "x2_I0_SPELLS"
#include "NW_I0_SPELLS"

void main()
{
	DoCaltropsEffects(GetEnteringObject());
}