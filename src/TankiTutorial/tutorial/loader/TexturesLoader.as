package tutorial.loader
{
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import tutorial.commons.Assets;
   
   public class TexturesLoader
   {
      
      private static const sinemuc:int = 5;
      
      private static const puran:uint = 5;
      
      private static const makotubo:Object = new Object();
      
      private static const tif:BitmapData = new BitmapData(1,1,false,8355711);
      
      private const jecateceb:Array = [];
      
      private var bita:ImageLoader;
      
      private var qahytenip:Boolean;
      
      private var zewucadiz:TextureMaterial;
      
      private var cefegu:Vector.<TextureQueueEntry> = new Vector.<TextureQueueEntry>();
      
      private var tugak:int;
      
      private var rirygyqic:uint;
      
      public function TexturesLoader()
      {
         super();
      }
      
      public function addToQueue(param1:TextureMaterial, param2:int, param3:Boolean = false) : void
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         if(this.bita == null)
         {
            this.bita = new ImageLoader(false);
         }
         if(Boolean(makotubo[param1.diffuseMapURL]))
         {
            param1.texture = makotubo[param1.diffuseMapURL];
            return;
         }
         if(Assets.hasData(param1.diffuseMapURL,BitmapData))
         {
            param1.texture = Assets.getData(param1.diffuseMapURL,BitmapData);
            return;
         }
         var _loc4_:int = sinemuc + param2;
         if(this.jecateceb[_loc4_] == null)
         {
            this.jecateceb[_loc4_] = new Vector.<TextureMaterial>();
         }
         this.jecateceb[_loc4_].push(param1);
         if(param1.texture == null)
         {
            _loc5_ = param1.diffuseMapURL.split("/");
            _loc5_.push(_loc5_[_loc5_.length - 1]);
            _loc5_[_loc5_.length - 2] = "low";
            _loc6_ = "";
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               _loc6_ += _loc5_[_loc7_];
               if(_loc7_ < _loc5_.length - 1)
               {
                  _loc6_ += "/";
               }
               _loc7_++;
            }
            if(Assets.hasData(_loc6_,BitmapData))
            {
               param1.texture = Assets.getData(_loc6_,BitmapData);
            }
            else
            {
               param1.texture = tif;
            }
         }
      }
      
      public function startLoad() : void
      {
         if(!this.qahytenip)
         {
            this.qahytenip = true;
            this.load();
         }
      }
      
      private function addToUploadQueue(param1:TextureMaterial, param2:BitmapData, param3:int) : void
      {
         this.cefegu.push(TextureQueueEntry.create(param1,param2,param3));
         if(this.rirygyqic == 0)
         {
            this.rirygyqic = setInterval(this.upload,30);
         }
      }
      
      private function load(param1:BitmapData = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<TextureMaterial> = null;
         if(param1 != null)
         {
            makotubo[this.zewucadiz.diffuseMapURL] = param1;
            this.addToUploadQueue(this.zewucadiz,param1,this.tugak);
         }
         this.zewucadiz = null;
         _loc2_ = 0;
         while(_loc2_ < this.jecateceb.length)
         {
            _loc3_ = this.jecateceb[_loc2_];
            if(_loc3_ != null && _loc3_.length > 0)
            {
               this.tugak = _loc2_;
               while(this.zewucadiz == null && _loc3_.length > 0)
               {
                  this.zewucadiz = _loc3_.shift();
                  if(_loc2_ < sinemuc)
                  {
                     this.zewucadiz.diffuseMapURL = this.insertLow(this.zewucadiz.diffuseMapURL);
                  }
                  else
                  {
                     this.zewucadiz.diffuseMapURL = this.removeLow(this.zewucadiz.diffuseMapURL);
                  }
                  if(!makotubo[this.zewucadiz.diffuseMapURL])
                  {
                     this.bita.load(this.zewucadiz.diffuseMapURL,this.load);
                  }
                  else
                  {
                     this.addToUploadQueue(this.zewucadiz,makotubo[this.zewucadiz.diffuseMapURL],this.tugak);
                     this.zewucadiz = null;
                  }
               }
               if(this.zewucadiz != null)
               {
                  break;
               }
            }
            _loc2_++;
         }
         if(this.zewucadiz == null)
         {
            this.qahytenip = false;
         }
      }
      
      private function upload() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TextureQueueEntry = null;
         var _loc4_:uint = 0;
         if(this.cefegu.length > 0)
         {
            _loc1_ = uint(getTimer());
            _loc2_ = 0;
            while(_loc2_ < puran && this.cefegu.length > 0)
            {
               _loc3_ = this.cefegu.shift();
               _loc3_.upload();
               _loc3_.recycle();
               _loc4_ = uint(getTimer());
               _loc2_ += _loc4_ - _loc1_;
               _loc1_ = _loc4_;
            }
         }
         else
         {
            clearInterval(this.rirygyqic);
            this.rirygyqic = 0;
         }
      }
      
      private function insertLow(param1:String) : String
      {
         if(param1.indexOf("/low/") > 0)
         {
            return param1;
         }
         var _loc2_:int = param1.lastIndexOf("/");
         return param1.substr(0,_loc2_) + "/low/" + param1.substr(_loc2_ + 1);
      }
      
      private function removeLow(param1:String) : String
      {
         return param1.replace("/low/","/");
      }
   }
}

