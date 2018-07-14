with GESTE;
with GESTE.Grid;
with GESTE.Tile_Bank;

with Game_Assets;
with Game_Assets.Tileset;
with Game_Assets.Tileset_Collisions;
with Game_Assets.track_1;

package body Levels is

   Tile_Bank : aliased GESTE.Tile_Bank.Instance
     (Game_Assets.Tileset.Tiles'Access,
      Game_Assets.Tileset_Collisions.Tiles'Access,
      Game_Assets.Palette'Access);

   Track2_Mid : aliased GESTE.Grid.Instance
     (Game_Assets.track_1.Track.Data'Access,
      Tile_Bank'Access);
   Track2_Back : aliased GESTE.Grid.Instance
     (Game_Assets.track_1.Background.Data'Access,
      Tile_Bank'Access);

   -----------
   -- Enter --
   -----------

   procedure Enter (Id : Level_Id) is
      pragma Unreferenced (Id);
   begin
      Track2_Mid.Enable_Collisions;
      Track2_Mid.Move ((0, 0));
      GESTE.Add (Track2_Mid'Access, 2);
      Track2_Back.Move ((0, 0));
      GESTE.Add (Track2_Back'Access, 1);
   end Enter;

   -----------
   -- Leave --
   -----------

   procedure Leave (Id : Level_Id) is
   begin
      null;
   end Leave;

end Levels;
