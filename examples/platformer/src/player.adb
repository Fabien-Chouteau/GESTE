with GESTE;
with GESTE.Tile_Bank;
with GESTE.Sprite;
with GESTE_Config;      use GESTE_Config;
with GESTE.Maths_Types; use GESTE.Maths_Types;
with GESTE.Physics;

with Game_Assets;
with Game_Assets.Tileset;

package body Player is

   type Player_Type (Bank       : not null GESTE.Tile_Bank.Const_Ref;
                     Init_Frame : GESTE_Config.Tile_Index)
   is limited new GESTE.Physics.Object with record
      Sprite : aliased GESTE.Sprite.Instance (Bank, Init_Frame);
   end record;

   Tile_Bank : aliased GESTE.Tile_Bank.Instance
     (Game_Assets.Tileset.Tiles'Access,
      GESTE.No_Collisions,
      Game_Assets.Palette'Access);

   P : aliased Player_Type (Tile_Bank'Access, 79);

   Max_Jump_Frame : constant := 7;

   Jumping : Boolean := False;
   Do_Jump : Boolean := False;
   Jump_Cnt : Natural := 0;

   Going_Left : Boolean := False;
   Going_Right : Boolean := False;

   type Collision_Points is (BL, BR, Left, Right, TL, TR);

   Collides : array (Collision_Points) of Boolean;
   Offset   : constant array (Collision_Points) of GESTE.Pix_Point
     := (BL    => (-4, 7),
         BR    => (4, 7),
         Left  => (-6, 5),
         Right => (6, 5),
         TL    => (-4, -7),
         TR    => (4, -7));

   Grounded : Boolean := False;

   procedure Update_Collisions;

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

   ----------
   -- Move --
   ----------

   procedure Move (Pt : GESTE.Pix_Point) is
   begin
      P.Set_Position (GESTE.Maths_Types.Point'(Value (Pt.X), Value (Pt.Y)));
   end Move;

   --------------
   -- Position --
   --------------

   function Position return GESTE.Pix_Point
   is ((Integer (P.Position.X), Integer (P.Position.Y)));

   ------------
   -- Update --
   ------------

   procedure Update is
      Old : constant Point := P.Position;
   begin

      if Going_Right then
         P.Sprite.Flip_Vertical (False);
         P.Sprite.Set_Tile (Tile_Index (79 + (Integer (Old.X) / 2) mod 3));
      elsif Going_Left then
         P.Sprite.Flip_Vertical (True);
         P.Sprite.Set_Tile (Tile_Index (79 + (Integer (Old.X) / 2) mod 3));
      end if;

      if Grounded then
         if Going_Right then
            P.Apply_Force ((14_000.0, 0.0));
         elsif Going_Left then
            P.Apply_Force ((-14_000.0, 0.0));
         else
            --  Friction
            P.Apply_Force (
                           (Value (Value (-800.0) * P.Speed.X),
                           0.0));
         end if;
      else
         if Going_Right then
            P.Apply_Force ((7_000.0, 0.0));
         elsif Going_Left then
            P.Apply_Force ((-7_000.0, 0.0));
         end if;

         P.Apply_Gravity (Value (-500.0));
      end if;

      if Do_Jump then
         P.Apply_Force ((0.0, -20_0000.0));
         Jumping := True;
      end if;

      P.Step (Value (1.0 / 60.0));

      Update_Collisions;

      if Collides (BL)
        or else
         Collides (BR)
        or else
         Collides (TL)
        or else
         Collides (TR)
      then
         P.Set_Position ((P.Position.X, Old.Y));
         P.Set_Speed ((P.Speed.X, Value (0.0)));
         Jump_Cnt := 0;
      end if;

      if Collides (TL) or else Collides (TR) then
         Jump_Cnt := Max_Jump_Frame + 1;
      end if;

      Grounded := Collides (BL) or else Collides (BR);
      Jumping := Jumping and not Grounded;

      if (P.Speed.X > Value (0.0)
          and then (Collides (Right) or else Collides (TR)))
        or else
          (P.Speed.X < Value (0.0)
           and then (Collides (Left) or else Collides (TL)))
      then
         P.Set_Position ((Old.X, P.Position.Y));
         P.Set_Speed ((Value (0.0), P.Speed.Y));
      end if;

      P.Sprite.Move ((Integer (P.Position.X) - 8,
                     Integer (P.Position.Y) - 8));

      Do_Jump := False;
      Going_Left := False;
      Going_Right := False;
   end Update;

   ----------
   -- Jump --
   ----------

   procedure Jump is
   begin
      if Grounded or else (Jumping and then Jump_Cnt < Max_Jump_Frame) then
         Do_Jump := True;
         Jump_Cnt := Jump_Cnt + 1;
      end if;
   end Jump;

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
   P.Set_Mass (Value (90.0));
   GESTE.Add (P.Sprite'Access, 3);
end Player;
