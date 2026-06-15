package alternativa.physics.collision
{
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.types.dudyqo;
   
   public class CollisionShape
   {
      
      public static const jupod:int = 1;
      
      public static const lumog:int = 2;
      
      public static const hosomubeb:int = 4;
      
      public static const miluvo:int = 8;
      
      public var huvozage:int;
      
      public var nute:int;
      
      public var body:Body;
      
      public var koma:Matrix4;
      
      public var wet:Matrix4 = new Matrix4();
      
      public var raruluk:dudyqo = new dudyqo();
      
      public var material:PhysicsMaterial;
      
      public function CollisionShape(param1:int, param2:int, param3:PhysicsMaterial)
      {
         super();
         this.huvozage = param1;
         this.nute = param2;
         this.material = param3;
      }
      
      public function setBody(param1:Body, param2:Matrix4 = null) : void
      {
         if(this.body == param1)
         {
            return;
         }
         this.body = param1;
         if(param1 != null)
         {
            if(param2 != null)
            {
               if(this.koma == null)
               {
                  this.koma = new Matrix4();
               }
               this.koma.copy(param2);
            }
            else
            {
               this.koma = null;
            }
         }
      }
      
      public function calculateAABB() : dudyqo
      {
         return this.raruluk;
      }
      
      public function raycast(param1:Vector3, param2:Vector3, param3:Number, param4:Vector3) : Number
      {
         return -1;
      }
      
      public function clone() : CollisionShape
      {
         var _loc1_:CollisionShape = this.createPrimitive();
         return _loc1_.copyFrom(this);
      }
      
      public function copyFrom(param1:CollisionShape) : CollisionShape
      {
         if(param1 == null)
         {
            throw new ArgumentError("Parameter source cannot be null");
         }
         this.huvozage = param1.huvozage;
         this.wet.copy(param1.wet);
         this.nute = param1.nute;
         this.setBody(param1.body,param1.koma);
         this.raruluk.copyFrom(param1.raruluk);
         return this;
      }
      
      protected function createPrimitive() : CollisionShape
      {
         return new CollisionShape(this.huvozage,this.nute,this.material);
      }
   }
}

