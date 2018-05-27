------------------------------------------------------------------------------
--                                                                          --
--                                   GESTE                                  --
--                                                                          --
--                    Copyright (C) 2018 Fabien Chouteau                    --
--                                                                          --
--                                                                          --
--  Redistribution and use in source and binary forms, with or without      --
--  modification, are permitted provided that the following conditions are  --
--  met:                                                                    --
--     1. Redistributions of source code must retain the above copyright    --
--        notice, this list of conditions and the following disclaimer.     --
--     2. Redistributions in binary form must reproduce the above copyright --
--        notice, this list of conditions and the following disclaimer in   --
--        the documentation and/or other materials provided with the        --
--        distribution.                                                     --
--     3. Neither the name of the copyright holder nor the names of its     --
--        contributors may be used to endorse or promote products derived   --
--        from this software without specific prior written permission.     --
--                                                                          --
--   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS    --
--   "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT      --
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR  --
--   A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT   --
--   HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, --
--   SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT       --
--   LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,  --
--   DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY  --
--   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT    --
--   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE  --
--   OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.   --
--                                                                          --
------------------------------------------------------------------------------

with Interfaces; use Interfaces;

with GESTE.Maths_Tables; use GESTE.Maths_Tables;

package body GESTE.Maths is

   ---------
   -- Sin --
   ---------

   function Sin
     (A : Angle_Value)
      return Dimensionless
   is
   begin
      return Sine_Table (Unsigned_32 (Integer (A * Sine_Alpha) mod (2**30)) and (Sine_Table_Size - 1));
   end Sin;

   ---------
   -- Cos --
   ---------

   function Cos
     (A : Angle_Value)
      return Dimensionless
   is
   begin
      return Cos_Table (Unsigned_32 (Integer (A * Cos_Alpha) mod (2**30)) and (Cos_Table_Size - 1));
   end Cos;

   ----------------
   -- To_Degrees --
   ----------------

   function To_Degrees (A : Angle_Value) return Dimensionless
   is (A * 360.0 / (Pi * 2.0));

   ---------
   -- To_ --
   ---------

   function To_Rad (A : Dimensionless) return Angle_Value
   is (Angle_Value (Angle_Value (A) * Angle_Value (Pi * 2.0)) / Angle_Value (360.0));

   ---------
   -- "-" --
   ---------

   function "-" (V : Vect) return Vect
   is (-V.X, -V.Y);

   ---------
   -- "*" --
   ---------

   function "*" (V : Vect; F : Force_Value) return Force_Vect
   is (V.X * F, V.Y * F);

   ---------
   -- "*" --
   ---------

   function "*" (F : Force_Value; V : Vect) return Force_Vect
   is (V.X * F, V.Y * F);

   ---------
   -- "*" --
   ---------

   function "*" (V : Force_Vect; F : Dimensionless) return Force_Vect
   is (V.X * F, V.Y * F);

   ---------
   -- "*" --
   ---------

   function "*" (F : Dimensionless; V : Force_Vect) return Force_Vect
   is (V.X * F, V.Y * F);

   ----------
   -- Sqrt --
   ----------

   function Sqrt (V : Dimensionless) return Dimensionless is
      A : Dimensionless;
   begin
      if V <= 0.0 then
         return -1.0;
      elsif V = 1.0 then
         return 1.0;
      end if;

      A := V / 2;

      for K in 1 .. Fractional_Bits loop
         if A = 0.0 then
            return 0.0;
         end if;
         A := (A + V / A) / 2.0;
      end loop;
      return A;
   end Sqrt;

   ---------------
   -- Magnitude --
   ---------------

   function Magnitude (V : Force_Vect) return Force_Value
   is (Sqrt (V.X * V.X + V.Y * V.Y));

   ---------------
   -- Magnitude --
   ---------------

   function Magnitude (V : Acceleration_Vect) return Acceleration_Value
   is (Sqrt (V.X * V.X + V.Y * V.Y));

   ---------------
   -- Magnitude --
   ---------------

   function Magnitude (V : Speed_Vect) return Speed_Value
   is (Sqrt (V.X * V.X + V.Y * V.Y));

end GESTE.Maths;
