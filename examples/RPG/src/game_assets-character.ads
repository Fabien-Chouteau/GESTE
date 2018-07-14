with GESTE;
with GESTE.Grid;
pragma Style_Checks (Off);
package Game_Assets.character is

   --  character
   Width       : constant := 2;
   Height      : constant := 4;
   Tile_Width  : constant := 16;
   Tile_Height : constant := 16;

   --  Down1
   package Down1 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 243, 244, 245, 246),
         ( 247, 248, 249, 250))      ;
   end Down1;

   --  Down2
   package Down2 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 251, 252, 253, 254),
         ( 255, 256, 257, 258))      ;
   end Down2;

   --  Down3
   package Down3 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 259, 260, 261, 262),
         ( 263, 264, 265, 266))      ;
   end Down3;

   --  Left1
   package Left1 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 267, 268, 269, 270),
         ( 271, 272, 273, 274))      ;
   end Left1;

   --  Left2
   package Left2 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 275, 276, 277, 278),
         ( 279, 280, 281, 282))      ;
   end Left2;

   --  Left3
   package Left3 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 283, 284, 285, 286),
         ( 287, 288, 289, 290))      ;
   end Left3;

   --  Right1
   package Right1 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 291, 292, 293, 294),
         ( 295, 296, 297, 298))      ;
   end Right1;

   --  Right2
   package Right2 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 299, 300, 301, 302),
         ( 303, 304, 305, 306))      ;
   end Right2;

   --  Right3
   package Right3 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 307, 308, 309, 310),
         ( 311, 312, 313, 314))      ;
   end Right3;

   --  Up1
   package Up1 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 315, 316, 317, 318),
         ( 319, 320, 321, 322))      ;
   end Up1;

   --  Up2
   package Up2 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 323, 324, 325, 326),
         ( 327, 328, 329, 330))      ;
   end Up2;

   --  Up3
   package Up3 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 331, 332, 333, 334),
         ( 335, 336, 337, 338))      ;
   end Up3;

end Game_Assets.character;
