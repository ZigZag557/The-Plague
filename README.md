# The Plague: Evolved
The Plague addon for Garry's Mod. Mainly designed for DarkRP but it can be used in any gamemode.

### Description:
With this addon, you can create an epidemic, infect players and let them spread the infection each other or let them contain themselves. All players will be informed when the infection starts spreading while you watch them panic and seek the help of Plague Doctors/Doctors.
Plague Doctors/Doctors are immune to the plague and they have the cure, they can sense the location of the plague and cure sick people.


### How to Install?
Just drag and drop the folders into "Garry's Mod/garrysmod".


#### DarkRP Job
If you would like to add a Doctor job in DarkRP, add this attribute to the job:
```
PlayerLoadout = function(ply)

  ply.isImmune = true
  ply:Give("weapon_plaguecure")
  
end
```


### Settings
You can find the "settings.lua" file in "lua/plague". Change it to your liking.


### Contact
I can create addons for you!

E-Mail: bek_2001@hotmail.com       
Steam: https://steamcommunity.com/profiles/76561198062191304/

