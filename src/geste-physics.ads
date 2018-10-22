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

   type Object is tagged limited private;

   procedure Step (This    : in out Object;
                   Elapsed : Value);
   --  Compute the new state (acceleration, speed, position) of the object given
   --  the time elapsed since last call to Step.

   function Mass (This : Object) return Value;
   --  Current mass of the object

   procedure Set_Mass (This : in out Object;
                       M    : Value);
   --  Set the mass of the object

   function Position (This : Object) return GESTE.Maths_Types.Point;
   --  Current position of the object

   procedure Set_Position (This : in out Object;
                           P    : GESTE.Maths_Types.Point);
   --  Set the position of the object. This is recomended only for initilization
   --  (or teleportation :). During normal operation the position should be
   --  computed from the speed in the Step procedure.

   function Angle (This : Object) return Value;
   --  Current angle of the object

   procedure Set_Angle (This  : in out Object;
                        Angle : Value);
   --  Set the angle of the object

   function Direction (This : Object) return Vect;
   --  Return a normalized vector of where the object is pointing. This vector
   --  is computed from the Angle of the object.

   function Speed (This : Object) return Vect;
   --  Current speed vecto of the object

   procedure Set_Speed (This : in out Object;
                        S    : Vect);
   --  Set the speed of the object. This is recomended only for initilization.
   --  During normal operation the speed should be computed from the
   --  acceleration in the Step procedure.

   function Acceleration (This : Object) return Vect;
   --  Current acceleration vector of the object

   procedure Set_Acceleration (This : in out Object;
                               A    : Vect);
   --  Set the acceleration of the object. This is recomended only for
   --  initilization. During normal operation the acceleration should
   --  be computed from the forces in the Step procedure.

   function Force (This : Object) return Vect;
   --  Sum of the current forces applied to the object. This is cleared during a
   --  during call to Step.

   procedure Apply_Force (This : in out Object;
                          F    : Vect);
   --  Apply a force vector to the object

   procedure Apply_Gravity (This : in out Object;
                            G    : Value := 9.51);
   --  Gravity helper procedure. Applies a G * Mass downwards force vector

private

   type Hit_Box_Kind is (None, Rectangle, Rect_Borders, Circle, Line);

   type Hit_Box_Type (Kind : Hit_Box_Kind := Rectangle) is record
      case Kind is
         when None =>
            null;
         when Rectangle | Rect_Borders =>
            Width  : Value;
            Height : Value;
         when Circle =>
            Radius : Value;
         when Line =>
            End_X_Offset : Value;
            End_Y_Offset : Value;
      end case;
   end record;

   procedure Set_Hit_Box (This : in out Object; Box : Hit_Box_Type);
   function Hit_Box (This : Object) return Hit_Box_Type;

   function Collide (This : Object; Obj : Object'Class) return Boolean;
   --  Return True of two objects colide with each other

   type Object is tagged limited record
      Box   : Hit_Box_Type := (Kind => None);
      P     : GESTE.Maths_Types.Point := Origin;
      M     : Value := 0.0;
      S     : Vect := No_Speed;
      A     : Vect := No_Acceleration;
      F     : Vect := No_Force;

      Angle : Value := 0.0;
   end record;

end GESTE.Physics;
