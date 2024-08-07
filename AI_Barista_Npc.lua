-- AI BARISTA NPC V1 --

-- Only works with the console for now. Support with real npcs coming soon.

-- This project was made for fun, and it is based on "Free Guy" (the movie) npcs

-- by @wharkk_ (discord) @hapygamer2 (roblox)

-- Coffee Knowledge Base so the npc learns the basics of making coffees
local coffeeKnowledgeBase = {
	["Latte"] = {
		description = "A latte is a coffee drink made with espresso and steamed milk.",
		ingredients = {"Espresso", "Steamed Milk"},
		preparation = "1. Prepare an espresso shot. 2. Steam the milk. 3. Combine the espresso and steamed milk.",
		typicalRatio = "1/3 espresso, 2/3 milk"
	},
	["Cappuccino"] = {
		description = "A cappuccino is a coffee drink with a base of espresso and topped with equal parts steamed milk and milk foam.",
		ingredients = {"Espresso", "Steamed Milk", "Foamed Milk"},
		preparation = "1. Prepare an espresso shot. 2. Steam the milk. 3. Top with foamed milk.",
		typicalRatio = "1/3 espresso, 1/3 steamed milk, 1/3 foamed milk"
	},
	["Americano"] = {
		description = "An Americano is a simple coffee drink made with espresso and hot water.",
		ingredients = {"Espresso", "Water"},
		preparation = "1. Prepare an espresso shot. 2. Dilute with hot water.",
		typicalRatio = "1/3 espresso, 2/3 water"
	}
	-- Add more coffee types as needed
}

-- Custom Recipes Storage, so the npc knows if it already made a recipe (basically by checking in this table if the new recipe it just created was 
-- already made before)
local customRecipes = {}

-- Inventory of Ingredients that the npc can use to make coffee
local ingredientInventory = {
	"Espresso",
	"Steamed Milk",
	"Foamed Milk",
	"Water",
	"Hazelnut",
	"Vanilla",
	"Chocolate",
	"Sugar"
}

-- Ingredient Compatibility so the npc doesn't make coffees with only sugar and chocolate for example
local ingredientCompatibility = {
	["Espresso"] = {"Steamed Milk", "Foamed Milk", "Water", "Hazelnut", "Vanilla", "Chocolate"},
	["Steamed Milk"] = {"Espresso", "Foamed Milk", "Vanilla", "Chocolate"},
	["Foamed Milk"] = {"Espresso", "Steamed Milk"},
	["Water"] = {"Espresso"},
	["Hazelnut"] = {"Espresso", "Steamed Milk", "Vanilla"},
	["Vanilla"] = {"Espresso", "Steamed Milk", "Hazelnut"},
	["Chocolate"] = {"Espresso", "Steamed Milk", "Vanilla"},
	["Sugar"] = {"Espresso", "Steamed Milk", "Vanilla"}
}

-- Performance Data so you can analyze the npc's performance
local performanceData = {
	recipes = {
		["Latte"] = {successes = 0, failures = 0},
		["Cappuccino"] = {successes = 0, failures = 0},
		["Americano"] = {successes = 0, failures = 0},
		-- Add more recipes as needed
	},
	customRecipes = {
		attempts = 0,
		successes = 0,
		failures = 0
	}
}

-- Functions

-- This function is used to find if any 'value' is in a specific 'table' (tbl)
local function tableFind(tbl, value)
	for _, v in ipairs(tbl) do
		if v == value then
			
			-- Returns true if it is
			return true
		end
	end
	
	-- And false if it isn't
	return false
end

-- Generates "detailed" recipe, where you can learn how to make the coffee the npc just invented
local function generateDetailedPreparation(ingredients)
	local preparationSteps = {}

	-- Ingredient-specific instructions so it is professional and somehow like a human interaction or when following a classic guide
	local instructions = {
		["Espresso"] = "Prepare an espresso shot.",
		["Steamed Milk"] = "Steam the milk.",
		["Foamed Milk"] = "Top with foamed milk.",
		["Water"] = "Dilute with hot water.",
		["Hazelnut"] = "Add hazelnut flavor.",
		["Vanilla"] = "Add vanilla flavor.",
		["Chocolate"] = "Add chocolate syrup.",
		["Sugar"] = "Add sugar to taste."
	}

	-- Build preparation steps based on ingredients
	for _, ingredient in ipairs(ingredients) do
		if instructions[ingredient] then
			table.insert(preparationSteps, instructions[ingredient])
		end
	end

	-- If it doesn't find anything in the steps (most likely because there was no instructions listed about the said ingredient in the instructions 
	-- table)
	if #preparationSteps == 0 then
		
		-- Then it'll just say to combine ingredients and serve
		return "Combine ingredients in a coffee maker and serve."
	else
		-- Else it'll return the steps to prepare the coffee in a human readable format and nicely combined so it makes a real sentence and not only
		-- an array containing each steps
		return table.concat(preparationSteps, " ")
	end
end

