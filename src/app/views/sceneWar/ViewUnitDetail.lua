
local ViewUnitDetail = class("ViewUnitDetail", cc.Node)

local LocalizationFunctions = require("app.utilities.LocalizationFunctions")
local AnimationLoader       = require("app.utilities.AnimationLoader")

local FONT_SIZE   = 25
local LINE_HEIGHT = FONT_SIZE / 5 * 8

local BACKGROUND_WIDTH      = display.width * 0.86
local BACKGROUND_HEIGHT     = math.min(LINE_HEIGHT * 11 + 10, display.height * 0.95)
local BACKGROUND_POSITION_X = (display.width  - BACKGROUND_WIDTH) / 2
local BACKGROUND_POSITION_Y = (display.height - BACKGROUND_HEIGHT) / 2

local DESCRIPTION_WIDTH      = BACKGROUND_WIDTH - 10
local DESCRIPTION_HEIGHT     = LINE_HEIGHT * 2
local DESCRIPTION_POSITION_X = BACKGROUND_POSITION_X + 5
local DESCRIPTION_POSITION_Y = BACKGROUND_POSITION_Y + BACKGROUND_HEIGHT - DESCRIPTION_HEIGHT - 8

local MOVEMENT_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local MOVEMENT_INFO_HEIGHT     = LINE_HEIGHT
local MOVEMENT_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local MOVEMENT_INFO_POSITION_Y = DESCRIPTION_POSITION_Y - MOVEMENT_INFO_HEIGHT

local VISION_INFO_WIDTH      = 300
local VISION_INFO_HEIGHT     = LINE_HEIGHT
local VISION_INFO_POSITION_X = BACKGROUND_POSITION_X + BACKGROUND_WIDTH - VISION_INFO_WIDTH
local VISION_INFO_POSITION_Y = DESCRIPTION_POSITION_Y - MOVEMENT_INFO_HEIGHT

local FUEL_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local FUEL_INFO_HEIGHT     = LINE_HEIGHT * 2
local FUEL_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local FUEL_INFO_POSITION_Y = MOVEMENT_INFO_POSITION_Y - FUEL_INFO_HEIGHT

local PRIMARY_WEAPON_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local PRIMARY_WEAPON_INFO_HEIGHT     = LINE_HEIGHT * 2
local PRIMARY_WEAPON_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local PRIMARY_WEAPON_INFO_POSITION_Y = FUEL_INFO_POSITION_Y - PRIMARY_WEAPON_INFO_HEIGHT

local SECONDARY_WEAPON_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local SECONDARY_WEAPON_INFO_HEIGHT     = LINE_HEIGHT * 2
local SECONDARY_WEAPON_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local SECONDARY_WEAPON_INFO_POSITION_Y = PRIMARY_WEAPON_INFO_POSITION_Y - SECONDARY_WEAPON_INFO_HEIGHT

local DEFENSE_INFO_WIDTH      = BACKGROUND_WIDTH - 10
local DEFENSE_INFO_HEIGHT     = LINE_HEIGHT * 2
local DEFENSE_INFO_POSITION_X = BACKGROUND_POSITION_X + 5
local DEFENSE_INFO_POSITION_Y = SECONDARY_WEAPON_INFO_POSITION_Y - DEFENSE_INFO_HEIGHT

local ICON_SCALE = FONT_SIZE * 0.016
local GRID_WIDTH = require("app.utilities.GameConstantFunctions").getGridSize().width

--------------------------------------------------------------------------------
-- Util functions.
--------------------------------------------------------------------------------
local BUTTOM_LINE_SPRITE_FRAME_NAME = "c03_t06_s01_f01.png"

local function createBottomLine(posX, poxY, width, height)
    local line = cc.Sprite:createWithSpriteFrameName(BUTTOM_LINE_SPRITE_FRAME_NAME)
    line:ignoreAnchorPointForPosition(true)
        :setPosition(posX, poxY)
        :setAnchorPoint(0, 0)
        :setScaleX(width / line:getContentSize().width)

    return line
end

