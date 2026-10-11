package tutorial.loader.proplib
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Occluder;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.physics.PhysicsMaterial;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.physics.collision.primitives.CollisionRect;
   import alternativa.physics.collision.primitives.CollisionTriangle;
   import alternativa.physics.collision.primitives.CollisionBox;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class PropObject
   {
      
      private static const physicsMaterial:PhysicsMaterial = new PhysicsMaterial(0,1);
      
      public var objects:Vector.<Object3D>;
      
      public var occluders:Vector.<Occluder>;
      
      public var collisionShapes:Vector.<CollisionShape>;
      
      private var textureNames:Vector.<String>;
      
      private var textureIndex:int;
      
      private var library:PropLibrary;
      
      private var groupName:String;
      
      public var name:String;
      
      private var callback:Function;
      
      public var priority:int;
      
      public function PropObject()
      {
         super();
      }
      
      public function load(xml:XML, callback:Function) : void
      {
         var textureName:XML = null;
         this.callback = callback;
         this.objects = new Vector.<Object3D>();
         this.occluders = new Vector.<Occluder>();
         this.collisionShapes = new Vector.<CollisionShape>();
         this.textureNames = new Vector.<String>();
         this.textureIndex = -1;
         var libraryName:String = XMLUtils.getAttributeAsString(xml,"library-name","");
         this.groupName = XMLUtils.getAttributeAsString(xml,"group-name","");
         this.name = XMLUtils.getAttributeAsString(xml,"name","");
         this.library = Assets.getData(libraryName,PropLibrary);
         this.priority = this.library.priority;
         this.textureNames.push(null);
         for each(textureName in xml.elements("texture-name"))
         {
            this.textureNames.push(textureName.toString());
         }
         this.parsePhysics(xml);
         this.loadObject();
      }
      
      private function parsePhysics(xml:XML) : void
      {
         var elements:XMLList = null;
         var len:int = 0;
         var i:int = 0;
         var collisionGroup:int = 0;
         var shape:CollisionShape = null;
         var position:Vector3 = null;
         var angles:Vector3 = null;
         var v0:Vector3 = null;
         var v1:Vector3 = null;
         var v2:Vector3 = null;
         var halfSize:Vector3 = null;
         var billboard:Boolean = GameData.bisoga && xml.attribute("name") == "Billboard";
         collisionGroup = 255;
         position = new Vector3();
         angles = new Vector3();
         var matrix:Matrix3 = new Matrix3();
         elements = xml.elements("collision-triangle");
         len = elements.length();
         v0 = new Vector3();
         v1 = new Vector3();
         v2 = new Vector3();
         i = 0;
         while(i < len)
         {
            if(!billboard)
            {
               v0.x = XMLUtils.getAttributeAsNumber(elements[i].elements("v0")[0],"x",0);
               v0.y = XMLUtils.getAttributeAsNumber(elements[i].elements("v0")[0],"y",0);
               v1.x = XMLUtils.getAttributeAsNumber(elements[i].elements("v1")[0],"x",0);
               v1.y = XMLUtils.getAttributeAsNumber(elements[i].elements("v1")[0],"y",0);
               v2.x = XMLUtils.getAttributeAsNumber(elements[i].elements("v2")[0],"x",0);
               v2.y = XMLUtils.getAttributeAsNumber(elements[i].elements("v2")[0],"y",0);
               position.x = XMLUtils.getAttributeAsNumber(elements[i].elements("position")[0],"x",0);
               position.y = XMLUtils.getAttributeAsNumber(elements[i].elements("position")[0],"y",0);
               position.z = XMLUtils.getAttributeAsNumber(elements[i].elements("position")[0],"z",0);
               angles.x = XMLUtils.getAttributeAsNumber(elements[i].elements("angles")[0],"x",0);
               angles.y = XMLUtils.getAttributeAsNumber(elements[i].elements("angles")[0],"y",0);
               angles.z = XMLUtils.getAttributeAsNumber(elements[i].elements("angles")[0],"z",0);
               shape = new CollisionTriangle(v0,v1,v2,collisionGroup,physicsMaterial);
               matrix.setRotationMatrix(angles.x,angles.y,angles.z);
               shape.transform.setFromMatrix3(matrix,position);
               this.collisionShapes.push(shape);
            }
            i++;
         }
         elements = xml.elements("collision-rect");
         len = elements.length();
         halfSize = new Vector3();
         i = 0;
         while(i < len)
         {
            halfSize.x = XMLUtils.getAttributeAsNumber(elements[i].elements("size")[0],"x",0) * 0.5;
            halfSize.y = XMLUtils.getAttributeAsNumber(elements[i].elements("size")[0],"y",0) * 0.5;
            halfSize.z = 0;
            position.x = XMLUtils.getAttributeAsNumber(elements[i].elements("position")[0],"x",0);
            position.y = XMLUtils.getAttributeAsNumber(elements[i].elements("position")[0],"y",0);
            position.z = XMLUtils.getAttributeAsNumber(elements[i].elements("position")[0],"z",0);
            angles.x = XMLUtils.getAttributeAsNumber(elements[i].elements("angles")[0],"x",0);
            angles.y = XMLUtils.getAttributeAsNumber(elements[i].elements("angles")[0],"y",0);
            angles.z = XMLUtils.getAttributeAsNumber(elements[i].elements("angles")[0],"z",0);
            shape = new CollisionRect(halfSize,collisionGroup,physicsMaterial);
            matrix.setRotationMatrix(angles.x,angles.y,angles.z);
            shape.transform.setFromMatrix3(matrix,position);
            this.collisionShapes.push(shape);
            i++;
         }
         elements = xml.elements("collision-box");
         len = elements.length();
         i = 0;
         while(i < len)
         {
            if(!billboard)
            {
               halfSize.x = XMLUtils.getAttributeAsNumber(elements[i].elements("size")[0],"x",0) * 0.5;
               halfSize.y = XMLUtils.getAttributeAsNumber(elements[i].elements("size")[0],"y",0) * 0.5;
               halfSize.z = XMLUtils.getAttributeAsNumber(elements[i].elements("size")[0],"z",0) * 0.5;
               position.x = XMLUtils.getAttributeAsNumber(elements[i].elements("position")[0],"x",0);
               position.y = XMLUtils.getAttributeAsNumber(elements[i].elements("position")[0],"y",0);
               position.z = XMLUtils.getAttributeAsNumber(elements[i].elements("position")[0],"z",0);
               angles.x = XMLUtils.getAttributeAsNumber(elements[i].elements("angles")[0],"x",0);
               angles.y = XMLUtils.getAttributeAsNumber(elements[i].elements("angles")[0],"y",0);
               angles.z = XMLUtils.getAttributeAsNumber(elements[i].elements("angles")[0],"z",0);
               shape = new CollisionBox(halfSize,collisionGroup,physicsMaterial);
               matrix.setRotationMatrix(angles.x,angles.y,angles.z);
               shape.transform.setFromMatrix3(matrix,position);
               this.collisionShapes.push(shape);
            }
            i++;
         }
      }
      
      private function loadObject(object:Object3D = null, meshOccluders:Vector.<Occluder> = null) : void
      {
         var i:int = 0;
         if(object != null)
         {
            this.objects.push(object);
            if(this.occluders.length == 0 && meshOccluders != null)
            {
               i = 0;
               while(i < meshOccluders.length)
               {
                  this.occluders[i] = meshOccluders[i];
                  i++;
               }
            }
         }
         ++this.textureIndex;
         if(this.textureIndex < this.textureNames.length)
         {
            this.library.loadObject(this.groupName,this.name,this.textureNames[this.textureIndex],this.loadObject);
         }
         else
         {
            this.callback(this);
         }
      }
   }
}

