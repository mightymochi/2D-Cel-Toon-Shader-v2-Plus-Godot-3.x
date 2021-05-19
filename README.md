# 2D-Cel-Toon-Shader-v2-Plus
A Godot shader that will restrict light values giving a type of cel or toon shaded look, as well as give you options to fake light depth.

[This is the advanced version of the shader that has extra features](https://github.com/mightymochi/2D-Cel-Toon-Shader-v2-Plus/blob/main/shaders/cel_shader_plus_all.shader). Those features consist of:
- [Basic Cel Shader](https://github.com/mightymochi/2D-Cel-Toon-Shader-v2-Plus/blob/main/shaders/cel_shader_basic.shader)
- [Rim Light](https://github.com/mightymochi/2D-Cel-Toon-Shader-v2-Plus/blob/main/shaders/rim_light.shader)
- [Fake Light Depth with light fade](https://github.com/mightymochi/2D-Cel-Toon-Shader-v2-Plus/blob/main/shaders/2D_Light_Z-Depth.shader)
- Fake Spotlight effect connected to depth
- [Modulate before light](https://github.com/mightymochi/2D-Cel-Toon-Shader-v2-Plus/blob/main/shaders/modulate_before_light.shader)
 
This shader will restrict light values giving a type of cel or toon shaded look, as well as give you options to fake light depth. It requires sprites to have normal maps. This shader will NOT create the drawn lines, but you could combine with a border shader to give an outline around edges of your sprites. To get extra glow-y light effects, you need to use the WorldEnvironment node. 

## Shader Param:
- First Stage – Sets the threshold for the darkest light. 

- First Smooth – Smooths the transition between darkest and the next stage.

- Second Stage – Sets a second light threshold for a mid value. If set to 0 this setting and Second Smooth is ignored and only two light stages are used.

- Second Smooth – Smooths from the second stage to the lightest. 

- Rim Light – Activates a border that reacts brightly to light. This border is based off of the outline shader code from GDQuest.

  - Rim Thickness – Changes the line thickness.

  - Rim Intense – Increase or decrease the brightness or intensity.

  - Rim Extra Thick – Adds another pass that thickens the border.

- Min Light – Sets minimum allowed light. 0 is complete darkness. Increasing from 0 may have a gradient effect due to the way I implement the ability to add light where there was none.

- Mid Light – Sets the light value of the Second Stage. If Second Stage is set to 0, this setting is ignored.

- Max Light – Sets the maximum light value allowed. 

- Obj Light Add – Adds the original light values to the cel values. 

- Fake Light Depth – Enables the fading or shrinking of light at a set height distance.

  - Obj Height – Sets the light height for this object.

  - Min Scale – A value for use outside of the shader. See “Modifying Scale and Z-index with Height Example.”

  - Max Scale – A value for use outside of the shader. See “Modifying Scale and Z-index with Height Example.”

  - Light Change Thresh – Sets the threshold for where the light is to start being affected by depth. For example: If the Light2D range_height is 500, the Obj Height is 0, and the Light Change Thresh is 500; then the fake depth activates if Light2D height increases any further.

  - Light Fade – Activates fading or dimming of light values.

    - Light Fade End – Sets the distance for the transition from lit to unlit.

  - Fake Spot Light – Activates the ability to shrink or grow the Stage values once the Light Change Thresh is reached. The best way to use these speed values is to set your Obj Height to the height you want it to be dark and change the speed values to your desired effect. Then return your Obj Height to where you had it last.

    - First Shrink Speed – Sets the shrink speed value of the First Stage.

    - Second Shrink Speed – Sets the shrink speed value of the Second Stage.

- Before Light Modulate – Alters the color of the object before the light pass, preserving luminosity. The standard Modulate setting will change the color of the object and the light after the light has been applied.


## Thanks

This shader is a combination of approaches I found on the internet, help from community members, and my own experimentation and development. 

Big thanks and shout outs to these people:

[Azagaya from Laigter](https://azagaya.itch.io/laigter) – Provided initial cel shading code that got the first version of the toon shader working and jump started me on this. His method for smoothing got carried over to this version and I utilized the VEC calculation to allow setting the Min Light. 

[Toasteater on Github](https://github.com/godotengine/godot/issues/27268) – In my searching I found this issue on Github where toasteater outlined his method for cel shading. I learned from their method to solve the gradient issues from version 1 of the toon shader. 

[cybereality on Reddit](https://www.reddit.com/r/godot/comments/n8vxw3/how_to_create_a_shader_that_mimics_canvas_modulate/gxl9kdh?utm_source=share&utm_medium=web2x&context=3) – Provided the super helpful solution for Before Light Modulate.

[GDQuest](https://www.gdquest.com/) – The Rim Light is based off of their outline shader. I also generally have learned a lot from their open source contributions and online lessons.


## Use it, Make it better!

If you use this in a project let me know so I can check it out. I’m not a programmer by trade so if you know how to make this better, please do so I can use a better version!
