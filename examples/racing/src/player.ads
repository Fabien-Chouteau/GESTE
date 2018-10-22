with GESTE;
with GESTE.Maths_Types; use GESTE.Maths_Types;

package Player is

   procedure Move (Pt : GESTE.Pix_Point);

   function Position return GESTE.Pix_Point;

   procedure Update (Elapsed : Value);

   procedure Throttle;
   procedure Brake;
   procedure Move_Left;
   procedure Move_Right;
end Player;
