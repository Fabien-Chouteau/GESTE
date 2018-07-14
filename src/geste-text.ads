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

with GESTE_Fonts;

package GESTE.Text is

   subtype Parent is Layer.Instance;

   type Instance (Da_Font           : not null GESTE_Fonts.Bitmap_Font_Ref;
                  Number_Of_Columns : Positive;
                  Number_Of_Lines   : Positive;
                  Foreground        : Output_Color;
                  Background        : Output_Color)
   is new Parent with private;

   subtype Class is Instance'Class;
   type Ref is access all Class;
   type Const_Ref is access constant Class;

   procedure Clear (This : in out Instance);
   --  Erase all text and set the cursor to (1, 1)

   procedure Cursor (This : in out Instance;
                     X, Y : Positive);

   procedure Put (This : in out Instance;
                  C    : Character);

   procedure Put (This : in out Instance;
                  Str  : String);

   function Char (This : in out Instance;
                  X, Y : Positive)
                  return Character;

   procedure Set_Colors (This       : in out Instance;
                         X, Y       : Positive;
                         Foreground : Output_Color;
                         Background : Output_Color);

   procedure Set_Colors_All (This       : in out Instance;
                             Foreground : Output_Color;
                             Background : Output_Color);

   procedure Invert (This     : in out Instance;
                     X, Y     : Positive;
                     Inverted : Boolean := True);

   procedure Invert_All (This     : in out Instance;
                         Inverted : Boolean := True);

private

   type Char_Property is record
      C        : Character;
      Inverted : Boolean;
      FG       : Output_Color;
      BG       : Output_Color;
   end record;

   type Char_Matrix is array (Positive range <>, Positive range <>)
     of Char_Property;

   type Instance (Da_Font           : not null GESTE_Fonts.Bitmap_Font_Ref;
                   Number_Of_Columns : Positive;
                   Number_Of_Lines   : Positive;
                   Foreground        : Output_Color;
                   Background        : Output_Color)
   is new Parent with record
      Matrix : Char_Matrix (1 .. Number_Of_Columns, 1 .. Number_Of_Lines) :=
        (others => (others => (' ', False, Foreground, Background)));

      CX : Positive := 1;
      CY : Positive := 1;
   end record;

   function Text_Bitmap_Set (This     : Instance;
                             X, Y     : Integer;
                             C        : out Char_Property)
                             return Boolean;

   overriding
   procedure Update_Size (This : in out Instance);

   overriding
   function Pix (This : Instance; X, Y : Integer) return Output_Color
     with Pre => X in 0 .. This.Width - 1 and then Y in 0 .. This.Height - 1;

   overriding
   function Collides (This : Instance; X, Y : Integer) return Boolean;


end GESTE.Text;
