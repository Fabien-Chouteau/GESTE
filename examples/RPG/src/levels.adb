
with Render;

with Game_Assets;
with Game_Assets.Tileset;
with Game_Assets.Tileset_Collisions;
with Game_Assets.outside;
with Game_Assets.inside;
with Game_Assets.cave;

with GESTE; use GESTE;
with GESTE.Tile_Bank;
with GESTE.Grid;
with GESTE.Text;

with Player;

package body Levels is

   Debug_Collisions : constant Boolean := False;

   Tile_Bank : aliased GESTE.Tile_Bank.Instance
     (Game_Assets.Tileset.Tiles'Access,
      Game_Assets.Tileset_Collisions.Tiles'Access,
      Game_Assets.Palette'Access);

   Outside_Front : aliased GESTE.Grid.Instance
     (Game_Assets.outside.over2.Data'Access,
      Tile_Bank'Access);
   Outside_Mid  : aliased GESTE.Grid.Instance
     (Game_Assets.outside.over.Data'Access,
      Tile_Bank'Access);
   Outside_Back : aliased GESTE.Grid.Instance
     (Game_Assets.outside.ground.Data'Access,
      Tile_Bank'Access);
   Outside_Collisions : aliased GESTE.Grid.Instance
     (Game_Assets.outside.collisions.Data'Access,
      Tile_Bank'Access);

   Inside_Objects2 : aliased GESTE.Grid.Instance
     (Game_Assets.inside.objects2.Data'Access,
      Tile_Bank'Access);
   Inside_Objects : aliased GESTE.Grid.Instance
     (Game_Assets.inside.objects.Data'Access,
      Tile_Bank'Access);
   Inside_Walls  : aliased GESTE.Grid.Instance
     (Game_Assets.inside.walls.Data'Access,
      Tile_Bank'Access);
   Inside_Ground : aliased GESTE.Grid.Instance
     (Game_Assets.inside.ground.Data'Access,
      Tile_Bank'Access);
   Inside_Collisions : aliased GESTE.Grid.Instance
     (Game_Assets.inside.collisions.Data'Access,
      Tile_Bank'Access);

   Cave_Mid  : aliased GESTE.Grid.Instance
     (Game_Assets.cave.Over.Data'Access,
      Tile_Bank'Access);
   Cave_Back : aliased GESTE.Grid.Instance
     (Game_Assets.cave.Ground.Data'Access,
      Tile_Bank'Access);
   Cave_Collisions : aliased GESTE.Grid.Instance
     (Game_Assets.cave.collisions.Data'Access,
      Tile_Bank'Access);


   Lvl : Levels.Level_Id := Levels.Inside;
   Screen_Pos : GESTE.Pix_Point := (0, 0);

   procedure Move_To (Obj : Game_Assets.Object);

   -------------
   -- Move_To --
   -------------

   procedure Move_To (Obj : Game_Assets.Object) is
   begin
      Player.Move ((Integer (Obj.X), Integer (Obj.Y)));
   end Move_To;


   ------------
   -- Update --
   ------------

   procedure Update is
      Pos : constant GESTE.Pix_Point := Player.Position;

      function Is_In (Obj : Game_Assets.Object) return Boolean;

      -----------
      -- Is_In --
      -----------

      function Is_In (Obj : Game_Assets.Object) return Boolean is
      begin
         return Pos.X in
           Integer (Obj.X) .. Integer (Obj.X) + Integer (Obj.Width) - 1
           and then
             Pos.Y in
               Integer (Obj.Y) .. Integer (Obj.Y) + Integer (Obj.Height) - 1;
      end Is_In;

   begin
      case Lvl is
         when Outside =>

            for Obj of Game_Assets.outside.screen_border.Objects loop
               if Is_In (Obj) then
                  if  Screen_Pos /= (Integer (Obj.X), Integer (Obj.Y)) then
                     Screen_Pos := (Integer (Obj.X), Integer (Obj.Y));
                     Render.Set_Screen_Offset (Screen_Pos);
                     Leave (Outside);
                     Enter (Outside);
                  end if;
               end if;
            end loop;

            if Is_In (Game_Assets.outside.gates.To_House) then
               Move_To (Game_Assets.inside.gates.From_Outside);
               Leave (Outside);
               Enter (Inside);
            end if;
         when Inside =>
            if Is_In (Game_Assets.inside.gates.To_Outside) then
               Move_To (Game_Assets.outside.gates.From_House);
               Leave (Inside);
               Enter (Outside);
            end if;
            if Is_In (Game_Assets.inside.gates.To_Cave) then
               Move_To (Game_Assets.cave.gates.From_House);
               Leave (Inside);
               Enter (Cave);
            end if;
         when Cave =>
            if Is_In (Game_Assets.cave.gates.To_House) then
               Move_To (Game_Assets.inside.gates.From_Cave);
               Leave (Cave);
               Enter (Inside);
            end if;
      end case;
   end Update;

   -----------
   -- Enter --
   -----------

   procedure Enter (Id : Level_Id) is
   begin
      case Id is
         when Outside =>
            Outside_Collisions.Move ((0, 0));
            Outside_Collisions.Enable_Collisions;
            GESTE.Add (Outside_Collisions'Access,
                       (if Debug_Collisions then 6 else 0));

            Outside_Back.Move ((0, 0));
            GESTE.Add (Outside_Back'Access, 1);

            Outside_Mid.Enable_Collisions;
            Outside_Mid.Move ((0, 0));
            GESTE.Add (Outside_Mid'Access, 2);

            Outside_Front.Move ((0, 0));
            GESTE.Add (Outside_Front'Access, 5);

         when Inside =>
            Inside_Collisions.Move ((0, 0));
            Inside_Collisions.Enable_Collisions;
            GESTE.Add (Inside_Collisions'Access,
                       (if Debug_Collisions then 6 else 0));

            Inside_Ground.Move ((0, 0));
            GESTE.Add (Inside_Ground'Access, 1);

            Inside_Walls.Move ((0, 0));
            GESTE.Add (Inside_Walls'Access, 2);

            Inside_Objects.Move ((0, 0));
            GESTE.Add (Inside_Objects'Access, 3);

            Inside_Objects2.Move ((0, 0));
            GESTE.Add (Inside_Objects2'Access, 5);
         when Cave =>
            Cave_Collisions.Move ((0, 0));
            Cave_Collisions.Enable_Collisions;
            GESTE.Add (Cave_Collisions'Access,
                       (if Debug_Collisions then 6 else 0));

            Cave_Back.Move ((0, 0));
            GESTE.Add (Cave_Back'Access, 1);

            Cave_Mid.Move ((0, 0));
            GESTE.Add (Cave_Mid'Access, 2);
      end case;

      Render.Render_All (0);

      Lvl := Id;

   end Enter;

   -----------
   -- Leave --
   -----------

   procedure Leave (Id : Level_Id) is
   begin
      case Id is
         when Outside  =>
            GESTE.Remove (Outside_Collisions'Access);
            GESTE.Remove (Outside_Back'Access);
            GESTE.Remove (Outside_Mid'Access);
            GESTE.Remove (Outside_Front'Access);
         when Inside =>
            GESTE.Remove (Inside_Collisions'Access);
            GESTE.Remove (Inside_Ground'Access);
            GESTE.Remove (Inside_Walls'Access);
            GESTE.Remove (Inside_Objects'Access);
            GESTE.Remove (Inside_Objects2'Access);
         when Cave =>
            GESTE.Remove (Cave_Collisions'Access);
            GESTE.Remove (Cave_Back'Access);
            GESTE.Remove (Cave_Mid'Access);
      end case;
   end Leave;

begin
   Enter (Inside);
   Move_To (Game_Assets.inside.gates.From_Outside);
end Levels;
