
void() monster_army = { monster_grunt(); }
void() monster_enforcer = { self.weapon = WP_SHOT; monster_grunt(); }
void() monster_demon1 = { monster_snork(); }
void() monster_shambler = { monster_bloodsucker(); }
void() monster_hell_knight = { monster_bloodsucker(); }
void() monster_knight = { monster_zombie(); }
void() monster_ogre = { monster_zombie(); }

void() weapon_nailgun = { info_loot(); }
void() weapon_supernailgun = { info_loot(); }
void() weapon_supershotgun = { info_loot(); }
void() weapon_rocketlauncher = { info_loot(); }
void() weapon_grenadelauncher = { info_loot(); }
void() item_spikes = { info_loot(); }
// void() weapon_lightning = { info_loot(); }

void() item_armor1 = { item_health(); }
void() item_armor2 = { item_health(); }
void() item_armorInv = { item_health(); }