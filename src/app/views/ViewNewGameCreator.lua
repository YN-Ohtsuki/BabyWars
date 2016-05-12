
local ViewNewGameCreator = class("ViewNewGameCreator", cc.Node)

local MENU_TITLE_Z_ORDER      = 1
local MENU_LIST_VIEW_Z_ORDER  = 1
local BUTTON_BACK_Z_ORDER     = 1
local MENU_BACKGROUND_Z_ORDER = 0

local MENU_BACKGROUND_WIDTH  = 250
local MENU_BACKGROUND_HEIGHT = display.height - 60
local MENU_LIST_VIEW_WIDTH   = MENU_BACKGROUND_WIDTH - 10
local MENU_LIST_VIEW_HEIGHT  = MENU_BACKGROUND_HEIGHT - 14 - 50 - 30
local MENU_TITLE_WIDTH       = MENU_BACKGROUND_WIDTH
local MENU_TITLE_HEIGHT      = 40

local MENU_BACKGROUND_POS_X = 30
local MENU_BACKGROUND_POS_Y = 30
local MENU_LIST_VIEW_POS_X  = MENU_BACKGROUND_POS_X + 5
local MENU_LIST_VIEW_POS_Y  = MENU_BACKGROUND_POS_Y + 6 + 30
local MENU_TITLE_POS_X      = MENU_BACKGROUND_POS_X
local MENU_TITLE_POS_Y      = MENU_BACKGROUND_POS_Y + MENU_BACKGROUND_HEIGHT - 50
local BUTTON_BACK_POS_X     = MENU_LIST_VIEW_POS_X
local BUTTON_BACK_POS_Y     = MENU_BACKGROUND_POS_Y + 6

local MENU_TITLE_FONT_COLOR = {r = 96,  g = 224, b = 88}
local MENU_TITLE_FONT_SIZE  = 28

local ITEM_WIDTH              = 230
local ITEM_HEIGHT             = 45
local ITEM_CAPINSETS          = {x = 1, y = ITEM_HEIGHT, width = 1, height = 1}
local ITEM_FONT_NAME          = "res/fonts/msyhbd.ttc"
local ITEM_FONT_SIZE          = 28
local ITEM_FONT_COLOR         = {r = 255, g = 255, b = 255}
local ITEM_FONT_OUTLINE_COLOR = {r = 0, g = 0, b = 0}
local ITEM_FONT_OUTLINE_WIDTH = 2

--------------------------------------------------------------------------------
-- The util functions.
--------------------------------------------------------------------------------
local function createViewMenuItem(item)
    local view = ccui.Button:create()
    view:loadTextureNormal("c03_t06_s01_f01.png", ccui.TextureResType.plistType)

        :setScale9Enabled(true)
        :setCapInsets(ITEM_CAPINSETS)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor(fontColor or ITEM_FONT_COLOR)
        :setTitleText(item.name)

    view:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    view:addTouchEventListener(function(sender, eventType)
        if (eventType == ccui.TouchEventType.ended) then
            item.callback()
        end
    end)

    return view
end

--------------------------------------------------------------------------------
-- The composition background.
--------------------------------------------------------------------------------
local function createMenuBackground()
    local background = cc.Scale9Sprite:createWithSpriteFrameName("c03_t01_s01_f01.png", {x = 4, y = 6, width = 1, height = 1})
    background:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_BACKGROUND_POS_X, MENU_BACKGROUND_POS_Y)
        :setContentSize(MENU_BACKGROUND_WIDTH, MENU_BACKGROUND_HEIGHT)
        :setOpacity(180)

    return background
end

local function initWithMenuBackground(self, background)
    self.m_MenuBackground = background
    self:addChild(background, MENU_BACKGROUND_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition list view.
--------------------------------------------------------------------------------
local function createMenuListView()
    local listView = ccui.ListView:create()
    listView:setPosition(MENU_LIST_VIEW_POS_X, MENU_LIST_VIEW_POS_Y)
        :setContentSize(MENU_LIST_VIEW_WIDTH, MENU_LIST_VIEW_HEIGHT)
        :setItemsMargin(5)
        :setGravity(ccui.ListViewGravity.centerHorizontal)

        :setOpacity(180)
        :setCascadeOpacityEnabled(true)

    return listView
end

local function initWithMenuListView(self, listView)
    self.m_MenuListView = listView
    self:addChild(listView, MENU_LIST_VIEW_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition menu title.
--------------------------------------------------------------------------------
local function createMenuTitle()
    local title = cc.Label:createWithTTF("New Game..", "res/fonts/msyhbd.ttc", MENU_TITLE_FONT_SIZE)
    title:ignoreAnchorPointForPosition(true)
        :setPosition(MENU_TITLE_POS_X, MENU_TITLE_POS_Y)

        :setDimensions(MENU_TITLE_WIDTH, MENU_TITLE_HEIGHT)
        :setHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
        :setVerticalAlignment(cc.TEXT_ALIGNMENT_CENTER)

        :setTextColor(MENU_TITLE_FONT_COLOR)
        :enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

        :setOpacity(180)

    return title
end

local function initWithMenuTitle(self, title)
    self.m_MenuTitle = title
    self:addChild(title, MENU_TITLE_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The composition back button.
--------------------------------------------------------------------------------
local function createButtonBack()
    local button = ccui.Button:create()
    button:ignoreAnchorPointForPosition(true)
        :setPosition(BUTTON_BACK_POS_X, BUTTON_BACK_POS_Y)

        :setScale9Enabled(true)
        :setContentSize(ITEM_WIDTH, ITEM_HEIGHT)

        :setZoomScale(-0.05)

        :setTitleFontName(ITEM_FONT_NAME)
        :setTitleFontSize(ITEM_FONT_SIZE)
        :setTitleColor({r = 240, g = 80, b = 56})
        :setTitleText("back")

    button:getTitleRenderer():enableOutline(ITEM_FONT_OUTLINE_COLOR, ITEM_FONT_OUTLINE_WIDTH)

    return button
end

local function initWithButtonBack(self, button)
    self.m_ButtonBack = button
    self:addChild(button, BUTTON_BACK_Z_ORDER)
end

--------------------------------------------------------------------------------
-- The constructor and initializers.
--------------------------------------------------------------------------------
function ViewNewGameCreator:ctor(param)
    initWithMenuBackground(self, createMenuBackground())
    initWithMenuListView(  self, createMenuListView())
    initWithMenuTitle(     self, createMenuTitle())
    initWithButtonBack(    self, createButtonBack(self))

    return self
end

function ViewNewGameCreator:setItemBack(item)
    self.m_ButtonBack:setTitleText(item.name)
        :addTouchEventListener(function(sender, eventType)
            if (eventType == ccui.TouchEventType.ended) then
                item.callback()
            end
        end)

    return self
end

--------------------------------------------------------------------------------
-- The public functions.
--------------------------------------------------------------------------------
function ViewNewGameCreator:removeAllItems()
    self.m_MenuListView:removeAllItems()

    return self
end

function ViewNewGameCreator:showListWarField(list)
    for _, listItem in ipairs(list) do
        self.m_MenuListView:pushBackCustomItem(createViewMenuItem(listItem))
    end

    return self
end

function ViewNewGameCreator:createAndPushBackItem(item)
    self.m_MenuListView:pushBackCustomItem(createViewMenuItem(item))

    return self
end

return ViewNewGameCreator
