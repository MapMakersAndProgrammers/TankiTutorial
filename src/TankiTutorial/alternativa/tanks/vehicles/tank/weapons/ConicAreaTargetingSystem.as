package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.physics.CollisionGroup;
   import flash.utils.Dictionary;
   
   public class ConicAreaTargetingSystem
   {
      
      private static const sowe:int = CollisionGroup.deli;
      
      private static const vyhomopog:Vector3 = new Vector3();
      
      private var range:Number;
      
      private var lomusipu:Number;
      
      private var wavi:int;
      
      private var zogefyv:int;
      
      private var kymaqos:CollisionDetector;
      
      private var dugojame:ConicAreaTargetValidator;
      
      private const dibi:Vector3 = new Vector3();
      
      private const gijalatyt:Matrix3 = new Matrix3();
      
      private const gizynuzelu:Matrix3 = new Matrix3();
      
      private const wonuhig:RayHit = new RayHit();
      
      private const woz:ConicTargetingCollisionFilter = new ConicTargetingCollisionFilter();
      
      private const janimamu:Vector3 = new Vector3();
      
      private const symamume:Vector3 = new Vector3();
      
      private var pezacu:Dictionary;
      
      public function ConicAreaTargetingSystem(param1:Number, param2:Number, param3:int, param4:int, param5:CollisionDetector, param6:ConicAreaTargetValidator)
      {
         super();
         this.range = param1;
         this.lomusipu = 0.5 * param2;
         this.wavi = param3;
         this.zogefyv = param4;
         this.kymaqos = param5;
         this.dugojame = param6;
      }
      
      public function getTargets(param1:Body, param2:Number, param3:Number, param4:Vector3, param5:Vector3, param6:Vector3, param7:Vector.<Body>, param8:Vector.<Number>) : void
      {
         var _loc15_:* = undefined;
         var _loc16_:Number = NaN;
         this.woz.wyd = param1;
         this.pezacu = new Dictionary();
         var _loc9_:Number = param3 * param2;
         var _loc10_:Number = param2 - _loc9_;
         if(this.kymaqos.raycast(param4,param5,sowe,param2,this.woz,this.wonuhig) && this.wonuhig.vetudozi.body == null)
         {
            return;
         }
         this.dibi.copy(param6);
         this.symamume.copy(param4).addScaled(_loc9_,param5);
         var _loc11_:Number = this.range + _loc10_;
         this.processRay(this.symamume,param5,_loc11_);
         this.gizynuzelu.fromAxisAngle(param5,Math.PI / this.zogefyv);
         var _loc12_:Number = this.lomusipu / this.wavi;
         var _loc13_:int = 0;
         while(_loc13_ < this.zogefyv)
         {
            this.processSector(this.symamume,param5,this.dibi,_loc11_,this.wavi,_loc12_);
            this.processSector(this.symamume,param5,this.dibi,_loc11_,this.wavi,-_loc12_);
            this.dibi.transform3(this.gizynuzelu);
            _loc13_++;
         }
         var _loc14_:int = 0;
         for(_loc15_ in this.pezacu)
         {
            param7[_loc14_] = _loc15_;
            _loc16_ = this.pezacu[_loc15_] - _loc10_;
            if(_loc16_ < 0)
            {
               _loc16_ = 0;
            }
            param8[_loc14_] = _loc16_;
            _loc14_++;
         }
         param7.length = _loc14_;
         param8.length = _loc14_;
         this.woz.wyd = null;
         this.woz.clearInvalidTargets();
         this.pezacu = null;
      }
      
      private function processSector(param1:Vector3, param2:Vector3, param3:Vector3, param4:Number, param5:int, param6:Number) : void
      {
         var _loc7_:Number = 0;
         var _loc8_:int = 0;
         while(_loc8_ < param5)
         {
            _loc7_ += param6;
            this.gijalatyt.fromAxisAngle(param3,_loc7_);
            this.gijalatyt.transformVector(param2,this.janimamu);
            this.processRay(param1,this.janimamu,param4);
            _loc8_++;
         }
      }
      
      private function processRay(param1:Vector3, param2:Vector3, param3:Number) : void
      {
         var _loc5_:Body = null;
         var _loc6_:Number = NaN;
         vyhomopog.copy(param1);
         var _loc4_:Number = 0;
         while(param3 > 0.1)
         {
            if(!this.kymaqos.raycast(vyhomopog,param2,sowe,param3,this.woz,this.wonuhig))
            {
               break;
            }
            _loc5_ = this.wonuhig.vetudozi.body;
            if(_loc5_ == null)
            {
               break;
            }
            vyhomopog.addScaled(this.wonuhig.jomuc,param2);
            _loc4_ += this.wonuhig.jomuc;
            if(this.dugojame.isValidTarget(_loc5_))
            {
               this.woz.addTarget(_loc5_);
               _loc6_ = Number(this.pezacu[_loc5_]);
               if(isNaN(_loc6_) || _loc6_ > _loc4_)
               {
                  this.pezacu[_loc5_] = _loc4_;
               }
            }
            else
            {
               this.woz.addInvalidTarget(_loc5_);
            }
            param3 -= this.wonuhig.jomuc;
         }
         this.woz.clearTargets();
      }
   }
}

