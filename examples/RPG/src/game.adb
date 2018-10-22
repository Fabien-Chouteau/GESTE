with Ada.Real_Time;

with Render;
with Keyboard;

with Levels;
with Player;

with GESTE.Text;
with GESTE_Config;
with GESTE_Fonts.FreeMono5pt7b;

package body Game is

   package RT renames Ada.Real_Time;
   use type RT.Time;
   use type RT.Time_Span;

   Text : aliased GESTE.Text.Instance
     (GESTE_Fonts.FreeMono5pt7b.Font,
      15, 1,
      Render.Black,
      GESTE_Config.Transparent);

   Frame_Counter   : Natural := 0;
   Next_FPS_Update : RT.Time := RT.Clock + RT.Seconds (1);

   Period : constant RT.Time_Span := RT.Seconds (1) / 60;
   Next_Release : RT.Time := RT.Clock + Period;

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

         Render.Render_Dirty (Render.Black);

         delay until Next_Release;
         Next_Release := Next_Release + Period;
      end loop;
   end Game_Loop;

   --------------------
   -- Set_Screen_Pos --
   --------------------

   procedure Set_Screen_Pos (Pt : GESTE.Pix_Point) is
   begin
      Render.Set_Screen_Offset (Pt);
   end Set_Screen_Pos;

begin
   Text.Move ((0, 0));
   GESTE.Add (Text'Access, 10);
   Render.Render_All (Render.Black);

end Game;
