with GESTE;
with GESTE_Config;

package Render is

   procedure Push_Pixels (Buffer : GESTE.Output_Buffer);

   procedure Set_Drawing_Area (Area : GESTE.Rect);

   procedure Set_Screen_Offset (Pt : GESTE.Point);

   procedure Render_All (Background : GESTE_Config.Output_Color);
   procedure Render_Dirty (Background : GESTE_Config.Output_Color);


   function Dark_Cyan return GESTE_Config.Output_Color;
   function Black     return GESTE_Config.Output_Color;

end Render;
