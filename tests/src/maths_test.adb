with Ada.Text_IO;       use Ada.Text_IO;

with GESTE.Maths_Types; use GESTE.Maths_Types;
with GESTE.Maths;       use GESTE.Maths;

procedure Maths_Test is

   Sqrt_Values : array (Natural range <>) of Value :=
     (0.0, 1.0, 1.00001, 2.0, 4.0, 25.0, 80.0, 81.0, 100.0);

   Cos_Values : array (Natural range <>) of Value :=
     (0.0, Pi, Pi / 2.0, -Pi / 2.0, Pi / 3.0, Pi * 10.0);

   Sin_Values : array (Natural range <>) of Value :=
     (0.0, Pi, Pi / 2.0, -Pi / 2.0, Pi / 6.0, Pi * 10.0);

   To_Rad_Values : array (Natural range <>) of Value :=
     (0.0, 180.0, 360.0);

   To_Degrees_Values : array (Natural range <>) of Value :=
     (0.0, Pi, Pi * 2.0, Pi * 10.0);
begin
   Put_Line ("Value'First'Img => " & Value'First'Img);
   Put_Line ("Value'Last'Img => " & Value'Last'Img);
   Put_Line ("Value'Small'Img => " & Value'Small'Img);


   for X of Sqrt_Values loop
      Put_Line ("Sqrt (" & X'Img & ") => " & Sqrt (X)'Img);
   end loop;

   for X of Cos_Values loop
      Put_Line ("Cos (" & X'Img & ") => " & Cos (X)'Img);
   end loop;

   for X of Sin_Values loop
      Put_Line ("Sin (" & X'Img & ") => " & Sin (X)'Img);
   end loop;

   for X of To_Rad_Values loop
      Put_Line ("To_Rad (" & X'Img & ") => " & To_Rad (X)'Img);
   end loop;

   for X of To_Degrees_Values loop
      Put_Line ("To_Degrees (" & X'Img & ") => " & To_Degrees (X)'Img);
   end loop;

   Put_Line ("Magnitude (Vect (0.0, 5.0)) =>" &
               Magnitude (Vect'(0.0, 5.0))'Img);

   Put_Line ("Magnitude (Vect (5.0, 0.0)) =>" &
               Magnitude (Vect'(5.0, 0.0))'Img);

   Put_Line ("Magnitude (Vect (5.0, 5.0)) =>" &
               Magnitude (Vect'(5.0, 5.0))'Img);


end Maths_Test;
