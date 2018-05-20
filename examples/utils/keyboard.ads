package Keyboard is

   type Key_Kind is (Up, Down, Left, Right, Esc);

   procedure Update;

   function Pressed (Key : Key_Kind) return Boolean;

end Keyboard;