local FONT_NAME          = "res/fonts/msyhbd.ttc"
local FONT_COLOR         = {r = 255, g = 255, b = 255}
local FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local FONT_OUTLINE_WIDTH = 2

local function createLabel(posX, posY, width, height, text)
    local label = cc.Label:createWithTTF(text or "", FONT_NAME, FONT_SIZE)
    label:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setDimensions(width, height)

        :setTextColor(FONT_COLOR)
        :enableOutline(FONT_OUTLINE_COLOR, FONT_OUTLINE_WIDTH)

    return label
end

local function createUnitIcons(posX, posY)
    local icons = cc.Node:create()
    icons:ignoreAnchorPointForPosition(true)
        :setPosition(posX, posY)
        :setScale(ICON_SCALE)

    return icons
end

local function resetIconsWithTypeNames(icons, typeNames)
    icons:removeAllChildren()
        :setVisible(true)

    for i, name in ipairs(typeNames) do
        local icon = cc.Sprite:create()
        icon:ignoreAnchorPointForPosition(true)
            :setPosition(GRID_WIDTH * (i - 1), 0)
            :playAnimationForever(AnimationLoader.getUnitAnimation(name))

        icons:addChild(icon)
    end

    icons.m_Width = #typeNames * GRID_WIDTH * ICON_SCALE
end

--------------------------------------------------------------------------------
-- The screen background (the grey transparent mask).
--------------------------------------------------------------------------------
local function createScreenBackground()
    local background = cc.LayerColor:create({r = 0, g = 0, b = 0, a = 160})
    background:setContentSize(display.width, display.height)
        :ignoreAnchorPointForPosition(true)

        :setOpacity(180)

    return background
end

local function initWithScreenBackground(self, background)
    self.m_ScreenBackground = background
    self:addChild(background)
end

--------------------------------------------------------------------------------
-- The detail panel background.
--------------------------------------------------------------------------------
local function createDetailBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(BACKGROUND_POSITION_X, BACKGROUND_POSITION_Y)

        :setContentSize(BACKGROUND_WIDTH, BACKGROUND_HEIGHT)
        :setOpacity(180)

    return background
end

local function initWithDetailBackground(self, background)
    self.m_DetailBackground = background
    self:addChild(background)
end

--------------------------------------------------------------------------------
-- The brief description for the unit.
--------------------------------------------------------------------------------
local function createDescriptionBottomLine()
    return createBottomLine(DESCRIPTION_POSITION_X + 5, DESCRIPTION_POSITION_Y,
                            DESCRIPTION_WIDTH - 10, DESCRIPTION_HEIGHT)
end

local function createDescriptionLabel()
    return createLabel(DESCRIPTION_POSITION_X, DESCRIPTION_POSITION_Y,
                        DESCRIPTION_WIDTH, DESCRIPTION_HEIGHT)
end

local function createDescription()
    local bottomLine = createDescriptionBottomLine()
    local label = createDescriptionLabel()

    local description = cc.Node:create()
    description:ignoreAnchorPointForPosition(true)
        :addChild(bottomLine)
        :addChild(label)

    description.m_BottomLine   = bottomLine
    description.m_Label        = label

    return description
end

local function initWithDescription(self, description)
    self.m_Description = description
    self:addChild(description)
end

local function updateDescriptionWithModelUnit(description, unit)
    description.m_Label:setString(unit:getDescription())
end

--------------------------------------------------------------------------------
-- The movement information for the unit.
--------------------------------------------------------------------------------
local function createMovementInfoButtomLine()
    return createBottomLine(MOVEMENT_INFO_POSITION_X + 5, MOVEMENT_INFO_POSITION_Y,
                            MOVEMENT_INFO_WIDTH - 10, MOVEMENT_INFO_HEIGHT)
end

local function createMovementInfoLabel()
    return createLabel(MOVEMENT_INFO_POSITION_X, MOVEMENT_INFO_POSITION_Y,
                    MOVEMENT_INFO_WIDTH, MOVEMENT_INFO_HEIGHT)
end

