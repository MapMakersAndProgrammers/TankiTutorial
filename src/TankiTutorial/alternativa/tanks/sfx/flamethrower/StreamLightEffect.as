package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.tanks.sfx.GraphicEffect;
   import alternativa.tanks.sfx.LightAnimation;
   import alternativa.tanks.sfx.Object3DPositionProvider;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class StreamLightEffect extends PooledObject implements GraphicEffect
   {
      
      private static const puludaqy:int = 250;
      
      protected var qarehop:Light3D;
      
      protected var zituciky:LightAnimation;
      
      protected var ged:LightAnimation;
      
      protected var racefom:int;
      
      protected var bibe:int;
      
      protected var lilamasy:int;
      
      protected var wyzunime:int;
      
      protected var dozalij:Boolean;
      
      protected var toz:Object3DPositionProvider;
      
      protected var kat:Boolean;
      
      protected var tize:int;
      
      protected var scale:Number;
      
      protected var rawo:Boolean;
      
      protected var jam:int;
      
      public function StreamLightEffect(param1:Pool, param2:Light3D)
      {
         super(param1);
         this.qarehop = param2;
      }
      
      public function addedToScene(param1:Object3DContainer) : void
      {
         param1.addChild(this.qarehop);
      }
      
      private function startLoop() : void
      {
         this.lilamasy = this.bibe + (Math.random() * this.tize - this.tize / 2);
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         var _loc3_:Number = NaN;
         if(!this.kat)
         {
            return false;
         }
         if(this.dozalij)
         {
            this.wyzunime += param1;
            this.zituciky.updateByTime(this.qarehop,this.wyzunime,this.racefom);
            if(this.wyzunime >= this.racefom)
            {
               this.dozalij = false;
               this.wyzunime = 0;
               this.startLoop();
            }
         }
         else
         {
            this.wyzunime += param1;
            if(this.wyzunime > this.lilamasy)
            {
               this.wyzunime %= this.lilamasy;
               this.startLoop();
            }
            this.ged.updateByTime(this.qarehop,this.wyzunime,this.bibe);
         }
         this.toz.updateObjectPosition(this.qarehop,param2,param1);
         if(this.rawo)
         {
            this.jam += param1;
            if(this.jam <= puludaqy)
            {
               _loc3_ = 1 - this.jam / puludaqy;
               this.qarehop.intensity *= _loc3_;
            }
            else
            {
               this.qarehop.intensity = 0;
               this.kill();
            }
         }
         return true;
      }
      
      public function destroy() : void
      {
         this.qarehop.removeFromParent();
         this.zituciky = null;
         this.ged = null;
         this.toz = null;
      }
      
      public function kill() : void
      {
         this.kat = false;
      }
      
      public function stop() : void
      {
         this.rawo = true;
         this.jam = 0;
      }
   }
}