-- Here we check if the combination (so the coffee that the npc invented) is doable and can still be called a coffee, and not only sugar and 
-- chocolate for example
local function isValidCombination(ingredients)
	
	-- Check if all the coffe ingredients are compatible with each other
	for i = 1, #ingredients do
		local ingredient = ingredients[i]
		for j = i + 1, #ingredients do
			local otherIngredient = ingredients[j]
			
			-- Checking here if they are actually compatible using the tableFind() function that was defined above
			if not tableFind(ingredientCompatibility[ingredient], otherIngredient) then
				
				-- If it isn't compatible, then it will return false
				return false
			end
		end
	end
	
	-- If it is, then it will return true
	return true
end

-- Here we check if the combination (so the coffee that the npc invented) already exists in the coffee recipes, so basically if it has already 
-- imagined this combination or if it already exists in the original knowledge base
local function recipeExists(ingredients)
	
	-- Making a new table to sort ingredients so we don't directly use the one we got in parameters (for security purposes, so we don't mess it up)
	local sortedIngredients = {}
	
	-- Here we're adding every ingredients used to make the coffee in the table used to sort them
	for _, ingredient in ipairs(ingredients) do
		table.insert(sortedIngredients, ingredient)
	end
	table.sort(sortedIngredients)
	
	-- Getting every keys of the table so we can further use that to compare if the combination already exists
	local recipeKey = table.concat(sortedIngredients, ", ")

	-- Checking if the coffee already exists by looping through each coffees we have in the starting knowledge database
	for _, recipe in pairs(coffeeKnowledgeBase) do
		local knownIngredients = recipe.ingredients
		
		-- Here it's the same as above, we're making a new table to sort the ingredients in each knowned recipes
		local sortedKnownIngredients = {}
		for _, ingredient in ipairs(knownIngredients) do
			table.insert(sortedKnownIngredients, ingredient)
		end
		table.sort(sortedKnownIngredients)
		local knownRecipeKey = table.concat(sortedKnownIngredients, ", ")

		if recipeKey == knownRecipeKey then
			
			-- If the recipe (so the coffee) already exists it returns true
			return true
		end
	end

	-- Same here but with the coffees the npc invented/created on his own
	for recipeName, recipe in pairs(customRecipes) do
		local customIngredients = recipe.ingredients
		local sortedCustomIngredients = {}
		for _, ingredient in ipairs(customIngredients) do
			table.insert(sortedCustomIngredients, ingredient)
		end
		table.sort(sortedCustomIngredients)
		local customRecipeKey = table.concat(sortedCustomIngredients, ", ")

		if recipeKey == customRecipeKey then
			return true
		end
	end

	-- If the recipe is new, so it doesn't already exists it returns false
	return false
end

