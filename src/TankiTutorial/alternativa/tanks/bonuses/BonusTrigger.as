package alternativa.tanks.bonuses
{
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.tanks.battle.BattleRunner;
   import alternativa.tanks.battle.Trigger;
   import alternativa.tanks.physics.CollisionGroup;
   
   public class BonusTrigger implements Trigger
   {
      
      private var nasybugo:BattleBonus;
      
      private var pyp:CollisionBox;
      
      private var battleRunner:BattleRunner;
      
      public function BonusTrigger(param1:BattleBonus)
      {
         super();
         this.nasybugo = param1;
         var _loc2_:Number = BonusConst.numij;
         this.pyp = new CollisionBox(new Vector3(_loc2_,_loc2_,_loc2_),CollisionGroup.BONUS,PhysicsMaterial.defaultMaterial);
      }
      
      public function enable(param1:BattleRunner) : void
      {
         if(this.battleRunner == null)
         {
            this.battleRunner = param1;
            param1.addTrigger(this);
         }
      }
      
      public function disable() : void
      {
         if(this.battleRunner != null)
         {
            this.battleRunner.removeTrigger(this);
            this.battleRunner = null;
         }
      }
      
      public function update(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         var _loc7_:Matrix4 = this.pyp.transform;
         _loc7_.setMatrix(param1,param2,param3,param4,param5,param6);
         this.pyp.calculateAABB();
      }
      
      public function setTransform(param1:Vector3, param2:Matrix3) : void
      {
         var _loc3_:Matrix4 = this.pyp.transform;
         _loc3_.setFromMatrix3(param2,param1);
         this.pyp.calculateAABB();
      }
      
      public function checkTrigger(param1:Body) : void
      {
         var _loc3_:CollisionShape = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.numCollisionShapes)
         {
            _loc3_ = param1.collisionShapes[_loc2_];
            if(this.battleRunner.getCollisionDetector().testCollision(_loc3_,this.pyp))
            {
               this.nasybugo.onTriggerActivated();
               return;
            }
            _loc2_++;
         }
      }
   }
}

