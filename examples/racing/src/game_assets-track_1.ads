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
  (( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106),
         ( 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106, 106))      ;
   end Background;

   --  Track
   package Track is
      Width  : constant :=  20;
      Height : constant :=  20;
      Data   : aliased GESTE.Grid.Grid_Data :=
  (( 107, 108, 109, 109, 109, 109, 109, 110, 109, 109, 109, 109, 109, 111, 112),
         ( 113, 114, 115, 116, 116, 116, 116, 117, 116, 116, 116, 118, 119, 120, 121),
         ( 122, 123, 124, 125, 126, 127, 127, 127, 127, 127, 126, 128, 129, 122, 123),
         ( 122, 123, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 122, 123),
         ( 122, 123, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 122, 123),
         ( 122, 123, 0, 107, 108, 109, 109, 109, 109, 109, 109, 109, 109, 130, 131),
         ( 122, 123, 0, 113, 114, 126, 126, 126, 126, 126, 126, 126, 126, 132, 133),
         ( 122, 123, 0, 134, 135, 136, 137, 0, 0, 0, 0, 0, 0, 0, 0),
         ( 122, 123, 0, 138, 139, 115, 140, 111, 112, 0, 0, 141, 109, 109, 142),
         ( 143, 144, 145, 0, 0, 124, 125, 120, 121, 0, 0, 122, 114, 120, 123),
         ( 146, 147, 148, 0, 0, 107, 108, 130, 131, 0, 0, 122, 123, 122, 123),
         ( 0, 143, 144, 145, 0, 113, 114, 132, 133, 0, 0, 122, 123, 122, 123),
         ( 0, 146, 147, 148, 0, 134, 135, 109, 109, 136, 137, 122, 123, 122, 123),
         ( 0, 0, 143, 144, 145, 138, 139, 126, 126, 115, 140, 130, 131, 122, 123),
         ( 0, 0, 146, 147, 148, 0, 0, 0, 0, 124, 125, 132, 133, 122, 123),
         ( 0, 0, 0, 122, 123, 0, 0, 149, 150, 136, 137, 0, 0, 122, 123),
         ( 0, 0, 0, 122, 123, 149, 150, 151, 119, 115, 140, 136, 137, 122, 123),
         ( 0, 0, 0, 134, 135, 151, 119, 128, 129, 124, 125, 115, 140, 130, 131),
         ( 0, 0, 0, 138, 139, 128, 129, 0, 0, 0, 0, 124, 125, 132, 133),
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
      gate1 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  1,
        Name => new String'("gate1"),
        X    =>  0.00000E+00,
        Y    =>  3.20000E+01,
        Width =>  3.20000E+01,
        Height =>  1.60000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate2 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  2,
        Name => new String'("gate2"),
        X    =>  3.20000E+01,
        Y    =>  0.00000E+00,
        Width =>  1.60000E+01,
        Height =>  3.20000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate3 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  3,
        Name => new String'("gate3"),
        X    =>  2.40000E+02,
        Y    =>  4.80000E+01,
        Width =>  1.60000E+01,
        Height =>  3.20000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate4 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  4,
        Name => new String'("gate4"),
        X    =>  2.40000E+02,
        Y    =>  1.44000E+02,
        Width =>  3.20000E+01,
        Height =>  1.60000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate5 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  5,
        Name => new String'("gate5"),
        X    =>  2.56000E+02,
        Y    =>  2.08000E+02,
        Width =>  1.60000E+01,
        Height =>  3.20000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate6 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  6,
        Name => new String'("gate6"),
        X    =>  1.44000E+02,
        Y    =>  2.08000E+02,
        Width =>  1.60000E+01,
        Height =>  3.20000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate7 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  7,
        Name => new String'("gate7"),
        X    =>  1.44000E+02,
        Y    =>  1.76000E+02,
        Width =>  1.60000E+01,
        Height =>  3.20000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate8 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  8,
        Name => new String'("gate8"),
        X    =>  2.08000E+02,
        Y    =>  1.60000E+02,
        Width =>  3.20000E+01,
        Height =>  1.60000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate9 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  10,
        Name => new String'("gate9"),
        X    =>  1.92000E+02,
        Y    =>  1.12000E+02,
        Width =>  3.20000E+01,
        Height =>  1.60000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate10 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  11,
        Name => new String'("gate10"),
        X    =>  1.44000E+02,
        Y    =>  1.12000E+02,
        Width =>  1.60000E+01,
        Height =>  3.20000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate11 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  12,
        Name => new String'("gate11"),
        X    =>  8.00000E+01,
        Y    =>  8.00000E+01,
        Width =>  3.20000E+01,
        Height =>  1.60000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate12 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  13,
        Name => new String'("gate12"),
        X    =>  6.40000E+01,
        Y    =>  2.08000E+02,
        Width =>  1.60000E+01,
        Height =>  3.20000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate13 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  14,
        Name => new String'("gate13"),
        X    =>  0.00000E+00,
        Y    =>  1.92000E+02,
        Width =>  3.20000E+01,
        Height =>  1.60000E+01,
        Tile_Id =>  0,
        Str => null
        );
      gate14 : aliased constant Object := (
        Kind => RECTANGLE_OBJ,
        Id   =>  16,
        Name => new String'("gate14"),
        X    =>  0.00000E+00,
        Y    =>  1.12000E+02,
        Width =>  3.20000E+01,
        Height =>  1.60000E+01,
        Tile_Id =>  0,
        Str => null
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
