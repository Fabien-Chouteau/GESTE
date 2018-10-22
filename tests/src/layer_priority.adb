with GESTE;
with GESTE.Sprite;
with GESTE.Tile_Bank;

with Ada.Text_IO;
with Console_Char_Screen;
with Ada.Exceptions;

procedure Layer_Priority is

   use type GESTE.Pix_Point;

   package Console_Screen is new Console_Char_Screen
     (Width       => 9,
      Height      => 9,
      Buffer_Size => 256,
      Init_Char   => ' ');

   Palette : aliased constant GESTE.Palette_Type :=
     ('1', '2', '3', '4');

   Background : Character := '-';

   Tiles : aliased constant GESTE.Tile_Array :=
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

   Bank : aliased GESTE.Tile_Bank.Instance (Tiles'Unrestricted_Access,
                                            GESTE.No_Collisions,
                                            Palette'Unrestricted_Access);

   Sprite_1 : aliased GESTE.Sprite.Instance (Bank       => Bank'Unrestricted_Access,
                                             Init_Frame => 1);
   Sprite_2 : aliased GESTE.Sprite.Instance (Bank       => Bank'Unrestricted_Access,
                                             Init_Frame => 2);
   Sprite_3 : aliased GESTE.Sprite.Instance (Bank       => Bank'Unrestricted_Access,
                                             Init_Frame => 3);
   Sprite_4 : aliased GESTE.Sprite.Instance (Bank       => Bank'Unrestricted_Access,
                                             Init_Frame => 4);

   procedure Update is
   begin
      GESTE.Render_Window
        (Window           => Console_Screen.Screen_Rect,
         Background       => Background,
         Buffer           => Console_Screen.Buffer,
         Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
         Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);
      Console_Screen.Print;
   end Update;
begin

   Console_Screen.Verbose;

   Sprite_3.Move ((3, 3));
   GESTE.Add (Sprite_3'Unrestricted_Access, 3); -- Insert head on empty list
   Sprite_4.Move ((4, 4));
   GESTE.Add (Sprite_4'Unrestricted_Access, 4); -- Insert head on non empty list
   Sprite_1.Move ((1, 1));
   GESTE.Add (Sprite_1'Unrestricted_Access, 1); -- Insert tail
   Sprite_2.Move ((2, 2));
   GESTE.Add (Sprite_2'Unrestricted_Access, 2); -- Insert mid

   Update;

   GESTE.Remove (Sprite_2'Unrestricted_Access); --  Remove mid
   Update;

   GESTE.Remove (Sprite_1'Unrestricted_Access); --  Remove tail
   Update;

   GESTE.Remove (Sprite_4'Unrestricted_Access); --  Remove head on non empty list
   Update;

   GESTE.Remove (Sprite_3'Unrestricted_Access); --  Remove head on empty list
   Update;

   declare
   begin
      --  Remove a layer not in the list
      GESTE.Remove (Sprite_3'Unrestricted_Access);
   exception
      when E : Program_Error =>
         Ada.Text_IO.Put_Line
           ("Exception:" & Ada.Exceptions.Exception_Message (E));
   end;

end Layer_Priority;
