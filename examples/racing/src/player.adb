with GESTE;
with GESTE.Tile_Bank;
with GESTE.Sprite.Rotated;
with GESTE_Config;      use GESTE_Config;
with GESTE.Maths;       use GESTE.Maths;
with GESTE.Physics;
with GESTE.Text;

with GESTE_Fonts.FreeMono6pt7b;

with Game_Assets.track_1;
with Game_Assets.Tileset;

with Interfaces; use Interfaces;

package body Player is

   type Player_Type (Bank       : not null GESTE.Tile_Bank.Const_Ref;
                     Init_Frame : GESTE_Config.Tile_Index)
   is limited new GESTE.Physics.Object with record
      Sprite : aliased GESTE.Sprite.Rotated.Instance (Bank, Init_Frame);
   end record;

   Tile_Bank : aliased GESTE.Tile_Bank.Instance
     (Game_Assets.Tileset.Tiles'Access,
      GESTE.No_Collisions,
      Game_Assets.Palette'Access);

   subtype Stat_Text is GESTE.Text.Instance
     (Da_Font           => GESTE_Fonts.FreeMono6pt7b.Font,
      Number_Of_Columns => 15,
      Number_Of_Lines   => 1,
      Foreground        => 1,
      Background        => GESTE_Config.Transparent);

   Next_Gate_Text : aliased Stat_Text;
   Lap_Text : aliased Stat_Text;
   Best_Text : aliased Stat_Text;
   Current_Text : aliased Stat_Text;

   Frame_Count : Unsigned_32 := 0;

   Start : Game_Assets.Object renames
     Game_Assets.track_1.Start.Objects (Game_Assets.track_1.Start.Objects'First);
   P : aliased Player_Type (Tile_Bank'Access, 105);

   Next_Gate   : Natural := Game_Assets.track_1.gates.Objects'First;
   Laps_Cnt    : Natural := 0;
   Best_Lap    : Value := 0.0;
   Current_Lap : Value := 0.0;

   Do_Throttle : Boolean := False;
   Do_Brake : Boolean := False;
   Going_Left : Boolean := False;
   Going_Right : Boolean := False;

   function Inside_Gate (Obj : Game_Assets.Object) return Boolean;

   -----------------
   -- Inside_Gate --
   -----------------

   function Inside_Gate (Obj : Game_Assets.Object) return Boolean
   is (P.Position.X in Obj.X .. Obj.X + Obj.Width
       and then
       P.Position.Y in Obj.Y .. Obj.Y + Obj.Height);

   ----------
   -- Move --
   ----------

   procedure Move (Pt : GESTE.Pix_Point) is
   begin
      P.Set_Position ((Value (Pt.X), Value (Pt.Y)));
   end Move;

   --------------
   -- Position --
   --------------

   function Position return GESTE.Pix_Point
   is ((Integer (P.Position.X), Integer (P.Position.Y)));

   ------------
   -- Update --
   ------------

   procedure Update (Elapsed : Value) is
      Old        : constant Point := P.Position;
      Brake_Coef : Value;
      Dir        : constant Vect := P.Direction;
      Traction   : constant Vect := Dir * 10_000.0;

      C_Drag   : constant Value := 0.5 * 0.3 * 2.2 * 1.29;
      VX       : constant Value := P.Speed.X;
      VY       : constant Value := P.Speed.Y;

      function Drag return Vect;
      function Friction return Vect;

      ----------
      -- Drag --
      ----------

      function Drag return Vect is
         Speed : constant Value := Magnitude (P.Speed);
      begin
         return (-(Value (C_Drag * VX) * Speed),
                 -(Value (C_Drag * VY) * Speed));
      end Drag;

      --------------
      -- Friction --
      --------------

      function Friction return Vect is
         C_TT : Value := 30.0 * C_Drag;
      begin
         if not GESTE.Collides ((Integer (Old.X), Integer (Old.Y))) then
            --  Off track
            C_TT := C_TT * 100;
         end if;
         return (-C_TT * VX, -C_TT * VY);
      end Friction;

   begin
      Frame_Count := Frame_Count + 1;

      if Going_Right then
         P.Set_Angle (P.Angle - 0.060);
      end if;
      if Going_Left then
         P.Set_Angle (P.Angle + 0.060);
      end if;

      if Do_Throttle then
         P.Apply_Force (Traction);
      end if;

      if Do_Brake then
         Brake_Coef := -120.0;
      else
         Brake_Coef := -90.0;
      end if;

      P.Apply_Force ((P.Speed.X * Brake_Coef, P.Speed.Y * Brake_Coef));

      P.Apply_Force (Drag);
      P.Apply_Force (Friction);

      P.Step (Elapsed);

      P.Set_Angle (P.Angle);
      P.Sprite.Move ((Integer (P.Position.X) - 8,
                     Integer (P.Position.Y) - 8));
      P.Sprite.Angle (P.Angle);

      if Frame_Count mod 10 = 0 then
         --  Update the current time every 10 frames
         Current_Text.Clear;
         Current_Text.Cursor (1, 1);
         Current_Text.Put (Current_Lap'Img);
      end if;

      Current_Lap := Current_Lap + Elapsed;

      if Inside_Gate (Game_Assets.track_1.gates.Objects (Next_Gate)) then
         if Next_Gate = Game_Assets.track_1.gates.Objects'Last then
            Next_Gate := Game_Assets.track_1.gates.Objects'First;
            Laps_Cnt := Laps_Cnt + 1;
            Lap_Text.Clear;
            Lap_Text.Cursor (1, 1);
            Lap_Text.Put ("Lap:" & Laps_Cnt'Img);

            if Best_Lap = 0.0 or else Current_Lap < Best_Lap then
               Best_Lap := Current_Lap;
               Best_Text.Clear;
               Best_Text.Cursor (1, 1);
               Best_Text.Put ("Best:" & Best_Lap'Img);
            end if;
            Current_Lap := 0.0;
         else
            Next_Gate := Next_Gate + 1;
         end if;

         Next_Gate_Text.Clear;
         Next_Gate_Text.Cursor (1, 1);
         Next_Gate_Text.Put ("Next Gate:" & Next_Gate'Img);
      end if;
      Do_Throttle := False;
      Do_Brake := False;
      Going_Left := False;
      Going_Right := False;
   end Update;

   --------------
   -- Throttle --
   --------------

   procedure Throttle is
   begin
      Do_Throttle := True;
   end Throttle;

   -----------
   -- Brake --
   -----------

   procedure Brake is
   begin
      Do_Brake := True;
   end Brake;

   ---------------
   -- Move_Left --
   ---------------

   procedure Move_Left is
   begin
      Going_Left := True;
   end Move_Left;

   ----------------
   -- Move_Right --
   ----------------

   procedure Move_Right is
   begin
      Going_Right := True;
   end Move_Right;

begin
   P.Set_Position ((Value (Start.X), Value (Start.Y)));
   P.Set_Angle (Pi);
   P.Set_Mass (90.0);
   GESTE.Add (P.Sprite'Access, 3);

   Next_Gate_Text.Move ((220, 0));
   Next_Gate_Text.Put ("Next Gate: 0");
   GESTE.Add (Next_Gate_Text'Access, 4);
   Lap_Text.Move ((220, 10));
   Lap_Text.Put ("Lap: 0");
   GESTE.Add (Lap_Text'Access, 5);
   Best_Text.Move ((220, 20));
   Best_Text.Put ("Best: 0.0");
   GESTE.Add (Best_Text'Access, 6);
   Current_Text.Move ((260, 30));
   GESTE.Add (Current_Text'Access, 7);
end Player;
