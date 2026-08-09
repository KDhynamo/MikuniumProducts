require("commons")

-- DEBUG: log the loading of this file to factorio-current.log
-- log("Loading data-final-fixes.lua for " .. modName)

-- TODO: Do this procedurally for all centrifuge recipes using uranium instead of this hardcoded list
local recipes = {
    "uranium-processing",
    "uranium-fuel-cell",
    "nuclear-fuel-reprocessing",
    "kovarex-enrichment-process"
}

for _, recipe_name in pairs(recipes) do
    local recipe = data.raw.recipe[recipe_name]
    if recipe then
        -- DEBUG: log the change to factorio-current.log
        -- log("Applying uranium tint to recipe: " .. recipe.name)
        
        -- Apply the tint
        recipe.crafting_machine_tint = {
            primary = {recipeTint[1], recipeTint[2], recipeTint[3], 1},
            secondary = {recipeTint[1], recipeTint[2], recipeTint[3], 1},
            tertiary = {recipeTint[1], recipeTint[2], recipeTint[3], 1},
            quaternary = {recipeTint[1], recipeTint[2], recipeTint[3], 1},
        }
    end
end

-- textplates mod compatibility: replace uranium textplate icons and pictures with mikunium versions, and update localised names
if mods and mods["textplates"] then
    local mikunium_graphics_path = modRoot .. "/graphics"

    local function replace_icon_path(proto)
        if proto.icon then
            proto.icon = proto.icon:gsub("__textplates__/graphics/entity/uranium/", mikunium_graphics_path .. "/textplates_mikunium/")
        end
        if proto.icons then
            for _, icon in pairs(proto.icons) do
                if icon.icon then
                    icon.icon = icon.icon:gsub("__textplates__/graphics/entity/uranium/", mikunium_graphics_path .. "/textplates_mikunium/")
                end
            end
        end
    end

    local function replace_picture_path(picture)
        if not picture then
            return
        end
        if picture.layers then
            for _, layer in pairs(picture.layers) do
                if layer and layer.filename then
                    layer.filename = layer.filename:gsub("__textplates__/graphics/entity/uranium/", mikunium_graphics_path .. "/textplates_mikunium/")
                    layer.filename = layer.filename:gsub("__textplates__/graphics/entity/uranium_glow/", mikunium_graphics_path .. "/textplates_mikunium_glow/")
                end
            end
        elseif picture.filename then
            picture.filename = picture.filename:gsub("__textplates__/graphics/entity/uranium/", mikunium_graphics_path .. "/textplates_mikunium/")
            picture.filename = picture.filename:gsub("__textplates__/graphics/entity/uranium_glow/", mikunium_graphics_path .. "/textplates_mikunium_glow/")
        end
    end

    local function get_textplate_size(name)
        if name:find("^textplate%-small%-uranium") then
            return "small"
        end
        if name:find("^textplate%-large%-uranium") then
            return "large"
        end
        return nil
    end

    for name, item in pairs(data.raw.item) do
        local size = get_textplate_size(name)
        if size then
            item.localised_name = { "item-name.textplate", { "textplates." .. size }, { "mikunium-textplates.material" } }
            replace_icon_path(item)
        end
    end

    for _, size in pairs({ "small", "large" }) do
        local entity = data.raw["simple-entity-with-force"] and data.raw["simple-entity-with-force"]["textplate-" .. size .. "-uranium"]
        if entity then
            entity.localised_name = { "entity-name.textplate", { "textplates." .. size }, { "mikunium-textplates.material" } }
            replace_icon_path(entity)
            if entity.pictures then
                for _, picture in pairs(entity.pictures) do
                    replace_picture_path(picture)
                end
            end
        end

        local recipe = data.raw.recipe["textplate-" .. size .. "-uranium"]
        if recipe then
            recipe.localised_name = { "item-name.textplate", { "textplates." .. size }, { "mikunium-textplates.material" } }
            replace_icon_path(recipe)
        end
    end

    local tech = data.raw.technology["textplates-uranium"]
    if tech then
        tech.localised_name = { "technology-name.textplate", { "mikunium-textplates.material-C" } }
        replace_icon_path(tech)
    end
end
