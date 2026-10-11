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
      
      private var graphicEffect:StreamWeaponGraphicEffect;
      
      private var collisionPositionProvider:CollisionObject3DPositionProvider;
      
      private var distances:Array = [0.1,0.3,0.5,0.8,0.9,1];
      
      private var weights:Array = [0.5,0.8,1,0.5,0.3,0.05];
      
      public function StreamWeaponParticlesPositionProvider(param1:Pool)
      {
         super(param1);
      }
      
      public function init(param1:StreamWeaponGraphicEffect, param2:CollisionObject3DPositionProvider) : void
      {
         this.graphicEffect = param1;
         this.collisionPositionProvider = param2;
      }
      
      public function initPosition(object:Object3D) : void
      {
         var particles:Vector.<StreamWeaponParticle> = null;
         var i:int = 0;
         var particle:StreamWeaponParticle = null;
         var t:Number = NaN;
         var weight:Number = NaN;
         var x:Number = 0;
         var y:Number = 0;
         var z:Number = 0;
         var totalWeight:Number = 0;
         if(this.graphicEffect.numParticles == 0)
         {
            this.collisionPositionProvider.initPosition(object);
         }
         else
         {
            particles = this.graphicEffect.particles;
            i = 0;
            while(i < this.graphicEffect.numParticles)
            {
               particle = particles[i];
               t = particle.flightDistance / this.graphicEffect.range;
               weight = this.getWeight(t);
               totalWeight += weight;
               x += particle.x * weight;
               y += particle.y * weight;
               z += particle.z * weight;
               i++;
            }
            x /= totalWeight;
            y /= totalWeight;
            z /= totalWeight;
            object.x = x;
            object.y = y;
            object.z = z;
         }
      }
      
      private function getWeight(t:Number) : Number
      {
         var distance:Number = NaN;
         var i:int = 0;
         while(i < this.distances.length)
         {
            distance = Number(this.distances[i]);
            if(distance >= t)
            {
               return this.weights[i];
            }
            i++;
         }
         return 0;
      }
      
      public function updateObjectPosition(object:Object3D, camera:GameCamera, deltaTime:int) : void
      {
         this.initPosition(object);
      }
      
      public function destroy() : void
      {
         this.graphicEffect = null;
         this.collisionPositionProvider = null;
      }
   }
}

