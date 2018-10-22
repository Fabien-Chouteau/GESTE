with Interfaces.C;    use Interfaces.C;
with SDL_SDL_h;       use SDL_SDL_h;
with SDL_SDL_video_h; use SDL_SDL_video_h;

package body SDL_Display is

   Display : access SDL_Surface;

   Screen_Offset : GESTE.Pix_Point := (0, 0);

   XS, XE, YS, YE : Natural := 0;
   X, Y : Natural := 0;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin

      if SDL_Init (SDL_INIT_VIDEO) < 0 then
         raise Program_Error with "SDL Video init failed";
         return;
      end if;

      Display := SDL_SetVideoMode (800 * int (Pixel_Scale),
                                   600 * int (Pixel_Scale),
                                   SDL_Pixel'Size,
                                   SDL_SWSURFACE);

      if Display = null then
         raise Program_Error with "Cannot create SDL display";
      end if;
   end Initialize;

   ----------------------
   -- Set_Drawing_Area --
   ----------------------

   procedure Set_Drawing_Area (Area : GESTE.Pix_Rect) is
   begin
      XS := Area.TL.X - Screen_Offset.X;
      YS := Area.TL.Y - Screen_Offset.Y;
      XE := Area.BR.X - Screen_Offset.X;
      YE := Area.BR.Y - Screen_Offset.Y;
      X := XS;
      Y := YS;
      if XS < 0 then
         raise Program_Error;
      end if;
      if YS < 0 then
         raise Program_Error;
      end if;
      if XE >= Width then
         raise Program_Error;
      end if;
      if YE >= Height then
         raise Program_Error;
      end if;
   end Set_Drawing_Area;

   -----------------------
   -- Set_Screen_Offset --
   -----------------------

   procedure Set_Screen_Offset (Pt : GESTE.Pix_Point) is
   begin
      Screen_Offset := Pt;
   end Set_Screen_Offset;

   ------------
   -- Update --
   ------------

   procedure Update is
   begin
      SDL_UpdateRect (Display, 0, 0, 0, 0);
   end Update;

   ------------------
   -- To_SDL_Color --
   ------------------

   function To_SDL_Color (R, G, B : Unsigned_8) return SDL_Pixel is
   begin
      return SDL_Pixel (SDL_MapRGB (Display.format,
                        unsigned_char (R),
                        unsigned_char (G),
                        unsigned_char (B)));
   end To_SDL_Color;

   -----------------
   -- Push_Pixels --
   -----------------

   procedure Push_Pixels (Pixels    : GESTE.Output_Buffer) is
      Buffer : array (0 .. Natural (Display.w * Display.h - 1))
        of SDL_Pixel
          with Address => Display.pixels;
   begin

      for Pix of Pixels loop
         for XP in X * Pixel_Scale .. X * Pixel_Scale + Pixel_Scale loop
            for YP in Y * Pixel_Scale .. Y * Pixel_Scale + Pixel_Scale loop
               Buffer (XP + YP * Natural (Display.w)) := Pix;
            end loop;
         end loop;

         if X = XE then
            X := XS;
            if Y = YE then
               Y := YS;
            else
               Y := Y + 1;
            end if;
         else
            X := X + 1;
         end if;
      end loop;

      SDL_UpdateRect (Display,
                      int (XS * Pixel_Scale),
                      int (YS * Pixel_Scale),
                      unsigned ((XE - XS + 1) * Pixel_Scale),
                      unsigned ((YE - YS + 1) * Pixel_Scale));
   end Push_Pixels;

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel (X, Y : Natural; Pix : SDL_Pixel) is
      Buffer : array (0 .. Natural (Display.w * Display.h - 1))
        of SDL_Pixel
          with Address => Display.pixels;
   begin
      Buffer (X + Y * Natural (Display.w)) := Pix;
   end Set_Pixel;

begin
   Initialize;
end SDL_Display;
