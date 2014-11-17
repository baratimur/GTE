return {
	map = "images/level.png",
	height = 5000,
	speed = 2,
	projectiles = {
		{
			class = "pistol",
			image = "images/bullet.png",
			projectilespeed = 20,
			distance = 1000
		},

		{
			class = "grenade",
			image = "images/grenade.png",
			projectilespeed = 5,
			distance = 500,
			exploderadius = 100
		}, 

		{
			class = "flame",
			image = "images/flame.png",
			projectilespeed = 5,
			distance = 400
		}
	},
	
	obstacles = {
		{
			class = "car",
			image = "images/car.png",
			positions = {
				{ 560, 500, 270 } ,
				{ 150, 1700, 0 } ,
				{ 180, 2700, 90 } ,
				{ 160, 3900, 0 } ,
				{ 200, 1700, 0 } 
			}
		}
	},
	
	objects = {
		{
			class = "cop_pistol",
			weapon = 1,
			image = { "images/cop_pistol_idle.png", "images/cop_pistol_fire.png" },
			firerate = 60, 
			positions = {
				{ 100, 600 } ,
				{ 550, 1000 } ,
				{ 120, 2200 } ,
				{ 90, 2400 } ,
				{ 600, 3200 } ,
				{ 560, 4600 } ,
				{ 360, 4800 } ,
				{ 80, 4800 } 
			}
		} ,

		{
			class = "cop_grenade",
			weapon = 2,
			image = { "images/cop_grenade_idle.png", "images/cop_grenade_fire.png" },
			firerate = 120, 
			positions = {
				{ 360, 1200 } ,
				{ 100, 4200 } 
			}
		} ,

		{
			class = "cop_flame",
			weapon = 3,
			image = { "images/cop_flame_idle.png", "images/cop_flame_fire.png" },
			firerate = 90, 
			positions = {
				{ 620, 1800 } ,
				{ 120, 3000 } 
			}
		}
	}
}