local function createMovementInfo()
    local bottomLine = createMovementInfoButtomLine()
    local label = createMovementInfoLabel()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(bottomLine)
        :addChild(label)

    info.m_BottomLine = bottomLine
    info.m_Label      = label

    return info
end

local function initWithMovementInfo(self, info)
    self.m_MovementInfo = info
    self:addChild(info)
end

local function updateMovementInfoWithModelUnit(info, unit, modelPlayer, modelWeather)
    info.m_Label:setString(LocalizationFunctions.getLocalizedText(91, unit:getMoveRange(modelPlayer, modelWeather), unit:getMoveTypeFullName()))
end

--------------------------------------------------------------------------------
-- The vision information for the unit.
--------------------------------------------------------------------------------
local function createVisionInfoLabel()
    return createLabel(VISION_INFO_POSITION_X, VISION_INFO_POSITION_Y,
                    VISION_INFO_WIDTH, VISION_INFO_HEIGHT)
end

local function createVisionInfo()
    local label = createVisionInfoLabel()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(label)

    info.m_Label = label

    return info
end

local function initWithVisionInfo(self, info)
    self.m_VisionInfo = info
    self:addChild(info)
end

local function updateVisionInfoWithModelUnit(info, unit)
    info.m_Label:setString(LocalizationFunctions.getLocalizedText(92, unit:getVision()))
end

--------------------------------------------------------------------------------
-- The fuel information for the unit.
--------------------------------------------------------------------------------
local function createFuelInfoBottomLine()
    return createBottomLine(FUEL_INFO_POSITION_X + 5, FUEL_INFO_POSITION_Y,
                            FUEL_INFO_WIDTH - 10, FUEL_INFO_HEIGHT)
end

local function createFuelInfoLabel()
    return createLabel(FUEL_INFO_POSITION_X, FUEL_INFO_POSITION_Y,
                    FUEL_INFO_WIDTH, FUEL_INFO_HEIGHT)
end

local function createFuelInfo()
    local bottomLine = createFuelInfoBottomLine()
    local label      = createFuelInfoLabel()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(bottomLine)
        :addChild(label)

    info.m_BottomLine = bottomLine
    info.m_Label      = label

    return info
end

local function initWithFuelInfo(self, info)
    self.m_FuelInfo = info
    self:addChild(info)
end

local function updateFuelInfoWithModelUnit(info, unit)
    info.m_Label:setString(LocalizationFunctions.getLocalizedText(93,
        unit:getCurrentFuel(), unit:getMaxFuel(), unit:getFuelConsumptionPerTurn(), unit:shouldDestroyOnOutOfFuel()))
end

--------------------------------------------------------------------------------
-- The primary weapon information for the unit.
--------------------------------------------------------------------------------
local function createPrimaryWeaponInfoBottomLine()
    return createBottomLine(PRIMARY_WEAPON_INFO_POSITION_X + 5, PRIMARY_WEAPON_INFO_POSITION_Y,
                            PRIMARY_WEAPON_INFO_WIDTH - 10, PRIMARY_WEAPON_INFO_HEIGHT)
end

local function createPrimaryWeaponInfoBriefLabel()
    return createLabel(PRIMARY_WEAPON_INFO_POSITION_X, PRIMARY_WEAPON_INFO_POSITION_Y,
                    PRIMARY_WEAPON_INFO_WIDTH, PRIMARY_WEAPON_INFO_HEIGHT)
end

local function createPrimaryWeaponInfoFatalLabel()
    return createLabel(PRIMARY_WEAPON_INFO_POSITION_X, PRIMARY_WEAPON_INFO_POSITION_Y,
        PRIMARY_WEAPON_INFO_WIDTH / 2, PRIMARY_WEAPON_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(96))
end

local function createPrimaryWeaponInfoFatalIcons()
    return createUnitIcons(PRIMARY_WEAPON_INFO_POSITION_X + 72, PRIMARY_WEAPON_INFO_POSITION_Y + 6)
end

local function createPrimaryWeaponInfoStrongLabel()
    return createLabel(PRIMARY_WEAPON_INFO_POSITION_X + 300, PRIMARY_WEAPON_INFO_POSITION_Y,
        PRIMARY_WEAPON_INFO_WIDTH / 2, PRIMARY_WEAPON_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(97))
