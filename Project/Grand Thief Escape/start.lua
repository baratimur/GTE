--[[
*************************************************************
 * This script is developed by Arturs Sosins aka ar2rsawseen, http://appcodingeasy.com
 * Feel free to distribute and modify code, but keep reference to its creator
 *
 * Gideros Game Template for developing games. Includes: 
 * Start scene, pack select, level select, settings, score system and much more
 *
 * For more information, examples and online documentation visit: 
 * http://appcodingeasy.com/Gideros-Mobile/Gideros-Mobile-Game-Template
**************************************************************
]]--
start = gideros.class(Sprite)

function start:init()
	--here we'd probably want to set up a background picture
	local screen = Bitmap.new(Texture.new("images/screen_bg.png"))
	self:addChild(screen)
	screen:setPosition((application:getContentWidth()-screen:getWidth())/2, (application:getContentHeight()-screen:getHeight())/2)

	--create start button
	local startButton = Button.new(Bitmap.new(Texture.new("images/play_clicked.png")), Bitmap.new(Texture.new("images/play_normal.png")))
	startButton:setPosition((application:getContentWidth()-startButton:getWidth())/2, ((application:getContentHeight()*3/2-startButton:getHeight())/2)-(startButton:getHeight()+20))
	self:addChild(startButton)

	--start button on click event
	startButton:addEventListener("click", 
		function()
			--go to pack select scene
			sceneManager:changeScene("pack_select", 1, transition, easing.outBack) 
		end
	)
	
	--create start button
	local optionsButton = Button.new(Bitmap.new(Texture.new("images/options_clicked.png")), Bitmap.new(Texture.new("images/options_normal.png")))
	optionsButton:setPosition((application:getContentWidth()-optionsButton:getWidth())/2, ((application:getContentHeight()*3/2-optionsButton:getHeight())/2))
	self:addChild(optionsButton)

	--start button on click event
	optionsButton:addEventListener("click", 
		function()	
			--go to pack select scene
			sceneManager:changeScene("options", 1, transition, easing.outBack) 
		end
	)
	
	--create start button
	local helpButton = Button.new(Bitmap.new(Texture.new("images/upgrade_clicked.png")), Bitmap.new(Texture.new("images/upgrade_normal.png")))
	helpButton:setPosition((application:getContentWidth()-helpButton:getWidth())/2, ((application:getContentHeight()*3/2-helpButton:getHeight())/2)+(helpButton:getHeight()+20))
	self:addChild(helpButton)

	--start button on click event
	helpButton:addEventListener("click", 
		function()	
			--go to pack select scene
			sceneManager:changeScene("help", 1, transition, easing.outBack) 
		end
	)
end