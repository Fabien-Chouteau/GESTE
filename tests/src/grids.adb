with GESTE;
with GESTE.Grid;
with GESTE.Tile_Bank;

with Ada.Text_IO;
with Console_Char_Screen;

procedure Grids is

   package Console_Screen is new Console_Char_Screen
     (Width       => 20,
      Height      => 20,
      Buffer_Size => 256,
      Init_Char   => ' ');

   Palette : aliased constant GESTE.Palette_Type :=
     ('#', '0', 'T', ' ');

   Background : constant Character := '_';

   Tiles : aliased constant GESTE.Tile_Array :=
     (1 => ((1, 1, 1, 1, 1),
            (1, 3, 3, 3, 1),
            (1, 3, 3, 3, 1),
            (1, 3, 3, 3, 1),
            (1, 1, 1, 1, 1)),

      2 => ((2, 3, 3, 3, 2),
            (3, 2, 3, 2, 3),
            (3, 3, 2, 3, 3),
            (3, 2, 3, 2, 3),
            (2, 3, 3, 3, 2)),

      3 => ((3, 3, 1, 3, 3),
            (3, 3, 1, 3, 3),
            (1, 1, 2, 1, 1),
            (3, 3, 1, 3, 3),
            (3, 3, 1, 3, 3))
     );

   Bank : aliased GESTE.Tile_Bank.Instance (Tiles'Unrestricted_Access,
                                                    GESTE.No_Collisions,
                                                    Palette'Unrestricted_Access);

   Grid_Data : aliased constant GESTE.Grid.Grid_Data :=
     ((0, 2, 0),
      (3, 1, 3),
      (0, 2, 0));

   Grid : aliased GESTE.Grid.Instance (Grid_Data'Unrestricted_Access,
                                               Bank'Unrestricted_Access);

begin

   Console_Screen.Verbose;

   Grid.Move ((1, 1));
   GESTE.Add (Grid'Unrestricted_Access, 0);

   GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);

   Console_Screen.Print;

   Grid.Move ((5, 5));

   GESTE.Render_Dirty
     (Screen_Rect      => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);

   Console_Screen.Print;

end Grids;
