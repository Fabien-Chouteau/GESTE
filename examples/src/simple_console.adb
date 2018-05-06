with GESTE;
with Ada.Text_IO;
with Console_Char_Screen;

procedure Main is

   type Color is range 1 .. 3;

   package Console_GESTE is new GESTE
     (Output_Color => Character,
      Color_Index  => Color,
      Tile_Index   => Natural,
      No_Tile      => 0,
      Transparent  => ' ',
      Tile_Size    => 5);

   package Console_Screen is new Console_Char_Screen
     (Width       => 30,
      Height      => 30,
      Buffer_Size => 256,
      Init_Char   => ' ',
      Engine      => Console_GESTE);

   Palette_A : aliased constant Console_GESTE.Palette_Type :=
     ('a', ' ', '+');

   Palette_B : aliased constant Console_GESTE.Palette_Type :=
     (' ', 'b', '+');

   Tiles : aliased constant Console_GESTE.Tile_Array :=
     (1 => ((1, 1, 1, 1, 1),
            (1, 2, 2, 2, 1),
            (1, 2, 3, 2, 1),
            (1, 2, 2, 2, 1),
            (1, 1, 1, 1, 1)),

      2 => ((2, 1, 1, 1, 2),
            (1, 2, 1, 2, 1),
            (1, 1, 3, 1, 1),
            (1, 2, 1, 2, 1),
            (2, 1, 1, 1, 2))
     );

   Grid_Palette : aliased constant Console_GESTE.Palette_Type :=
     ('.', '|', '_');

   Grid_Tiles : aliased constant Console_GESTE.Tile_Array :=
     (1 => ((1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1)),
      2 => ((2, 2, 2, 2, 2),
            (1, 1, 1, 1, 3),
            (1, 1, 1, 1, 3),
            (1, 1, 1, 1, 3),
            (2, 2, 2, 2, 2)),
      3 => ((1, 1, 1, 1, 3),
            (1, 1, 1, 1, 3),
            (1, 1, 1, 1, 3),
            (1, 1, 1, 1, 3),
            (1, 1, 1, 1, 3))
     );

   Bank_A : aliased Console_GESTE.Tile_Bank.Instance (Tiles'Access,
                                                      Palette_A'Access);
   Bank_B : aliased Console_GESTE.Tile_Bank.Instance (Tiles'Access,
                                                      Palette_B'Access);

   Grid_Bank : aliased Console_GESTE.Tile_Bank.Instance (Grid_Tiles'Access,
                                                         Grid_Palette'Access);

   Sprite_A : aliased Console_GESTE.Sprite.Instance (Bank       => Bank_A'Access,
                                                     Init_Frame => 1);

   Sprite_B : aliased Console_GESTE.Sprite.Instance (Bank       => Bank_B'Access,
                                                     Init_Frame => 2);

   Grid_Data_A : aliased constant Console_GESTE.Grid_Data :=
     ((2, 2, 2, 2, 2),
      (2, 1, 1, 3, 2),
      (2, 1, 1, 3, 2),
      (2, 1, 1, 3, 2),
      (2, 2, 2, 2, 2));

   Grid : aliased Console_GESTE.Grid.Instance (Grid_Data_A'Access,
                                               Grid_Bank'Access);

begin

   Grid.Move ((1, 1));
   Console_GESTE.Add (Grid'Access);

   Sprite_A.Move ((1, 1));
   Console_GESTE.Add (Sprite_A'Access);

   Sprite_B.Move ((10, 4));
   Console_GESTE.Add (Sprite_B'Access);

   Console_GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => ' ',
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);

   Console_Screen.Print;
   Ada.Text_IO.New_Line;

   Sprite_A.Move ((4, 4));
   Sprite_B.Move ((6, 6));

   Console_GESTE.Render_Dirty
     (Screen_Rect      => Console_Screen.Screen_Rect,
      Background       => ' ',
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);
   Console_Screen.Print;
end Main;
