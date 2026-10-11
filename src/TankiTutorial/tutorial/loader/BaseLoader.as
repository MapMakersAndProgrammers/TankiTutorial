package tutorial.loader
{
   import flash.events.ProgressEvent;
   import tutorial.commons.Shared;
   
   public class BaseLoader
   {
      
      private var bytesLoaded:uint;
      
      private var bytesTotal:uint;
      
      private var currentTarget:Object;
      
      protected var currentURL:String;
      
      public function BaseLoader()
      {
         super();
      }
      
      protected function onProgress(progressEvent:ProgressEvent) : void
      {
         if(progressEvent.target != this.currentTarget)
         {
            this.bytesLoaded = 0;
            this.bytesTotal = progressEvent.bytesTotal;
            this.currentTarget = progressEvent.target;
         }
         Shared.preloader.addBytes(progressEvent.bytesLoaded - this.bytesLoaded);
         this.bytesLoaded = progressEvent.bytesLoaded;
      }
      
      protected function onFinishLoad() : void
      {
         if(this.bytesLoaded < this.bytesTotal)
         {
            Shared.preloader.addBytes(this.bytesTotal - this.bytesLoaded);
         }
         this.bytesLoaded = 0;
         this.bytesTotal = 0;
      }
   }
}