end

local function createPrimaryWeaponInfoStrongIcons()
    return createUnitIcons(PRIMARY_WEAPON_INFO_POSITION_X, PRIMARY_WEAPON_INFO_POSITION_Y + 6)
end

local function createPrimaryWeaponInfo()
    local bottomLine  = createPrimaryWeaponInfoBottomLine()
    local briefLabel  = createPrimaryWeaponInfoBriefLabel()
    local fatalLabel  = createPrimaryWeaponInfoFatalLabel()
    local fatalIcons  = createPrimaryWeaponInfoFatalIcons()
    local strongLabel = createPrimaryWeaponInfoStrongLabel()
    local strongIcons = createPrimaryWeaponInfoStrongIcons()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(bottomLine)
        :addChild(briefLabel)
        :addChild(fatalLabel)
        :addChild(fatalIcons)
        :addChild(strongLabel)
        :addChild(strongIcons)

    info.m_BottomLine   = bottomLine
    info.m_BriefLabel   = briefLabel
    info.m_FatalLabel   = fatalLabel
    info.m_FatalIcons   = fatalIcons
    info.m_StrongLabel  = strongLabel
    info.m_StrongIcons  = strongIcons

    return info
end

local function initWithPrimaryWeaponInfo(self, info)
    self.m_PrimaryWeaponInfo = info
    self:addChild(info)
end

local function updatePrimaryWeaponInfoBriefLabel(label, unit, hasPrimaryWeapon)
    if (hasPrimaryWeapon) then
        local minRange, maxRange = unit:getAttackRangeMinMax()
        label:setString(LocalizationFunctions.getLocalizedText(94, unit:getPrimaryWeaponFullName(), unit:getPrimaryWeaponCurrentAmmo(), unit:getPrimaryWeaponMaxAmmo(), minRange, maxRange))
    else
        label:setString(LocalizationFunctions.getLocalizedText(95))
    end
end

local function updatePrimaryWeaponInfoFatalLabel(label, unit, hasPrimaryWeapon)
    label:setVisible(hasPrimaryWeapon)
end

local function updatePrimaryWeaponInfoFatalIcons(icons, unit, hasPrimaryWeapon)
    icons:setVisible(hasPrimaryWeapon)
    if (hasPrimaryWeapon) then
        resetIconsWithTypeNames(icons, unit:getPrimaryWeaponFatalList())
    end
end

local function updatePrimaryWeaponInfoStrongLabel(label, unit, hasPrimaryWeapon, fatalIcons)
    label:setVisible(hasPrimaryWeapon)

    if (hasPrimaryWeapon) then
        local fatalInfoWidth = math.max(85 + fatalIcons.m_Width, 120)

        label:setPosition(PRIMARY_WEAPON_INFO_POSITION_X + fatalInfoWidth, PRIMARY_WEAPON_INFO_POSITION_Y)
    end
end

local function updatePrimaryWeaponInfoStrongIcons(icons, unit, hasPrimaryWeapon, strongLabel)
    icons:setVisible(hasPrimaryWeapon)
    if (hasPrimaryWeapon) then
        resetIconsWithTypeNames(icons, unit:getPrimaryWeaponStrongList())
        icons:setPosition(strongLabel:getPositionX() + 98, icons:getPositionY())
    end
end

local function updatePrimaryWeaponInfoWithModelUnit(info, unit)
    local hasPrimaryWeapon = unit.hasPrimaryWeapon and unit:hasPrimaryWeapon()
    updatePrimaryWeaponInfoBriefLabel(info.m_BriefLabel, unit, hasPrimaryWeapon)
    updatePrimaryWeaponInfoFatalLabel(info.m_FatalLabel, unit, hasPrimaryWeapon)
    updatePrimaryWeaponInfoFatalIcons(info.m_FatalIcons, unit, hasPrimaryWeapon)
    updatePrimaryWeaponInfoStrongLabel(info.m_StrongLabel, unit, hasPrimaryWeapon, info.m_FatalIcons)
    updatePrimaryWeaponInfoStrongIcons(info.m_StrongIcons, unit, hasPrimaryWeapon, info.m_StrongLabel)
