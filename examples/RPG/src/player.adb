with GESTE;
with GESTE.Tile_Bank;
with GESTE.Grid;
with GESTE_Config;      use GESTE_Config;
with GESTE.Maths_Types; use GESTE.Maths_Types;
with GESTE.Physics;

with Game_Assets.Tileset;
with Game_Assets.character;
with Interfaces; use Interfaces;

package body Player is

   Player_Sprite : aliased GESTE.Grid.Grid_Data :=
     ((0, 0, 0, 0),
      (0, 0, 0, 0));

   type Player_Type (Bank       : not null GESTE.Tile_Bank.Const_Ref;
                     Init_Frame : GESTE_Config.Tile_Index)
   is limited new GESTE.Physics.Object with record
      Sprite : aliased GESTE.Grid.Instance
        (Player_Sprite'Access,
         Bank);
   end record;

   Tile_Bank : aliased GESTE.Tile_Bank.Instance
     (Game_Assets.Tileset.Tiles'Access,
      GESTE.No_Collisions,
      Game_Assets.Palette'Access);

   P : aliased Player_Type (Tile_Bank'Access, 3);

   Move_Unit : constant := 1.0;

   Going_Left : Boolean := False;
   Going_Right : Boolean := False;
   Going_Up : Boolean := False;
   Going_Down : Boolean := False;

   type Collision_Points is (BL, BR, TL, TR);

   Collides : array (Collision_Points) of Boolean;
   Offset   : constant array (Collision_Points) of GESTE.Pix_Point
     := (BL    => (-13, 7),
         BR    => (13, 7),
         TL    => (-13, -5),
         TR    => (13, -5));

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
      P.Set_Position ((Value (Pt.X), Value (Pt.Y)));
      P.Sprite.Move ((Integer (P.Position.X) - 16,
                     Integer (P.Position.Y) - 50));
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
      Old : Point := P.Position;
   begin

      if Going_Up then
         P.Set_Position ((P.Position.X, P.Position.Y - Move_Unit));
      elsif Going_Down then
         P.Set_Position ((P.Position.X, P.Position.Y + Move_Unit));
      end if;

      Update_Collisions;

      if Collides (BL)
        or else
         Collides (BR)
        or else
         Collides (TL)
        or else
         Collides (TR)
      then
         P.Set_Position (Old);
      end if;

      Old := P.Position;

      if Going_Right then
         P.Set_Position ((P.Position.X + Move_Unit, P.Position.Y));
      elsif Going_Left then
         P.Set_Position ((P.Position.X - Move_Unit, P.Position.Y));
      end if;

      Update_Collisions;

      if Collides (BL)
        or else
         Collides (BR)
        or else
         Collides (TL)
        or else
         Collides (TR)
      then
         P.Set_Position (Old);
      end if;

      if Going_Up then
         case Unsigned_32 (abs P.Position.Y) mod 16 is
            when 0 .. 3 => Player_Sprite := Game_Assets.character.Up1.Data;
            when 4 .. 5 | 12 .. 15 => Player_Sprite := Game_Assets.character.Up2.Data;
            when others => Player_Sprite := Game_Assets.character.Up3.Data;
         end case;
      elsif Going_Down then
         case Unsigned_32 (abs P.Position.Y) mod 16 is
            when 0 .. 3 => Player_Sprite := Game_Assets.character.Down1.Data;
            when 4 .. 5 | 12 .. 15 => Player_Sprite := Game_Assets.character.Down2.Data;
            when others => Player_Sprite := Game_Assets.character.Down3.Data;
         end case;
      elsif Going_Left then
         case Unsigned_32 (abs P.Position.X) mod 16 is
            when 0 .. 3 => Player_Sprite := Game_Assets.character.Left1.Data;
            when 4 .. 5 | 12 .. 15 => Player_Sprite := Game_Assets.character.Left2.Data;
            when others => Player_Sprite := Game_Assets.character.Left3.Data;
         end case;
      elsif Going_Right then
         case Unsigned_32 (abs P.Position.X) mod 16 is
            when 0 .. 3 => Player_Sprite := Game_Assets.character.Right1.Data;
            when 4 .. 5 | 12 .. 15 => Player_Sprite := Game_Assets.character.Right2.Data;
            when others => Player_Sprite := Game_Assets.character.Right3.Data;
         end case;
      end if;

      P.Sprite.Move ((Integer (P.Position.X) - 16,
                     Integer (P.Position.Y) - 50));

      Going_Left  := False;
      Going_Right := False;
      Going_Up    := False;
      Going_Down  := False;
   end Update;

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

   -------------
   -- Move_Up --
   -------------

   procedure Move_Up is
   begin
      Going_Up := True;
   end Move_Up;

   ----------------
   -- Move_Down --
   ----------------

   procedure Move_Down is
   begin
      Going_Down := True;
   end Move_Down;

begin
   Player_Sprite := Game_Assets.character.Up1.Data;
   GESTE.Add (P.Sprite'Access, 4);
end Player;
