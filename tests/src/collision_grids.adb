with GESTE;
with Ada.Text_IO;
with Console_Char_Screen;

procedure Collision_Grids is

   type Color is range 1 .. 3;

   package Console_GESTE is new GESTE
     (Output_Color => Character,
      Color_Index  => Color,
      Tile_Index   => Natural,
      No_Tile      => 0,
      Transparent  => '3',
      Tile_Size    => 3);

   package Console_Screen is new Console_Char_Screen
     (Width       => 12,
      Height      => 6,
      Buffer_Size => 256,
      Init_Char   => ' ',
      Engine      => Console_GESTE);

   Palette : aliased constant Console_GESTE.Palette_Type :=
     ('#', '0', '3');

   Background : constant Character := ' ';

   Tiles : aliased constant Console_GESTE.Tile_Array :=
     (1 => ((1, 1, 1),
            (1, 1, 1),
            (1, 1, 1)),

      2 => ((3, 3, 3),
            (3, 3, 3),
            (3, 3, 3))
     );

   Tiles_Collisions : aliased constant Console_GESTE.Tile_Collisions_Array :=
     (1 => ((True, True, True),
            (True, True, True),
            (True, True, True)),

      2 => ((False, False, False),
            (False, False, False),
            (False, False, False))
     );

   Bank : aliased Console_GESTE.Tile_Bank.Instance
     (Tiles'Access,
      Tiles_Collisions'Access,
      Palette'Access);

   Bank_No_Collisions : aliased Console_GESTE.Tile_Bank.Instance
     (Tiles'Access,
      Console_GESTE.No_Collisions,
      Palette'Access);

   Grid_Data : aliased constant Console_GESTE.Grid_Data :=
     ((1, 2),
      (0, 1));

   Grid : aliased Console_GESTE.Grid.Instance (Grid_Data'Access,
                                               Bank'Access);

   Grid_No_Collisions : aliased Console_GESTE.Grid.Instance (Grid_Data'Access,
                                                             Bank'Access);

begin
   Grid.Move ((0, 0));
   Console_GESTE.Add (Grid'Access, 0);

   Grid_No_Collisions.Move ((6, 0));
   Console_GESTE.Add (Grid_No_Collisions'Access, 0);

   Console_GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);

   Console_Screen.Print;

   --  Collisions disabled on all layers
   Console_Screen.Test_Collision (1, 1, False);
   Console_Screen.Test_Collision (4, 1, False);

   --  Collisions enabled on all layers
   Grid.Enable_Collisions;
   Grid_No_Collisions.Enable_Collisions;
   Console_Screen.Test_Collision (1, 1, True);
   Console_Screen.Test_Collision (4, 1, False);

   --  There's no collisions when there's no tile
   Console_Screen.Test_Collision (1, 4, False);

   --  There's no collisions data for the bank of this layer
   Console_Screen.Test_Collision (4, 1, False);

   --  There's no collisions outside the grids
   Console_Screen.Test_Collision (10, 10, False);

end Collision_Grids;
