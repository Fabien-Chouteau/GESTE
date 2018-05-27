with GESTE;
with GESTE.Tile_Bank;
with GESTE.Sprite.Rotated;
with GESTE_Config;      use GESTE_Config;
with GESTE.Maths;       use GESTE.Maths;
with GESTE.Maths_Types; use GESTE.Maths_Types;
with GESTE.Physics;
with GESTE.Text;

with GESTE_Fonts.FreeMono6pt7b;

with Game_Assets;
with Game_Assets.track_1;
with Game_Assets.Tileset;


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

   Stats : aliased GESTE.Text.Instance
     (Da_Font           => GESTE_Fonts.FreeMono6pt7b.Font,
      Number_Of_Columns => 15,
      Number_Of_Lines   => 4,
      Foreground        => 1,
      Background        => GESTE_Config.Transparent);

   Start : Game_Assets.Object renames
     Game_Assets.track_1.Start.Objects (Game_Assets.track_1.Start.Objects'First);
   P : aliased Player_Type (Tile_Bank'Access, 105);

   Next_Gate   : Natural := Game_Assets.track_1.gates.Objects'First;
   Laps_Cnt    : Natural := 0;
   Best_Lap    : Time_Value := 0.0 * s;
   Current_Lap : Time_Value := 0.0 * s;

   Max_Jump_Frame : constant := 7;

   Do_Throttle : Boolean := False;
   Do_Brake : Boolean := False;
   Going_Left : Boolean := False;
   Going_Right : Boolean := False;

   type Collision_Points is (BL, BR, Left, Right, TL, TR);

   Collides : array (Collision_Points) of Boolean;
   Offset   : constant array (Collision_Points) of GESTE.Point
     := (BL    => (-4, 7),
         BR    => (4, 7),
         Left  => (-6, 5),
         Right => (6, 5),
         TL    => (-4, -7),
         TR    => (4, -7));

   procedure Update_Collisions;
   function Inside_Gate (Obj : Game_Assets.Object) return Boolean;

   -----------------------
   -- Update_Collisions --
   -----------------------

   procedure Update_Collisions is
      X : constant Integer := Integer (P.Position.X);
      Y : constant Integer := Integer (P.Position.Y);
   begin
      for Pt in Collision_Points loop
         Collides (Pt) := GESTE.Collides ((X + Offset (Pt).X,
                                           Y + Offset (Pt).Y));
      end loop;
   end Update_Collisions;

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

   procedure Move (Pt : GESTE.Point) is
   begin
      P.Set_Position ((Length_Value (Pt.X), Length_Value (Pt.Y)));
   end Move;

   --------------
   -- Position --
   --------------

   function Position return GESTE.Point
   is ((Integer (P.Position.X), Integer (P.Position.Y)));

   ------------
   -- Update --
   ------------

   procedure Update (Elapsed : Time_Value) is
      Old        : constant Position_Type := P.Position;
      Brake_Coef : Force_Value;
      Dir        : constant Vect := P.Direction;
      Traction   : constant Force_Vect := Dir * Force_Value (10_000.0);

      C_Drag   : constant Dimensionless := 0.5 * 0.3 * 2.2 * 1.29;
      VX       : constant Dimensionless := P.Speed.X;
      VY       : constant Dimensionless := P.Speed.Y;

      function Drag return Force_Vect is
         Speed    : constant Dimensionless := Magnitude (P.Speed);
      begin
         return (Force_Value (-Dimensionless (C_Drag * Dimensionless (VX * Speed))),
                 Force_Value (-Dimensionless (C_Drag * Dimensionless (VY * Speed))));
      end Drag;

      function Friction return Force_Vect is
         C_TT : Dimensionless := 30.0 * C_Drag;
      begin
         if not GESTE.Collides ((Integer (Old.X), Integer (Old.Y))) then
            --  Off track
            C_TT := C_TT * 100;
         end if;
         return (Force_Value (-Dimensionless (C_TT * VX)),
                 Force_Value (-Dimensionless (C_TT * VY)));
      end Friction;

   begin

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
         Brake_Coef := -120.0 * N;
      else
         Brake_Coef := -90.0 * N;
      end if;

      P.Apply_Force ((Dimensionless (P.Speed.X) * Brake_Coef,
                     (Dimensionless (P.Speed.Y) * Brake_Coef)));

      P.Apply_Force (Drag);
      P.Apply_Force (Friction);

      P.Step (Elapsed);

      Update_Collisions;

      P.Set_Angle (P.Angle);
      P.Sprite.Move ((Integer (P.Position.X) - 8,
                     Integer (P.Position.Y) - 8));
      P.Sprite.Angle (P.Angle);

      Stats.Clear;
      Stats.Cursor (1, 1);
      Stats.Put ("Next Gate:" & Next_Gate'Img & ASCII.LF);
      Stats.Put ("Lap:" & Laps_Cnt'Img & ASCII.LF);
      Stats.Put ("Best:" & Best_Lap'Img & ASCII.LF);
      Stats.Put ("     " & Current_Lap'Img & ASCII.LF);

      Current_Lap := Current_Lap + Elapsed;

      if Inside_Gate (Game_Assets.track_1.gates.Objects (Next_Gate)) then
         if Next_Gate = Game_Assets.track_1.gates.Objects'Last then
            Next_Gate := Game_Assets.track_1.gates.Objects'First;
            Laps_Cnt := Laps_Cnt + 1;
            if Best_Lap = 0.0 * s or else Current_Lap < Best_Lap then
               Best_Lap := Current_Lap;
            end if;
            Current_Lap := 0.0 * s;
         else
            Next_Gate := Next_Gate + 1;
         end if;
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
   P.Set_Position ((Length_Value (Start.X), Length_Value (Start.Y)));
   P.Set_Angle (Pi);
   P.Set_Mass (Mass_Value (90.0));
   GESTE.Add (P.Sprite'Access, 3);

   Stats.Move ((220, 0));
   GESTE.Add (Stats'Access, 4);
end Player;
