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

with GESTE.Maths_Types; use GESTE.Maths_Types;

package GESTE.Maths is

   function Sin (A : Angle_Value) return Dimensionless
     with Post => Sin'Result in -1.0 .. 1.0;

   function Cos (A : Angle_Value) return Dimensionless
     with Post => Cos'Result in -1.0 .. 1.0;

   function To_Degrees (A : Angle_Value) return Dimensionless;

   function To_Rad (A : Dimensionless) return Angle_Value;

   function "-" (V : Vect) return Vect;
   function "*" (V : Vect; F : Force_Value) return Force_Vect;
   function "*" (F : Force_Value; V : Vect) return Force_Vect;

   function "*" (V : Force_Vect; F : Dimensionless) return Force_Vect;
   function "*" (F : Dimensionless; V : Force_Vect) return Force_Vect;

   function Sqrt (V : Dimensionless) return Dimensionless;

   function Magnitude (V : Force_Vect) return Force_Value;
   function Magnitude (V : Acceleration_Vect) return Acceleration_Value;
   function Magnitude (V : Speed_Vect) return Speed_Value;

end GESTE.Maths;
