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

generic
   type Output_Color is (<>);

   type Color_Index is (<>);

   type Tile_Index is (<>);

   Transparent  : Output_Color;

   No_Tile : Tile_Index;

   Tile_Size : Natural;

package GESTE is

   subtype Coordinate is Integer;
   subtype Lenght is Natural;

   type Point is record
      X, Y : Integer;
   end record;

   type Rect is record
      TL : Point; -- Top Left
      BR : Point; -- Bottom right
   end record;

   -- Palette --

   type Palette_Type is array (Color_Index) of Output_Color;
   type Palette_Ref is access constant Palette_Type;
   No_Palette : constant Palette_Ref := null;

   -- Tile --

   type Tile is array (0 .. Tile_Size - 1,
                       0 .. Tile_Size - 1)
     of Color_Index;

   type Tile_Array is array (Tile_Index range <>) of Tile;
   type Tile_Array_Ref is access constant Tile_Array;

   type Tile_Collisions is array (0 .. Tile_Size - 1,
                                  0 .. Tile_Size - 1)
     of Boolean;

   type Tile_Collisions_Array is array (Tile_Index range <>)
     of Tile_Collisions;

   type Tile_Collisions_Array_Ref is access constant Tile_Collisions_Array;
   No_Collisions : constant Tile_Collisions_Array_Ref := null;

   type Grid_Data is array (Natural range <>,
                            Natural range <>)
     of Tile_Index;
   type Grid_Data_Ref is access constant Grid_Data;

   -- Tile_Bank --

   type Tile_Bank_Type (Tiles      : not null Tile_Array_Ref;
                        Collisions :          Tile_Collisions_Array_Ref;
                        Palette    :          Palette_Ref)
   is tagged limited private;

   package Tile_Bank is
      subtype Instance is Tile_Bank_Type;
      subtype Class is Instance'Class;
      type Ref is access all Class;
      type Const_Ref is access constant Class;
   end Tile_Bank;

   -- Layer --

   type Layer_Type is abstract tagged limited private;

   function Position (This : Layer_Type) return Point;
   function Width (This : Layer_Type) return Natural;
   function Height (This : Layer_Type) return Natural;

   procedure Move (This : in out Layer_Type;
                   Pt   : Point);

   procedure Enable_Collisions (This   : in out Layer_Type;
                                Enable : Boolean := True);

   package Layer is
      subtype Instance is Layer_Type;
      subtype Class is Instance'Class;
      type Ref is access all Class;
      type Const_Ref is access constant Class;
   end Layer;

   -- Grid --

   type Grid_Type (Data : not null Grid_Data_Ref;
                   Bank : not null Tile_Bank.Const_Ref)
   is new Layer_Type with private;


   package Grid is
      subtype Instance is Grid_Type;
      subtype Class is Instance'Class;
      type Ref is access all Class;
      type Const_Ref is access constant Class;
   end Grid;

   -- Sprite --

   type Sprite_Type (Bank       : not null Tile_Bank.Const_Ref;
                     Init_Frame : Tile_Index)
   is new Layer_Type with private;

   procedure Set_Tile (This        : in out Sprite_Type;
                       Tile        : Tile_Index;
                       Orientation : Integer);

   package Sprite is
      subtype Instance is Sprite_Type;
      subtype Class is Instance'Class;
      type Ref is access all Class;
      type Const_Ref is access constant Class;
   end Sprite;

   -- Text --

   type Text_Type (Da_Font           : not null GESTE_Fonts.Bitmap_Font_Ref;
                   Number_Of_Columns : Positive;
                   Number_Of_Lines   : Positive;
                   Foreground        : Output_Color;
                   Background        : Output_Color)
   is new Layer_Type with private;

   procedure Clear (This : in out Text_Type);
   --  Erase all text and set the cursor to (1, 1)

   procedure Cursor (This : in out Text_Type;
                     X, Y : Positive);

   procedure Put (This : in out Text_Type;
                  C    : Character);

   procedure Put (This : in out Text_Type;
                  Str  : String);

   function Char (This : in out Text_Type;
                  X, Y : Positive)
                  return Character;

   procedure Set_Colors (This       : in out Text_Type;
                         X, Y       : Positive;
                         Foreground : Output_Color;
                         Background : Output_Color);

   procedure Set_Colors_All (This       : in out Text_Type;
                             Foreground : Output_Color;
                             Background : Output_Color);

   procedure Invert (This     : in out Text_Type;
                     X, Y     : Positive;
                     Inverted : Boolean := True);

   procedure Invert_All (This     : in out Text_Type;
                         Inverted : Boolean := True);

   package Text is
      subtype Instance is Text_Type;
      subtype Class is Instance'Class;
      type Ref is access all Class;
      type Const_Ref is access constant Class;
   end Text;

   -- Engine --

   procedure Add (L : not null Layer.Ref);

   subtype Output_Buffer_Index is Natural;

   type Output_Buffer is array (Output_Buffer_Index range <>) of Output_Color;

   type Push_Pixels_Proc is
     access procedure (Buffer : Output_Buffer);

   type Set_Drawing_Area_Proc is access procedure (Area : Rect);

   procedure Render_Window (Window           : Rect;
                            Background       : Output_Color;
                            Buffer           : in out Output_Buffer;
                            Push_Pixels      : Push_Pixels_Proc;
                            Set_Drawing_Area : Set_Drawing_Area_Proc);

   procedure Render_All (Screen_Rect      : Rect;
                         Background       : Output_Color;
                         Buffer           : in out Output_Buffer;
                         Push_Pixels      : Push_Pixels_Proc;
                         Set_Drawing_Area : Set_Drawing_Area_Proc);

   procedure Render_Dirty (Screen_Rect      : Rect;
                           Background       : Output_Color;
                           Buffer           : in out Output_Buffer;
                           Push_Pixels      : Push_Pixels_Proc;
                           Set_Drawing_Area : Set_Drawing_Area_Proc);

   -- Collisions --

   function Collides (Pt : Point) return Boolean;

