return {
	map = "image/level.png",
	height = 5000,
	speed = 2,
	projectiles = {
		{
			class = "pistol",
			image = "image/bullet.png",
			projectilespeed = 20,
			distance = 1000
		},

		{
			class = "grenade",
			image = "image/grenade.png",
			projectilespeed = 5,
			distance = 500,
			exploderadius = 100
		}, 

		{
			class = "flame",
			image = "image/flame.png",
			projectilespeed = 5,
			distance = 400
		}
	},

	objects = {
		{
			class = "cop_pistol",
			weapon = 1,
			image = { "image/cop_pistol_idle.png", "image/cop_pistol_fire.png" },
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
			image = { "image/cop_grenade_idle.png", "image/cop_grenade_fire.png" },
			firerate = 120, 
			positions = {
				{ 360, 1200 } ,
				{ 100, 4200 } 
			}
		} ,

		{
			class = "cop_flame",
			weapon = 3,
			image = { "image/cop_flame_idle.png", "image/cop_flame_fire.png" },
			firerate = 90, 
			positions = {
				{ 620, 1800 } ,
				{ 120, 3000 } 
			}
		} ,

		{
			class = "car",
			image = "image/car.png"
			positions = {
				{ 560, 500, 270 } ,
				{ 150, 1700, 0 } ,
				{ 180, 2700, 90 } ,
				{ 160, 3900, 0 } ,
				{ 200, 1700, 0 } 
			} 
		}
	}
}