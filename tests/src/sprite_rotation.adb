with GESTE;
with GESTE.Sprite.Rotated;
with GESTE.Tile_Bank;
with GESTE.Maths_Types; use GESTE.Maths_Types;
with Ada.Text_IO;
with Console_Char_Screen;

procedure Sprite_Rotation is

   use type GESTE.Pix_Point;

   package Console_Screen is new Console_Char_Screen
     (Width       => 5,
      Height      => 5,
      Buffer_Size => 256,
      Init_Char   => ' ');

   Palette : aliased constant GESTE.Palette_Type :=
     ('#', '0', 'T', ' ');

   Background : Character := '_';

   Tiles : aliased constant GESTE.Tile_Array :=
     (1 => ((3, 3, 3, 3, 1),
            (3, 3, 3, 1, 3),
            (3, 3, 1, 3, 3),
            (3, 1, 3, 3, 3),
            (1, 3, 3, 3, 3))
     );

   Collisions : aliased constant GESTE.Tile_Collisions_Array :=
     (1 => ((False, False, False, False, True),
            (False, False, False, True, False),
            (False, False, True, False, False),
            (False, True, False, False, False),
            (True, False, False, False, False))
     );

   Bank : aliased GESTE.Tile_Bank.Instance (Tiles'Unrestricted_Access,
                                            Collisions'Unrestricted_Access,
                                            Palette'Unrestricted_Access);

   Sprite_A : aliased GESTE.Sprite.Rotated.Instance
     (Bank       => Bank'Unrestricted_Access,
      Init_Frame => 1);

begin

   Sprite_A.Move ((0, 0));
   Sprite_A.Enable_Collisions;
   GESTE.Add (Sprite_A'Unrestricted_Access, 0);

   if not GESTE.Collides ((4, 0)) then
      Ada.Text_IO.Put_Line ("Collision expected");
   end if;

   GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);

   Console_Screen.Print;
   Ada.Text_IO.New_Line;

   Sprite_A.Angle (Pi / 4.0);

   if Sprite_A.Angle /= (Pi / 4.0) then
      Ada.Text_IO.Put_Line ("Unexpected angle value");
   end if;

   if GESTE.Collides ((4, 0)) then
      Ada.Text_IO.Put_Line ("Collision unexpected");
   end if;

   GESTE.Render_Dirty
     (Screen_Rect      => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);
   Console_Screen.Print;
   Ada.Text_IO.New_Line;

   Sprite_A.Angle (Pi / 2.0);

   GESTE.Render_Dirty
     (Screen_Rect      => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);
   Console_Screen.Print;
   Ada.Text_IO.New_Line;

   Sprite_A.Angle (Pi);

   GESTE.Render_Dirty
     (Screen_Rect      => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);
   Console_Screen.Print;
   Ada.Text_IO.New_Line;

end Sprite_Rotation;
