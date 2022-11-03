package Directions is
   
   task sense with Priority => 1; --lavest prioritet 
   task act with Priority => 2;   --høyest prioritet 
   
   type rettning is (Forward, Right, Left, Stop);
   
   procedure drive(dir: rettning);
   procedure findLine;
   counter : Integer := 0;
   
   protected directionobj is
      procedure setDirection(dir: rettning );
      function getDirection return rettning;
      procedure readLinetracker(trackerstate: Boolean);
      function getLinetracker return Boolean;

   private
      dir_value: rettning;
      linetrackerState : Boolean;
      
   end directionobj;
   
end Directions;
