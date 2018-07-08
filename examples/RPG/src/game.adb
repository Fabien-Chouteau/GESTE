with Ada.Real_Time;

with SDL_Display;
with Keyboard;

with Game_Assets;
with Game_Assets.Tileset;
with Game_Assets.Tileset_Collisions;

with Levels;
with Player;

with GESTE;
with GESTE.Text;
with GESTE_Config;
with GESTE_Fonts.FreeMono5pt7b;

package body Game is

   package RT renames Ada.Real_Time;
   use type RT.Time;
   use type RT.Time_Span;

   Width : constant := 320;
   Height : constant := 240;

   package Display is new SDL_Display
     (Width       => Width,
      Height      => Height,
      Pixel_Scale => 4,
      Buffer_Size => 320 * 240);

   Background : constant Display.SDL_Pixel
     := Display.To_SDL_Color (176, 226, 255);

   Black      : constant Display.SDL_Pixel
     := Display.To_SDL_Color (0, 0, 0);

   Text : aliased GESTE.Text.Instance
     (GESTE_Fonts.FreeMono5pt7b.Font,
      15, 1,
      Black,
      GESTE_Config.Transparent);

   Frame_Counter   : Natural := 0;
   Next_FPS_Update : RT.Time := RT.Clock + RT.Seconds (1);

   Period : constant RT.Time_Span := RT.Seconds (1) / 60;
   Next_Release : RT.Time := RT.Clock + Period;

   Screen_Pt : GESTE.Point := (0, 0);

   ---------------
   -- Game_Loop --
   ---------------

   procedure Game_Loop is
   begin
      loop

         Keyboard.Update;
         if Keyboard.Pressed (Keyboard.Up) then
            Player.Move_Up;
         end if;
         if Keyboard.Pressed (Keyboard.Down) then
            Player.Move_Down;
         end if;
         if Keyboard.Pressed (Keyboard.Left) then
            Player.Move_Left;
         end if;
         if Keyboard.Pressed (Keyboard.Right) then
            Player.Move_Right;
         end if;
         if Keyboard.Pressed (Keyboard.Esc) then
            return;
         end if;

         Player.Update;
         Levels.Update;

         Frame_Counter := Frame_Counter + 1;

         if Next_FPS_Update <= RT.Clock then
            Next_FPS_Update := RT.Clock + RT.Seconds (1);

            Text.Clear;
            Text.Cursor (1, 1);
            Text.Put ("FPS:" & Frame_Counter'Img);
            Frame_Counter := 0;
         end if;

         GESTE.Render_Dirty
           ((Screen_Pt,
            (Screen_Pt.X + Width - 1,
             Screen_Pt.Y + Height - 1)),
            Background,
            Display.Buffer,
            Display.Push_Pixels'Access,
            Display.Set_Drawing_Area'Access);

         delay until Next_Release;
         Next_Release := Next_Release + Period;
      end loop;
   end Game_Loop;

   --------------------
   -- Set_Screen_Pos --
   --------------------

   procedure Set_Screen_Pos (Pt : GESTE.Point) is
   begin
      Screen_Pt := Pt;
      Display.Set_Screen_Offset (Pt);
   end Set_Screen_Pos;

begin
   Text.Move ((0, 0));
   GESTE.Add (Text'Access, 10);
   GESTE.Render_All
     (Display.Screen_Rect,
      Background,
      Display.Buffer,
      Display.Push_Pixels'Access,
      Display.Set_Drawing_Area'Access);

end Game;
