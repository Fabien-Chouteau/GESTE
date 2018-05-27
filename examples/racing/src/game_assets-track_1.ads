with GESTE;
with GESTE.Grid;
pragma Style_Checks (Off);
package Game_Assets.track_1 is

   --  track_1
   Width       : constant := 20;
   Height      : constant := 15;
   Tile_Width  : constant := 16;
   Tile_Height : constant := 16;

   --  Background
   package Background is
      Width  : constant :=  20;
      Height : constant :=  20;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94),
         ( 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94, 94))      ;
   end Background;

   --  Track
   package Track is
      Width  : constant :=  20;
      Height : constant :=  20;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 8, 26, 21, 21, 21, 21, 21, 69, 21, 21, 21, 21, 21, 44, 62),
         ( 9, 27, 49, 22, 22, 22, 22, 70, 22, 22, 22, 72, 31, 45, 63),
         ( 4, 40, 50, 68, 23, 79, 79, 79, 79, 79, 23, 14, 32, 4, 40),
         ( 4, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 40),
         ( 4, 40, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 40),
         ( 4, 40, 0, 8, 26, 21, 21, 21, 21, 21, 21, 21, 21, 46, 64),
         ( 4, 40, 0, 9, 27, 23, 23, 23, 23, 23, 23, 23, 23, 47, 65),
         ( 4, 40, 0, 10, 28, 48, 66, 0, 0, 0, 0, 0, 0, 0, 0),
         ( 4, 40, 0, 11, 29, 49, 67, 44, 62, 0, 0, 6, 21, 21, 24),
         ( 17, 35, 53, 0, 0, 50, 68, 45, 63, 0, 0, 4, 27, 45, 40),
         ( 18, 36, 54, 0, 0, 8, 26, 46, 64, 0, 0, 4, 40, 4, 40),
         ( 0, 17, 35, 53, 0, 9, 27, 47, 65, 0, 0, 4, 40, 4, 40),
         ( 0, 18, 36, 54, 0, 10, 28, 21, 21, 48, 66, 4, 40, 4, 40),
         ( 0, 0, 17, 35, 53, 11, 29, 23, 23, 49, 67, 46, 64, 4, 40),
         ( 0, 0, 18, 36, 54, 0, 0, 0, 0, 50, 68, 47, 65, 4, 40),
         ( 0, 0, 0, 4, 40, 0, 0, 12, 30, 48, 66, 0, 0, 4, 40),
         ( 0, 0, 0, 4, 40, 12, 30, 13, 31, 49, 67, 48, 66, 4, 40),
         ( 0, 0, 0, 10, 28, 13, 31, 14, 32, 50, 68, 49, 67, 46, 64),
         ( 0, 0, 0, 11, 29, 14, 32, 0, 0, 0, 0, 50, 68, 47, 65),
         ( 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))      ;
   end Track;

   package gates is
      Objects : Object_Array :=
        (
           0 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  1,
            Name => new String'("gate1"),
            X    =>  0.00000E+00,
            Y    =>  3.20000E+01,
            Width =>  3.20000E+01,
            Height =>  1.60000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           1 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  2,
            Name => new String'("gate2"),
            X    =>  3.20000E+01,
            Y    =>  0.00000E+00,
            Width =>  1.60000E+01,
            Height =>  3.20000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           2 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  3,
            Name => new String'("gate3"),
            X    =>  2.40000E+02,
            Y    =>  4.80000E+01,
            Width =>  1.60000E+01,
            Height =>  3.20000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           3 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  4,
            Name => new String'("gate4"),
            X    =>  2.40000E+02,
            Y    =>  1.44000E+02,
            Width =>  3.20000E+01,
            Height =>  1.60000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           4 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  5,
            Name => new String'("gate5"),
            X    =>  2.56000E+02,
            Y    =>  2.08000E+02,
            Width =>  1.60000E+01,
            Height =>  3.20000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           5 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  6,
            Name => new String'("gate6"),
            X    =>  1.44000E+02,
            Y    =>  2.08000E+02,
            Width =>  1.60000E+01,
            Height =>  3.20000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           6 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  7,
            Name => new String'("gate7"),
            X    =>  1.44000E+02,
            Y    =>  1.76000E+02,
            Width =>  1.60000E+01,
            Height =>  3.20000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           7 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  8,
            Name => new String'("gate8"),
            X    =>  2.08000E+02,
            Y    =>  1.60000E+02,
            Width =>  3.20000E+01,
            Height =>  1.60000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           8 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  10,
            Name => new String'("gate9"),
            X    =>  1.92000E+02,
            Y    =>  1.12000E+02,
            Width =>  3.20000E+01,
            Height =>  1.60000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           9 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  11,
            Name => new String'("gate10"),
            X    =>  1.44000E+02,
            Y    =>  1.12000E+02,
            Width =>  1.60000E+01,
            Height =>  3.20000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           10 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  12,
            Name => new String'("gate11"),
            X    =>  8.00000E+01,
            Y    =>  8.00000E+01,
            Width =>  3.20000E+01,
            Height =>  1.60000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           11 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  13,
            Name => new String'("gate12"),
            X    =>  6.40000E+01,
            Y    =>  2.08000E+02,
            Width =>  1.60000E+01,
            Height =>  3.20000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           12 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  14,
            Name => new String'("gate13"),
            X    =>  0.00000E+00,
            Y    =>  1.92000E+02,
            Width =>  3.20000E+01,
            Height =>  1.60000E+01,
            Tile_Id =>  0,
            Str => null
          ),
           13 => (
            Kind => RECTANGLE_OBJ,
            Id   =>  16,
            Name => new String'("gate14"),
            X    =>  0.00000E+00,
            Y    =>  1.12000E+02,
            Width =>  3.20000E+01,
            Height =>  1.60000E+01,
            Tile_Id =>  0,
            Str => null
          )
        );
   end gates;
   package Start is
      Objects : Object_Array :=
        (
           0 => (
            Kind => POINT_OBJ,
            Id   =>  17,
            Name => null,
            X    =>  1.60000E+01,
            Y    =>  1.44000E+02,
            Width =>  0.00000E+00,
            Height =>  0.00000E+00,
            Tile_Id =>  0,
            Str => null
          )
        );
   end Start;
   package AI is
      Objects : Object_Array :=
        (
           0 => (
            Kind => POLYGON_OBJ,
            Id   =>  18,
            Name => null,
            X    =>  7.33333E+00,
            Y    =>  9.60000E+01,
            Width =>  0.00000E+00,
            Height =>  0.00000E+00,
            Tile_Id =>  0,
            Str => null
          )
        );
   end AI;
end Game_Assets.track_1;
