# The Plague: Evolved
The Plague addon for Garry's Mod. Mainly designed for DarkRP but it can be used in any gamemode.

### Description:
With this addon, you can create an epidemic, infect players and let them spread the infection to each other or let them contain themselves. All players will be informed when the infection starts spreading.
Plague Doctors are immune to the plague and they have the cure, they can sense the location of the plague and cure sick people.


### How to Install?
Drag and drop the "lua" and "sound" folders into "Garry's Mod/garrysmod".


#### DarkRP Job
If you would like to add a Doctor job in DarkRP, add this attribute to the job:
```
PlayerLoadout = function(ply)

  ply.isImmune = true
  ply:Give("weapon_plaguecure")
  
end
```
### Commands

/startplague x -> x Is the amount of players you would like to infect.

/stopplague -> Remove all infection.

/setimmune x -> x is the player's name you would like to make immune to the disease.


### Settings
You can find the "settings.lua" file in "lua/plague". Change it to your liking.


### Contact Information
Steam: https://steamcommunity.com/profiles/76561198062191304/

