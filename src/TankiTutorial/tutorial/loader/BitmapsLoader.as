package tutorial.loader
{
   import flash.display.BitmapData;
   import tutorial.commons.Assets;
   
   public class BitmapsLoader extends TanksLoader
   {
      
      private var ryv:Vector.<String>;
      
      private var besitelob:Vector.<String>;
      
      private var dodycoli:int;
      
      public function BitmapsLoader()
      {
         super();
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.bitmaps.length() > 0;
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         var _loc6_:XML = null;
         this.pomagu = param2.bitmaps[0];
         this.hon = param3;
         this.ryv = new Vector.<String>();
         this.besitelob = new Vector.<String>();
         this.dodycoli = 0;
         var _loc4_:String = param1 + pomagu.@baseURL;
         var _loc5_:int = 0;
         for each(_loc6_ in pomagu.elements("bitmap"))
         {
            this.besitelob[_loc5_] = _loc6_.@id.toString();
            this.ryv[_loc5_] = _loc4_ + _loc6_.@url.toString();
            _loc5_++;
         }
         this.loadBitmaps();
      }
      
      private function loadBitmaps(param1:BitmapData = null) : void
      {
         if(param1 != null)
         {
            Assets.saveData(this.besitelob[this.dodycoli],param1,BitmapData);
            ++this.dodycoli;
         }
         if(this.dodycoli < this.ryv.length)
         {
            if(Assets.hasData(this.besitelob[this.dodycoli],BitmapData))
            {
               ++this.dodycoli;
               this.loadBitmaps();
            }
            else
            {
               julicoj = this.ryv[this.dodycoli];
               bita.load(this.ryv[this.dodycoli],this.loadBitmaps);
            }
         }
         else if(hon != null)
         {
            hon();
         }
      }
   }
}

