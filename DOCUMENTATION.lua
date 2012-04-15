--[[

iPod size = 480x320 or 960x640
iPad size = 1024x768

The iPad width is 2.133333 * 480 = 1024
Then 2.133333 * 320 = 682.666666 for the height

the starting image sizes need to be 1024x682

There is a 34 pixel status bar so the level images are going to be 1024x648

This leaves two 43 pixel blank areas on an iPad










- OLD

So the starting image sizes need to be 1024x682.6666 then scale them down to 480x320

On the iPad there would be an extra 42.6666 (actually 43 after the status bar) pixels on the top and bottom that are 
blank.  Then 43 / 2.13333 = 20.156 so we need a 576x20 scalled down image which is 1224x43 at 2x.

The status bar is 16 pixels at the normal resolution.  Then 16 * 2.133333 = 34.133333 = 34 at 2x.
The final status bar size is 1224x34.  Scaled down to 576x16.

This means the actual level size can be 480x(320 - 16) = 480x304.  Scale this up by 2.13333 to get 1024x648.53333333
or 1024x648 for the start size.



Menus can use a bigger generic background at 570x380 which is 1152x768 when multiplied by 2.133333

--]]