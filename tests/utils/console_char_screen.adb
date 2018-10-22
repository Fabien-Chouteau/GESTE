package body Console_Char_Screen is

   Screen : array (0 .. Width - 1, 0 .. Height - 1) of Character
     := (others => (others => Init_Char));

   XS, XE, YS, YE : Natural := 0;
   X, Y : Natural := 0;

   Verbose_On : Boolean := False;

   -----------------
   -- Push_Pixels --
   -----------------

   procedure Push_Pixels (Buffer : GESTE.Output_Buffer) is
   begin
      for C of Buffer loop
         Screen (X, Y) := C;
         if X = XE then
            X := XS;
            if Y = YE then
               Y := YS;
            else
               Y := Y + 1;
            end if;
         else
            X := X + 1;
         end if;
      end loop;
   end Push_Pixels;

   ----------------------
   -- Set_Drawing_Area --
   ----------------------

   procedure Set_Drawing_Area (Area : GESTE.Pix_Rect) is
   begin
      XS := Area.TL.X;
      YS := Area.TL.Y;
      XE := Area.BR.X;
      YE := Area.BR.Y;

      XS := Integer'Max (0, XS);
      YS := Integer'Max (0, YS);

      XE := Integer'Min (Width - 1, XE);
      YE := Integer'Min (Height - 1, YE);

      X := XS;
      Y := YS;
      if Verbose_On then
         Put_Line ("New drawing area:");
         Put_Line ("X Start:" & XS'Img);
         Put_Line ("X End:" & XE'Img);
         Put_Line ("Y Start:" & YS'Img);
         Put_Line ("Y end:" & YE'Img);
      end if;
   end Set_Drawing_Area;

   -----------
   -- Print --
   -----------

   procedure Print is
   begin
      for Y in Screen'Range (2) loop
         for X in Screen'Range (1) loop
            Put (Screen (X, Y));
            if X /= Screen'Last (1) then
               Put (' ');
            else
               New_Line;
            end if;
         end loop;
      end loop;
   end Print;

   -------------
   -- Verbose --
   -------------

   procedure Verbose is
   begin
      Verbose_On := True;
   end Verbose;

   ----------------
   -- Set_Output --
   ----------------

   procedure Set_Output (Output : File_Type) is
   begin
      Ada.Text_IO.Set_Output (Output);
   end Set_Output;

   --------------------
   -- Test_Collision --
   --------------------

   procedure Test_Collision
     (X, Y     : Integer;
      Expected : Boolean)
   is
   begin
      if GESTE.Collides ((X, Y)) /= Expected then
         if Expected then
            Put_Line ("Collision expected at X:" & X'Img & " Y:" & Y'Img);
         else
            Put_Line ("Unexpected collision at X:" & X'Img & " Y:" & Y'Img);
         end if;
      else
         if Expected then
            Put_Line ("Collision decteted at X:" & X'Img & " Y:" & Y'Img);
         else
            Put_Line ("No collision at X:" & X'Img & " Y:" & Y'Img);
         end if;
      end if;
   end Test_Collision;

end Console_Char_Screen;
