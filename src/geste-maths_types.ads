------------------------------------------------------------------------------
--                                                                          --
--                                   GESTE                                  --
--                                                                          --
--                 Copyright (C) 2018-2019 Fabien Chouteau                  --
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

package GESTE.Maths_Types is

   Integer_Bits    : constant := 22;
   Fractional_Bits : constant := 10;

   pragma Compile_Time_Warning
     (Integer_Bits + Fractional_Bits /= 32,
      "Invalid number of bits in fixed-point definition");

   V_Delta : constant := 2.0**(-Fractional_Bits);
   V_Range : constant := 2.0**(Integer_Bits - 1);

   type Value is delta V_Delta range -V_Range .. V_Range - V_Delta
     with Size  => Integer_Bits + Fractional_Bits,
          Small => V_Delta;

   Pi  : constant Value  := 3.1415926535897932384626433;

   type Vect is record
      X, Y : Value;
   end record;

   subtype Point is Vect;

   Origin : constant Point := (0.0, 0.0);

   type Rectangle is record
      Org    : Point;
      Width  : Value;
      Height : Value;
   end record;

   type Circle is record
      Org    : Point;
      Radius : Value;
   end record;

   No_Force        : constant Vect := (0.0, 0.0);
   No_Speed        : constant Vect := (0.0, 0.0);
   No_Acceleration : constant Vect := (0.0, 0.0);

end GESTE.Maths_Types;
