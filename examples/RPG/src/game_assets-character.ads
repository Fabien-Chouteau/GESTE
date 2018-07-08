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
  (( 961, 967, 973, 979),
         ( 962, 968, 974, 980))      ;
   end Down1;

   --  Down2
   package Down2 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 963, 969, 975, 981),
         ( 964, 970, 976, 982))      ;
   end Down2;

   --  Down3
   package Down3 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 965, 971, 977, 983),
         ( 966, 972, 978, 984))      ;
   end Down3;

   --  Left1
   package Left1 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 985, 991, 997, 1003),
         ( 986, 992, 998, 1004))      ;
   end Left1;

   --  Left2
   package Left2 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 987, 993, 999, 1005),
         ( 988, 994, 1000, 1006))      ;
   end Left2;

   --  Left3
   package Left3 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 989, 995, 1001, 1007),
         ( 990, 996, 1002, 1008))      ;
   end Left3;

   --  Right1
   package Right1 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 1009, 1015, 1021, 1027),
         ( 1010, 1016, 1022, 1028))      ;
   end Right1;

   --  Right2
   package Right2 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 1011, 1017, 1023, 1029),
         ( 1012, 1018, 1024, 1030))      ;
   end Right2;

   --  Right3
   package Right3 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 1013, 1019, 1025, 1031),
         ( 1014, 1020, 1026, 1032))      ;
   end Right3;

   --  Up1
   package Up1 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 1033, 1039, 1045, 1051),
         ( 1034, 1040, 1046, 1052))      ;
   end Up1;

   --  Up2
   package Up2 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 1035, 1041, 1047, 1053),
         ( 1036, 1042, 1048, 1054))      ;
   end Up2;

   --  Up3
   package Up3 is
      Width  : constant :=  2;
      Height : constant :=  2;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 1037, 1043, 1049, 1055),
         ( 1038, 1044, 1050, 1056))      ;
   end Up3;

end Game_Assets.character;
