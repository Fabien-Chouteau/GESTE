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

package body GESTE is
   use Layer;

   function Max (A, B : Coordinate) return Coordinate
   is (Coordinate'Max (A, B))
   with Inline_Always;

   function Min (A, B : Coordinate) return Coordinate
   is (Coordinate'Min (A, B))
   with Inline_Always;

   --------------
   -- Position --
   --------------

   function Position (This : Layer_Type)
                     return Pix_Point
   is (This.Pt);

   ----------
   -- Move --
   ----------

   procedure Move (This : in out Layer_Type;
                   Pt   : Pix_Point)
   is
   begin
      if This.Pt /= Pt then
         This.Last_Pt := This.Pt;
         This.Pt := Pt;
         This.Dirty := True;
      end if;
   end Move;

   -----------------------
   -- Enable_Collisions --
   -----------------------

   procedure Enable_Collisions (This   : in out Layer_Type;
                                Enable : Boolean := True)
   is
   begin
      This.Collisions_Enabled := Enable;
   end Enable_Collisions;

   -----------
   -- Width --
   -----------

   function Width (This : Layer_Type) return Natural
   is (This.A_Width);

   ------------
   -- Height --
   ------------

   function Height (This : Layer_Type) return Natural
   is (This.A_Height);

   ---------
   -- Add --
   ---------

   procedure Add (L        : not null Layer.Ref;
                  Priority : Layer_Priority) is
      Prev : Layer.Ref := null;
      Cur  : Layer.Ref := Layer_List;
   begin
      L.Prio := Priority;

      while Cur /= null and then Cur.Prio > Priority loop
         Prev := Cur;
         Cur := Cur.Next;
      end loop;

      if Prev = null then
         --  Head
         if Layer_List /= null then
            Layer_List.Prev := L;
         end if;

         L.Next := Layer_List;
         L.Prev := null;
         Layer_List := L;
      else
         if Cur = null then
            --  Tail
            Prev.Next := L;
            L.Prev := Prev;
            L.Next := null;
         else
            L.Prev := Prev;
            Prev.Next := L;

            L.Next := Cur;
            Cur.Prev := L;
         end if;
      end if;
      L.Dirty := True;
      L.Last_Pt := L.Pt;
      L.Update_Size;
   end Add;

   ------------
   -- Remove --
   ------------

   procedure Remove (L : not null Layer.Ref) is
   begin

      if L.Next /= null then
         L.Next.Prev := L.Prev;
      end if;

      if L.Prev /= null then
         L.Prev.Next := L.Next;
      else
         if Layer_List = L then
            Layer_List := L.Next;
         else
            raise Program_Error with "Layer not in the list";
         end if;
      end if;

      L.Next := null;
      L.Prev := null;

   end Remove;

   ----------------
   -- Remove_All --
   ----------------

   procedure Remove_All is
      L : Layer.Ref;
   begin
      while Layer_List /= null loop
         L := Layer_List;
         Layer_List := L.next;

         L.Next := null;
         L.Prev := null;
      end loop;
   end Remove_All;

   -------------------
   -- Render_Window --
   -------------------

   procedure Render_Window (Window           : Pix_Rect;
                            Background       : Output_Color;
                            Buffer           : in out  Output_Buffer;
                            Push_Pixels      : Push_Pixels_Proc;
                            Set_Drawing_Area : Set_Drawing_Area_Proc)
   is
      C     : Output_Color;
      Index : Output_Buffer_Index := Buffer'First;
      L     : Layer.Ref;
      PX    : Integer;
      PY    : Integer;
   begin
      --  For each pixel that we want to render, we look for the color of that
      --  pixel inside the first layer. If that color is not the Transparent
      --  color, we push it to the screen, otherwise we look in the next layer.
      --
      --  Here is a one dimension example using characters for the output
      --  'color'. The | (pipe) symbol shows how the layers are traversed.
      --
      --              ||||||||||||||||||||||||||||||||||||||||||||||||||
      --  Layer 1   : AAA|A|AAA|AA|AAA|AA||||AA|A|||||A||||||A|A|||||A|A
      --  Layer 2   :   BBBB   | BBB BBBBBB||  BBBBB|BB|BBB||BBB||||| BB
      --  Layer 3   : CCCCCCC  | CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC||||CCC
      --  Background: ##################################################
      --
      --  Output    : AAABABAAA#AABAAABAABBCCAABABBBCBACBBBCCABAC#####ABA

      Set_Drawing_Area (Window);

      for Y in Window.TL.Y .. Window.BR.Y loop
         for X in Window.TL.X .. Window.BR.X loop

            C := Transparent;

            L := Layer_List;
            Layer_Loop : while L /= null loop

               PX := X - L.Pt.X;
               PY := Y - L.Pt.Y;

               if PX in 0 .. L.A_Width - 1
                 and then
                   PY in 0 .. L.A_Height - 1
               then
                  C := L.Pix (PX, PY);
                  if C /= Transparent then
                     exit Layer_Loop;
                  end if;
               end if;
               L := L.Next;
            end loop Layer_Loop;

            if C = Transparent then
               C := Background;
            end if;

            Buffer (Index) := C;
            if Index = Buffer'Last then
               Push_Pixels (Buffer);
               Index := Buffer'First;
            else
               Index := Index + 1;
            end if;
         end loop;
      end loop;

      --  Push the remaining pixels
      if Index /= Buffer'First then
         Push_Pixels (Buffer (Buffer'First .. Index - 1));
      end if;
   end Render_Window;

   ----------------
   -- Render_All --
   ----------------

   procedure Render_All (Screen_Rect      : Pix_Rect;
                         Background       : Output_Color;
                         Buffer           : in out Output_Buffer;
                         Push_Pixels      : Push_Pixels_Proc;
                         Set_Drawing_Area : Set_Drawing_Area_Proc)
   is
      L : Layer.Ref := Layer_List;

      Min_X : constant Coordinate := Screen_Rect.TL.X;
      Min_Y : constant Coordinate := Screen_Rect.TL.Y;
      Max_X : constant Coordinate := Screen_Rect.BR.X;
      Max_Y : constant Coordinate := Screen_Rect.BR.Y;

      X0 : Coordinate := Max_X;
      X1 : Coordinate := Min_X;
      Y0 : Coordinate := Max_Y;
      Y1 : Coordinate := Min_Y;
   begin

      --  Find the window that contains all the layers
      while L /= null loop
         X0 := Min (X0, L.Pt.X);
         Y0 := Min (Y0, L.Pt.Y);
         X1 := Max (X1, L.Pt.X + L.A_Width - 1);
         Y1 := Max (Y1, L.Pt.Y + L.A_Height - 1);

         L.Dirty := False;
         L := L.Next;
      end loop;

      --  Apply screen limits
      X0 := Max (Min_X, Min (Max_X, X0));
      Y0 := Max (Min_Y, Min (Max_Y, Y0));
      X1 := Max (Min_X, Min (Max_X, X1));
      Y1 := Max (Min_Y, Min (Max_Y, Y1));

      if X1 >= X0 and then Y1 >= Y0 then
         Render_Window (((X0, Y0), (X1, Y1)),
                        Background,
                        Buffer,
                        Push_Pixels,
                        Set_Drawing_Area);
      end if;
   end Render_All;

   ------------------
   -- Render_Dirty --
   ------------------

   procedure Render_Dirty (Screen_Rect      : Pix_Rect;
                           Background       : Output_Color;
                           Buffer           : in out Output_Buffer;
                           Push_Pixels      : Push_Pixels_Proc;
                           Set_Drawing_Area : Set_Drawing_Area_Proc)
   is
      Min_X : Coordinate renames Screen_Rect.TL.X;
      Min_Y : Coordinate renames Screen_Rect.TL.Y;
      Max_X : Coordinate renames Screen_Rect.BR.X;
      Max_Y : Coordinate renames Screen_Rect.BR.Y;

      W, H : Lenght;
      L : Layer.Ref := Layer_List;
      X0, X1, Y0, Y1 : Integer;
   begin

      while L /= null loop
         if L.Dirty then

            --  Find the window that contains both the layer now and the layer
            --  at its previous location.
            W := L.A_Width;
            H := L.A_Height;
            X0 := Min (L.Last_Pt.X, L.Pt.X);
            Y0 := Min (L.Last_Pt.Y, L.Pt.Y);
            X1 := Max (L.Last_Pt.X + W, L.Pt.X + W - 1);
            Y1 := Max (L.Last_Pt.Y + H, L.Pt.Y + H - 1);

            --  Apply screen limits
            X0 := Max (Min_X, Min (Max_X, X0));
            Y0 := Max (Min_Y, Min (Max_Y, Y0));
            X1 := Max (Min_X, Min (Max_X, X1));
            Y1 := Max (Min_Y, Min (Max_Y, Y1));

            --  Update that window if it is not empty
            if X1 >= X0 and then Y1 >= Y0 then
               Render_Window (((X0, Y0), (X1, Y1)),
                              Background,
                              Buffer,
                              Push_Pixels,
                              Set_Drawing_Area);
            end if;

            L.Last_Pt := L.Pt;
            L.Dirty := False;
         end if;
         L := L.Next;
      end loop;
   end Render_Dirty;

   --------------
   -- Collides --
   --------------

   function Collides (Pt : Pix_Point) return Boolean is
      L : Layer.Ref := Layer_List;
      X : Integer;
      Y : Integer;
   begin

      while L /= null loop
         if L.Collisions_Enabled then
            X := Pt.X - L.Pt.X;
            Y := Pt.Y - L.Pt.Y;
            if X in 0 .. L.A_Width - 1
              and then
               Y in 0 .. L.A_Height - 1
              and then
               L.Collides (X, Y)
            then
               return True;
            end if;
         end if;
         L := L.Next;
      end loop;
      return False;
   end Collides;

end GESTE;
