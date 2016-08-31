/*
	Anti C-Bug ~ Kevin-Reinke

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

// ** INCLUDES

#include <a_samp>

// ** DEFINES

// *** FUNCTIONS

// **** KEY SIMULATIONS

#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

// ** VARIABLES

// *** PER-PLAYER VARIABLES

// **** GENERAL

new bool:pCBugging[MAX_PLAYERS] = false;

// **** TIMERS

new ptmCBugFreezeOver[MAX_PLAYERS];

// **** TIMESTAMPS

new ptsLastFiredWeapon[MAX_PLAYERS];

// ** CALLBACKS

public OnFilterScriptInit()
{
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	ResetPlayerVariables(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	GivePlayerWeapon(playerid, WEAPON_DEAGLE, 500);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!pCBugging[playerid])
	{
		if(PRESSED(KEY_FIRE))
		{
			switch(GetPlayerWeapon(playerid))
			{
				case WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SNIPER:
				{
					ptsLastFiredWeapon[playerid] = gettime();
				}
			}
		}
		else if(PRESSED(KEY_CROUCH))
		{
			if((gettime() - ptsLastFiredWeapon[playerid]) < 1)
			{
				TogglePlayerControllable(playerid, false);

				pCBugging[playerid] = true;

				GameTextForPlayer(playerid, "~r~~h~DON'T C-BUG!", 3000, 4);

				KillTimer(ptmCBugFreezeOver[playerid]);
				ptmCBugFreezeOver[playerid] = SetTimerEx("CBugFreezeOver", 1500, false, "i", playerid);
			}
		}
	}
	return 1;
}

// ** LOAD PLAYER COMPONENTS

stock ResetPlayerVariables(playerid)
{
	// ** GENERAL

	pCBugging[playerid] = false;

	// ** TIMERS

	KillTimer(ptmCBugFreezeOver[playerid]);

	// ** TIMESTAMPS

	ptsLastFiredWeapon[playerid] = 0;
	return 1;
}

// ** FUNCTIONS

forward CBugFreezeOver(playerid);
public CBugFreezeOver(playerid)
{
	TogglePlayerControllable(playerid, true);

	pCBugging[playerid] = false;
	return 1;
}