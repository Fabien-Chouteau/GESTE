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

with Interfaces; use Interfaces;

with GESTE.Maths_Types; use GESTE.Maths_Types;

package GESTE.Maths_Tables is

   Sine_Table_Size : constant := 256;
   Sine_Alpha      : constant := Dimensionless (Sine_Table_Size) / (2 * 3.14159);
   pragma Style_Checks (Off);
   Sine_Table : constant array (Unsigned_32 range 0 .. Sine_Table_Size - 1) of Dimensionless :=
    ( 0.000, 0.025, 0.049, 0.074, 0.098, 0.122,
      0.147, 0.171, 0.195, 0.219, 0.243, 0.267,
      0.290, 0.314, 0.337, 0.360, 0.383, 0.405,
      0.428, 0.450, 0.471, 0.493, 0.514, 0.535,
      0.556, 0.576, 0.596, 0.615, 0.634, 0.653,
      0.672, 0.690, 0.707, 0.724, 0.741, 0.757,
      0.773, 0.788, 0.803, 0.818, 0.831, 0.845,
      0.858, 0.870, 0.882, 0.893, 0.904, 0.914,
      0.924, 0.933, 0.942, 0.950, 0.957, 0.964,
      0.970, 0.976, 0.981, 0.985, 0.989, 0.992,
      0.995, 0.997, 0.999, 1.000, 1.000, 1.000,
      0.999, 0.997, 0.995, 0.992, 0.989, 0.985,
      0.981, 0.976, 0.970, 0.964, 0.957, 0.950,
      0.942, 0.933, 0.924, 0.914, 0.904, 0.893,
      0.882, 0.870, 0.858, 0.845, 0.831, 0.818,
      0.803, 0.788, 0.773, 0.757, 0.741, 0.724,
      0.707, 0.690, 0.672, 0.653, 0.634, 0.615,
      0.596, 0.576, 0.556, 0.535, 0.514, 0.493,
      0.471, 0.450, 0.428, 0.405, 0.383, 0.360,
      0.337, 0.314, 0.290, 0.267, 0.243, 0.219,
      0.195, 0.171, 0.147, 0.122, 0.098, 0.074,
      0.049, 0.025, 0.000,-0.025,-0.049,-0.074,
     -0.098,-0.122,-0.147,-0.171,-0.195,-0.219,
     -0.243,-0.267,-0.290,-0.314,-0.337,-0.360,
     -0.383,-0.405,-0.428,-0.450,-0.471,-0.493,
     -0.514,-0.535,-0.556,-0.576,-0.596,-0.615,
     -0.634,-0.653,-0.672,-0.690,-0.707,-0.724,
     -0.741,-0.757,-0.773,-0.788,-0.803,-0.818,
     -0.831,-0.845,-0.858,-0.870,-0.882,-0.893,
     -0.904,-0.914,-0.924,-0.933,-0.942,-0.950,
     -0.957,-0.964,-0.970,-0.976,-0.981,-0.985,
     -0.989,-0.992,-0.995,-0.997,-0.999,-1.000,
     -1.000,-1.000,-0.999,-0.997,-0.995,-0.992,
     -0.989,-0.985,-0.981,-0.976,-0.970,-0.964,
     -0.957,-0.950,-0.942,-0.933,-0.924,-0.914,
     -0.904,-0.893,-0.882,-0.870,-0.858,-0.845,
     -0.831,-0.818,-0.803,-0.788,-0.773,-0.757,
     -0.741,-0.724,-0.707,-0.690,-0.672,-0.653,
     -0.634,-0.615,-0.596,-0.576,-0.556,-0.535,
     -0.514,-0.493,-0.471,-0.450,-0.428,-0.405,
     -0.383,-0.360,-0.337,-0.314,-0.290,-0.267,
     -0.243,-0.219,-0.195,-0.171,-0.147,-0.122,
     -0.098,-0.074,-0.049,-0.025);
   pragma Style_Checks (On);


   Cos_Table_Size : constant := 256;
   Cos_Alpha      : constant := Dimensionless (Cos_Table_Size) / (2 * 3.14159);
   pragma Style_Checks (Off);
   Cos_Table : constant array (Unsigned_32 range 0 .. Cos_Table_Size - 1) of Dimensionless :=
    ( 1.000, 1.000, 0.999, 0.997, 0.995, 0.992,
      0.989, 0.985, 0.981, 0.976, 0.970, 0.964,
      0.957, 0.950, 0.942, 0.933, 0.924, 0.914,
      0.904, 0.893, 0.882, 0.870, 0.858, 0.845,
      0.831, 0.818, 0.803, 0.788, 0.773, 0.757,
      0.741, 0.724, 0.707, 0.690, 0.672, 0.653,
      0.634, 0.615, 0.596, 0.576, 0.556, 0.535,
      0.514, 0.493, 0.471, 0.450, 0.428, 0.405,
      0.383, 0.360, 0.337, 0.314, 0.290, 0.267,
      0.243, 0.219, 0.195, 0.171, 0.147, 0.122,
      0.098, 0.074, 0.049, 0.025, 0.000,-0.025,
     -0.049,-0.074,-0.098,-0.122,-0.147,-0.171,
     -0.195,-0.219,-0.243,-0.267,-0.290,-0.314,
     -0.337,-0.360,-0.383,-0.405,-0.428,-0.450,
     -0.471,-0.493,-0.514,-0.535,-0.556,-0.576,
     -0.596,-0.615,-0.634,-0.653,-0.672,-0.690,
     -0.707,-0.724,-0.741,-0.757,-0.773,-0.788,
     -0.803,-0.818,-0.831,-0.845,-0.858,-0.870,
     -0.882,-0.893,-0.904,-0.914,-0.924,-0.933,
     -0.942,-0.950,-0.957,-0.964,-0.970,-0.976,
     -0.981,-0.985,-0.989,-0.992,-0.995,-0.997,
     -0.999,-1.000,-1.000,-1.000,-0.999,-0.997,
     -0.995,-0.992,-0.989,-0.985,-0.981,-0.976,
     -0.970,-0.964,-0.957,-0.950,-0.942,-0.933,
     -0.924,-0.914,-0.904,-0.893,-0.882,-0.870,
     -0.858,-0.845,-0.831,-0.818,-0.803,-0.788,
     -0.773,-0.757,-0.741,-0.724,-0.707,-0.690,
     -0.672,-0.653,-0.634,-0.615,-0.596,-0.576,
     -0.556,-0.535,-0.514,-0.493,-0.471,-0.450,
     -0.428,-0.405,-0.383,-0.360,-0.337,-0.314,
     -0.290,-0.267,-0.243,-0.219,-0.195,-0.171,
     -0.147,-0.122,-0.098,-0.074,-0.049,-0.025,
     -0.000, 0.025, 0.049, 0.074, 0.098, 0.122,
      0.147, 0.171, 0.195, 0.219, 0.243, 0.267,
      0.290, 0.314, 0.337, 0.360, 0.383, 0.405,
      0.428, 0.450, 0.471, 0.493, 0.514, 0.535,
      0.556, 0.576, 0.596, 0.615, 0.634, 0.653,
      0.672, 0.690, 0.707, 0.724, 0.741, 0.757,
      0.773, 0.788, 0.803, 0.818, 0.831, 0.845,
      0.858, 0.870, 0.882, 0.893, 0.904, 0.914,
      0.924, 0.933, 0.942, 0.950, 0.957, 0.964,
      0.970, 0.976, 0.981, 0.985, 0.989, 0.992,
      0.995, 0.997, 0.999, 1.000);
   pragma Style_Checks (On);

end GESTE.Maths_Tables;
