package alternativa.tanks.sfx.flamethrower
{
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.AnimatedSprite3D;
   import flash.geom.ColorTransform;
   
   public class StreamWeaponParticle extends AnimatedSprite3D
   {
      
      private static var resym:int = 20;
      
      private static var hybuhy:Vector.<StreamWeaponParticle> = new Vector.<StreamWeaponParticle>(resym);
      
      private static var byqe:int = -1;
      
      public var zerus:Vector3 = new Vector3();
      
      public var hyn:Number = 0;
      
      public var tyfu:Number;
      
      public var huved:int;
      
      public function StreamWeaponParticle()
      {
         super(100,100);
         softAttenuation = 100;
         colorTransform = new ColorTransform();
      }
      
      public static function getParticle() : StreamWeaponParticle
      {
         if(byqe == -1)
         {
            return new StreamWeaponParticle();
         }
         var _loc1_:StreamWeaponParticle = hybuhy[byqe];
         hybuhy[byqe--] = null;
         return _loc1_;
      }
      
      private static function interpolateColorTransform(param1:ColorTransformEntry, param2:ColorTransformEntry, param3:Number, param4:ColorTransform) : void
      {
         param4.alphaMultiplier = param1.fidemujil + param3 * (param2.fidemujil - param1.fidemujil);
         param4.alphaOffset = param1.jadig + param3 * (param2.jadig - param1.jadig);
         param4.redMultiplier = param1.kukuv + param3 * (param2.kukuv - param1.kukuv);
         param4.redOffset = param1.goror + param3 * (param2.goror - param1.goror);
         param4.greenMultiplier = param1.bofo + param3 * (param2.bofo - param1.bofo);
         param4.greenOffset = param1.ruh + param3 * (param2.ruh - param1.ruh);
         param4.blueMultiplier = param1.zybyjaweb + param3 * (param2.zybyjaweb - param1.zybyjaweb);
         param4.blueOffset = param1.totejigi + param3 * (param2.totejigi - param1.totejigi);
      }
      
      private static function copyStructToColorTransform(param1:ColorTransformEntry, param2:ColorTransform) : void
      {
         param2.alphaMultiplier = param1.fidemujil;
         param2.alphaOffset = param1.jadig;
         param2.redMultiplier = param1.kukuv;
         param2.redOffset = param1.goror;
         param2.greenMultiplier = param1.bofo;
         param2.greenOffset = param1.ruh;
         param2.blueMultiplier = param1.zybyjaweb;
         param2.blueOffset = param1.totejigi;
      }
      
      public function dispose() : void
      {
         removeFromParent();
         clear();
         hybuhy[++byqe] = this;
      }
      
      public function updateColorTransofrm(param1:Number, param2:Vector.<ColorTransformEntry>) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:ColorTransformEntry = null;
         var _loc5_:ColorTransformEntry = null;
         var _loc6_:int = 0;
         if(param2 != null)
         {
            _loc3_ = this.hyn / param1;
            if(_loc3_ <= 0)
            {
               _loc4_ = param2[0];
               copyStructToColorTransform(_loc4_,colorTransform);
            }
            else if(_loc3_ >= 1)
            {
               _loc4_ = param2[param2.length - 1];
               copyStructToColorTransform(_loc4_,colorTransform);
            }
            else
            {
               _loc6_ = 1;
               _loc4_ = param2[0];
               _loc5_ = param2[1];
               while(_loc5_.jomuc < _loc3_)
               {
                  _loc6_++;
                  _loc4_ = _loc5_;
                  _loc5_ = param2[_loc6_];
               }
               _loc3_ = (_loc3_ - _loc4_.jomuc) / (_loc5_.jomuc - _loc4_.jomuc);
               interpolateColorTransform(_loc4_,_loc5_,_loc3_,colorTransform);
            }
            alpha = colorTransform.alphaMultiplier;
         }
      }
   }
}