end

--------------------------------------------------------------------------------
-- The secondary weapon information for the unit.
--------------------------------------------------------------------------------
local function createSecondaryWeaponInfoBottomLine()
    return createBottomLine(SECONDARY_WEAPON_INFO_POSITION_X + 5, SECONDARY_WEAPON_INFO_POSITION_Y,
                            SECONDARY_WEAPON_INFO_WIDTH - 10, SECONDARY_WEAPON_INFO_HEIGHT)
end

local function createSecondaryWeaponInfoBriefLabel()
    return createLabel(SECONDARY_WEAPON_INFO_POSITION_X, SECONDARY_WEAPON_INFO_POSITION_Y,
                    SECONDARY_WEAPON_INFO_WIDTH, SECONDARY_WEAPON_INFO_HEIGHT)
end

local function createSecondaryWeaponInfoFatalLabel()
    return createLabel(SECONDARY_WEAPON_INFO_POSITION_X, SECONDARY_WEAPON_INFO_POSITION_Y,
        SECONDARY_WEAPON_INFO_WIDTH / 2, SECONDARY_WEAPON_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(96))
end

local function createSecondaryWeaponInfoFatalIcons()
    return createUnitIcons(SECONDARY_WEAPON_INFO_POSITION_X + 72, SECONDARY_WEAPON_INFO_POSITION_Y + 6)
end

local function createSecondaryWeaponInfoStrongLabel()
    return createLabel(SECONDARY_WEAPON_INFO_POSITION_X + 300, SECONDARY_WEAPON_INFO_POSITION_Y,
        SECONDARY_WEAPON_INFO_WIDTH / 2, SECONDARY_WEAPON_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(97))
end

local function createSecondaryWeaponInfoStrongIcons()
    return createUnitIcons(SECONDARY_WEAPON_INFO_POSITION_X, SECONDARY_WEAPON_INFO_POSITION_Y + 6)
end

local function createSecondaryWeaponInfo()
    local bottomLine  = createSecondaryWeaponInfoBottomLine()
    local briefLabel  = createSecondaryWeaponInfoBriefLabel()
    local fatalLabel  = createSecondaryWeaponInfoFatalLabel()
    local fatalIcons  = createSecondaryWeaponInfoFatalIcons()
    local strongLabel = createSecondaryWeaponInfoStrongLabel()
    local strongIcons = createSecondaryWeaponInfoStrongIcons()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(bottomLine)
        :addChild(briefLabel)
        :addChild(fatalLabel)
        :addChild(fatalIcons)
        :addChild(strongLabel)
        :addChild(strongIcons)

    info.m_BottomLine   = bottomLine
    info.m_BriefLabel   = briefLabel
    info.m_FatalLabel   = fatalLabel
    info.m_FatalIcons   = fatalIcons
    info.m_StrongLabel  = strongLabel
    info.m_StrongIcons  = strongIcons

    return info
end

local function initWithSecondaryWeaponInfo(self, info)
    self.m_SecondaryWeaponInfo = info
    self:addChild(info)
end

local function updateSecondaryWeaponInfoBriefLabel(label, unit, hasSecondaryWeapon)
    if (hasSecondaryWeapon) then
        label:setString(LocalizationFunctions.getLocalizedText(98, unit:getSecondaryWeaponFullName(), unit:getAttackRangeMinMax()))
    else
        label:setString(LocalizationFunctions.getLocalizedText(99))
    end
end

local function updateSecondaryWeaponInfoFatalLabel(label, unit, hasSecondaryWeapon)
    label:setVisible(hasSecondaryWeapon)
end

local function updateSecondaryWeaponInfoFatalIcons(icons, unit, hasSecondaryWeapon)
    icons:setVisible(hasSecondaryWeapon)
    if (hasSecondaryWeapon) then
        resetIconsWithTypeNames(icons, unit:getSecondaryWeaponFatalList())
    end
