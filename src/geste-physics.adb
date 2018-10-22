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

with GESTE.Maths; use GESTE.Maths;

package body GESTE.Physics is

   function Collide_Rect_Rect (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rectangle and then B.Box.Kind = Rectangle,
     Inline;

   function Collide_Rect_Borders (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rectangle and then B.Box.Kind = Rect_Borders,
     Inline;

   function Collide_Rect_Circle (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rectangle and then B.Box.Kind = Circle,
     Inline;

   function Collide_Rect_Line (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rectangle and then B.Box.Kind = Line,
     Inline;

   function Collide_Borders_Borders (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rect_Borders and then B.Box.Kind = Rect_Borders,
     Inline;

   function Collide_Borders_Circle (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rect_Borders and then B.Box.Kind = Circle,
     Inline;

   function Collide_Borders_Line (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Rect_Borders and then B.Box.Kind = Line,
     Inline;

   function Collide_Circle_Circle (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Circle and then B.Box.Kind = Circle,
     Inline;

   function Collide_Circle_Line (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Circle and then B.Box.Kind = Line,
     Inline;

   function Collide_Line_Line (A, B : Object'Class) return Boolean
     with Pre => A.Box.Kind = Line and then B.Box.Kind = Line,
     Inline;

   -----------------
   -- Set_Hit_Box --
   -----------------

   procedure Set_Hit_Box (This : in out Object; Box : Hit_Box_Type) is
   begin
      This.Box := Box;
   end Set_Hit_Box;

   -------------
   -- Hit_Box --
   -------------

   function Hit_Box (This : Object) return Hit_Box_Type
   is (This.Box);

   -----------------------
   -- Collide_Rect_Rect --
   -----------------------

   function Collide_Rect_Rect (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Rect_Rect;

   --------------------------
   -- Collide_Rect_Borders --
   --------------------------

   function Collide_Rect_Borders (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Rect_Borders;

   -------------------------
   -- Collide_Rect_Circle --
   -------------------------

   function Collide_Rect_Circle (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Rect_Circle;

   -----------------------
   -- Collide_Rect_Line --
   -----------------------

   function Collide_Rect_Line (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Rect_Line;

   -----------------------------
   -- Collide_Borders_Borders --
   -----------------------------

   function Collide_Borders_Borders (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Borders_Borders;

   ----------------------------
   -- Collide_Borders_Circle --
   ----------------------------

   function Collide_Borders_Circle (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Borders_Circle;

   --------------------------
   -- Collide_Borders_Line --
   --------------------------

   function Collide_Borders_Line (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Borders_Line;

   ---------------------------
   -- Collide_Circle_Circle --
   ---------------------------

   function Collide_Circle_Circle (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Circle_Circle;

   -------------------------
   -- Collide_Circle_Line --
   -------------------------

   function Collide_Circle_Line (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Circle_Line;

   -----------------------
   -- Collide_Line_Line --
   -----------------------

   function Collide_Line_Line (A, B : Object'Class) return Boolean
   is
      pragma Unreferenced (B, A);
   begin
      return False;
   end Collide_Line_Line;

   -------------
   -- Collide --
   -------------

   function Collide (This : Object; Obj : Object'Class) return Boolean is
   begin
      case This.Box.Kind is
         when None =>
            return False;
         when Rectangle =>
            case Obj.Box.Kind is
            when None =>
               return False;
            when Rectangle =>
               return Collide_Rect_Rect (This, Obj);
            when Rect_Borders =>
               return Collide_Rect_Borders (This, Obj);
            when Circle =>
               return Collide_Rect_Circle (This, Obj);
            when Line =>
               return Collide_Rect_Line (This, Obj);
            end case;
         when Rect_Borders =>
            case Obj.Box.Kind is
            when None =>
               return False;
            when Rectangle =>
               return Collide_Rect_Borders (Obj, This);
            when Rect_Borders =>
               return Collide_Borders_Borders (This, Obj);
            when Circle =>
               return Collide_Borders_Circle (This, Obj);
            when Line =>
               return Collide_Borders_Line (This, Obj);
            end case;
         when Circle =>
            case Obj.Box.Kind is
            when None =>
               return False;
            when Rectangle =>
               return Collide_Rect_Circle (Obj, This);
            when Rect_Borders =>
               return Collide_Borders_Circle (Obj, This);
            when Circle =>
               return Collide_Circle_Circle (This, Obj);
            when Line =>
               return Collide_Circle_Line (This, Obj);
            end case;
         when Line =>
            case Obj.Box.Kind is
            when None =>
               return False;
            when Rectangle =>
               return Collide_Rect_Line (Obj, This);
            when Rect_Borders =>
               return Collide_Borders_Line (Obj, This);
            when Circle =>
               return Collide_Circle_Line (Obj, This);
            when Line =>
               return Collide_Line_Line (This, Obj);
            end case;
      end case;
   end Collide;

   ----------
   -- Mass --
   ----------

   function Mass (This : Object) return Value
   is (This.M);

   --------------
   -- Set_Mass --
   --------------

   procedure Set_Mass (This : in out Object;
                       M    : Value)
   is
   begin
      This.M := M;
   end Set_Mass;

   --------------
   -- Position --
   --------------

   function Position (This : Object) return GESTE.Maths_Types.Point
   is (This.P);

   ------------------
   -- Set_Position --
   ------------------

   procedure Set_Position
     (This : in out Object;
      P    : GESTE.Maths_Types.Point)
   is
   begin
      This.P := P;
   end Set_Position;

   -----------
   -- Speed --
   -----------

   function Speed (This : Object) return Vect
   is (This.S);

   ---------------
   -- Set_Speed --
   ---------------

   procedure Set_Speed
     (This : in out Object;
      S    : Vect)
   is
   begin
      This.S := S;
   end Set_Speed;


   ------------------
   -- Acceleration --
   ------------------

   function Acceleration (This : Object) return Vect
   is (This.A);

   ----------------------
   -- Set_Acceleration --
   ----------------------

   procedure Set_Acceleration
     (This : in out Object;
      A    : Vect)
   is
   begin
      This.A := A;
   end Set_Acceleration;

   -----------
   -- Force --
   -----------

   function Force (This : Object) return Vect
   is (This.F);

   -----------------
   -- Apply_Force --
   -----------------

   procedure Apply_Force
     (This : in out Object;
      F    : Vect)
   is
   begin
      This.F.X := This.F.X + F.X;
      This.F.Y := This.F.Y + F.Y;
   end Apply_Force;

   -------------------
   -- Apply_Gravity --
   -------------------

   procedure Apply_Gravity (This : in out Object;
                            G    : Value := 9.51)
   is
   begin
      This.Apply_Force ((0.0, -G * This.Mass));
   end Apply_Gravity;

   -----------
   -- Angle --
   -----------

   function Angle (This : Object) return Value
   is (This.Angle);

   ---------------
   -- Set_Angle --
   ---------------

   procedure Set_Angle (This  : in out Object;
                        Angle : Value)
   is
   begin
      This.Angle := Angle;
   end Set_Angle;

   ---------------
   -- Direction --
   ---------------

   function Direction (This : Object) return Vect is
   begin
      return (Sin (This.Angle), Cos (This.Angle));
   end Direction;

   ----------
   -- Step --
   ----------

   procedure Step
     (This    : in out Object;
      Elapsed : Value)
   is
   begin
      This.A.X := This.F.X / This.M;
      This.A.Y := This.F.Y / This.M;
      This.F := No_Force;

      This.S.X := This.S.X + This.A.X * Elapsed;
      This.S.Y := This.S.Y + This.A.Y * Elapsed;

      This.P.X := This.P.X + This.S.X * Elapsed;
      This.P.Y := This.P.Y + This.S.Y * Elapsed;
   end Step;

end GESTE.Physics;
