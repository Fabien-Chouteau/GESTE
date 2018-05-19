with GESTE;
with Ada.Text_IO;
with Console_Char_Screen;

procedure Grids is

   type Color is range 1 .. 3;

   package Console_GESTE is new GESTE
     (Output_Color => Character,
      Color_Index  => Color,
      Tile_Index   => Natural,
      No_Tile      => 0,
      Transparent  => '3',
      Tile_Size    => 3);

   package Console_Screen is new Console_Char_Screen
     (Width       => 20,
      Height      => 20,
      Buffer_Size => 256,
      Init_Char   => ' ',
      Engine      => Console_GESTE);

   Palette : aliased constant Console_GESTE.Palette_Type :=
     ('#', '0', '3');

   Background : constant Character := '_';

   Tiles : aliased constant Console_GESTE.Tile_Array :=
     (1 => ((1, 1, 1),
            (1, 3, 1),
            (1, 1, 1)),

      2 => ((2, 3, 2),
            (3, 2, 3),
            (2, 3, 2)),

      3 => ((3, 1, 3),
            (1, 2, 1),
            (3, 1, 3))
     );

   Bank : aliased Console_GESTE.Tile_Bank.Instance (Tiles'Access,
                                                    Console_GESTE.No_Collisions,
                                                    Palette'Access);

   Grid_Data : aliased constant Console_GESTE.Grid_Data :=
     ((0, 2, 0),
      (3, 1, 3),
      (0, 2, 0));

   Grid : aliased Console_GESTE.Grid.Instance (Grid_Data'Access,
                                               Bank'Access);

begin

   Console_Screen.Verbose;

   Grid.Move ((1, 1));
   Console_GESTE.Add (Grid'Access, 0);

   Console_GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);

   Console_Screen.Print;

   Grid.Move ((5, 5));

   Console_GESTE.Render_Dirty
     (Screen_Rect      => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);

   Console_Screen.Print;

end Grids;
