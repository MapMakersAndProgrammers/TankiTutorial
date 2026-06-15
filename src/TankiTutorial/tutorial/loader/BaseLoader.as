package tutorial.loader
{
   import flash.events.ProgressEvent;
   import tutorial.commons.Shared;
   
   public class BaseLoader
   {
      
      private var fajo:uint;
      
      private var buw:uint;
      
      private var jin:Object;
      
      protected var julicoj:String;
      
      public function BaseLoader()
      {
         super();
      }
      
      protected function onProgress(param1:ProgressEvent) : void
      {
         if(param1.target != this.jin)
         {
            this.fajo = 0;
            this.buw = param1.bytesTotal;
            this.jin = param1.target;
         }
         Shared.preloader.addBytes(param1.bytesLoaded - this.fajo);
         this.fajo = param1.bytesLoaded;
      }
      
      protected function onFinishLoad() : void
      {
         if(this.fajo < this.buw)
         {
            Shared.preloader.addBytes(this.buw - this.fajo);
         }
         this.fajo = 0;
         this.buw = 0;
      }
   }
}

