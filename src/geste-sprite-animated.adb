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

package body GESTE.Sprite.Animated is

   -------------------
   -- Set_Animation --
   -------------------

   procedure Set_Animation
     (This    : in out Instance;
      Anim    :        Animation;
      Looping :        Boolean)
   is
   begin
      if Anim'Length = 0 then
         This.Anim := No_Animation;
         This.TTL := Frame_Counter'Last;
         This.Set_Tile (This.Init_Frame);
      else
         This.Anim := Anim;
         This.Looping := Looping;
         This.Current_Step := This.Anim'First;
         This.TTL := This.Anim (This.Current_Step).Frame_Cnt - 1;
         This.Set_Tile (This.Anim (This.Current_Step).Tile);
      end if;
   end Set_Animation;

   ---------------
   -- Anim_Done --
   ---------------

   function Anim_Done (This : Instance) return Boolean
   is (This.Anim = No_Animation);

   ------------------
   -- Signal_Frame --
   ------------------

   procedure Signal_Frame (This : in out Instance) is
   begin

      --  Check if we are at the last frame for this step
      if This.TTL = 0 then

         --  Check if we are at the last step of the anim
         if This.Current_Step = This.Anim'Last then

            if This.Looping then
               --  Restart the anim
               This.Current_Step := This.Anim'First;

            else
               -- Stop the anim
               This.Set_Animation (No_Animation, False);
               return;
            end if;

         else
            --  Go to the next step
            This.Current_Step := This.Current_Step + 1;
         end if;

         This.TTL := This.Anim (This.Current_Step).Frame_Cnt - 1;
         This.Set_Tile (This.Anim (This.Current_Step).Tile);

      else
         This.TTL := This.TTL - 1;
      end if;
   end Signal_Frame;

end GESTE.Sprite.Animated;
