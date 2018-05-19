with GESTE;
with Ada.Text_IO;
with Console_Char_Screen;
with Ada.Exceptions;

procedure Layer_Priority is

   type Color is range 1 .. 4;

   package Console_GESTE is new GESTE
     (Output_Color => Character,
      Color_Index  => Color,
      Tile_Index   => Natural,
      No_Tile      => 0,
      Transparent  => ' ',
      Tile_Size    => 5);

   use type Console_GESTE.Point;

   package Console_Screen is new Console_Char_Screen
     (Width       => 9,
      Height      => 9,
      Buffer_Size => 256,
      Init_Char   => ' ',
      Engine      => Console_GESTE);

   Palette : aliased constant Console_GESTE.Palette_Type :=
     ('1', '2', '3', '4');

   Background : Character := '-';

   Tiles : aliased constant Console_GESTE.Tile_Array :=
     (1 => ((1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1),
            (1, 1, 1, 1, 1)),

      2 => ((2, 2, 2, 2, 2),
            (2, 2, 2, 2, 2),
            (2, 2, 2, 2, 2),
            (2, 2, 2, 2, 2),
            (2, 2, 2, 2, 2)),

      3 => ((3, 3, 3, 3, 3),
            (3, 3, 3, 3, 3),
            (3, 3, 3, 3, 3),
            (3, 3, 3, 3, 3),
            (3, 3, 3, 3, 3)),

      4 => ((4, 4, 4, 4, 4),
            (4, 4, 4, 4, 4),
            (4, 4, 4, 4, 4),
            (4, 4, 4, 4, 4),
            (4, 4, 4, 4, 4))
     );

   Bank : aliased Console_GESTE.Tile_Bank.Instance (Tiles'Access,
                                                    Console_GESTE.No_Collisions,
                                                    Palette'Access);

   Sprite_1 : aliased Console_GESTE.Sprite.Instance (Bank       => Bank'Access,
                                                     Init_Frame => 1);
   Sprite_2 : aliased Console_GESTE.Sprite.Instance (Bank       => Bank'Access,
                                                     Init_Frame => 2);
   Sprite_3 : aliased Console_GESTE.Sprite.Instance (Bank       => Bank'Access,
                                                     Init_Frame => 3);
   Sprite_4 : aliased Console_GESTE.Sprite.Instance (Bank       => Bank'Access,
                                                     Init_Frame => 4);

   procedure Update is
   begin
      Console_GESTE.Render_Window
        (Window           => Console_Screen.Screen_Rect,
         Background       => Background,
         Buffer           => Console_Screen.Buffer,
         Push_Pixels      => Console_Screen.Push_Pixels'Access,
         Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);
      Console_Screen.Print;
   end Update;
begin

   Console_Screen.Verbose;

   Sprite_3.Move ((3, 3));
   Console_GESTE.Add (Sprite_3'Access, 3); -- Insert head on empty list
   Sprite_4.Move ((4, 4));
   Console_GESTE.Add (Sprite_4'Access, 4); -- Insert head on non empty list
   Sprite_1.Move ((1, 1));
   Console_GESTE.Add (Sprite_1'Access, 1); -- Insert tail
   Sprite_2.Move ((2, 2));
   Console_GESTE.Add (Sprite_2'Access, 2); -- Insert mid

   Update;

   Console_GESTE.Remove (Sprite_2'Access); --  Remove mid
   Update;

   Console_GESTE.Remove (Sprite_1'Access); --  Remove tail
   Update;

   Console_GESTE.Remove (Sprite_4'Access); --  Remove head on non empty list
   Update;

   Console_GESTE.Remove (Sprite_3'Access); --  Remove head on empty list
   Update;

   declare
   begin
      --  Remove a layer not in the list
      Console_GESTE.Remove (Sprite_3'Access);
   exception
      when E : Program_Error =>
         Ada.Text_IO.Put_Line
           ("Exception:" & Ada.Exceptions.Exception_Message (E));
   end;

end Layer_Priority;
