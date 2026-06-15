package lycikehe
{
   public class vipifoki
   {
      
      private var kebesyqug:int;
      
      private var lusimeciw:int;
      
      private var gywej:int;
      
      private var zabiso:Number;
      
      private var lozusezyr:Number;
      
      private var gahehake:Number;
      
      private var duz:Number;
      
      private var supoly:Number;
      
      private var sesibo:Number;
      
      private var lafujot:int;
      
      private var viwohykyr:int;
      
      public function vipifoki(param1:int, param2:int, param3:int, param4:Number, param5:Number, param6:Number)
      {
         super();
         this.kebesyqug = param1;
         this.lusimeciw = param2;
         this.gywej = param3;
         this.lozusezyr = param4;
         this.zabiso = param5;
         this.gahehake = param6;
         this.sesibo = param5 - param4;
      }
      
      public function nuq(param1:int) : void
      {
         this.kebesyqug = param1;
      }
      
      public function cabor(param1:int) : void
      {
         this.duz = this.zabiso;
         this.viwohykyr = this.kebesyqug;
         this.supoly = this.met(-1);
         this.lafujot = param1 + this.viwohykyr;
      }
      
      public function hywit(param1:Number) : void
      {
         if(param1 >= this.lozusezyr)
         {
            this.zabiso = param1;
            this.sesibo = this.zabiso - this.lozusezyr;
         }
      }
      
      public function ficysofa(param1:Number) : void
      {
         if(param1 <= this.zabiso)
         {
            this.lozusezyr = param1;
            this.sesibo = this.zabiso - this.lozusezyr;
         }
      }
      
      public function wyjari() : Number
      {
         return this.lozusezyr;
      }
      
      public function sukogehen(param1:int, param2:int) : Number
      {
         this.duz += this.supoly * param2;
         if(this.duz > this.zabiso)
         {
            this.duz = this.zabiso;
         }
         if(this.duz < this.lozusezyr)
         {
            this.duz = this.lozusezyr;
         }
         if(param1 >= this.lafujot)
         {
            if(this.viwohykyr > this.lusimeciw)
            {
               this.viwohykyr -= this.gywej;
               if(this.viwohykyr < this.lusimeciw)
               {
                  this.viwohykyr = this.lusimeciw;
               }
            }
            this.lafujot = param1 + this.viwohykyr;
            if(this.supoly < 0)
            {
               this.supoly = this.met(1);
            }
            else
            {
               this.supoly = this.met(-1);
            }
         }
         return this.duz;
      }
      
      private function met(param1:Number) : Number
      {
         return param1 * this.gahehake * this.sesibo / this.viwohykyr;
      }
   }
}

