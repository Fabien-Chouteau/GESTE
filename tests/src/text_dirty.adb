
with GESTE;
with GESTE.Text;
with Ada.Text_IO;
with Console_Char_Screen;
with GESTE_Fonts.FreeMono8pt7b;

procedure Text_Dirty is

   package Font_A renames GESTE_Fonts.FreeMono8pt7b;

   package Console_Screen is new Console_Char_Screen
     (Width       => 45,
      Height      => 20,
      Buffer_Size => 45,
      Init_Char   => ' ');


   Text_A : aliased GESTE.Text.Instance
     (Font_A.Font, 4, 1, '#', ' ');

   procedure Update is
   begin
      GESTE.Render_Dirty
        (Screen_Rect      => Console_Screen.Screen_Rect,
         Background       => ' ',
         Buffer           => Console_Screen.Buffer,
         Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
         Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);

      Console_Screen.Print;
      Ada.Text_IO.New_Line;
   end Update;
begin

   Console_Screen.Verbose;

   Text_A.Put ("test");
   Text_A.Move ((0, 0));
   GESTE.Add (Text_A'Unrestricted_Access, 0);

   GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => ' ',
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);

   Console_Screen.Print;
   Ada.Text_IO.New_Line;

   Update;

   --  Check that inverting a char triggers a re-draw
   Text_A.Invert (2, 1);
   Update;

   --  Check that changing a char triggers a re-draw
   Text_A.Cursor (3, 1);
   Text_A.Put ('O');
   Update;

   --  Check that changing colors triggers a re-draw
   Text_A.Set_Colors (4, 1, '_', ' ');
   Update;

   --  Check that clearing text triggers a re-draw
   Text_A.Clear;
   Update;

end Text_Dirty;
