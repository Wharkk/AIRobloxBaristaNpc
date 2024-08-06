-- AI BARISTA NPC V1 --

-- Only works with the console for now. Support with real npcs coming soon.

-- by @wharkk_ (discord) @hapygamer2 (roblox)

-- Coffee Knowledge Base
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

-- Custom Recipes Storage
local customRecipes = {}

-- Inventory of Ingredients
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

-- Ingredient Compatibility
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

-- Performance Data
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

local function tableFind(tbl, value)
	for _, v in ipairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

local function generateDetailedPreparation(ingredients)
	local preparationSteps = {}

	-- Ingredient-specific instructions
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

	if #preparationSteps == 0 then
		return "Combine ingredients in a coffee maker and serve."
	else
		return table.concat(preparationSteps, " ")
	end
end

local function isValidCombination(ingredients)
	for i = 1, #ingredients do
		local ingredient = ingredients[i]
		for j = i + 1, #ingredients do
			local otherIngredient = ingredients[j]
			if not tableFind(ingredientCompatibility[ingredient], otherIngredient) then
				return false
			end
		end
	end
	return true
end

local function recipeExists(ingredients)
	local sortedIngredients = {}
	for _, ingredient in ipairs(ingredients) do
		table.insert(sortedIngredients, ingredient)
	end
	table.sort(sortedIngredients)
	local recipeKey = table.concat(sortedIngredients, ", ")

	for _, recipe in pairs(coffeeKnowledgeBase) do
		local knownIngredients = recipe.ingredients
		local sortedKnownIngredients = {}
		for _, ingredient in ipairs(knownIngredients) do
			table.insert(sortedKnownIngredients, ingredient)
		end
		table.sort(sortedKnownIngredients)
		local knownRecipeKey = table.concat(sortedKnownIngredients, ", ")

		if recipeKey == knownRecipeKey then
			return true
		end
	end

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

	return false
end

local function generateCustomName(ingredients)
	local baseNames = {"Special Blend", "House Favorite", "Custom Brew", "Artisan Coffee", "Signature Cup"}
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

	local nameParts = {baseNames[math.random(#baseNames)]}

	for _, ingredient in ipairs(ingredients) do
		if ingredientNames[ingredient] then
			table.insert(nameParts, ingredientNames[ingredient])
		end
	end

	return table.concat(nameParts, " ")
end

local function logPerformance(recipe, success)
	if coffeeKnowledgeBase[recipe] then
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

local function prepareRecipe(coffeeType, ingredients)
	if #ingredients < 2 then
		print("A coffee recipe must have at least two ingredients.")
		return
	end

	-- Prevent recipes with only milk
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

	local knowledge = coffeeKnowledgeBase[coffeeType]
	if knowledge then
		-- Known recipe
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

local function generateCustomRecipe()
	local selectedIngredients = {}

	-- Ensure at least two ingredients and a base ingredient
	while #selectedIngredients < 2 do
		local ingredient = ingredientInventory[math.random(1, #ingredientInventory)]
		if not tableFind(selectedIngredients, ingredient) then
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

	return selectedIngredients
end

-- Automated Tests
local function automatedTests()
	print("Running automated tests...")

	for i = 1, 5 do
		local testIngredients = generateCustomRecipe()
		prepareRecipe("Custom Coffee", testIngredients)
		wait(1) -- Delay between tests
	end

	analyzePerformance()
end

-- Start automated tests
automatedTests()
