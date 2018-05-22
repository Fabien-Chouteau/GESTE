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

package body GESTE.Grid is

   -----------------
   -- Update_Size --
   -----------------

   overriding
   procedure Update_Size (This : in out Instance) is
   begin
      This.A_Width := This.Data'Length (1) * Tile_Size;
      This.A_Height := This.Data'Length (2) * Tile_Size;
   end Update_Size;

   ---------
   -- Pix --
   ---------

   overriding
   function Pix (This : Instance;
                 X, Y : Integer)
                 return Output_Color
   is
      Tile_ID : Tile_Index;
      C       : Color_Index;
   begin
      Tile_ID := This.Data (This.Data'First (1) + (X / Tile_Size),
                            This.Data'First (2) + (Y / Tile_Size));

      if Tile_ID = No_Tile then
         return Transparent;
      else
         C := This.Bank.Tiles (Tile_ID) (X mod Tile_Size, Y mod Tile_Size);
         return This.Bank.Palette (C);
      end if;
   end Pix;

   --------------
   -- Collides --
   --------------

   overriding
   function Collides (This : Instance;
                      X, Y : Integer)
                      return Boolean
   is
      Tile_ID : Tile_Index;
   begin
      Tile_ID := This.Data (This.Data'First (1) + (X / Tile_Size),
                            This.Data'First (2) + (Y / Tile_Size));

      if Tile_ID = No_Tile or else This.Bank.Collisions = null then
         return False;
      else
         return This.Bank.Collisions (Tile_ID) (X mod Tile_Size,
                                                Y mod Tile_Size);
      end if;
   end Collides;

end GESTE.Grid;
