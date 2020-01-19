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

with GESTE_Config; use GESTE_Config;

package GESTE is

   type Pix_Point is record
      X, Y : Integer;
   end record;

   type Pix_Rect is record
      TL : Pix_Point; -- Top Left
      BR : Pix_Point; -- Bottom right
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

   -- Collisions --

   type Tile_Collisions is array (0 .. Tile_Size - 1,
                                  0 .. Tile_Size - 1)
     of Boolean;

   type Tile_Collisions_Array is array (Tile_Index range <>)
     of Tile_Collisions;

   type Tile_Collisions_Array_Ref is access constant Tile_Collisions_Array;

   No_Collisions : constant Tile_Collisions_Array_Ref := null;

   -- Layer --

   type Layer_Type is abstract tagged limited private;

   function Position (This : Layer_Type) return Pix_Point;
   function Width (This : Layer_Type) return Natural;
   function Height (This : Layer_Type) return Natural;

   procedure Move (This : in out Layer_Type;
                   Pt   : Pix_Point);

   procedure Enable_Collisions (This   : in out Layer_Type;
                                Enable : Boolean := True);

   package Layer is
      subtype Instance is Layer_Type;
      subtype Class is Instance'Class;
      type Ref is access all Class;
      type Const_Ref is access constant Class;
   end Layer;

   -- Engine --

   type Layer_Priority is new Natural;

   procedure Add (L        : not null Layer.Ref;
                  Priority : Layer_Priority);

   procedure Remove (L : not null Layer.Ref);

   procedure Remove_All;

   subtype Output_Buffer_Index is Natural;

   type Output_Buffer is array (Output_Buffer_Index range <>) of Output_Color;

   type Push_Pixels_Proc is
     access procedure (Buffer : Output_Buffer);

   type Set_Drawing_Area_Proc is access procedure (Area : Pix_Rect);

   procedure Render_Window (Window           : Pix_Rect;
                            Background       : Output_Color;
                            Buffer           : in out Output_Buffer;
                            Push_Pixels      : Push_Pixels_Proc;
                            Set_Drawing_Area : Set_Drawing_Area_Proc);

   procedure Render_All (Screen_Rect      : Pix_Rect;
                         Background       : Output_Color;
                         Buffer           : in out Output_Buffer;
                         Push_Pixels      : Push_Pixels_Proc;
                         Set_Drawing_Area : Set_Drawing_Area_Proc);

   procedure Render_Dirty (Screen_Rect      : Pix_Rect;
                           Background       : Output_Color;
                           Buffer           : in out Output_Buffer;
                           Push_Pixels      : Push_Pixels_Proc;
                           Set_Drawing_Area : Set_Drawing_Area_Proc);

   -- Collisions --

   function Collides (Pt : Pix_Point) return Boolean;

private

   subtype Coordinate is Integer;
   subtype Lenght is Natural;

   -- Layer --

   type Layer_Type is abstract tagged limited record
      Next               : Layer.Ref      := null;
      Prev               : Layer.Ref      := null;
      Prio               : Layer_Priority := 0;

      Pt                 : Pix_Point := (0, 0);
      A_Width            : Natural := 0;
      A_Height           : Natural := 0;
      Dirty              : Boolean := True;
      Last_Pt            : Pix_Point := (0, 0);
      Collisions_Enabled : Boolean := False;
   end record;

   function Pix (This               : Layer_Type;
                 Unused_X, Unused_Y : Integer)
                 return Output_Color
   is (Transparent);

   function Collides (This               : Layer_Type;
                      Unused_X, Unused_Y : Integer)
                      return Boolean
   is (False);

   procedure Update_Size (This : in out Layer_Type)
   is null;

   Layer_List : Layer.Ref := null;
end GESTE;
