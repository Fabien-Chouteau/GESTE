with GESTE;
with Game_Assets;

package Player is

   procedure Move (Pt : GESTE.Point);

   function Position return GESTE.Point;

   procedure Update;

   procedure Move_Left;
   procedure Move_Right;
   procedure Move_Up;
   procedure Move_Down;
end Player;
