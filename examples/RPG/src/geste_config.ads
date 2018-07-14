with Interfaces;

package GESTE_Config is

   type Color_Index is range  0 ..  138;

   subtype Output_Color is Interfaces.Unsigned_16;

   Transparent : constant Output_Color :=  0;

   Tile_Size : constant :=  16;

   type Tile_Index is range 0 .. 932;
   No_Tile : constant Tile_Index := 0;
end GESTE_Config;
