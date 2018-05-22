with GESTE;
with GESTE.Grid;
with GESTE.Tile_Bank;

with Ada.Text_IO;
with Console_Char_Screen;

procedure Collision_Grids is

   package Console_Screen is new Console_Char_Screen
     (Width       => 20,
      Height      => 10,
      Buffer_Size => 256,
      Init_Char   => ' ');

   Palette : aliased constant GESTE.Palette_Type :=
     ('#', '0', 'T', ' ');

   Background : constant Character := ' ';

   Tiles : aliased constant GESTE.Tile_Array :=
     (1 => ((1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1)),

      2 => ((3, 3, 3, 3, 3),
            (3, 3, 3, 3, 3),
            (3, 3, 3, 3, 3),
            (3, 3, 3, 3, 3),
            (3, 3, 3, 3, 3))
     );

   Tiles_Collisions : aliased constant GESTE.Tile_Collisions_Array :=
     (1 => ((True, True, True, True, True),
            (True, True, True, True, True),
            (True, True, True, True, True),
            (True, True, True, True, True),
            (True, True, True, True, True)),

      2 => ((False, False, False, False, False),
            (False, False, False, False, False),
            (False, False, False, False, False),
            (False, False, False, False, False),
            (False, False, False, False, False))
     );

   Bank : aliased GESTE.Tile_Bank.Instance
     (Tiles'Unrestricted_Access,
      Tiles_Collisions'Unrestricted_Access,
      Palette'Unrestricted_Access);

   Bank_No_Collisions : aliased GESTE.Tile_Bank.Instance
     (Tiles'Unrestricted_Access,
      GESTE.No_Collisions,
      Palette'Unrestricted_Access);

   Grid_Data : aliased constant GESTE.Grid.Grid_Data :=
     ((1, 2),
      (0, 1));

   Grid : aliased GESTE.Grid.Instance
     (Grid_Data'Unrestricted_Access,
      Bank'Unrestricted_Access);

   Grid_No_Collisions : aliased GESTE.Grid.Instance
     (Grid_Data'Unrestricted_Access,
      Bank_No_Collisions'Unrestricted_Access);

begin
   Grid.Move ((0, 0));
   GESTE.Add (Grid'Unrestricted_Access, 0);

   Grid_No_Collisions.Move ((10, 0));
   GESTE.Add (Grid_No_Collisions'Unrestricted_Access, 0);

   GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);

   Console_Screen.Print;

   --  Collisions disabled on all layers
   Console_Screen.Test_Collision (1, 1, False);
   Console_Screen.Test_Collision (6, 1, False);

   --  Collisions enabled on all layers
   Grid.Enable_Collisions;
   Grid_No_Collisions.Enable_Collisions;
   Console_Screen.Test_Collision (1, 1, True);
   Console_Screen.Test_Collision (6, 1, False);

   --  There's no collisions when there's no tile
   Console_Screen.Test_Collision (1, 6, False);

   --  There's no collisions data for the bank of this layer
   Console_Screen.Test_Collision (10, 1, False);

   --  There's no collisions outside the grids
   Console_Screen.Test_Collision (25, 25, False);

end Collision_Grids;
