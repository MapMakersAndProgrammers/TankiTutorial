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
   import alternativa.engine3d.alternativa3d;
   
   // XXX: needed to access an object3d function
   use namespace alternativa3d;

   public class StreamLightEffect extends PooledObject implements GraphicEffect
   {
      
      private static const STOP_DURATION:int = 250;
      
      protected var light:Light3D;
      
      protected var startAnimation:LightAnimation;
      
      protected var loopAnimation:LightAnimation;
      
      protected var racefom:int;
      
      protected var loopTime:int;
      
      protected var lilamasy:int;
      
      protected var time:int;
      
      protected var starting:Boolean;
      
      protected var positionProvider:Object3DPositionProvider;
      
      protected var alive:Boolean;
      
      protected var tize:int;
      
      protected var scale:Number;
      
      protected var stopping:Boolean;
      
      protected var stopTime:int;
      
      public function StreamLightEffect(param1:Pool, param2:Light3D)
      {
         super(param1);
         this.light = param2;
      }
      
      public function addedToScene(container:Object3DContainer) : void
      {
         container.addChild(this.light);
      }
      
      private function startLoop() : void
      {
         this.lilamasy = this.loopTime + (Math.random() * this.tize - this.tize / 2);
      }
      
      public function play(deltaTime:int, camera:GameCamera) : Boolean
      {
         var _loc3_:Number = NaN;
         if(!this.alive)
         {
            return false;
         }
         if(this.starting)
         {
            this.time += deltaTime;
            this.startAnimation.updateByTime(this.light,this.time,this.racefom);
            if(this.time >= this.racefom)
            {
               this.starting = false;
               this.time = 0;
               this.startLoop();
            }
         }
         else
         {
            this.time += deltaTime;
            if(this.time > this.lilamasy)
            {
               this.time %= this.lilamasy;
               this.startLoop();
            }
            this.loopAnimation.updateByTime(this.light,this.time,this.loopTime);
         }
         this.positionProvider.updateObjectPosition(this.light,camera,deltaTime);
         if(this.stopping)
         {
            this.stopTime += deltaTime;
            if(this.stopTime <= STOP_DURATION)
            {
               _loc3_ = 1 - this.stopTime / STOP_DURATION;
               this.light.intensity *= _loc3_;
            }
            else
            {
               this.light.intensity = 0;
               this.kill();
            }
         }
         return true;
      }
      
      public function destroy() : void
      {
         this.light.removeFromParent();
         this.startAnimation = null;
         this.loopAnimation = null;
         this.positionProvider = null;
      }
      
      public function kill() : void
      {
         this.alive = false;
      }
      
      public function stop() : void
      {
         this.stopping = true;
         this.stopTime = 0;
      }
   }
}

