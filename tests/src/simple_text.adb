
with GESTE;
with GESTE.Text;
with Ada.Text_IO;
with Console_Char_Screen;
with GESTE_Fonts.FreeMono6pt7b;

procedure Simple_Text is

   package Font_A renames GESTE_Fonts.FreeMono6pt7b;

   package Console_Screen is new Console_Char_Screen
     (Width       => 42,
      Height      => 35,
      Buffer_Size => 256,
      Init_Char   => ' ');

   Text_A : aliased GESTE.Text.Instance
     (Font_A.Font, 6, 3, '#', ' ');
begin

   Text_A.Move ((0, 0));
   GESTE.Add (Text_A'Unrestricted_Access, 0);

   Text_A.Cursor (1, 1);

   --  Check that out of bounds Set_Cursor has no effect
   Text_A.Cursor (100, 1);
   Text_A.Cursor (1, 100);
   Text_A.Cursor (100, 100);

   Text_A.Put ("AbCdEf");

   -- Check LF in the middle of a string
   Text_A.Put ("{!@&^" & ASCII.LF & "123");

   --  Check overflow of the last line (7 will be printed at (1, 1)
   Text_A.Put ("4567");
   if Text_A.Char (1, 1) /= '7' then
      Ada.Text_IO.Put_Line ("unexpected character at (1, 1)");
   end if;

   --  Invert some characters
   Text_A.Invert (1, 1);
   Text_A.Invert (3, 1);
   Text_A.Invert (5, 1);
   Text_A.Invert (2, 2);
   Text_A.Invert (4, 2);

   --  Change color of the second line
   for A in 1 .. 5 loop
      Text_A.Set_Colors (A, 2, '/', ' ');
   end loop;

   --  Out of bounds access
   if Text_A.Char (10, 10) /= ASCII.NUL then
      Ada.Text_IO.Put_Line ("NUL expected for out of bounds position");
   end if;

   GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => ' ',
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);

   Console_Screen.Print;
   Ada.Text_IO.New_Line;

   Text_A.Invert_All;
   Text_A.Set_Colors_All ('-', ' ');

   GESTE.Render_Window
     (Window           => Console_Screen.Screen_Rect,
      Background       => ' ',
      Buffer           => Console_Screen.Buffer,
      Push_Pixels      => Console_Screen.Push_Pixels'Unrestricted_Access,
      Set_Drawing_Area => Console_Screen.Set_Drawing_Area'Unrestricted_Access);

   Console_Screen.Print;
   Ada.Text_IO.New_Line;
end Simple_Text;
