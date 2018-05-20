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

package GESTE.Physics is

   type Hit_Box_Kind is (None, Rectangle, Rect_Borders, Circle, Line);

   type Hit_Box_Type (Kind : Hit_Box_Kind := Rectangle) is record
      case Kind is
         when None =>
            null;
         when Rectangle | Rect_Borders =>
            Width  : Length_Value;
            Height : Length_Value;
         when Circle =>
            Radius : Length_Value;
         when Line =>
            End_X_Offset : Length_Value;
            End_Y_Offset : Length_Value;
      end case;
   end record;

   type Object is tagged limited private;

   procedure Set_Hit_Box (This : in out Object; Box : Hit_Box_Type);
   function Hit_Box (This : Object) return Hit_Box_Type;

   function Collide (This : Object; Obj : Object'Class) return Boolean;

   function Mass (This : Object) return Mass_Value;
   procedure Set_Mass (This : in out Object;
                       M    : Mass_Value);

   function Position (This : Object) return Position_Type;
   procedure Set_Position (This : in out Object;
                           P    : Position_Type);

   function Speed (This : Object) return Speed_Vect;
   procedure Set_Speed (This : in out Object;
                        S    : Speed_Vect);

   function Acceleration (This : Object) return Acceleration_Vect;
   procedure Set_Acceleration (This : in out Object;
                               A    : Acceleration_Vect);

   function Force (This : Object) return Force_Vect;
   procedure Apply_Force (This : in out Object;
                          F    : Force_Vect);

   procedure Apply_Gravity (This : in out Object;
                            G    : Force_Value := 9.51 * N);

   procedure Step (This    : in out Object;
                   Elapsed : Time_Value);

private

   type Object is tagged limited record
      Box : Hit_Box_Type := (Kind => None);
      P   : Position_Type := Origin;
      M   : Mass_Value := Mass_Value (0.0);
      S   : Speed_Vect := No_Speed;
      A   : Acceleration_Vect := No_Acceleration;
      F   : Force_Vect := No_Force;
   end record;

end GESTE.Physics;
