package tutorial.loader
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.tanks.sfx.TextureAnimation;
   import alternativa.tanks.utils.GraphicsUtils;
   import flash.display.BitmapData;
   import tutorial.commons.Assets;
   
   public class EffectsLoader extends TanksLoader
   {
      
      private var hobuna:Vector.<XML>;
      
      private var luwuqap:String;
      
      private var dodycoli:int;
      
      public function EffectsLoader()
      {
         super();
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.effects.length() > 0;
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         var _loc5_:XML = null;
         this.pomagu = param2.effects[0];
         this.hon = param3;
         this.hobuna = new Vector.<XML>();
         this.dodycoli = 0;
         this.luwuqap = param1 + pomagu.@baseURL;
         var _loc4_:int = 0;
         for each(_loc5_ in pomagu.elements("effect"))
         {
            this.hobuna[_loc4_] = _loc5_;
            _loc4_++;
         }
         this.loadEffect();
      }
      
      private function loadEffect() : void
      {
         if(this.dodycoli < this.hobuna.length)
         {
            if(Assets.hasData(this.hobuna[this.dodycoli].@id.toString(),TextureAnimation))
            {
               ++this.dodycoli;
               this.loadEffect();
            }
            else
            {
               julicoj = this.luwuqap + this.hobuna[this.dodycoli].@url.toString();
               bita.load(this.luwuqap + this.hobuna[this.dodycoli].@url.toString(),this.saveBitmap);
            }
         }
         else if(hon != null)
         {
            hon();
         }
      }
      
      private function saveBitmap(param1:BitmapData) : void
      {
         var _loc2_:XML = null;
         var _loc3_:TextureMaterial = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param1 != null)
         {
            _loc2_ = this.hobuna[this.dodycoli];
            _loc3_ = new TextureMaterial(param1,false,true,MipMapping.NONE,2.5);
            _loc4_ = _loc2_.@frameWidth > 0 ? Number(_loc2_.@frameWidth) : param1.height;
            _loc5_ = _loc2_.@frameHeight > 0 ? Number(_loc2_.@frameHeight) : param1.height;
            Assets.saveData(_loc2_.@id.toString(),new TextureAnimation(_loc3_,GraphicsUtils.getUVFramesFromTexture(param1,_loc4_,_loc5_,_loc2_.@numFrames),_loc2_.@fps > 0 ? Number(_loc2_.@fps) : 30),TextureAnimation);
         }
         ++this.dodycoli;
         this.loadEffect();
      }
   }
}

