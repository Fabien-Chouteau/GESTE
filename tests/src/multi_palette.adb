with GESTE;
with Ada.Text_IO;
with Console_Char_Screen;

procedure Multi_Palette is

   type Color is range 1 .. 2;

   package Console_GESTE is new GESTE
     (Output_Color => Character,
      Color_Index  => Color,
      Tile_Index   => Natural,
      No_Tile      => 0,
      Transparent  => '2',
      Tile_Size    => 5);

   package Console_Screen is new Console_Char_Screen
     (Width       => 16,
      Height      => 16,
      Buffer_Size => 256,
      Init_Char   => ' ',
      Engine      => Console_GESTE);

   Palette_A : aliased constant Console_GESTE.Palette_Type :=
     ('#', '2');

   Palette_B : aliased constant Console_GESTE.Palette_Type :=
     ('0', '2');

   Background : Character := '_';

   Tiles : aliased constant Console_GESTE.Tile_Array :=
     (1 => ((2, 2, 1, 2, 2),
            (2, 2, 1, 2, 2),
            (1, 1, 1, 1, 1),
            (2, 2, 1, 2, 2),
            (2, 2, 1, 2, 2))
     );

   Bank_A : aliased Console_GESTE.Tile_Bank.Instance (Tiles'Access,
                                                      Palette_A'Access);
   Bank_B : aliased Console_GESTE.Tile_Bank.Instance (Tiles'Access,
                                                      Palette_B'Access);

   Sprite_A : aliased Console_GESTE.Sprite.Instance (Bank       => Bank_A'Access,
                                                     Init_Frame => 1);

   Sprite_B : aliased Console_GESTE.Sprite.Instance (Bank       => Bank_B'Access,
                                                     Init_Frame => 1);

begin

   Console_Screen.Verbose;

   Sprite_A.Move ((1, 1));
   Console_GESTE.Add (Sprite_A'Access);

   Sprite_B.Move ((10, 4));
   Console_GESTE.Add (Sprite_B'Access);

   Console_GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);

   Console_Screen.Print;
   Ada.Text_IO.New_Line;

   Sprite_A.Move ((4, 4));
   Sprite_B.Move ((6, 6));

   Console_GESTE.Render_Dirty
     (Screen_Rect      => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);
   Console_Screen.Print;
end Multi_Palette;
