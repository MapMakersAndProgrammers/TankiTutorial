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
      
      private var bonus:BattleBonus;
      
      private var collisionBox:CollisionBox;
      
      private var battleRunner:BattleRunner;
      
      public function BonusTrigger(bonus:BattleBonus)
      {
         super();
         this.bonus = bonus;
         var halfSize:Number = BonusConst.BONUS_HALF_SIZE;
         this.collisionBox = new CollisionBox(new Vector3(halfSize,halfSize,halfSize),CollisionGroup.BONUS,PhysicsMaterial.defaultMaterial);
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
      
      public function update(x:Number, y:Number, z:Number, rotationX:Number, rotationY:Number, rotationZ:Number) : void
      {
         var transform:Matrix4 = this.collisionBox.transform;
         transform.setMatrix(x,y,z,rotationX,rotationY,rotationZ);
         this.collisionBox.calculateAABB();
      }
      
      public function setTransform(position:Vector3, matrix:Matrix3) : void
      {
         var transform:Matrix4 = this.collisionBox.transform;
         transform.setFromMatrix3(matrix,position);
         this.collisionBox.calculateAABB();
      }
      
      public function checkTrigger(body:Body) : void
      {
         var shape:CollisionShape = null;
         var i:int = 0;
         while(i < body.numCollisionShapes)
         {
            shape = body.collisionShapes[i];
            if(this.battleRunner.getCollisionDetector().testCollision(shape,this.collisionBox))
            {
               this.bonus.onTriggerActivated();
               return;
            }
            i++;
         }
      }
   }
}

