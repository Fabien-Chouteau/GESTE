package GESTE_Config is

   subtype Output_Color is Character;

   type Color_Index is range 1 .. 4;

   subtype Tile_Index is Natural;

   No_Tile : constant Tile_Index := 0;

   Transparent : Constant Output_Color := 'T';

   Tile_Size : constant := 5;

end GESTE_Config;