private

   -- Tile_Bank --

   type Tile_Bank_Type (Tiles      : not null Tile_Array_Ref;
                        Collisions :          Tile_Collisions_Array_Ref;
                        Palette     :         Palette_Ref)
   is tagged limited null record;

   -- Layer --

   type Layer_Type is abstract tagged limited record
      Pt                  : Point := (0, 0);
      Next                : Layer.Ref := null;
      Dirty               : Boolean := True;
      Last_Pt             : Point := (0, 0);
      Collissions_Enabled : Boolean := False;
   end record;

   function Pix (This : Layer_Type; X, Y : Integer) return Output_Color
   is (Transparent);

   function Collides (This : Layer_Type; X, Y : Integer) return Boolean
   is (False);

   -- Grid --

   type Grid_Map is array (Natural range <>, Natural range <>) of Tile_Index;
   type Grid_Orientation is array (Natural range <>, Natural range <>) of Integer;

   type Grid_Access is access all Grid_Type;

   type Grid_Type (Data : not null Grid_Data_Ref;
                   Bank : not null Tile_Bank.Const_Ref)
   is new Layer_Type with null record;

   overriding
   function Width (This : Grid_Type) return Natural;

   overriding
   function Height (This : Grid_Type) return Natural;

   overriding
   function Pix (This : Grid_Type; X, Y : Integer) return Output_Color;

   overriding
   function Collides (This : Grid_Type; X, Y : Integer) return Boolean;

   -- Sprite --

   type Sprite_Access is access all Grid_Type;

   type Sprite_Type (Bank       : not null Tile_Bank.Const_Ref;
                     Init_Frame : Tile_Index)
   is new Layer_Type with record
      Tile        : Tile_Index := Init_Frame;
      Orientation : Integer := 0;
   end record;

   overriding
   function Width (This : Sprite_Type) return Natural
   is (Tile_Size);

   overriding
   function Height (This : Sprite_Type) return Natural
   is (Tile_Size);

   overriding
   function Pix (This : Sprite_Type; X, Y : Integer) return Output_Color;

   overriding
   function Collides (This : Sprite_Type; X, Y : Integer) return Boolean;

   -- Text --

   type Text_Access is access all Grid_Type;

   type Char_Property is record
      C        : Character;
      Inverted : Boolean;
      FG       : Output_Color;
      BG       : Output_Color;
   end record;

   type Char_Matrix is array (Positive range <>, Positive range <>)
     of Char_Property;

   type Text_Type (Da_Font           : not null GESTE_Fonts.Bitmap_Font_Ref;
                   Number_Of_Columns : Positive;
                   Number_Of_Lines   : Positive;
                   Foreground        : Output_Color;
                   Background        : Output_Color)
   is new Layer_Type with record
      Matrix : Char_Matrix (1 .. Number_Of_Columns, 1 .. Number_Of_Lines) :=
        (others => (others => (' ', False, Foreground, Background)));

      CX : Positive := 1;
      CY : Positive := 1;
   end record;

   overriding
   function Width (This : Text_Type) return Natural
   is (This.Number_Of_Columns * This.Da_Font.Glyph_Width);
   --  TODO: This is constant and could be computed once and for all

   overriding
   function Height (This : Text_Type) return Natural
   is (This.Number_Of_Lines * This.Da_Font.Glyph_Height);
   --  TODO: This is constant and could be computed once and for all

   overriding
   function Pix (This : Text_Type; X, Y : Integer) return Output_Color;

   overriding
   function Collides (This : Text_Type; X, Y : Integer) return Boolean;

   Layer_List : Layer.Ref := null;
end GESTE;
