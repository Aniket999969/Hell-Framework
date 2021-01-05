local blips = {
    -- Example {title="", colour=, id=, x=, y=, z=},
	 {name="Barber Shop", color=51, id=71, x=136.8, y=-1708.4, z=28.3},
	 {name="Barber Shop", color=51, id=71, x=-1282.6, y=-1116.8, z=6.0},
	 {name="Barber Shop", color=51, id=71, x=1931.5, y=3729.7, z=31.8},
	 {name="Barber Shop", color=51, id=71, x=1212.8, y=-472.9, z=65.2},
	 {name="Barber Shop", color=51, id=71, x=-32.9, y=-152.3, z=56.1},
	 {name="Barber Shop", color=51, id=71, x=-278.1, y=6228.5, z=30.7},
	 {name="Clothing Store", color=4, id=73, x=72.254, y=-1399.102, z=28.376},
	 {name="Clothing Store", color=4, id=73, x=-703.776,  y=-152.258,  z=36.415},
	 {name="Clothing Store", color=4, id=73, x=-167.863,  y=-298.969,  z=38.733},
	 {name="Clothing Store", color=4, id=73, x=428.694,   y=-800.106,  z=28.491},
	 {name="Clothing Store", color=4, id=73, x=-829.413,  y=-1073.710, z=10.328},
	 {name="Clothing Store", color=4, id=73, x=-1447.797, y=-242.461,  z=48.820},
	 {name="Clothing Store", color=4, id=73, x=11.632,    y=6514.224,  z=30.877},
	 {name="Clothing Store", color=4, id=73, x=123.646,   y=-219.440,  z=53.557},
	 {name="Clothing Store", color=4, id=73, x=1696.291,  y=4829.312,  z=41.063},
	 {name="Clothing Store", color=4, id=73, x=618.093,   y=2759.629,  z=41.088},
	 {name="Clothing Store", color=4, id=73, x=1190.550,  y=2713.441,  z=37.222},
	 {name="Clothing Store", color=4, id=73, x=-1193.429, y=-772.262,  z=16.324},
	 {name="Clothing Store", color=4, id=73, x=-3172.496, y=1048.133,  z=19.863},
	 {name="Clothing Store", color=4, id=73, x=-1108.441, y=2708.923,  z=18.107},
	 {name="Clothing Store", color=4, id=73, x=1858.9041748047, y=3687.8701171875,  z=34.267036437988},
	 {name="Clothing Store", color=4, id=73, x=2435.4169921875, y=4965.6123046875,  z=46.810600280762},
	 {name="Tattoo Shop", color=1, id=75, x=1322.645, y=-1651.976, z=52.275},
	 {name="Tattoo Shop", color=1, id=75, x=-1153.676, y=-1425.68, z=4.954},
	 {name="Tattoo Shop", color=1, id=75, x=322.139, y=180.467, z=103.587},
	 {name="Tattoo Shop", color=1, id=75, x=1864.633, y=3747.738, z=33.032},
	 {name="Tattoo Shop", color=1, id=75, x=-293.713, y=6200.04, z=31.487},
	 {name="Tattoo Shop", color=1, id=75, x=-293.713, y=6200.04, z=31.487},
	 {name="Court House",color=46, id=58, x= 231.8554, y= -422.3298,  z = 48.07677},
	 {name="Vangelico Jewery Store", color=4, id=617, x=-622.097, y=-230.720, z=38.057},
	 {name="Downtown Cab Co.", color=5, id=56, x=903.9481, y=-173.5247, z=74.0756},
	 {name="Bean Machine",color=10, id=106, x = -632.64, y = 235.25, z = 81.89}
}

Citizen.CreateThread(function()

    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.7)
      SetBlipColour(info.blip, info.color)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.name)
      EndTextCommandSetBlipName(info.blip)
    end
end)