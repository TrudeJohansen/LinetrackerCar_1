with MicroBit.IOsForTasking;
with MicroBit;
with MicroBit.Console; use MicroBit.Console;
with Ada.Real_Time; use Ada.Real_Time;

package body Directions is
   
   protected body directionobj is
      procedure setDirection(dir: rettning ) is
         begin
         dir_value := dir;
      end setDirection;
      
      function getDirection return rettning is 
      begin
         return dir_value;
      end getDirection;
      
      --leser fra linetracker: --------------------------------
      procedure readLinetracker(trackerstate: Boolean) is
      begin 
         linetrackerState := trackerstate;
      end readLinetracker;
      
      function getLinetracker return Boolean is
      begin 
         return linetrackerState;
      end getLinetracker;

      
   end directionobj;
   ------------------------------------------
   procedure findLine is

   begin 
      if  counter < 50 then
         directionobj.setDirection(Left);
         drive(left);
      else
         if counter < 150 then 
            directionobj.setDirection(Right);
            drive(Right);
         else 
            directionobj.setDirection(Stop);
            drive(Stop);
         end if;
         
      end if;
      counter := counter + 1; --add "20ms"
      
   end findLine;
   --------------------------------------------------------
   
   
   -- def av rettningene:---------------------------------------------------
   procedure drive(dir: rettning) is
      Speed : constant MicroBit.IOsForTasking.Analog_Value := 512;
   begin
      MicroBit.IOsForTasking.Set_Analog_Period_Us(20000); -- 50 Hz = 1/50 = 0.02s = 20 ms = 20000us 
         if dir = Forward then
      --LEFT
      --front   
      MicroBit.IOsForTasking.Set(6, True); --IN1
      MicroBit.IOsForTasking.Set(7, False); --IN2
   
      --back
      MicroBit.IOsForTasking.Set(2, True); --IN3
      MicroBit.IOsForTasking.Set(3, False); --IN4
   
      --RIGHT
      --front
      MicroBit.IOsForTasking.Set(12, True); --IN1
      MicroBit.IOsForTasking.Set(13, False); --IN2

      --back
      MicroBit.IOsForTasking.Set(14, True); --IN3
      MicroBit.IOsForTasking.Set(15, False); --IN4
   
     MicroBit.IOsForTasking.Write (0, Speed); --left speed control ENA ENB
            MicroBit.IOsForTasking.Write (1, Speed); --right speed control ENA ENB
      end if;
      
      if dir = Left then 
               --LEFT
      --front   
      MicroBit.IOsForTasking.Set(6, False); --IN1
      MicroBit.IOsForTasking.Set(7, True); --IN2
   
      --back
      MicroBit.IOsForTasking.Set(2, True); --IN3
      MicroBit.IOsForTasking.Set(3, False); --IN4
   
      --RIGHT
      --front
      MicroBit.IOsForTasking.Set(12, True); --IN1
      MicroBit.IOsForTasking.Set(13, False); --IN2

      --back
      MicroBit.IOsForTasking.Set(14, False); --IN3
      MicroBit.IOsForTasking.Set(15, True); --IN4
   
     MicroBit.IOsForTasking.Write (0, Speed); --left speed control ENA ENB
            MicroBit.IOsForTasking.Write (1, Speed); --right speed control ENA ENB
      end if; 
      
      if dir = Right then
               --LEFT
      --front   
      MicroBit.IOsForTasking.Set(6, True); --IN1
      MicroBit.IOsForTasking.Set(7, False); --IN2
   
      --back
      MicroBit.IOsForTasking.Set(2, False); --IN3
      MicroBit.IOsForTasking.Set(3, True); --IN4
   
      --RIGHT
      --front
      MicroBit.IOsForTasking.Set(12, False); --IN1
      MicroBit.IOsForTasking.Set(13, True); --IN2

      --back
      MicroBit.IOsForTasking.Set(14, True); --IN3
      MicroBit.IOsForTasking.Set(15, False); --IN4
   
            
              
            MicroBit.IOsForTasking.Write (0, Speed); --left speed control ENA ENB
            MicroBit.IOsForTasking.Write (1, Speed); --right speed control ENA ENB
      end if; 
      
      if dir = Stop then
      --LEFT
      --front   
      MicroBit.IOsForTasking.Set(6, False); --IN1
      MicroBit.IOsForTasking.Set(7, False); --IN2
   
      --back
      MicroBit.IOsForTasking.Set(2, False); --IN3
      MicroBit.IOsForTasking.Set(3, False); --IN4
   
      --RIGHT
      --front
      MicroBit.IOsForTasking.Set(12, False); --IN1
      MicroBit.IOsForTasking.Set(13, False); --IN2

      --back
      MicroBit.IOsForTasking.Set(14, False); --IN3
      MicroBit.IOsForTasking.Set(15, False); --IN4
   
     MicroBit.IOsForTasking.Write (0, 0); --left speed control ENA ENB
     MicroBit.IOsForTasking.Write (1, 0); --right speed control ENA ENB
      end if;
      
   end drive;
   ----------------------------------------------------------------------------------------  
   
   task body sense is
      Time_Now : Ada.Real_Time.Time;
      linetrackerState : Boolean := True;
   begin 
      loop
         Time_Now := Ada.Real_Time.Clock;
         directionobj.readLinetracker(MicroBit.IOsForTasking.set(4));

         delay until Time_Now + Ada.Real_Time.Milliseconds(20); 
      end loop;
   
   end sense;
   
   -----------------------------------------------------------------------------------------
   task body act is
      Time_Now : Ada.Real_Time.Time;
      dir : rettning;
      Speed : constant MicroBit.IOsForTasking.Analog_Value := 512;
      current_state : rettning := Forward;
      ltState : Boolean;

   begin 
      loop
         Time_Now := Ada.Real_Time.Clock;
         
         dir := directionobj.getDirection;
         ltState := directionobj.getLinetracker;
     
      if ltState = True then 
            directionobj.setDirection(Forward);
            drive(Forward);
            counter := 0;
      else
         findLine;
         end if;
         
         Put_Line("Direction: " & rettning'Image(dir));

         delay until Time_Now + Ada.Real_Time.Milliseconds(20); 
      end loop;
   
   end act;
   
   
end Directions;
