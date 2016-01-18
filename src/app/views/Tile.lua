
local Tile = class("Tile", function()
	return display.newSprite()
end)
local Requirer			= require"app.utilities.Requirer"
local TileTemplates		= Requirer.gameConstant().Tile
local TiledIdMapping	= Requirer.gameConstant().TiledID_Mapping
local ComponentManager	= Requirer.component("ComponentManager")

local function toTileTemplate(tiledID)
	return TiledIdMapping[tiledID]
end

local function createModel(param)
	if (type(param) ~= "table") then
		return nil, "Tile--createModel() the param is not a table."
	end
	
	-- TODO: load data from param and handle errors
	if (param.TiledID ~= nil) then
		local template = toTileTemplate(param.TiledID)
		if (template == nil) then
			return nil, "Tile--createModel() failed to map the TiledID to a Tile template."
		end
		
		return {spriteFrame = TileTemplates[template.Template].Animation, gridIndex = param.GridIndex}
	else
		return {spriteFrame = TileTemplates[param.Template].Animation, gridIndex = param.GridIndex}
	end
end

function Tile:ctor(param)
	self:load(param)

	return self
end

function Tile:load(param)
	local createModelResult, createModelMsg = createModel(param)
	if (createModelResult == nil) then
		return nil, "Tile:loadData() failed to load the param:\n" .. createModelMsg
	end
	
	if (createModelResult.gridIndex ~= nil) then
		if (not ComponentManager.hasBinded(self, "GridIndexable")) then	
			ComponentManager.bindComponent(self, "GridIndexable")
		end
		self:setGridIndexAndPosition(createModelResult.gridIndex)
	end
	
	self:setSpriteFrame(createModelResult.spriteFrame)
		
	return self
end

function Tile.createInstance(param)
	local tile, createTileMsg = Tile.new():load(param)
	if (tile == nil) then
		return nil, "Tile.createInstance() failed:\n" .. createTileMsg
	else
		return tile
	end
end

return Tile
