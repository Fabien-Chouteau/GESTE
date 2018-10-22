with GESTE;

package Player is

   procedure Move (Pt : GESTE.Pix_Point);

   function Position return GESTE.Pix_Point;

   procedure Update;

   procedure Jump;
   procedure Move_Left;
   procedure Move_Right;
end Player;
