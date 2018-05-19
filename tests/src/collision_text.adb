
with GESTE;
with Ada.Text_IO; use Ada.Text_IO;
with Console_Char_Screen;
with GESTE_Fonts.FreeMonoBold8pt7b;

procedure Collision_Text is

   package Font_A renames GESTE_Fonts.FreeMonoBold8pt7b;

   type Color is range 1 .. 3;

   package Console_GESTE is new GESTE
     (Output_Color => Character,
      Color_Index  => Color,
      Tile_Index   => Natural,
      No_Tile      => 0,
      Transparent  => ' ',
      Tile_Size    => 5);

   package Console_Screen is new Console_Char_Screen
     (Width       => 10,
      Height      => 16,
      Buffer_Size => 45,
      Init_Char   => ' ',
      Engine      => Console_GESTE);


   Text_A : aliased Console_GESTE.Text.Instance
     (Font_A.Font, 1, 1, '#', ' ');

begin

   Text_A.Put ("T");
   Text_A.Move ((0, 0));
   Console_GESTE.Add (Text_A'Access, 0);

   Console_GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => ' ',
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);

   Console_Screen.Print;


   --  Collisions not enabled on the text layer
   Console_Screen.Test_Collision (5, 5, False);

   --  Collisions enabled on the text layer
   Text_A.Enable_Collisions;
   Console_Screen.Test_Collision (5, 5, True);

   --  Invert the text so now it shouldn't collide any more
   Text_A.Invert_All;

   Ada.Text_IO.New_Line;
   Console_GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => ' ',
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Access);

   Console_Screen.Print;

   Console_Screen.Test_Collision (5, 5, False);

   --  Test collision outside the text layer
   Console_Screen.Test_Collision (20, 20, False);
end Collision_Text;
