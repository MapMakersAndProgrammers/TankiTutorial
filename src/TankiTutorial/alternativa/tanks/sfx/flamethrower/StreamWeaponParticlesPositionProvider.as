package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.tanks.sfx.Object3DPositionProvider;
   import alternativa.tanks.sfx.CollisionObject3DPositionProvider;
   
   public class StreamWeaponParticlesPositionProvider extends PooledObject implements Object3DPositionProvider
   {
      
      private var gucoqub:StreamWeaponGraphicEffect;
      
      private var podelidi:CollisionObject3DPositionProvider;
      
      private var zedyhitem:Array = [0.1,0.3,0.5,0.8,0.9,1];
      
      private var logigap:Array = [0.5,0.8,1,0.5,0.3,0.05];
      
      public function StreamWeaponParticlesPositionProvider(param1:Pool)
      {
         super(param1);
      }
      
      public function init(param1:StreamWeaponGraphicEffect, param2:CollisionObject3DPositionProvider) : void
      {
         this.gucoqub = param1;
         this.podelidi = param2;
      }
      
      public function initPosition(param1:Object3D) : void
      {
         var _loc6_:Vector.<StreamWeaponParticle> = null;
         var _loc7_:int = 0;
         var _loc8_:StreamWeaponParticle = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         if(this.gucoqub.numParticles == 0)
         {
            this.podelidi.initPosition(param1);
         }
         else
         {
            _loc6_ = this.gucoqub.particles;
            _loc7_ = 0;
            while(_loc7_ < this.gucoqub.numParticles)
            {
               _loc8_ = _loc6_[_loc7_];
               _loc9_ = _loc8_.hyn / this.gucoqub.range;
               _loc10_ = this.getWeight(_loc9_);
               _loc5_ += _loc10_;
               _loc2_ += _loc8_.x * _loc10_;
               _loc3_ += _loc8_.y * _loc10_;
               _loc4_ += _loc8_.z * _loc10_;
               _loc7_++;
            }
            _loc2_ /= _loc5_;
            _loc3_ /= _loc5_;
            _loc4_ /= _loc5_;
            param1.x = _loc2_;
            param1.y = _loc3_;
            param1.z = _loc4_;
         }
      }
      
      private function getWeight(param1:Number) : Number
      {
         var _loc3_:Number = NaN;
         var _loc2_:int = 0;
         while(_loc2_ < this.zedyhitem.length)
         {
            _loc3_ = Number(this.zedyhitem[_loc2_]);
            if(_loc3_ >= param1)
            {
               return this.logigap[_loc2_];
            }
            _loc2_++;
         }
         return 0;
      }
      
      public function updateObjectPosition(param1:Object3D, param2:GameCamera, param3:int) : void
      {
         this.initPosition(param1);
      }
      
      public function destroy() : void
      {
         this.gucoqub = null;
         this.podelidi = null;
      }
   }
}

