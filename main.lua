local deploy = require("plugin.deploy")
local widget = require("widget")
local json = require("json")
local zip = require( "plugin.zip" )
--
local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
bg:setFillColor( 0,.8,0 )

local title = display.newText( "Deploy Plugn", display.contentCenterX, 20, native.systemFontBold, 30 )
--
local myModule 
local obj
local pathForBlueScript
--
deploy.runCode("print(\"hello world\")")
--
local runRedScript = widget.newButton( {
	x = display.contentCenterX,
	y = display.contentCenterY+100,
	label = "Run Red Rect Script",
	onRelease = function (  )
		display.remove( obj )
		myModule = deploy.runScript("redRect.lua", system.DocumentsDirectory, "redRect.lua")
		obj = myModule.run()
	end
} )
local runGreenScript = widget.newButton( {
	x = display.contentCenterX,
	y = display.contentCenterY+160,
	label = "Run Green Rect Script",
	onRelease = function (  )
		display.remove( obj )
		myModule = deploy.runScript("greenRect.lua", system.DocumentsDirectory, "greenRect.lua")
		obj = myModule.run()
	end
} )
local runBlueScript = widget.newButton( {
	x = display.contentCenterX,
	y = display.contentCenterY+220,
	label = "Run Blue Rect Script",
	onRelease = function (  )
		display.remove( obj )
		myModule = deploy.runScript(pathForBlueScript, system.DocumentsDirectory, nil,{86, 43, 70, 69, 30})
		obj = myModule.run()
	end
} )
runBlueScript.alpha = 0
--print our encrypted blue script
deploy.printEncryptedCode( [==[ 
		local m = {}
		m.run = function (  )
			local obj = display.newRect( display.contentCenterX, display.contentCenterY, 80, 50 )
			obj:setFillColor( 0,0,1 )
			return obj 
		end
		return m 
]==],{86, 43, 70, 69, 30}) 

--download blue script
network.download( "https://gist.github.com/scottrules44/c41f445fee999852a819f66a5f1c1901/archive/320f37ff7e809e5d38a2994e265044621197cfc5.zip", "get", function ( e )
	if (e.isError) then
		print("could not download blue script")
	else
		print("downloaded blue script, unziping")
		local function zipListener( event )
 
		    if ( event.isError == false ) then
		        pathForBlueScript = event.response[2]
		        runBlueScript.alpha = 1
		    end
		end
		 
		
		local zipOptions =
		{
		    zipFile = "blueScript.zip",
		    zipBaseDir = system.DocumentsDirectory,
		    dstBaseDir = system.DocumentsDirectory,
		    listener = zipListener
		}
		zip.uncompress( zipOptions )
	end
end, "blueScript.zip", system.DocumentsDirectory )