-- This function is pretty simple, it will be used to generate custom names for the coffee the bot invented
local function generateCustomName(ingredients)
	
	-- Here we're storing some base names (they will be added if certain conditions are met in the future, so in/for special occasions)
	local baseNames = {"Special Blend", "House Favorite", "Custom Brew", "Artisan Coffee", "Signature Cup"}
	
	-- Every ingredients names used to make the coffee
	local ingredientNames = {
		["Espresso"] = "Espresso",
		["Steamed Milk"] = "Steamed Milk",
		["Foamed Milk"] = "Foamed Milk",
		["Water"] = "Water",
		["Hazelnut"] = "Hazelnut",
		["Vanilla"] = "Vanilla",
		["Chocolate"] = "Chocolate",
		["Sugar"] = "Sugar"
	}
	
	-- Getting a random base name
	local nameParts = {baseNames[math.random(#baseNames)]}

	-- Loops through each ingredients used to make the newly created coffee 
	for _, ingredient in ipairs(ingredients) do
		
		-- Checks if the coffee exists in ingredient table (ingredientNames)
		if ingredientNames[ingredient] then
			
			-- If it does exists we'll add it to the name (they will be added with prepositions to make the sentence even more human)
			table.insert(nameParts, ingredientNames[ingredient])
		end
	end

	-- Getting every keys of the newly generated name (stored in the nameParts table), so we can then assemble them
	return table.concat(nameParts, " ")
end

-- Here we log the npc's performance for development reasons
-- It is basically used to analyze the efficiency of the npc and to get his statistics
local function logPerformance(recipe, success)
	
	-- checking if the base recipe exists
	if coffeeKnowledgeBase[recipe] then
		
		-- Handle base recipes
		if success then
			performanceData.recipes[recipe].successes = performanceData.recipes[recipe].successes + 1
		else
			performanceData.recipes[recipe].failures = performanceData.recipes[recipe].failures + 1
		end
	else
		-- Handle custom recipes
		if success then
			performanceData.customRecipes.successes = performanceData.customRecipes.successes + 1
		else
			performanceData.customRecipes.failures = performanceData.customRecipes.failures + 1
		end
		performanceData.customRecipes.attempts = performanceData.customRecipes.attempts + 1
	end
end

-- This function will be handling the proccess of preparing coffees/making recipes based on a type of coffee and ingredients
local function prepareRecipe(coffeeType, ingredients)
	
	-- Security to check if the coffee isn't just one ingredient (e.g: a coffee can't be just milk (and yes before I added this security measure
	-- the npc actually imagined a coffee recipe with steamed milk only or chocolate syrup only))
	if #ingredients < 2 then
		print("A coffee recipe must have at least two ingredients.")
		return
	end

	-- Prevent recipes with only milk, pretty self explanatory if you ask me
	local hasBase = false
	for _, ingredient in ipairs(ingredients) do
		if ingredient == "Espresso" or ingredient == "Water" then
			hasBase = true
			break
		end
	end

	if not hasBase and (tableFind(ingredients, "Steamed Milk") or tableFind(ingredients, "Foamed Milk")) then
		print("Recipe cannot contain only milk ingredients.")
		return
	end

	if not hasBase then
		print("Recipe must include a base ingredient (Espresso or Water).")
		return
	end

	-- Check if the recipe is in the basic database
	local knowledge = coffeeKnowledgeBase[coffeeType]
	if knowledge then
		-- Known recipe
		-- It will still prepare it, even if it is already known if it has the right ingredients (so basically if a customer (it can be another npc 
		-- or a player) comes up and ask for a capuccino it'll be able to remember how to make one)
		print("Preparing " .. coffeeType)
		local correct = true
		for _, ingredient in ipairs(knowledge.ingredients) do
			if not tableFind(ingredients, ingredient) then
				print("Missing ingredient: " .. ingredient)
				correct = false
			end
		end

		if correct then
			print("Recipe is correct. Enjoy your " .. coffeeType .. "!")
			print("Recipe: " .. coffeeType)
			print("Ingredients: " .. table.concat(knowledge.ingredients, ", "))
			print("Preparation: " .. knowledge.preparation)
			logPerformance(coffeeType, true)
		else
			logPerformance(coffeeType, false)
		end
	else
		-- Custom recipe
		-- This can be triggered if the npc made a new recipe by itself, or if a customer ask for a coffee it doesn't know about yet. That's why
		-- it's so powerful, it will be able to learn how to make it by itself (I mean in theory.. When the system will be fully done)
		if isValidCombination(ingredients) then
			if recipeExists(ingredients) then
				print("Recipe with these ingredients already exists.")
			else
				local recipeName = generateCustomName(ingredients)
				print("Preparing " .. recipeName .. " with ingredients: " .. table.concat(ingredients, ", "))
				local preparation = generateDetailedPreparation(ingredients)
				print("Preparation: " .. preparation)
				
				-- Store custom recipe
				customRecipes[recipeName] = {
					ingredients = ingredients,
					preparation = preparation
				}
				print("Recipe: " .. recipeName)
				print("Ingredients: " .. table.concat(ingredients, ", "))
				print("Preparation: " .. preparation)
				logPerformance(recipeName, true)
			end
		else
			print("Invalid ingredient combination for " .. coffeeType .. ".")
			logPerformance(coffeeType, false)
		end
	end
end

-- Automatically analyzing the npc's performance
local function analyzePerformance()
	print("Analyzing performance:")
	for recipe, data in pairs(performanceData.recipes) do
		print("Recipe: " .. recipe)
		print("Successes: " .. data.successes)
		print("Failures: " .. data.failures)
	end

	print("Custom Recipes Performance:")
	print("Attempts: " .. performanceData.customRecipes.attempts)
	print("Successes: " .. performanceData.customRecipes.successes)
	print("Failures: " .. performanceData.customRecipes.failures)
end

-- Here we generate a custom recipe, so basically we make the npc think and test by itself to invent/make a new recipe
local function generateCustomRecipe()
	
	-- Table to store every ingredients used to make the newly invented coffee
	local selectedIngredients = {}

	-- Ensure at least two ingredients and a base ingredient, this basically is the tests that the npc will make to know if a coffee is a good idea
	-- or not
	while #selectedIngredients < 2 do
		local ingredient = ingredientInventory[math.random(1, #ingredientInventory)]
		if not tableFind(selectedIngredients, ingredient) then
			-- It'll insert in the selectedIngredients table the ingredient if it's not already in the table
			table.insert(selectedIngredients, ingredient)
		end
	end

	-- Ensure at least one base ingredient
	local hasBase = false
	for _, ingredient in ipairs(selectedIngredients) do
		if ingredient == "Espresso" or ingredient == "Water" then
			hasBase = true
			break
		end
	end

	if not hasBase then
		table.insert(selectedIngredients, "Espresso")
	end

	-- Returns every ingredients used to make this coffee
	return selectedIngredients
end

-- Automated Tests
local function automatedTests()
	print("Running automated tests...")

	-- Tests ran with a for loop so we can edit it and choose how many times we want to run it
	-- In this case, it'll run 5 times
	for i = 1, 5 do
		local testIngredients = generateCustomRecipe()
		prepareRecipe("Custom Coffee", testIngredients)
		wait(1) -- Delay between tests
	end

	-- At the end of the tests we'll analyze the npc's performance
	analyzePerformance()
end

-- Start automated tests
automatedTests()
