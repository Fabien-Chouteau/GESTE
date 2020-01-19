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

package body GESTE.Sprite is

   ----------
   -- Tile --
   ----------

   procedure Set_Tile (This : in out Instance;
                       Tile : Tile_Index)
   is
   begin
      if This.Tile /= Tile then
         This.Tile := Tile;
         This.Dirty := True;
      end if;
   end Set_Tile;

   -------------------
   -- Flip_Vertical --
   -------------------

   procedure Flip_Vertical (This : in out Instance;
                            Flip : Boolean := True)
   is
   begin
      if This.V_Flip /= Flip then
         This.V_Flip := Flip;
         This.Dirty := True;
      end if;
   end Flip_Vertical;

   ---------------------
   -- Flip_Horizontal --
   ---------------------

   procedure Flip_Horizontal (This : in out Instance;
                              Flip : Boolean := True)
   is
   begin
      if This.H_Flip /= Flip then
         This.H_Flip := Flip;
         This.Dirty := True;
      end if;
   end Flip_Horizontal;


   -----------------
   -- Update_Size --
   -----------------

   overriding
   procedure Update_Size (This : in out Instance) is
   begin
      This.A_Width := Tile_Size;
      This.A_Height := Tile_Size;
   end Update_Size;

   ---------
   -- Pix --
   ---------

   overriding
   function Pix (This : Instance;
                 X, Y : Integer)
                 return Output_Color
   is
      C  : Color_Index;
      PX : Integer := X;
      PY : Integer := Y;
   begin

      if This.H_Flip then
         PX := Tile_Size - PX - 1;
      end if;

      if This.V_Flip then
         PY := Tile_Size - PY - 1;
      end if;

      C := This.Bank.Tiles (This.Tile) (PX, PY);
      return This.Bank.Palette (C);
   end Pix;

   --------------
   -- Collides --
   --------------

   overriding
   function Collides (This : Instance;
                      X, Y : Integer)
                      return Boolean
   is
   begin
      if This.Bank.Collisions /= null then
         return This.Bank.Collisions (This.Tile) (X, Y);
      else
         return False;
      end if;
   end Collides;

end GESTE.Sprite;
