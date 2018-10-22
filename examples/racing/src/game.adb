with Ada.Real_Time;

with Keyboard;

with Levels;
with Player;

with Render;
with GESTE;
with GESTE.Maths_Types; use GESTE.Maths_Types;
with GESTE.Text;

package body Game is

   package RT renames Ada.Real_Time;
   use type RT.Time;
   use type RT.Time_Span;

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
            Player.Throttle;
         end if;
         if Keyboard.Pressed (Keyboard.Down) then
            Player.Brake;
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

         Player.Update (Value (1.0 / 60.0));

         Render.Render_Dirty (Render.Black);

         delay until Next_Release;
         Next_Release := RT.Clock + Period;
      end loop;
   end Game_Loop;

begin
   Levels.Enter (Levels.Lvl_1);
   Render.Render_All (Render.Black);
end Game;
