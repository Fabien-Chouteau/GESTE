with GESTE;

with Interfaces; use Interfaces;

generic

   Width  : Natural;
   Height : Natural;

   Pixel_Scale : Natural;

   Buffer_Size : Positive;

package SDL_Display is

   Screen_Rect : constant GESTE.Rect := ((0, 0), (Width - 1, Height - 1));

   Buffer : GESTE.Output_Buffer (1 .. Buffer_Size);

   procedure Push_Pixels (Pixels    : GESTE.Output_Buffer);
   procedure Set_Drawing_Area (Area : GESTE.Rect);

   procedure Update;

   subtype SDL_Pixel is Unsigned_16;

   function To_SDL_Color (R, G, B : Unsigned_8) return SDL_Pixel;

end SDL_Display;
