with Interfaces.C;     use Interfaces.C;
with SDL_SDL_events_h; use SDL_SDL_events_h;
with SDL_SDL_keysym_h; use SDL_SDL_keysym_h;

package body Keyboard is

   Is_Pressed : array (Key_Kind) of Boolean := (others => False);

   ------------
   -- Update --
   ------------

   procedure Update is
      Evt : aliased SDL_Event;
   begin
      while SDL_PollEvent (Evt'Access) /= 0 loop

         if Evt.c_type = SDL_KEYDOWN or else Evt.c_type = SDL_KEYUP then
            case Evt.key.keysym.sym is
            when SDLK_LEFT =>
               Is_Pressed (Left) := Evt.c_type = SDL_KEYDOWN;
            when SDLK_RIGHT =>
               Is_Pressed (Right) := Evt.c_type = SDL_KEYDOWN;
            when SDLK_DOWN =>
               Is_Pressed (Down) := Evt.c_type = SDL_KEYDOWN;
            when SDLK_UP =>
               Is_Pressed (Up) := Evt.c_type = SDL_KEYDOWN;
            when SDLK_ESCAPE =>
               Is_Pressed (Esc) := Evt.c_type = SDL_KEYDOWN;
            when others =>
               null;
            end case;
         end if;
      end loop;
   end Update;

   -------------
   -- Pressed --
   -------------

   function Pressed (Key : Key_Kind) return Boolean
   is (Is_Pressed (Key));

end Keyboard;