end

local function updateSecondaryWeaponInfoStrongLabel(label, unit, hasSecondaryWeapon, fatalIcons)
    label:setVisible(hasSecondaryWeapon)

    if (hasSecondaryWeapon) then
        local fatalInfoWidth = 85 + fatalIcons.m_Width
        if (fatalInfoWidth < 300) then
            fatalInfoWidth = 300
        end

        label:setPosition(SECONDARY_WEAPON_INFO_POSITION_X + fatalInfoWidth, SECONDARY_WEAPON_INFO_POSITION_Y)
    end
end

local function updateSecondaryWeaponInfoStrongIcons(icons, unit, hasSecondaryWeapon, strongLabel)
    icons:setVisible(hasSecondaryWeapon)
    if (hasSecondaryWeapon) then
        resetIconsWithTypeNames(icons, unit:getSecondaryWeaponStrongList())
        icons:setPosition(strongLabel:getPositionX() + 98, icons:getPositionY())
    end
end

local function updateSecondaryWeaponInfoWithModelUnit(info, unit)
    local hasSecondaryWeapon = unit.hasSecondaryWeapon and unit:hasSecondaryWeapon()
    updateSecondaryWeaponInfoBriefLabel(info.m_BriefLabel, unit, hasSecondaryWeapon)
    updateSecondaryWeaponInfoFatalLabel(info.m_FatalLabel, unit, hasSecondaryWeapon)
    updateSecondaryWeaponInfoFatalIcons(info.m_FatalIcons, unit, hasSecondaryWeapon)
    updateSecondaryWeaponInfoStrongLabel(info.m_StrongLabel, unit, hasSecondaryWeapon, info.m_FatalIcons)
    updateSecondaryWeaponInfoStrongIcons(info.m_StrongIcons, unit, hasSecondaryWeapon, info.m_StrongLabel)
end

--------------------------------------------------------------------------------
-- The defense information for the unit.
--------------------------------------------------------------------------------
local function createDefenseInfoBriefLabel()
    return createLabel(DEFENSE_INFO_POSITION_X, DEFENSE_INFO_POSITION_Y,
        DEFENSE_INFO_WIDTH, DEFENSE_INFO_HEIGHT, LocalizationFunctions.getLocalizedText(100))
end

local function createDefenseInfoFatalLabel()
    return createLabel(DEFENSE_INFO_POSITION_X, DEFENSE_INFO_POSITION_Y,
        DEFENSE_INFO_WIDTH / 2, DEFENSE_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(101))
end

local function createDefenseInfoFatalIcons()
    return createUnitIcons(DEFENSE_INFO_POSITION_X + 72, DEFENSE_INFO_POSITION_Y + 6)
end

local function createDefenseInfoWeakLabel()
    return createLabel(DEFENSE_INFO_POSITION_X + 300, DEFENSE_INFO_POSITION_Y,
        DEFENSE_INFO_WIDTH / 2, DEFENSE_INFO_HEIGHT / 2, LocalizationFunctions.getLocalizedText(102))
end

local function createDefenseInfoWeakIcons()
    return createUnitIcons(DEFENSE_INFO_POSITION_X, DEFENSE_INFO_POSITION_Y + 6)
end

local function createDefenseInfo()
    local briefLabel  = createDefenseInfoBriefLabel()
    local fatalLabel  = createDefenseInfoFatalLabel()
    local fatalIcons  = createDefenseInfoFatalIcons()
    local weakLabel = createDefenseInfoWeakLabel()
    local weakIcons = createDefenseInfoWeakIcons()

    local info = cc.Node:create()
    info:ignoreAnchorPointForPosition(true)
        :addChild(briefLabel)
        :addChild(fatalLabel)
        :addChild(fatalIcons)
        :addChild(weakLabel)
        :addChild(weakIcons)

    info.m_BriefLabel = briefLabel
    info.m_FatalLabel = fatalLabel
    info.m_FatalIcons = fatalIcons
    info.m_WeakLabel  = weakLabel
    info.m_WeakIcons  = weakIcons

    return info
