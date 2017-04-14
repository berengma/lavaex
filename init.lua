

local car = 8                        -- cleanup_action_radius
local ore = {"default:stone_with_coal","default:stone_with_iron","default:stone_with_diamond","default:stone_with_copper","default:stone_with_mese","default:stone_with_gold"}
local ore_gen_possibility = 3


local function gen_ore(pos, source)
  local rnd = math.random(100)
  
    if rnd <= ore_gen_possibility then
      
      minetest.set_node(pos, {name=ore[math.random(6)]})
    
    else
      if source then 
	minetest.set_node(pos, {name="default:obsidian"})
      else
	minetest.set_node(pos, {name="default:stone"})
      end
    end
end

      
local function lava_killer(pos, user)
	local name = user:get_player_name()
	local minp = vector.subtract(pos, car)
        local maxp = vector.add(pos, car)

	local poslistlsource = minetest.find_nodes_in_area(minp, maxp, {"default:lava_source"})
	local poslistlflow   = minetest.find_nodes_in_area(minp, maxp, {"default:lava_flowing"})

	
		for _,cpos in pairs(poslistlsource) do

					
			if not minetest.is_protected(cpos, name) then
			   
				gen_ore(cpos, true)
				
			end
		
			
		end	
		
		for _,cpos in pairs(poslistlflow) do

					
			if not minetest.is_protected(cpos, name) then
			   
				gen_ore(cpos, false)
				
			end
		
			
		end
			
				
end


minetest.register_craftitem("lavaex:gunpowder", {
	description = "Gunpowder",
	inventory_image = "lavaex_gunpowder.png",
})

minetest.register_craftitem("lavaex:lavaex", {
	description = "Kills lava in a radius of "..car.." nodes",
	inventory_image = "lavaex_lavaex.png",
	liquids_pointable = true,
 
	on_place = function(itemstack, dropper, pointed)
	  local pos = minetest.get_pointed_thing_position(pointed, true)
		
	  if pos ~= nil then
		lava_killer(pos, dropper)
		--minetest.remove_node(pos)
		itemstack:take_item()
		return itemstack
	  end
	end,
})


minetest.register_craft({
	output = "lavaex:gunpowder 3",
	recipe = {
		{"technic:sulfur_dust", "technic:sulfur_dust", "technic:sulfur_dust"},
		{"technic:coal_dust", "technic:coal_dust", "technic:coal_dust"},
		{"technic:uranium0_dust", "technic:uranium0_dust", "technic:uranium0_dust"},
	}
})

minetest.register_craft({
	output = "lavaex:lavaex",
	recipe = {
		{"default:ice", "default:steel_ingot", "default:ice"},
		{"default:steel_ingot", "lavaex:gunpowder", "default:steel_ingot"},
		{"default:ice", "default:steel_ingot", "default:ice"},
	}
})
