package alternativa.tanks.vehicles.tank
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.shared.physics.TankBody;
   import alternativa.utils.MathUtils;
   
   public class CollisionBoxesBuilder
   {
      
      private static const zabybam:PhysicsMaterial = new PhysicsMaterial(0,1);
      
      private static const lymuwykos:PhysicsMaterial = new PhysicsMaterial(0,0.2);
      
      public function CollisionBoxesBuilder()
      {
         super();
      }
      
      public static function createStaticCollisionBoxes(halfSize:Vector3, height:Number, tankBody:TankBody) : void
      {
         var cornerY:Number = NaN;
         var cornerZ:Number = NaN;
         var bodyHeight:Number = height - 10;
         var halfLength:Number = halfSize.y;
         var halfHeight:Number = bodyHeight / 2;
         var straightRatio:Number = 0.82;
         var _loc8_:Number = 1 - (1 - straightRatio) * (1 - straightRatio) * halfLength * halfLength / (halfHeight * halfHeight);
         if(_loc8_ > 0)
         {
            _loc8_ = Math.sqrt(_loc8_);
         }
         else
         {
            _loc8_ = 1 - (1 - straightRatio) * halfLength / halfHeight;
         }
         var slope:Number = (straightRatio - 1) * halfLength / ((1 + _loc8_) * halfHeight);
         var intercept:Number = _loc8_ * halfHeight - slope * halfLength;
         var _loc11_:Number = (1 - straightRatio) * halfLength / ((1 + _loc8_) * halfHeight);
         var _loc12_:Number = (1 - _loc8_) * halfHeight / ((1 - straightRatio) * halfLength);
         if(MathUtils.numbersEqual(_loc11_,_loc12_,0.00001) || _loc11_ < _loc12_)
         {
            cornerY = straightRatio * halfLength;
            cornerZ = slope * cornerY + intercept;
         }
         else
         {
            cornerY = (1 - _loc8_) * halfHeight / slope + halfLength;
            cornerZ = halfHeight;
         }
         var dz:Number = cornerZ - _loc8_ * halfHeight;
         var dy:Number = halfLength - cornerY;
         var boxHalfLength:Number = Math.sqrt(dz * dz + dy * dy) / 2;
         dz = (1 + _loc8_) * halfHeight;
         dy = (1 - straightRatio) * halfLength;
         var boxHalfHeight:Number = Math.sqrt(dz * dz + dy * dy) / 2;
         var box:CollisionBox = new CollisionBox(new Vector3(halfSize.x,boxHalfLength,boxHalfHeight),CollisionGroup.STATIC,lymuwykos);
         var transform:Matrix4 = new Matrix4();
         var angle:Number = Math.atan(_loc11_);
         transform.setRotationMatrix(-angle,0,0);
         var boxY:Number = straightRatio * halfLength + boxHalfHeight * Math.sin(angle) - boxHalfLength * Math.cos(angle);
         var boxZ:Number = -halfHeight + boxHalfHeight * Math.cos(angle) + boxHalfLength * Math.sin(angle) - (halfSize.z - bodyHeight / 2);
         transform.setPosition(new Vector3(0,boxY,boxZ));
         tankBody.body.addCollisionShape(box,transform);
         tankBody.staticCollisionBoxes.push(box);
         box = new CollisionBox(new Vector3(halfSize.x,boxHalfLength,boxHalfHeight),CollisionGroup.STATIC,lymuwykos);
         transform.setRotationMatrix(angle,0,0);
         transform.setPosition(new Vector3(0,-boxY,boxZ));
         tankBody.body.addCollisionShape(box,transform);
         tankBody.staticCollisionBoxes.push(box);
         var lowerBoxHeight:Number = height * 3 / 4;
         var lowerBoxHalfSize:Vector3 = new Vector3(halfSize.x,halfSize.y * straightRatio,lowerBoxHeight / 2);
         var lowerBoxTransform:Matrix4 = new Matrix4();
         lowerBoxTransform.ml = lowerBoxHalfSize.z - halfSize.z;
         var lowerBox:CollisionBox = new CollisionBox(lowerBoxHalfSize,CollisionGroup.STATIC,lymuwykos);
         tankBody.body.addCollisionShape(lowerBox,lowerBoxTransform);
         tankBody.staticCollisionBoxes.push(lowerBox);
         var upperBoxHeight:Number = height * 3 / 4;
         var upperBoxHalfSize:Vector3 = new Vector3(halfSize.x,halfSize.y * straightRatio,upperBoxHeight / 2);
         var upperBoxTransform:Matrix4 = new Matrix4();
         upperBoxTransform.ml = height - upperBoxHalfSize.z - halfSize.z;
         var upperBox:CollisionBox = new CollisionBox(upperBoxHalfSize,CollisionGroup.STATIC,zabybam);
         tankBody.body.addCollisionShape(upperBox,upperBoxTransform);
         tankBody.staticCollisionBoxes.push(upperBox);
      }
      
      public static function createTankCollisionBox(halfSize:Vector3, height:Number, tankBody:TankBody) : void
      {
         var boxHalfSize:Vector3 = new Vector3(halfSize.x,halfSize.y,height / 2);
         var box:CollisionBox = new CollisionBox(boxHalfSize,0,lymuwykos);
         var transform:Matrix4 = new Matrix4();
         transform.ml = height / 2 - halfSize.z;
         tankBody.body.addCollisionShape(box,transform);
         tankBody.tankCollisionBox = box;
      }
   }
}

