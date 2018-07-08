package Levels is

   type Level_Id is (Outside, Inside, Cave);

   procedure Update;

   procedure Enter (Id : Level_Id);
   procedure Leave (Id : Level_Id);

end Levels;
