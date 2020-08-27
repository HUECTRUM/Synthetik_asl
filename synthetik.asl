state("Synthetik")
{
	string22 room: 0x22A4088, 0x280;
	double finalBossHp: 0x24D6EAC, 0x14, 0xD4, 0x12C, 0x80, 0x48, 0x8, 0x2C, 0x10, 0x390, 0x0;
}

init {
	vars.finalBossSpawned = false;
}

start {
	if (old.room.StartsWith("main_menu") && !current.room.StartsWith("main_menu")) {
		vars.finalBossSpawned = false;
		return true;
	}
}

isLoading {
	return false;
}

split {
	if (current.room.StartsWith("R_Boss_Heart") || current.room.StartsWith("_Boss_Heart") || current.room.StartsWith("Boss_Heart")) { //for some reason, sometimes the room name is just shifted for a frame or two
		print("final boss hp " + current.finalBossHp);
		if (!vars.finalBossSpawned && current.finalBossHp > 50000) { //this gets around tracking tanks' hitpoints which are stored in the same address
			print("final boss spawned");
			vars.finalBossSpawned = true;
		} else {
			if (vars.finalBossSpawned && current.finalBossHp < 1e-6) { //final boss killed
				return true;
			}
		}
	}
	return !old.room.StartsWith("main_menu") && !current.room.StartsWith("main_menu") && old.room != current.room
		&& !old.room.StartsWith("_Boss_Heart") && !old.room.StartsWith("Boss_Heart") && !current.room.StartsWith("_Boss_Heart") && !current.room.StartsWith("_Boss_Heart"); //really :(
}

