with Ada.Text_IO; use Ada.Text_IO;

with GESTE;

generic

   Width  : Natural;
   Height : Natural;

   Buffer_Size : Positive;

   Init_Char : Character;

   with package Engine is new GESTE (Output_Color => Character,
                                     others => <>);

package Console_Char_Screen is

   Screen_Rect : constant Engine.Rect := ((0, 0), (Width - 1, Height - 1));

   Buffer : Engine.Output_Buffer (1 .. Buffer_Size);

   procedure Push_Pixels (Buffer    : Engine.Output_Buffer);
   procedure Set_Drawing_Area (Area : Engine.Rect);

   procedure Print;

   procedure Verbose;
   procedure Set_Output (Output : File_Type);

   procedure Test_Collision (X, Y : Integer;
                             Expected : Boolean);

end Console_Char_Screen;
