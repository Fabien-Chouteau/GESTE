with GESTE;
with GESTE.Maths_Types;
with GESTE_Config;

pragma Style_Checks (Off);
package Game_Assets is


   Palette : aliased GESTE.Palette_Type := (
      0 =>  391,
      1 =>  59147,
      2 =>  22089,
      3 =>  58727,
      4 =>  52303,
      5 =>  4907,
      6 =>  41834,
      7 =>  39694,
      8 =>  16847,
      9 =>  35372,
      10 =>  17208,
      11 =>  14856,
      12 =>  21228,
      13 =>  29681,
      14 =>  63423,
      15 =>  42326,
      16 =>  57613,
      17 =>  11414,
      18 =>  65535,
      19 =>  46486,
      20 =>  0);

   type Object_Kind is (Rectangle_Obj, Point_Obj,
     Ellipse_Obj, Polygon_Obj, Tile_Obj, Text_Obj);

   type String_Access is access all String;

   type Object
     (Kind : Object_Kind := Rectangle_Obj)
   is record
      Name    : String_Access;
      Id      : Natural;
      X       : GESTE.Maths_Types.Value;
      Y       : GESTE.Maths_Types.Value;
      Width   : GESTE.Maths_Types.Value;
      Height  : GESTE.Maths_Types.Value;
      Str     : String_Access;
      Tile_Id : GESTE_Config.Tile_Index;
   end record;

   type Object_Array is array (Natural range <>)
      of Object;

end Game_Assets;
