with GESTE;
with Ada.Text_IO;
with Console_Char_Screen;

procedure Sprites is

   use type GESTE.Point;

   package Console_Screen is new Console_Char_Screen
     (Width       => 16,
      Height      => 16,
      Buffer_Size => 256,
      Init_Char   => ' ');

   Palette : aliased constant GESTE.Palette_Type :=
     ('#', '0', 'T', ' ');

   Background : Character := '_';

   Tiles : aliased constant GESTE.Tile_Array :=
     (1 => ((3, 3, 1, 3, 3),
            (3, 3, 1, 3, 3),
            (1, 1, 1, 1, 1),
            (3, 3, 1, 3, 3),
            (3, 3, 1, 3, 3)),

      2 => ((2, 3, 3, 3, 2),
            (3, 2, 3, 2, 3),
            (3, 3, 2, 3, 3),
            (3, 2, 3, 2, 3),
            (2, 3, 3, 3, 2))
     );

   Bank : aliased GESTE.Tile_Bank.Instance (Tiles'Unrestricted_Access,
                                            GESTE.No_Collisions,
                                            Palette'Unrestricted_Access);

   Sprite_A : aliased GESTE.Sprite.Instance (Bank       => Bank'Unrestricted_Access,
                                             Init_Frame => 1);

   Sprite_B : aliased GESTE.Sprite.Instance (Bank       => Bank'Unrestricted_Access,
                                             Init_Frame => 2);

begin

   Console_Screen.Verbose;

   Sprite_A.Move ((1, 1));

   if Sprite_A.Position /= (1, 1) then
      raise Program_Error;
   end if;

   GESTE.Add (Sprite_A'Unrestricted_Access, 0);

   Sprite_B.Move ((10, 4));
   GESTE.Add (Sprite_B'Unrestricted_Access, 0);

   GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);

   Console_Screen.Print;
   Ada.Text_IO.New_Line;

   Sprite_A.Move ((4, 4));
   Sprite_B.Move ((6, 6));

   GESTE.Render_Dirty
     (Screen_Rect      => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);
   Console_Screen.Print;
end Sprites;
