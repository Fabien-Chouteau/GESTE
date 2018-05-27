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

package GESTE.Maths_Types is

   Integer_Bits    : constant := 22;
   Fractional_Bits : constant := 10;

   pragma Compile_Time_Warning
     (Integer_Bits + Fractional_Bits /= 32,
      "Invalid number of bits in fixed-point definition");

   V_Delta : constant := 2.0**(-Fractional_Bits);
   V_Range : constant := 2.0**(Integer_Bits - 1);

   type Value is delta V_Delta range -V_Range .. V_Range - V_Delta
     with Size  => Integer_Bits + Fractional_Bits,
          Small => V_Delta;

   type Dimensionless is new Value
     with
       Dimension_System =>
         ((Unit_Name => Meter,    Unit_Symbol => 'm',   Dim_Symbol => 'L'),
          (Unit_Name => Kilogram, Unit_Symbol => "kg",  Dim_Symbol => 'M'),
          (Unit_Name => Second,   Unit_Symbol => 's',   Dim_Symbol => 'T'),
          (Unit_Name => Ampere,   Unit_Symbol => 'A',   Dim_Symbol => 'I'),
          (Unit_Name => Kelvin,   Unit_Symbol => 'K',   Dim_Symbol => '@'),
          (Unit_Name => Mole,     Unit_Symbol => "mol", Dim_Symbol => 'N'),
          (Unit_Name => Candela,  Unit_Symbol => "cd",  Dim_Symbol => 'J'));

   subtype Length_Value is Dimensionless
     with
       Dimension => (Symbol => 'm',
                     Meter  => 1,
                     others => 0);

   subtype Area_Value is Dimensionless
     with
       Dimension => (Meter  => 2,
                     others => 0);

   subtype Mass_Value is  Dimensionless
     with
       Dimension => (Symbol => "kg",
                     Kilogram => 1,
                     others   => 0);

   subtype Time_Value is Dimensionless
     with
       Dimension => (Symbol => 's',
                     Second => 1,
                     others => 0);

   subtype Speed_Value is Dimensionless
     with
       Dimension => (Meter  =>  1,
                     Second => -1,
                     others =>  0);

   subtype Acceleration_Value is Dimensionless
     with
       Dimension => (Meter  =>  1,
                     Second => -2,
                     others =>  0);

   subtype Force_Value is Dimensionless
     with
       Dimension => (Symbol => 'N',
                     Meter    => 1,
                     Kilogram => 1,
                     Second   => -2,
                     others   => 0);

   subtype Torque_Value is Dimensionless
     with
       Dimension => (Meter    => 2,
                     Kilogram => 1,
                     Second   => -2,
                     others   => 0);

   subtype Density_Value is Dimensionless
     with
       Dimension => (Meter    => 3,
                     Kilogram => 1,
                     others   => 0);

   subtype Angle_Value is Dimensionless
     with
      Dimension => (Symbol => "rad",
                    others => 0);

   pragma Warnings (Off, "*assumed to be*");

   m   : constant Length_Value := 1.0;
   kg  : constant Mass_Value   := 1.0;
   s   : constant Time_Value   := 1.0;
   N   : constant Force_Value  := 1.0;
   rad : constant Angle_Value  := 1.0;
   Pi  : constant Angle_Value  := 3.1415926535897932384626433;

   pragma Warnings (On, "*assumed to be*");

   type Position_Type is record
      X, Y : Length_Value;
   end record;

   Origin : constant Position_Type := (0.0 * m, 0.0 * m);

   type Vect is record
      X, Y : Dimensionless;
   end record;

   type Rectangle is record
      Org    : Position_Type;
      Width  : Length_Value;
      Height : Length_Value;
   end record;

   type Circle is record
      Org    : Position_Type;
      Radius : Length_Value;
   end record;

   type Force_Vect is record
      X, Y : Force_Value;
   end record;

   No_Force : constant Force_Vect := (0.0 * N, 0.0 * N);

   type Speed_Vect is record
      X, Y : Speed_Value;
   end record;

   No_Speed : constant Speed_Vect := (Speed_Value (0.0), Speed_Value (0.0));

   type Acceleration_Vect is record
      X, Y : Acceleration_Value;
   end record;

   No_Acceleration : constant Acceleration_Vect :=
     (Acceleration_Value (0.0),
      Acceleration_Value (0.0));

end GESTE.Maths_Types;
