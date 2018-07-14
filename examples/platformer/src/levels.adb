
with Game_Assets;
with Game_Assets.Tileset;
with Game_Assets.Tileset_Collisions;
with Game_Assets.Level_1;
with Game_Assets.Level_2;
with Game_Assets.Level_3;

with Render;
with GESTE;
with GESTE.Tile_Bank;
with GESTE.Grid;
with GESTE.Text;
with GESTE_Config;
with GESTE_Fonts.FreeMono8pt7b;

package body Levels is

   Tile_Bank : aliased GESTE.Tile_Bank.Instance
     (Game_Assets.Tileset.Tiles'Access,
      Game_Assets.Tileset_Collisions.Tiles'Access,
      Game_Assets.Palette'Access);

   Lvl1_Text  : aliased GESTE.Text.Instance
     (Da_Font           => GESTE_Fonts.FreeMono8pt7b.Font,
      Number_Of_Columns => 18,
      Number_Of_Lines   => 3,
      Foreground        => 0,
      Background        => GESTE_Config.Transparent);

   Lvl1_Front : aliased GESTE.Grid.Instance
     (Game_Assets.Level_1.Front.Data'Access,
      Tile_Bank'Access);
   Lvl1_Mid  : aliased GESTE.Grid.Instance
     (Game_Assets.Level_1.Mid.Data'Access,
      Tile_Bank'Access);
   Lvl1_Back : aliased GESTE.Grid.Instance
     (Game_Assets.Level_1.Back.Data'Access,
      Tile_Bank'Access);

   Lvl2_Front : aliased GESTE.Grid.Instance
     (Game_Assets.Level_2.Front.Data'Access,
      Tile_Bank'Access);
   Lvl2_Mid  : aliased GESTE.Grid.Instance
     (Game_Assets.Level_2.Mid.Data'Access,
      Tile_Bank'Access);
   Lvl2_Back : aliased GESTE.Grid.Instance
     (Game_Assets.Level_2.Back.Data'Access,
      Tile_Bank'Access);

   Lvl3_Front : aliased GESTE.Grid.Instance
     (Game_Assets.Level_3.Front.Data'Access,
      Tile_Bank'Access);
   Lvl3_Mid  : aliased GESTE.Grid.Instance
     (Game_Assets.Level_3.Mid.Data'Access,
      Tile_Bank'Access);
   Lvl3_Back : aliased GESTE.Grid.Instance
     (Game_Assets.Level_3.Back.Data'Access,
      Tile_Bank'Access);

   -----------
   -- Enter --
   -----------

   procedure Enter (Id : Level_Id) is
   begin
      case Id is
         when Lvl_1 =>
            Lvl1_Back.Move ((0, 0));
            GESTE.Add (Lvl1_Back'Access, 1);

            Lvl1_Mid.Enable_Collisions;
            Lvl1_Mid.Move ((0, 0));
            GESTE.Add (Lvl1_Mid'Access, 2);

            Lvl1_Front.Move ((0, 0));
            GESTE.Add (Lvl1_Front'Access, 3);

            Lvl1_Text.Move ((100, 10));
            GESTE.Add (Lvl1_Text'Access, 4);
         when Lvl_2 =>
            Lvl2_Back.Move ((0, 0));
            GESTE.Add (Lvl2_Back'Access, 1);

            Lvl2_Mid.Enable_Collisions;
            Lvl2_Mid.Move ((0, 0));
            GESTE.Add (Lvl2_Mid'Access, 2);

            Lvl2_Front.Move ((0, 0));
            GESTE.Add (Lvl2_Front'Access, 3);

         when Lvl_3 =>
            Lvl3_Back.Move ((0, 0));
            GESTE.Add (Lvl3_Back'Access, 1);

            Lvl3_Mid.Enable_Collisions;
            Lvl3_Mid.Move ((0, 0));
            GESTE.Add (Lvl3_Mid'Access, 2);

            Lvl3_Front.Move ((0, 0));
            GESTE.Add (Lvl3_Front'Access, 2);
      end case;

      Render.Render_All (Render.Dark_Cyan);
   end Enter;

   -----------
   -- Leave --
   -----------

   procedure Leave (Id : Level_Id) is
   begin
      case Id is
         when Lvl_1 =>
            GESTE.Remove (Lvl1_Back'Access);
            GESTE.Remove (Lvl1_Mid'Access);
            GESTE.Remove (Lvl1_Front'Access);
            GESTE.Remove (Lvl1_Text'Access);
         when Lvl_2 =>
            GESTE.Remove (Lvl2_Back'Access);
            GESTE.Remove (Lvl2_Mid'Access);
            GESTE.Remove (Lvl2_Front'Access);
         when Lvl_3 =>
            GESTE.Remove (Lvl3_Back'Access);
            GESTE.Remove (Lvl3_Mid'Access);
            GESTE.Remove (Lvl3_Front'Access);
      end case;
   end Leave;

begin
   Lvl1_Text.Clear;
   Lvl1_Text.Put ("Welcome to GESTE's" &
                  "  platform game   " &
                  "    example!");
end Levels;
