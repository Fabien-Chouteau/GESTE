with GESTE;
with Ada.Text_IO;
with Console_Char_Screen;

procedure Collision_Sprite is

   type Color is range 1 .. 3;

   package Console_GESTE is new GESTE
     (Output_Color => Character,
      Color_Index  => Color,
      Tile_Index   => Natural,
      No_Tile      => 0,
      Transparent  => '3',
      Tile_Size    => 5);

   use type Console_GESTE.Point;

   package Console_Screen is new Console_Char_Screen
     (Width       => 10,
      Height      => 5,
      Buffer_Size => 256,
      Init_Char   => ' ',
      Engine      => Console_GESTE);

   Palette : aliased constant Console_GESTE.Palette_Type :=
     ('#', '0', '3');

   Background : Character := ' ';

   Tiles : aliased constant Console_GESTE.Tile_Array :=
     (1 => ((1, 1, 1, 1, 1),
            (1, 3, 3, 3, 1),
            (1, 3, 3, 3, 1),
            (1, 3, 3, 3, 1),
            (1, 1, 1, 1, 1)),

      2 => ((3, 3, 3, 3, 3),
            (3, 2, 2, 2, 3),
            (3, 2, 3, 2, 3),
            (3, 2, 2, 2, 3),
            (3, 3, 3, 3, 3))
     );

   Tiles_Collisions : aliased constant Console_GESTE.Tile_Collisions_Array :=
     (1 => ((True, True,  True,  True,  True),
            (True, False, False, False, True),
            (True, False, False, False, True),
            (True, False, False, False, True),
            (True, True,  True,  True,  True)),

      2 => ((False, False, False, False, False),
            (False, True,  True,  True,  False),
            (False, True,  False, True,  False),
            (False, True,  True,  True,  False),
            (False, False, False, False, False))
     );

   Bank : aliased Console_GESTE.Tile_Bank.Instance (Tiles'Access,
                                                    Tiles_Collisions'Access,
                                                    Palette'Access);

   Bank_No_Collisions : aliased Console_GESTE.Tile_Bank.Instance
     (Tiles'Access,
      Console_GESTE.No_Collisions,
      Palette'Access);

   Sprite_A : aliased Console_GESTE.Sprite.Instance (Bank       => Bank'Access,
                                                     Init_Frame => 1);

   Sprite_B : aliased Console_GESTE.Sprite.Instance (Bank       => Bank'Access,
                                                     Init_Frame => 2);

   Sprite_No_Collisions : aliased Console_GESTE.Sprite.Instance
     (Bank       => Bank_No_Collisions'Access,
      Init_Frame => 1);

begin
   Sprite_A.Move ((0, 0));
   Console_GESTE.Add (Sprite_A'Access, 0);

   Sprite_B.Move ((0, 0));
   Console_GESTE.Add (Sprite_B'Access, 0);

   Sprite_No_Collisions.Move ((5, 0));
   Console_GESTE.Add (Sprite_No_Collisions'Access, 0);

   Console_GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => Background,
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);

   Console_Screen.Print;

   --  Collisions disabled on all layers
   Console_Screen.Test_Collision (0, 0, False);
   Console_Screen.Test_Collision (1, 1, False);
   Console_Screen.Test_Collision (2, 2, False);
   Console_Screen.Test_Collision (6, 6, False); -- Outside sprites

   --  Collisions enabled on layer A only
   Sprite_A.Enable_Collisions;
   Console_Screen.Test_Collision (0, 0, True);
   Console_Screen.Test_Collision (1, 1, False);
   Console_Screen.Test_Collision (2, 2, False);
   Console_Screen.Test_Collision (6, 6, False); -- Outside sprites

   --  Collisions enabled on all
   Sprite_B.Enable_Collisions;
   Console_Screen.Test_Collision (0, 0, True);
   Console_Screen.Test_Collision (1, 1, True);
   Console_Screen.Test_Collision (2, 2, False);
   Console_Screen.Test_Collision (6, 6, False); -- Outside sprites

   --  No collisions on a sprite using a bank without collisions
   Sprite_No_Collisions.Enable_Collisions;
   Console_Screen.Test_Collision (6, 0, False); -- Outside sprites

end Collision_Sprite;
