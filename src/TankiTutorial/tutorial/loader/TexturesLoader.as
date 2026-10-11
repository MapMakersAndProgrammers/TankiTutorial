package tutorial.loader
{
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import tutorial.commons.Assets;
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;

   public class TexturesLoader
   {
      
      private static const sinemuc:int = 5;
      
      private static const MAX_UPLOAD_TIME:uint = 5;
      
      private static const cache:Object = new Object();
      
      private static const stub:BitmapData = new BitmapData(1,1,false,8355711);
      
      private const queues:Array = [];
      
      private var imageLoader:ImageLoader;
      
      private var loading:Boolean;
      
      private var current:TextureMaterial;
      
      private var uploadQueue:Vector.<TextureQueueEntry> = new Vector.<TextureQueueEntry>();
      
      private var currentPriority:int;
      
      private var intervalId:uint;
      
      public function TexturesLoader()
      {
         super();
      }
      
      public function addToQueue(material:TextureMaterial, priority:int, param3:Boolean = false) : void
      {
         var parts:Array = null;
         var lowURL:String = null;
         var i:int = 0;
         if(this.imageLoader == null)
         {
            this.imageLoader = new ImageLoader(false);
         }
         if(Boolean(cache[material.diffuseMapURL]))
         {
            material.texture = cache[material.diffuseMapURL];
            return;
         }
         if(Assets.hasData(material.diffuseMapURL,BitmapData))
         {
            material.texture = Assets.getData(material.diffuseMapURL,BitmapData);
            return;
         }
         var index:int = sinemuc + priority;
         if(this.queues[index] == null)
         {
            this.queues[index] = new Vector.<TextureMaterial>();
         }
         this.queues[index].push(material);
         if(material.texture == null)
         {
            parts = material.diffuseMapURL.split("/");
            parts.push(parts[parts.length - 1]);
            parts[parts.length - 2] = "low";
            lowURL = "";
            i = 0;
            while(i < parts.length)
            {
               lowURL += parts[i];
               if(i < parts.length - 1)
               {
                  lowURL += "/";
               }
               i++;
            }
            if(Assets.hasData(lowURL,BitmapData))
            {
               material.texture = Assets.getData(lowURL,BitmapData);
            }
            else
            {
               material.texture = stub;
            }
         }
      }
      
      public function startLoad() : void
      {
         if(!this.loading)
         {
            this.loading = true;
            this.load();
         }
      }
      
      private function addToUploadQueue(material:TextureMaterial, texture:BitmapData, priority:int) : void
      {
         this.uploadQueue.push(TextureQueueEntry.create(material,texture,priority));
         if(this.intervalId == 0)
         {
            this.intervalId = setInterval(this.upload,30);
         }
      }
      
      private function load(bitmapData:BitmapData = null) : void
      {
         var i:int = 0;
         var queue:Vector.<TextureMaterial> = null;
         if(bitmapData != null)
         {
            cache[this.current.diffuseMapURL] = bitmapData;
            this.addToUploadQueue(this.current,bitmapData,this.currentPriority);
         }
         this.current = null;
         i = 0;
         while(i < this.queues.length)
         {
            queue = this.queues[i];
            if(queue != null && queue.length > 0)
            {
               this.currentPriority = i;
               while(this.current == null && queue.length > 0)
               {
                  this.current = queue.shift();
                  if(i < sinemuc)
                  {
                     this.current.diffuseMapURL = this.insertLow(this.current.diffuseMapURL);
                  }
                  else
                  {
                     this.current.diffuseMapURL = this.removeLow(this.current.diffuseMapURL);
                  }
                  if(!cache[this.current.diffuseMapURL])
                  {
                     this.imageLoader.load(this.current.diffuseMapURL,this.load);
                  }
                  else
                  {
                     this.addToUploadQueue(this.current,cache[this.current.diffuseMapURL],this.currentPriority);
                     this.current = null;
                  }
               }
               if(this.current != null)
               {
                  break;
               }
            }
            i++;
         }
         if(this.current == null)
         {
            this.loading = false;
         }
      }
      
      private function upload() : void
      {
         var lastTime:uint = 0;
         var elapsed:uint = 0;
         var entry:TextureQueueEntry = null;
         var time:uint = 0;
         if(this.uploadQueue.length > 0)
         {
            lastTime = uint(getTimer());
            elapsed = 0;
            while(elapsed < MAX_UPLOAD_TIME && this.uploadQueue.length > 0)
            {
               entry = this.uploadQueue.shift();
               entry.upload();
               entry.recycle();
               time = uint(getTimer());
               elapsed += time - lastTime;
               lastTime = time;
            }
         }
         else
         {
            clearInterval(this.intervalId);
            this.intervalId = 0;
         }
      }
      
      private function insertLow(url:String) : String
      {
         if(url.indexOf("/low/") > 0)
         {
            return url;
         }
         var index:int = url.lastIndexOf("/");
         return url.substr(0,index) + "/low/" + url.substr(index + 1);
      }
      
      private function removeLow(url:String) : String
      {
         return url.replace("/low/","/");
      }
   }
}