end

local function initWithDefenseInfo(self, info)
    self.m_DefenseInfo = info
    self:addChild(info)
end

local function updateDefenseInfoFatalIcons(icons, unit)
    resetIconsWithTypeNames(icons, unit:getDefenseFatalList())
end

local function updateDefenseInfoWeakLabel(label, unit, fatalIcons)
    local fatalInfoWidth = 85 + fatalIcons.m_Width
    if (fatalInfoWidth < 300) then
        fatalInfoWidth = 300
    end

    label:setPosition(DEFENSE_INFO_POSITION_X + fatalInfoWidth, DEFENSE_INFO_POSITION_Y)
end

local function updateDefenseInfoWeakIcons(icons, unit, weakLabel)
    resetIconsWithTypeNames(icons, unit:getDefenseWeakList())
    icons:setPosition(weakLabel:getPositionX() + 86, icons:getPositionY())
end

local function updateDefenseInfoWithModelUnit(info, unit)
    updateDefenseInfoFatalIcons(info.m_FatalIcons, unit)
    updateDefenseInfoWeakLabel(info.m_WeakLabel, unit, info.m_FatalIcons)
    updateDefenseInfoWeakIcons(info.m_WeakIcons, unit, info.m_WeakLabel)
end

--------------------------------------------------------------------------------
-- The touch listener.
--------------------------------------------------------------------------------
local function createTouchListener(self)
    local touchListener = cc.EventListenerTouchOneByOne:create()
    touchListener:setSwallowTouches(true)
    local isTouchWithinBackground

    touchListener:registerScriptHandler(function(touch, event)
        isTouchWithinBackground = require("app.utilities.DisplayNodeFunctions").isTouchWithinNode(touch, self.m_DetailBackground)
        return true
    end, cc.Handler.EVENT_TOUCH_BEGAN)

    touchListener:registerScriptHandler(function(touch, event)
        if (not isTouchWithinBackground) then
            self:setEnabled(false)
        end
    end, cc.Handler.EVENT_TOUCH_ENDED)

    return touchListener
end

local function initWithTouchListener(self, touchListener)
    self.m_TouchListener = touchListener
    self:getEventDispatcher():addEventListenerWithSceneGraphPriority(self.m_TouchListener, self)
end

--------------------------------------------------------------------------------
-- The constructor and public functions.
--------------------------------------------------------------------------------
function ViewUnitDetail:ctor(param)
    initWithScreenBackground(   self, createScreenBackground())
    initWithDetailBackground(   self, createDetailBackground())
    initWithDescription(        self, createDescription())
    initWithMovementInfo(       self, createMovementInfo())
    initWithVisionInfo(         self, createVisionInfo())
    initWithFuelInfo(           self, createFuelInfo())
    initWithPrimaryWeaponInfo(  self, createPrimaryWeaponInfo())
    initWithSecondaryWeaponInfo(self, createSecondaryWeaponInfo())
    initWithDefenseInfo(        self, createDefenseInfo())
    initWithTouchListener(      self, createTouchListener(self))

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewUnitDetail:updateWithModelUnit(modelUnit, modelPlayer, modelWeather)
    updateDescriptionWithModelUnit(        self.m_Description,         modelUnit)
    updateMovementInfoWithModelUnit(       self.m_MovementInfo,        modelUnit, modelPlayer, modelWeather)
    updateVisionInfoWithModelUnit(         self.m_VisionInfo,          modelUnit)
    updateFuelInfoWithModelUnit(           self.m_FuelInfo,            modelUnit)
    updatePrimaryWeaponInfoWithModelUnit(  self.m_PrimaryWeaponInfo,   modelUnit)
    updateSecondaryWeaponInfoWithModelUnit(self.m_SecondaryWeaponInfo, modelUnit)
    updateDefenseInfoWithModelUnit(        self.m_DefenseInfo,         modelUnit)

    return self
end

function ViewUnitDetail:setEnabled(enabled)
    self:setVisible(enabled)
    self.m_TouchListener:setEnabled(enabled)

    return self
end

return ViewUnitDetail
