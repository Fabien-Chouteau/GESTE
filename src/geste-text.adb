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

with Interfaces; use Interfaces;

package body GESTE.Text is

   -----------
   -- Clear --
   -----------

   procedure Clear (This : in out Instance) is
   begin
      for C of This.Matrix loop
         C.C := ' ';
      end loop;
      This.CX := 1;
      This.CY := 1;
      This.Dirty := True;
   end Clear;

   ------------
   -- Cursor --
   ------------

   procedure Cursor (This : in out Instance;
                     X, Y : Positive)
   is
   begin
      if X <= This.Matrix'Last (1) and then Y <= This.Matrix'Last (2) then
         This.CX := X;
         This.CY := Y;
      end if;
   end Cursor;

   ---------
   -- Put --
   ---------

   procedure Put (This : in out Instance;
                  C    : Character)
   is
   begin
      This.Matrix (This.CX, This.CY).C := C;

      This.Dirty := True;

      if This.CX < This.Matrix'Last (1) and then C /= ASCII.LF then
         This.CX := This.CX + 1;
      else
         This.CX := This.Matrix'First (1);
         if This.CY < This.Matrix'Last (2) then
            This.CY := This.CY + 1;
         else
            This.CY := This.Matrix'First (2);
         end if;
      end if;
   end Put;

   ---------
   -- Put --
   ---------

   procedure Put (This : in out Instance;
                  Str  : String)
   is
   begin
      for C of Str loop
         This.Put (C);
      end loop;
   end Put;

   ----------
   -- Char --
   ----------

   function Char (This : in out Instance;
                  X, Y : Positive)
                  return Character
   is
   begin
      if X <= This.Matrix'Last (1)
        and then
         Y <= This.Matrix'Last (2)
      then
         return This.Matrix (X, Y).C;
      else
         return ASCII.NUL;
      end if;
   end Char;

   ----------------
   -- Set_Colors --
   ----------------

   procedure Set_Colors (This       : in out Instance;
                         X, Y       : Positive;
                         Foreground : Output_Color;
                         Background : Output_Color)
   is
   begin
      if X <= This.Matrix'Last (1)
        and then
         Y <= This.Matrix'Last (2)
      then
         This.Matrix (X, Y).FG := Foreground;
         This.Matrix (X, Y).BG := Background;
         This.Dirty := True;
      end if;
   end Set_Colors;

   --------------------
   -- Set_Colors_All --
   --------------------

   procedure Set_Colors_All (This       : in out Instance;
                             Foreground : Output_Color;
                             Background : Output_Color)
   is
   begin
      for C of This.Matrix loop
         C.FG := Foreground;
         C.BG := Background;
      end loop;
      This.Dirty := True;
   end Set_Colors_All;

   ------------
   -- Invert --
   ------------

   procedure Invert (This     : in out Instance;
                     X, Y     : Positive;
                     Inverted : Boolean := True)
   is
   begin
      if X <= This.Matrix'Last (1)
        and then
         Y <= This.Matrix'Last (2)
      then
         This.Matrix (X, Y).Inverted := Inverted;
         This.Dirty := True;
      end if;
   end Invert;

   ----------------
   -- Invert_All --
   ----------------

   procedure Invert_All (This     : in out Instance;
                         Inverted : Boolean := True)
   is
   begin
      for C of This.Matrix loop
         C.Inverted := Inverted;
         This.Dirty := True;
      end loop;
   end Invert_All;

   ---------------------
   -- Text_Bitmap_Set --
   ---------------------

   function Text_Bitmap_Set (This     : Instance;
                             X, Y     : Integer;
                             C        : out Char_Property)
                             return Boolean
   is
      GW : constant Positive := This.Da_Font.Glyph_Width;
      GH : constant Positive := This.Da_Font.Glyph_Height;

      CX, CY        : Positive;
      PX, PY        : Integer;
      Index         : Integer;
      Bit_Index     : Natural;
      Bitmap_Offset : Integer;
   begin
      CX := This.Matrix'First (1) + (X / GW);
      CY := This.Matrix'First (2) + (Y / GH);

      C := This.Matrix (CX, CY);

      if C.C in '!' .. '~' then
         Index := Character'Pos (C.C) - Character'Pos ('!');

         PX := X mod GW;
         PY := Y mod GH;

         Bit_Index := PX + PY * GW;

         Bitmap_Offset := This.Da_Font.Bytes_Per_Glyph * Index + Bit_Index / 8;

         Bit_Index := Bit_Index mod 8;

         if (Shift_Left (This.Da_Font.Data (Bitmap_Offset),
                         Bit_Index) and 16#80#) /= 0
         then
            return not C.Inverted;
         else
            return C.Inverted;
         end if;
      else
         return C.Inverted;
      end if;
   end Text_Bitmap_Set;

   -----------------
   -- Update_Size --
   -----------------

   overriding
   procedure Update_Size (This : in out Instance) is
   begin
      This.A_Width := This.Number_Of_Columns * This.Da_Font.Glyph_Width;
      This.A_Height := This.Number_Of_Lines * This.Da_Font.Glyph_Height;
   end Update_Size;

   ---------
   -- Pix --
   ---------

   overriding
   function Pix (This : Instance;
                 X, Y : Integer)
                 return Output_Color
   is
      C : Char_Property;

   begin
      if Text_Bitmap_Set (This, X, Y, C) then
         return C.FG;
      else
         return C.BG;
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
      C : Char_Property;
   begin
      return Text_Bitmap_Set (This, X, Y, C);
   end Collides;

end GESTE.Text;
