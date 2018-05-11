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

package body GESTE is
   use Tile_Bank;
   use Layer;
   use Grid;
   use Sprite;

   function Max (A, B : Coordinate) return Coordinate
   is (Coordinate'Max (A, B))
   with Inline_Always;

   function Min (A, B : Coordinate) return Coordinate
   is (Coordinate'Min (A, B))
   with Inline_Always;

   --------------
   -- Position --
   --------------

   function Position (This : Layer_Type)
                     return Point
   is (This.Pt);

   ----------
   -- Move --
   ----------

   procedure Move (This : in out Layer_Type;
                   Pt   : Point)
   is
   begin
      if This.Pt /= Pt then
         This.Last_Pt := This.Pt;
         This.Pt := Pt;
         This.Dirty := True;
      end if;
   end Move;

   -----------
   -- Width --
   -----------

   function Width (This : Layer_Type) return Natural
   is (0);

   ------------
   -- Height --
   ------------

   function Height (This : Layer_Type) return Natural
   is (0);

   ---------------
   -- Set_Frame --
   ---------------

   procedure Set_Frame (This        : in out Sprite_Type;
                        Frame       : Tile_Index;
                        Orientation : Integer)
   is
   begin
      This.Frame := Frame;
      This.Orientation := Orientation;
   end Set_Frame;

   ---------
   -- Add --
   ---------

   procedure Add (L : not null Layer.Ref) is
   begin
      L.Next := Layer_List;
      Layer_List := L;
      L.Dirty := True;
   end Add;

   -------------------
   -- Render_Window --
   -------------------

   procedure Render_Window (Window           : Rect;
                            Background       : Output_Color;
                            Buffer           : in out  Output_Buffer;
                            Push_Pixels      : Push_Pixels_Proc;
                            Set_Drawing_Area : Set_Drawing_Area_Proc)
   is
      C     : Output_Color;
      Index : Output_Buffer_Index := Buffer'First;
      L     : Layer.Ref;
   begin
      --  For each pixel that we want to render, we look for the color of that
      --  pixel inside the first layer. If that color is not the Transparent
      --  color, we push it to the screen, otherwise we look in the next layer.
      --
      --  Here is a one dimension example using characters for the output
      --  'color'. The | (pipe) symbol shows how the layers are traversed.
      --
      --              ||||||||||||||||||||||||||||||||||||||||||||||||||
      --  Layer 1   : AAA|A|AAA|AA|AAA|AA||||AA|A|||||A||||||A|A|||||A|A
      --  Layer 2   :   BBBB   | BBB BBBBBB||  BBBBB|BB|BBB||BBB||||| BB
      --  Layer 3   : CCCCCCC  | CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC||||CCC
      --  Background: ##################################################
      --
      --  Output    : AAABABAAA#AABAAABAABBCCAABABBBCBACBBBCCABAC#####ABA

      Set_Drawing_Area (Window);

      for Y in Window.TL.Y .. Window.BR.Y loop
         for X in Window.TL.X .. Window.BR.X loop

            C := Transparent;

            L := Layer_List;
            Layer_Loop : while L /= null loop
               C := L.Pix (X, Y);
               if C /= Transparent then
                  exit Layer_Loop;
               end if;
               L := L.Next;
            end loop Layer_Loop;

            if C = Transparent then
               C := Background;
            end if;

            Buffer (Index) := C;
            if Index = Buffer'Last then
               Push_Pixels (Buffer);
               Index := Buffer'First;
            else
               Index := Index + 1;
            end if;
         end loop;
      end loop;

      --  Push the remaining pixels
      if Index /= Buffer'First then
         Push_Pixels (Buffer (Buffer'First .. Index - 1));
      end if;
   end Render_Window;

   ----------------
   -- Render_All --
   ----------------

   procedure Render_All (Screen_Rect      : Rect;
                         Background       : Output_Color;
                         Buffer           : in out Output_Buffer;
                         Push_Pixels      : Push_Pixels_Proc;
                         Set_Drawing_Area : Set_Drawing_Area_Proc)
   is
      L : Layer.Ref := Layer_List;

      Min_X : constant Coordinate := Screen_Rect.TL.X;
      Min_Y : constant Coordinate := Screen_Rect.TL.Y;
      Max_X : constant Coordinate := Screen_Rect.BR.X;
      Max_Y : constant Coordinate := Screen_Rect.BR.Y;

      X0 : Coordinate := Max_X;
      X1 : Coordinate := Min_X;
      Y0 : Coordinate := Max_Y;
      Y1 : Coordinate := Min_Y;
   begin

      --  Find the window that contains all the layers
      while L /= null loop
         X0 := Min (X0, L.Pt.X);
         Y0 := Min (Y0, L.Pt.Y);
         X1 := Max (X1, L.Pt.X + L.Width - 1);
         Y1 := Max (Y1, L.Pt.Y + L.Height - 1);

         L.Dirty := False;
         L := L.Next;
      end loop;

      if X1 >= X0 and then Y1 >= Y0 then
         Render_Window (((X0, Y0), (X1, Y1)),
                        Background,
                        Buffer,
                        Push_Pixels,
                        Set_Drawing_Area);
      end if;
   end Render_All;

   ------------------
   -- Render_Dirty --
   ------------------

   procedure Render_Dirty (Screen_Rect      : Rect;
                           Background       : Output_Color;
                           Buffer           : in out Output_Buffer;
                           Push_Pixels      : Push_Pixels_Proc;
                           Set_Drawing_Area : Set_Drawing_Area_Proc)
   is
      Min_X : Coordinate renames Screen_Rect.TL.X;
      Min_Y : Coordinate renames Screen_Rect.TL.Y;
      Max_X : Coordinate renames Screen_Rect.BR.X;
      Max_Y : Coordinate renames Screen_Rect.BR.Y;

      W, H : Lenght;
      L : Layer.Ref := Layer_List;
      X0, X1, Y0, Y1 : Integer;
   begin

      while L /= null loop
         if L.Dirty then

            --  Find the window that contains both the layer now and the layer
            --  at its previous location.
            W := L.Width;
            H := L.Height;
            X0 := Min (L.Last_Pt.X, L.Pt.X);
            Y0 := Min (L.Last_Pt.Y, L.Pt.Y);
            X1 := Max (L.Last_Pt.X + W, L.Pt.X + W - 1);
            Y1 := Max (L.Last_Pt.Y + H, L.Pt.Y + H - 1);

            --  Apply screen limits
            X0 := Max (Min_X, Min (Max_X, X0));
            Y0 := Max (Min_Y, Min (Max_Y, Y0));
            X1 := Max (Min_X, Min (Max_X, X1));
            Y1 := Max (Min_Y, Min (Max_Y, Y1));

            --  Update that window if it is not empty
            if X1 >= X0 and then Y1 >= Y0 then
               Render_Window (((X0, Y0), (X1, Y1)),
                              Background,
                              Buffer,
                              Push_Pixels,
                              Set_Drawing_Area);
            end if;

            L.Dirty := False;
         end if;
         L := L.Next;
      end loop;
   end Render_Dirty;

   -----------
   -- Width --
   -----------

   overriding
   function Width (This : Grid_Type) return Natural
   is (This.Data'Length (1) * Tile_Size);

   ------------
   -- Height --
   ------------

   overriding
   function Height (This : Grid_Type) return Natural
   is (This.Data'Length (2) * Tile_Size);

   ---------
   -- Pix --
   ---------

   overriding
   function Pix (This : Grid_Type;
                 X, Y : Integer)
                 return Output_Color
   is
      Pt      : Point;
      Tile_ID : Tile_Index;
      C       : Color_Index;
   begin
      Pt.X := X - This.Pt.X;
      Pt.Y := Y - This.Pt.Y;

      if Pt.X not in 0 .. (This.Data'Length (1) * Tile_Size) - 1
        or else
          Pt.Y not in 0 .. (This.Data'Length (2) * Tile_Size) - 1
      then
         return Transparent;
      end if;

      Tile_ID := This.Data (This.Data'First (1) + (Pt.X / Tile_Size),
                            This.Data'First (2) + (Pt.Y / Tile_Size));

      if Tile_ID = No_Tile then
         return Transparent;
      else
         C := This.Bank.Tiles (Tile_ID) (Pt.X mod Tile_Size, Pt.Y mod Tile_Size);
         return This.Bank.Palette (C);
      end if;
   end Pix;

   ---------
   -- Pix --
   ---------

   overriding
   function Pix (This : Sprite_Type;
                 X, Y : Integer)
                 return Output_Color
   is
      Pt : Point;
      C  : Color_Index;
   begin
      Pt.X := X - This.Pt.X;
      Pt.Y := Y - This.Pt.Y;

      if Pt.X not in 0 .. Tile_Size - 1
        or else
          Pt.Y not in 0 .. Tile_Size - 1
      then
         return Transparent;
      end if;

      C := This.Bank.Tiles (This.Frame) (Pt.X, Pt.Y);
      return This.Bank.Palette (C);
   end Pix;

   ------------
   -- Cursor --
   ------------

   procedure Cursor (This : in out Text_Type;
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

   procedure Put (This : in out Text_Type;
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

   procedure Put (This : in out Text_Type;
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

   function Char (This : in out Text_Type;
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

   procedure Set_Colors (This       : in out Text_Type;
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

   procedure Set_Colors_All (This       : in out Text_Type;
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

   procedure Invert (This     : in out Text_Type;
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

   procedure Invert_All (This     : in out Text_Type;
                         Inverted : Boolean := True)
   is
   begin
      for C of This.Matrix loop
         C.Inverted := Inverted;
         This.Dirty := True;
      end loop;
   end Invert_All;

   ---------
   -- Pix --
   ---------

   overriding
   function Pix (This : Text_Type;
                 X, Y : Integer)
                 return Output_Color
   is
      Pt : Point;
      CX, CY : Positive;
      PX, PY : Integer;
      C : Char_Property;

      Index : Integer;
      Bitmap_Offset : Integer;

      Bit_Index : Natural;

      GW : constant Positive := This.Da_Font.Glyph_Width;
      GH : constant Positive := This.Da_Font.Glyph_Height;

      function FG return Output_Color
      is (if C.Inverted then C.BG else C.FG);

      function BG return Output_Color
      is (if C.Inverted then C.FG else C.BG);
   begin
      Pt.X := X - This.Pt.X;
      Pt.Y := Y - This.Pt.Y;

      if Pt.X not in 0 .. This.Number_Of_Columns * GW - 1
        or else
          Pt.Y not in 0 .. This.Number_Of_Lines * GH - 1
      then
         return Transparent;
      end if;

      CX := This.Matrix'First (1) + (Pt.X / GW);
      CY := This.Matrix'First (2) + (Pt.Y / GH);

      C := This.Matrix (CX, CY);

      if C.C in '!' .. '~' then
         Index := Character'Pos (C.C) - Character'Pos ('!');

         PX := Pt.X mod GW;
         PY := Pt.Y mod GH;

         Bit_Index := PX + PY * GW;

         Bitmap_Offset := This.Da_Font.Bytes_Per_Glyph * Index + Bit_Index / 8;

         Bit_Index := Bit_Index mod 8;

         if (Shift_Left (This.Da_Font.Data (Bitmap_Offset),
                         Bit_Index) and 16#80#) /= 0
         then
            return FG;
         else
            return BG;
         end if;
      else
         return BG;
      end if;
   end Pix;

end GESTE;
