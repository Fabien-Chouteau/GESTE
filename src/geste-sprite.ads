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

with GESTE.Tile_Bank;

package GESTE.Sprite is

   subtype Parent is Layer.Instance;
   type Instance (Bank       : not null Tile_Bank.Const_Ref;
                  Init_Frame : Tile_Index)
   is new Parent with private;

   subtype Class is Instance'Class;
   type Ref is access all Class;
   type Const_Ref is access constant Class;

   procedure Set_Tile (This : in out Instance;
                       Tile : Tile_Index);

   procedure Flip_Vertical (This : in out Instance;
                            Flip : Boolean := True);

   procedure Flip_Horizontal (This : in out Instance;
                              Flip : Boolean := True);

private

   type Instance (Bank       : not null Tile_Bank.Const_Ref;
                  Init_Frame : Tile_Index)
   is new Parent with record
      Tile   : Tile_Index := Init_Frame;
      V_Flip : Boolean := False;
      H_Flip : Boolean := False;
   end record;

   overriding
   procedure Update_Size (This : in out Instance);

   overriding
   function Pix (This : Instance; X, Y : Integer) return Output_Color
     with Pre => X in 0 .. This.Width - 1 and then Y in 0 .. This.Height - 1;

   overriding
   function Collides (This : Instance; X, Y : Integer) return Boolean;

end GESTE.Sprite;
