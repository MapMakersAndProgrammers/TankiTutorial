package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is needed for some object3d properties
   use namespace alternativa3d;

   public final class AnimatedLightEffect extends PooledObject implements GraphicEffect
   {
      
      public static const nimowu:Number = 99999;
      
      public var qarehop:OmniLight;
      
      private var toz:Object3DPositionProvider;
      
      private var zeg:LightAnimation;
      
      private var wyzunime:int;
      
      private var sef:int;
      
      private var bol:Boolean;
      
      private var kat:Boolean;
      
      private var gog:Number;
      
      private var jawyn:Number;
      
      private var position:Vector3 = new Vector3();
      
      public function AnimatedLightEffect(param1:Pool)
      {
         super(param1);
         this.qarehop = new OmniLight(0,0,0);
      }
      
      public function init(param1:Object3DPositionProvider, param2:LightAnimation, param3:Number = 99999, param4:Boolean = false) : void
      {
         this.initFromTime(param1,param2.getLiveTime(),param2,param3,param4);
      }
      
      public function initFromTime(param1:Object3DPositionProvider, param2:int, param3:LightAnimation, param4:Number = 99999, param5:Boolean = false) : void
      {
         this.toz = param1;
         this.sef = param2;
         this.wyzunime = 0;
         this.zeg = param3;
         this.bol = param5;
         this.kat = true;
         this.gog = param4;
         this.jawyn = param4 / 4 * 3;
         param1.initPosition(this.qarehop);
      }
      
      public function initFromAnimation(param1:Object3DPositionProvider, param2:TextureAnimation, param3:LightAnimation, param4:Number = 99999, param5:Boolean = false) : void
      {
         this.initFromTime(param1,param2.qyvoladeg.length / param2.fps * 1000,param3,param4,param5);
      }
      
      public function addedToScene(param1:Object3DContainer) : void
      {
         param1.addChild(this.qarehop);
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this.kat)
         {
            this.zeg.updateByTime(this.qarehop,this.wyzunime,this.sef);
            this.toz.updateObjectPosition(this.qarehop,param2,param1);
            this.wyzunime += param1;
            if(this.wyzunime > this.sef)
            {
               if(this.bol)
               {
                  this.wyzunime %= this.sef;
               }
               else
               {
                  this.kat = false;
               }
            }
            this.position.x = this.qarehop.x;
            this.position.y = this.qarehop.y;
            this.position.z = this.qarehop.z;
            _loc3_ = Number(this.position.distanceTo(param2.position));
            if(_loc3_ > this.jawyn)
            {
               _loc4_ = 1 - (_loc3_ - this.jawyn) / (this.gog - this.jawyn);
               this.qarehop.intensity *= _loc4_;
               this.qarehop.visible = _loc3_ < this.gog;
            }
            return this.kat;
         }
         return false;
      }
      
      public function destroy() : void
      {
         this.qarehop.removeFromParent();
         this.zeg = null;
         this.toz = null;
      }
      
      public function kill() : void
      {
         this.kat = false;
      }
   }
}

