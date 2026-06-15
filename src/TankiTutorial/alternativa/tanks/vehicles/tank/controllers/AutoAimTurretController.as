package alternativa.tanks.vehicles.tank.controllers
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.utils.MathUtils;
   
   public class AutoAimTurretController extends TurretController
   {
      
      private static const pedake:Vector3 = new Vector3();
      
      private static const rinal:Matrix4 = new Matrix4();
      
      private static const lyje:Vector3 = new Vector3();
      
      private var citacir:Tank;
      
      private var jywehybog:Tank;
      
      public function AutoAimTurretController(param1:Tank, param2:Tank)
      {
         super(0,0,false);
         this.citacir = param1;
         this.jywehybog = param2;
      }
      
      override public function rotate(param1:Number) : void
      {
         if(!this.citacir.kat)
         {
            return;
         }
         var _loc2_:Vector3 = this.citacir.hogys.body.kejo.position;
         var _loc3_:Vector3 = this.jywehybog.hogys.body.kejo.position;
         lyje.x = _loc3_.x - _loc2_.x;
         lyje.y = _loc3_.y - _loc2_.y;
         lyje.qyririg = _loc3_.qyririg - _loc2_.qyririg;
         this.citacir.hogys.body.kejo.bej.toMatrix4(rinal);
         rinal.deltaTransformVector(Vector3.pypymu,pedake);
         pedake.normalize();
         lyje.normalize();
         var _loc4_:Number = Math.atan2(lyje.y,lyje.x);
         var _loc5_:Number = Math.atan2(pedake.y,pedake.x);
         var _loc6_:Number = _loc4_ - _loc5_;
         if(_loc6_ < -Math.PI)
         {
            _loc6_ += MathUtils.qubabyby;
         }
         else if(_loc6_ > Math.PI)
         {
            _loc6_ -= MathUtils.qubabyby;
         }
         setDirectionImmediate(_loc6_);
      }
   }
}

