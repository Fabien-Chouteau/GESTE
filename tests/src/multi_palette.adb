with GESTE;
with GESTE.Sprite;
with GESTE.Tile_Bank;

with Ada.Text_IO;
with Console_Char_Screen;

procedure Multi_Palette is

   package Console_Screen is new Console_Char_Screen
     (Width       => 16,
      Height      => 16,
      Buffer_Size => 256,
      Init_Char   => ' ');

   Palette_A : aliased constant GESTE.Palette_Type :=
     ('#', 'T', ' ', ' ');

   Palette_B : aliased constant GESTE.Palette_Type :=
     ('0', 'T', ' ', ' ');

   Background : Character := '_';

   Tiles : aliased constant GESTE.Tile_Array :=
     (1 => ((2, 2, 1, 2, 2),
            (2, 2, 1, 2, 2),
            (1, 1, 1, 1, 1),
            (2, 2, 1, 2, 2),
            (2, 2, 1, 2, 2))
     );

   Bank_A : aliased GESTE.Tile_Bank.Instance (Tiles'Unrestricted_Access,
                                              GESTE.No_Collisions,
                                              Palette_A'Unrestricted_Access);
   Bank_B : aliased GESTE.Tile_Bank.Instance (Tiles'Unrestricted_Access,
                                              GESTE.No_Collisions,
                                              Palette_B'Unrestricted_Access);

   Sprite_A : aliased GESTE.Sprite.Instance (Bank       => Bank_A'Unrestricted_Access,
                                             Init_Frame => 1);

   Sprite_B : aliased GESTE.Sprite.Instance (Bank       => Bank_B'Unrestricted_Access,
                                             Init_Frame => 1);

begin

   Console_Screen.Verbose;

   Sprite_A.Move ((1, 1));
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
end Multi_Palette;
