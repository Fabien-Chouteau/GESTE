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

package body GESTE.Sprite.Rotated is

   -----------
   -- Angle --
   -----------

   function Angle (This : Instance) return Value
   is (This.Angle);

   -----------
   -- Angle --
   -----------

   procedure Angle (This  : in out Instance;
                    Angle : Value)
   is
   begin
      if This.Angle /= Angle then
         This.Angle := Angle;
         This.Dirty := True;
      end if;
   end Angle;

   ---------------
   -- Translate --
   ---------------

   function Transform (This : Instance;
                       X, Y : in out Integer)
                       return Boolean
   is
      SX : constant Integer := X - Tile_Size / 2;
      SY : constant Integer := Y - Tile_Size / 2;
   begin
      X := Integer (Cos (-This.Angle) * SX + Sin (-This.Angle) * SY);
      Y := Integer (-Sin (-This.Angle) * SX + Cos (-This.Angle) * SY);

      X := X + Tile_Size / 2;
      Y := Y + Tile_Size / 2;

      if X not in 0 .. This.A_Width - 1
        or else
          Y not in 0 .. This.A_Height - 1
      then
         return False;
      end if;
      return True;
   end Transform;

   ---------
   -- Pix --
   ---------

   overriding
   function Pix (This : Instance; X, Y : Integer) return Output_Color
   is
      TX : Integer := X;
      TY : Integer := Y;
   begin
      if This.Transform (TX, TY) then
         return Parent (This).Pix (TX, TY);
      else
         return Transparent;
      end if;
   end Pix;

   --------------
   -- Collides --
   --------------

   overriding
   function Collides (This : Instance; X, Y : Integer) return Boolean
   is
      TX : Integer := X;
      TY : Integer := Y;
   begin
      if This.Transform (TX, TY) then
         return Parent (This).Collides (TX, TY);
      else
         return False;
      end if;
   end Collides;

end GESTE.Sprite.Rotated;
