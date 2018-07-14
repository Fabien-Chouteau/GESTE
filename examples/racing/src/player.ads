with GESTE;
with GESTE.Maths_Types; use GESTE.Maths_Types;

package Player is

   procedure Move (Pt : GESTE.Point);

   function Position return GESTE.Point;

   procedure Update (Elapsed : Time_Value);

   procedure Throttle;
   procedure Brake;
   procedure Move_Left;
   procedure Move_Right;
end Player;
