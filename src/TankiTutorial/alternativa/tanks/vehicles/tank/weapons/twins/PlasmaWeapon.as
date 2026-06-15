package alternativa.tanks.vehicles.tank.weapons.twins
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.CollisionDetector;
   import alternativa.physics.collision.types.RayHit;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.sfx.twins.PlasmaEffects;
   import alternativa.tanks.sfx.twins.PlasmaShot;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.vehicles.tank.Tank;
   import alternativa.tanks.vehicles.tank.weapons.*;
   import flash.utils.getTimer;
   import tutorial.GameData;
   
   public class PlasmaWeapon extends Weapon
   {
      
      private static const qumuvup:Vector3 = new Vector3();
      
      private static const vimub:HitInfo = new HitInfo();
      
      private static const wonuhig:RayHit = new RayHit();
      
      private var goc:int;
      
      private var namekazaf:CommonTargetingSystem;
      
      private var kafe:int;
      
      private var nubedut:int;
      
      private var kymaqos:CollisionDetector = GameData.kymaqos;
      
      private var murow:ObjectPool = GameData.murow;
      
      private var syli:WeaponSettings;
      
      private var hobuna:PlasmaEffects;
      
      public function PlasmaWeapon(param1:WeaponSettings, param2:CommonTargetingSystem, param3:PlasmaEffects, param4:int)
      {
         super("Plasma");
         this.syli = param1;
         this.namekazaf = param2;
         this.hobuna = param3;
         this.kafe = param4;
      }
      
      override public function get status() : Number
      {
         var _loc1_:Number = 1 - (this.goc - getTimer()) / this.syli.qyvynefi;
         return _loc1_ > 1 ? 1 : _loc1_;
      }
      
      override public function update(param1:int, param2:int) : void
      {
         if(zadawe && param1 >= this.goc)
         {
            this.shoot();
         }
      }
      
      override public function getTarget() : Tank
      {
         var _loc1_:TurretData = getData();
         var _loc2_:Tank = getTank();
         _loc1_.update(_loc2_,0);
         if(this.namekazaf.getTarget(_loc1_.fybumu,_loc1_.ruda,_loc1_.zequsir,_loc2_.hogys.body,10000000000,vimub))
         {
            if(vimub.body != null)
            {
               return vimub.body.katuf as Tank;
            }
         }
         return null;
      }
      
      private function shoot() : void
      {
         this.goc = getTimer() + this.syli.qyvynefi;
         var _loc1_:Tank = getTank();
         var _loc2_:Mesh = _loc1_.kuca.turretMesh;
         var _loc3_:Vector3 = _loc1_.firaqe.jun[this.nubedut];
         var _loc4_:TurretData = getData();
         _loc4_.update(_loc1_,this.nubedut);
         _loc1_.hogys.body.addWorldForceScaled(_loc4_.symamume,_loc4_.ruda,-this.syli.pocobyr);
         this.hobuna.createShotEffects(_loc2_,_loc1_.firaqe.jun[this.nubedut]);
         if(this.barrelCollidesWithStatic(_loc4_.fybumu,_loc4_.ruda,_loc3_.y))
         {
            qumuvup.copy(_loc4_.ruda);
         }
         else if(this.namekazaf.getTarget(_loc4_.fybumu,_loc4_.ruda,_loc4_.zequsir,_loc1_.hogys.body,10000000000,vimub))
         {
            qumuvup.diff(vimub.wimybu,_loc4_.symamume).normalize();
         }
         else
         {
            qumuvup.copy(_loc4_.ruda);
         }
         var _loc5_:PlasmaShot = PlasmaShot(this.murow.getObject(PlasmaShot));
         _loc5_.init(this.syli.myd,this.syli.beryfitu * kuqy);
         _loc5_.addToGame(_loc4_.fybumu,_loc4_.symamume,qumuvup,_loc1_.hogys.body);
         this.nubedut = (this.nubedut + 1) % this.kafe;
      }
      
      private function barrelCollidesWithStatic(param1:Vector3, param2:Vector3, param3:Number) : Boolean
      {
         return this.kymaqos.raycastStatic(param1,param2,CollisionGroup.neli,param3,null,wonuhig);
      }
   }
}

