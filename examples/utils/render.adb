with SDL_Display;

package body Render is

   Width : constant := 320;
   Height : constant := 240;

   package Display is new SDL_Display
     (Width       => Width,
      Height      => Height,
      Pixel_Scale => 4,
      Buffer_Size => 320 * 240);

   Screen_Pt : GESTE.Pix_Point := (0, 0);

   -----------------
   -- Push_Pixels --
   -----------------

   procedure Push_Pixels (Buffer : GESTE.Output_Buffer)
   renames Display.Push_Pixels;

   ----------------------
   -- Set_Drawing_Area --
   ----------------------

   procedure Set_Drawing_Area (Area : GESTE.Pix_Rect)
   renames Display.Set_Drawing_Area;

   -----------------------
   -- Set_Screen_Offset --
   -----------------------

   procedure Set_Screen_Offset (Pt : GESTE.Pix_Point) is
   begin
      Display.Set_Screen_Offset (Pt);
      Screen_Pt := Pt;
   end Set_Screen_Offset;

   ----------------
   -- Render_All --
   ----------------

   procedure Render_All (Background : GESTE_Config.Output_Color) is
   begin
      GESTE.Render_All
        ((Screen_Pt,
         (Screen_Pt.X + Width - 1,
          Screen_Pt.Y + Height - 1)),
         Background,
         Display.Buffer,
         Display.Push_Pixels'Access,
         Display.Set_Drawing_Area'Access);
   end Render_All;

   ------------------
   -- Render_Dirty --
   ------------------

   procedure Render_Dirty (Background : GESTE_Config.Output_Color) is
   begin
      GESTE.Render_Dirty
        ((Screen_Pt,
         (Screen_Pt.X + Width - 1,
          Screen_Pt.Y + Height - 1)),
         Background,
         Display.Buffer,
         Display.Push_Pixels'Access,
         Display.Set_Drawing_Area'Access);
   end Render_Dirty;

   ---------------
   -- Dark_Cyan --
   ---------------

   function Dark_Cyan return GESTE_Config.Output_Color
   is (Display.To_SDL_Color (176, 226, 255));

   -----------
   -- Black --
   -----------

   function Black return GESTE_Config.Output_Color
   is (Display.To_SDL_Color (0, 0, 0));

end Render;
