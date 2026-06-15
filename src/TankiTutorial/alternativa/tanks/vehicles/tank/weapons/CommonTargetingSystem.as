package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.physics.CollisionGroup;
   
   public class CommonTargetingSystem
   {
      
      private static const sowe:int = CollisionGroup.deli;
      
      private static const gijalatyt:Matrix3 = new Matrix3();
      
      private static const sudak:Vector3 = new Vector3();
      
      private static const zewufyg:Vector3 = new Vector3();
      
      private static const wonuhig:RayHit = new RayHit();
      
      private var maxDistance:Number;
      
      private var kerahe:Number;
      
      private var tywoneziw:int;
      
      private var cahyv:Number;
      
      private var mojy:int;
      
      private var kymaqos:CollisionDetector;
      
      private var ryzodu:CommonTargetEvaluator;
      
      private var qemub:Number;
      
      private var sapywevis:Body;
      
      private var qesaput:Number;
      
      private var hywyvi:Vector3 = new Vector3();
      
      private var lefugefo:Vector3 = new Vector3();
      
      private var woz:CommonRayCollisionFilter = new CommonRayCollisionFilter();
      
      public function CommonTargetingSystem(param1:Number, param2:Number, param3:int, param4:Number, param5:int, param6:CollisionDetector, param7:CommonTargetEvaluator)
      {
         super();
         this.maxDistance = param1;
         this.kerahe = param2;
         this.tywoneziw = param3;
         this.cahyv = param4;
         this.mojy = param5;
         this.kymaqos = param6;
         this.ryzodu = param7;
      }
      
      public function getTarget(param1:Vector3, param2:Vector3, param3:Vector3, param4:Body, param5:Number, param6:HitInfo) : Boolean
      {
         var _loc8_:Body = null;
         this.qemub = 0;
         this.qesaput = this.maxDistance + 1;
         this.sapywevis = null;
         this.woz.bowe = param4;
         var _loc7_:Number = this.kerahe > this.cahyv ? this.kerahe : this.cahyv;
         if(this.kymaqos.raycast(param1,param2,sowe,this.maxDistance,this.woz,wonuhig))
         {
            this.lefugefo.copy(wonuhig.lefugefo);
            this.hywyvi.copy(param2);
            this.qesaput = wonuhig.jomuc;
            _loc8_ = wonuhig.vetudozi.body;
            if(_loc8_ != null)
            {
               this.sapywevis = _loc8_;
               this.qemub = this.ryzodu.getTargetPriority(_loc8_,this.qesaput,0,param5,_loc7_);
            }
         }
         if(this.tywoneziw > 0)
         {
            this.checkSector(param1,param2,param3,this.tywoneziw,this.kerahe / this.tywoneziw,param5,_loc7_);
         }
         if(this.mojy > 0)
         {
            this.checkSector(param1,param2,param3,this.mojy,-this.cahyv / this.mojy,param5,_loc7_);
         }
         this.woz.bowe = null;
         if(this.qesaput <= this.maxDistance)
         {
            param6.jomuc = this.qesaput;
            param6.bec.copy(this.hywyvi);
            param6.wimybu.copy(param1).addScaled(this.qesaput,this.hywyvi);
            param6.body = this.sapywevis;
            this.sapywevis = null;
            return true;
         }
         return false;
      }
      
      private function checkSector(param1:Vector3, param2:Vector3, param3:Vector3, param4:int, param5:Number, param6:Number, param7:Number) : void
      {
         var _loc10_:Body = null;
         var _loc11_:Number = NaN;
         gijalatyt.fromAxisAngle(param3,param5);
         if(param5 < 0)
         {
            param5 = -param5;
         }
         zewufyg.copy(param2);
         var _loc8_:Number = 0;
         var _loc9_:int = 1;
         while(_loc9_ <= param4)
         {
            _loc8_ += param5;
            sudak.copy(zewufyg);
            gijalatyt.transformVector(sudak,zewufyg);
            if(this.kymaqos.raycast(param1,zewufyg,sowe,this.maxDistance,this.woz,wonuhig))
            {
               _loc10_ = wonuhig.vetudozi.body;
               if(_loc10_ != null)
               {
                  _loc11_ = this.ryzodu.getTargetPriority(_loc10_,wonuhig.jomuc,_loc8_,param6,param7);
                  if(_loc11_ > this.qemub)
                  {
                     this.qemub = _loc11_;
                     this.sapywevis = _loc10_;
                     this.hywyvi.copy(zewufyg);
                     this.qesaput = wonuhig.jomuc;
                  }
               }
            }
            _loc9_++;
         }
      }
   }
}

