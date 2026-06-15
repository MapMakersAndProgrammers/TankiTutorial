package tutorial.tasks
{
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.controllers.CommonTankController;
   import alternativa.utils.MathUtils;
   import tutorial.GameData;
   import tutorial.TimeData;
   
   public class EnemyTankTask extends CommonEnemyTask
   {
      
      private static const veco:Number = Math.cos(MathUtils.toRadians(25));
      
      private static const nuzofaqi:Number = MathUtils.toRadians(10);
      
      private static const tifot:Vector3 = new Vector3();
      
      private var qaf:Vector.<Vector3>;
      
      private var sesupi:int;
      
      private var dom:Sprite3D;
      
      private var pebi:Vector3;
      
      private var range:Number = 800;
      
      private var foc:Vector3 = new Vector3();
      
      public function EnemyTankTask(param1:String, param2:String, param3:String, param4:Vector3, param5:Quaternion, param6:Vector.<Vector3>, param7:Number = 0, param8:Number = 1, param9:Function = null, param10:uint = 3000, param11:Boolean = false, param12:Vector3 = null)
      {
         super(param1,param2,param3,param4,param5,param7,param8,param9,param10,param11);
         this.qaf = param6;
         this.pebi = param12;
      }
      
      override protected function onInit() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(this.pebi != null)
         {
            _loc1_ = Number(GameData.jifom.kuca.hullMesh.x);
            _loc2_ = Number(GameData.jifom.kuca.hullMesh.y);
            _loc3_ = (_loc1_ - this.pebi.x) * (_loc1_ - this.pebi.x) + (_loc2_ - this.pebi.y) * (_loc2_ - this.pebi.y);
            if(_loc3_ < this.range * this.range)
            {
               super.onInit();
            }
         }
         else
         {
            super.onInit();
         }
      }
      
      override protected function onExecute() : void
      {
         var _loc3_:Tank = null;
         var _loc4_:Vector3 = null;
         var _loc5_:Vector3 = null;
         var _loc6_:Number = NaN;
         var _loc7_:Matrix3 = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc1_:uint = 0;
         if(this.sesupi < this.qaf.length)
         {
            _loc3_ = citacir;
            _loc4_ = _loc3_.body.kejo.position;
            _loc5_ = this.qaf[this.sesupi];
            this.foc.x = _loc5_.x - _loc4_.x;
            this.foc.y = _loc5_.y - _loc4_.y;
            this.foc.qyririg = 0;
            _loc6_ = this.foc.x * this.foc.x + this.foc.y * this.foc.y;
            this.foc.normalize();
            _loc7_ = _loc3_.body.jefe;
            tifot.x = _loc7_.cydop;
            tifot.y = _loc7_.qanezycap;
            tifot.normalize();
            _loc8_ = tifot.x * this.foc.y - tifot.y * this.foc.x;
            _loc9_ = Math.asin(_loc8_);
            _loc10_ = Number(_loc3_.body.kejo.fev.qyririg);
            _loc11_ = _loc9_ + _loc10_ * GameData.lecopojen.ziqod;
            if(Math.cos(_loc11_) > veco)
            {
               _loc1_ |= 1 << CommonTankController.cyjeruqa;
            }
            if(_loc6_ < 110000)
            {
               ++this.sesupi;
               if(this.sesupi == this.qaf.length)
               {
                  if(hefine)
                  {
                     this.sesupi = 0;
                  }
                  else
                  {
                     _loc1_ = 0;
                     if(kejo < hukozi)
                     {
                        kejo = cenebah;
                     }
                  }
                  return;
               }
            }
            if(MathUtils.sign(_loc11_) == MathUtils.sign(_loc9_))
            {
               if(Math.abs(_loc11_) > Math.PI)
               {
                  if(_loc10_ > 0)
                  {
                     _loc1_ |= 1 << CommonTankController.dudazodol;
                  }
                  else if(_loc10_ < 0)
                  {
                     _loc1_ |= 1 << CommonTankController.qij;
                  }
               }
               else if(Math.abs(_loc11_) > nuzofaqi)
               {
                  if(_loc9_ > 0)
                  {
                     _loc1_ |= 1 << CommonTankController.dudazodol;
                  }
                  else
                  {
                     _loc1_ |= 1 << CommonTankController.qij;
                  }
               }
            }
         }
         var _loc2_:TimeData = GameData.lecopojen;
         CommonTankController(controller).setAction(_loc1_ | tryShoot(_loc2_.lecopojen));
      }
      
      override protected function onDecoy() : void
      {
         super.onDecoy();
      }
   }
}

