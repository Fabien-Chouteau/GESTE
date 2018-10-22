package Levels is

   type Level_Id is (Lvl_1);

   procedure Enter (Id : Level_Id);
   procedure Leave (Id : Level_Id);

end Levels;
