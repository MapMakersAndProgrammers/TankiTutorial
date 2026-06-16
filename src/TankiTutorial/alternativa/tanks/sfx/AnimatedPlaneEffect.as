package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import alternativa.tanks.utils.objectpool.Pool;
   import alternativa.engine3d.alternativa3d;
   
   // XXX: this is for some object3d property
   use namespace alternativa3d;

   public class AnimatedPlaneEffect extends PooledObject implements GraphicEffect
   {
      
      private static const hydobym:Number = 100;
      
      private var tytofu:Number;
      
      private var scale:Number;
      
      private var zeqowas:Number;
      
      private var gefeci:AnimatedPlane;
      
      private var wyzunime:int;
      
      private var davaqymev:int;
      
      public function AnimatedPlaneEffect(param1:Pool)
      {
         super(param1);
         this.gefeci = new AnimatedPlane(hydobym);
      }
      
      public function init(param1:Number, param2:Vector3, param3:Vector3, param4:Number, param5:TextureAnimation, param6:Number) : void
      {
         this.gefeci.init(param5,0.001 * param4);
         this.davaqymev = this.gefeci.getOneLoopTime();
         this.wyzunime = 0;
         this.tytofu = 0.001 * param6;
         this.zeqowas = param1 / hydobym;
         this.scale = this.zeqowas;
         this.gefeci.x = param2.x;
         this.gefeci.y = param2.y;
         this.gefeci.z = param2.z;
         this.gefeci.rotationX = param3.x;
         this.gefeci.rotationY = param3.y;
         this.gefeci.rotationZ = param3.z;
      }
      
      public function addedToScene(param1:Object3DContainer) : void
      {
         param1.addChild(this.gefeci);
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         if(this.wyzunime >= this.davaqymev)
         {
            return false;
         }
         this.gefeci.setTime(this.wyzunime);
         this.wyzunime += param1;
         this.gefeci.scaleX = this.scale;
         this.gefeci.scaleY = this.scale;
         this.scale += this.zeqowas * this.tytofu * param1;
         return true;
      }
      
      public function destroy() : void
      {
         this.gefeci.removeFromParent();
         this.gefeci.clear();
         recycle();
      }
      
      public function kill() : void
      {
         this.wyzunime = this.davaqymev;
      }
   }
}

