------------------------------------------------------------------------------
--                                                                          --
--                                   GESTE                                  --
--                                                                          --
--                    Copyright (C) 2019 Fabien Chouteau                    --
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

package GESTE.Sprite.Animated is

   type Frame_Counter is new Natural;

   type Animation_Step is record
      Tile      : GESTE_Config.Tile_Index;
      Frame_Cnt : Frame_Counter;
   end record;

   type Animation_Array is array (Natural range <>) of Animation_Step;
   type Animation is not null access constant Animation_Array;

   No_Animation_Array : aliased Animation_Array :=
     (1 .. 0 => (GESTE_Config.No_Tile,
                 Frame_Counter'Last));

   No_Animation : Animation := No_Animation_Array'Access;

   subtype Parent is Sprite.Instance;
   type Instance is new Parent with private;

   procedure Set_Animation
     (This    : in out Instance;
      Anim    :        Animation;
      Looping :        Boolean);

   function Anim_Done (This : Instance) return Boolean;
   --  Return True if there is no animation running

   procedure Signal_Frame (This : in out Instance);
   --  Signal to the animated sprite that a new frame is rendered

private

   type Instance is new Parent with record
      Anim         : Animation := No_Animation;
      Current_Step : Natural := No_Animation_Array'First;
      TTL          : Frame_Counter := Frame_Counter'Last;
      Looping      : Boolean := False;
   end record;

end GESTE.Sprite.Animated;
