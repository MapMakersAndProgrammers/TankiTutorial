package tutorial.loader
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.TanksPhysicsScene;
   import alternativa.physics.collision.CollisionShape;
   import alternativa.tanks.physics.CollisionGroup;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import tutorial.GameData;
   import tutorial.GameScene;
   import tutorial.commons.Assets;
   import tutorial.commons.Shared;
   import tutorial.loader.proplib.PropObject;
   import tutorial.loader.proplib.XMLUtils;
   import tutorial.script.ScriptStep;
   
   public class PropMapLoader extends TanksLoader
   {
      
      public static const mepevimo:int = 500;
      
      private static const gijalatyt:Matrix3D = new Matrix3D();
      
      private static const sudadu:Matrix4 = new Matrix4();
      
      private var wija:URLLoader;
      
      private var neludetur:Vector.<PropObject>;
      
      private var muluhe:Vector.<XML>;
      
      private var dodycoli:int;
      
      private var tuce:GameScene = GameData.tuce;
      
      private var gov:TanksPhysicsScene = GameData.gov;
      
      private var lyqydybog:Boolean = false;
      
      private var bemevem:Object = {};
      
      public function PropMapLoader()
      {
         super();
      }
      
      private static function initBonusRegionMaterial(param1:Number, param2:BitmapData) : TextureMaterial
      {
         var _loc3_:TextureMaterial = new TextureMaterial();
         _loc3_.texture = param2;
         _loc3_.mipMapping = MipMapping.PER_PIXEL;
         _loc3_.resolution = param1 / _loc3_.texture.width;
         return _loc3_;
      }
      
      private static function createBonusRegion(param1:Vector3, param2:Vector3, param3:TextureMaterial) : Decal
      {
         var _loc4_:Decal = new Decal();
         var _loc5_:Number = mepevimo / 2;
         var _loc6_:Number = 0;
         if(!Shared.gpu)
         {
            _loc6_ = 0.5;
         }
         var _loc7_:Vertex = _loc4_.addVertex(-_loc5_,_loc5_,_loc6_,0,0);
         var _loc8_:Vertex = _loc4_.addVertex(-_loc5_,-_loc5_,_loc6_,0,1);
         var _loc9_:Vertex = _loc4_.addVertex(_loc5_,-_loc5_,_loc6_,1,1);
         var _loc10_:Vertex = _loc4_.addVertex(_loc5_,_loc5_,_loc6_,1,0);
         _loc4_.addQuadFace(_loc7_,_loc8_,_loc9_,_loc10_,param3);
         _loc4_.calculateFacesNormals();
         _loc4_.calculateVerticesNormals();
         _loc4_.x = param1.x;
         _loc4_.y = param1.y;
         _loc4_.z = param1.qyririg;
         _loc4_.rotationX = param2.x;
         _loc4_.rotationY = param2.y;
         _loc4_.rotationZ = param2.qyririg;
         return _loc4_;
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.@propmap.toString() != "";
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         this.hon = param3;
         var _loc4_:String = param1 + XMLUtils.getAttributeAsString(param2,"propmap");
         this.parseDynamics(param2);
         if(Assets.hasData(_loc4_,ByteArray))
         {
            this.lyqydybog = true;
            this.parse(Assets.getData(_loc4_,ByteArray));
         }
         else if(Assets.hasData(_loc4_,XML))
         {
            this.lyqydybog = false;
            this.parse(Assets.getData(_loc4_,XML));
         }
         else
         {
            this.lyqydybog = _loc4_.indexOf(".bin") > 0;
            this.wija = createURLLoader(this.onLoaded,onError,onProgress);
            if(this.lyqydybog)
            {
               this.wija.dataFormat = URLLoaderDataFormat.BINARY;
            }
            this.wija.load(new URLRequest(_loc4_));
         }
      }
      
      private function onLoaded(param1:Event) : void
      {
         var _loc2_:* = this.wija.data;
         this.wija = null;
         onFinishLoad();
         this.parse(_loc2_);
      }
      
      private function parse(param1:*) : void
      {
         var _loc2_:XML = null;
         var _loc3_:ByteArray = null;
         if(this.lyqydybog)
         {
            _loc3_ = param1;
            _loc3_.uncompress();
            param1 = _loc3_.readUTFBytes(_loc3_.length);
         }
         pomagu = XML(param1);
         this.neludetur = new Vector.<PropObject>();
         this.muluhe = new Vector.<XML>();
         this.dodycoli = 0;
         for each(_loc2_ in pomagu.prop)
         {
            this.muluhe.push(_loc2_);
         }
         this.loadProp();
      }
      
      private function loadProp(param1:PropObject = null) : void
      {
         var _loc2_:PropObject = null;
         if(param1 != null)
         {
            this.neludetur.push(param1);
            ++this.dodycoli;
         }
         if(this.dodycoli < this.muluhe.length)
         {
            _loc2_ = new PropObject();
            _loc2_.load(this.muluhe[this.dodycoli],this.loadProp);
         }
         else
         {
            this.parseMap();
         }
      }
      
      private function parseMap() : void
      {
         this.parseMeshes();
         this.parseSprites();
         this.parseAndAddBonusRegions();
         hon();
      }
      
      private function parseAndAddBonusRegions() : void
      {
         var _loc2_:XML = null;
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         var _loc5_:Vector3 = null;
         var _loc1_:TextureMaterial = initBonusRegionMaterial(mepevimo,Assets.getData("repairKitBonusRegion",BitmapData));
         for each(_loc2_ in Assets.scripts.script)
         {
            for each(_loc3_ in _loc2_.elements("step"))
            {
               for each(_loc4_ in _loc3_.elements())
               {
                  if(_loc4_.name().toString() == ScriptStep.wejaqat)
                  {
                     _loc5_ = new Vector3(Number(_loc4_.@x),Number(_loc4_.@y),Number(_loc4_.@z));
                     GameData.wuhibota.push(_loc5_);
                     this.tuce.addDynamic(createBonusRegion(_loc5_,new Vector3(),_loc1_));
                  }
               }
            }
         }
      }
      
      private function parseDynamics(param1:XML) : void
      {
         var _loc2_:String = param1.@dynamics.toString();
         var _loc3_:Array = _loc2_.split(",");
         for each(_loc2_ in _loc3_)
         {
            this.bemevem[_loc2_] = true;
         }
      }
      
      private function parseMeshes() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:PropObject = null;
         var _loc4_:XML = null;
         var _loc5_:Vector3 = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:Object3D = null;
         for each(_loc1_ in pomagu.mesh)
         {
            _loc2_ = XMLUtils.getAttributeAsInt(_loc1_,"prop-index");
            _loc3_ = this.neludetur[_loc2_];
            _loc4_ = _loc1_.position[0];
            _loc5_ = new Vector3(_loc4_.@x,_loc4_.@y,_loc4_.@z);
            _loc6_ = Number(_loc1_.elements("rotation-z"));
            gijalatyt.identity();
            gijalatyt.appendRotation(_loc6_ * 180 / Math.PI,Vector3D.Z_AXIS);
            gijalatyt.appendTranslation(_loc5_.x,_loc5_.y,_loc5_.qyririg);
            _loc7_ = _loc1_.elements("texture-index").length() > 0 ? int(int(_loc1_.elements("texture-index")) + 1) : 0;
            _loc8_ = _loc3_.leqib[_loc7_];
            if(Boolean(this.bemevem[_loc3_.gepocivaj]))
            {
               this.parseDynamicObject(_loc8_,_loc3_);
            }
            else
            {
               this.parseStaticObject(_loc8_,_loc3_,_loc5_,_loc6_);
            }
         }
      }
      
      private function parseDynamicObject(param1:Object3D, param2:PropObject) : void
      {
         var _loc4_:CollisionShape = null;
         var _loc5_:CollisionShape = null;
         param1 = this.parseMesh(param1 as Mesh,param2.gohigewam,gijalatyt);
         this.tuce.addDynamic(param1);
         var _loc3_:Body = new Body(1,Matrix3.nyra);
         _loc3_.gepocivaj = param2.gepocivaj;
         _loc3_.midorofic = false;
         for each(_loc4_ in param2.jehi)
         {
            _loc5_ = _loc4_.clone();
            _loc3_.addCollisionShape(_loc5_,_loc5_.wet.clone());
         }
         _loc3_.setPositionXYZ(param1.x,param1.y,param1.z);
         this.gov.addKinematicBody(_loc3_);
      }
      
      private function parseStaticObject(param1:Object3D, param2:PropObject, param3:Vector3, param4:Number) : void
      {
         var _loc8_:CollisionShape = null;
         var _loc9_:CollisionShape = null;
         var _loc5_:Mesh = this.parseBSP(param1 as Mesh,param2.gohigewam,gijalatyt) as Mesh;
         this.tuce.addObject(_loc5_);
         var _loc6_:Face = _loc5_.faces[0];
         var _loc7_:int = _loc6_.material == null ? CollisionGroup.neli : 255;
         for each(_loc8_ in param2.jehi)
         {
            sudadu.setMatrix(param3.x,param3.y,param3.qyririg,0,0,param4);
            _loc9_ = _loc8_.clone();
            _loc9_.nute = _loc7_;
            _loc9_.wet.append(sudadu);
            this.gov.addCollisionPrimitive(_loc9_);
         }
      }
      
      private function parseBSP(param1:Mesh, param2:int, param3:Matrix3D) : Object3D
      {
         var _loc4_:Mesh = param1.clone() as Mesh;
         _loc4_.matrix = param3;
         var _loc5_:TextureMaterial = param1.faceList.material as TextureMaterial;
         if(_loc5_ != null)
         {
            _loc5_.mipMapping = MipMapping.PER_PIXEL;
            _loc5_.resolution = 5;
            _loc4_.setMaterialToAllFaces(_loc5_);
            GameData.ciqoby.addToQueue(_loc5_,param2,true);
         }
         return _loc4_;
      }
      
      private function parseMesh(param1:Mesh, param2:int, param3:Matrix3D) : Object3D
      {
         var _loc4_:Mesh = param1.clone() as Mesh;
         var _loc5_:TextureMaterial = param1.faceList.material as TextureMaterial;
         if(_loc5_ != null)
         {
            _loc5_.mipMapping = MipMapping.PER_PIXEL;
            _loc5_.resolution = 5;
            _loc4_.setMaterialToAllFaces(_loc5_);
            GameData.ciqoby.addToQueue(_loc5_,param2,true);
         }
         _loc4_.matrix = param3;
         _loc4_.sorting = Sorting.DYNAMIC_BSP;
         return _loc4_;
      }
      
      private function parseSprites() : void
      {
         var _loc1_:XML = null;
         var _loc2_:int = 0;
         var _loc3_:PropObject = null;
         var _loc4_:Sprite3D = null;
         var _loc5_:Sprite3D = null;
         var _loc6_:XML = null;
         var _loc7_:TextureMaterial = null;
         for each(_loc1_ in pomagu.sprite)
         {
            _loc2_ = XMLUtils.getAttributeAsInt(_loc1_,"prop-index");
            _loc3_ = this.neludetur[_loc2_];
            _loc4_ = _loc3_.leqib[0] as Sprite3D;
            _loc5_ = _loc4_.clone() as Sprite3D;
            _loc6_ = _loc1_.position[0];
            _loc5_.x = _loc6_.@x;
            _loc5_.y = _loc6_.@y;
            _loc5_.z = _loc6_.@z;
            _loc7_ = _loc4_.material as TextureMaterial;
            _loc7_.mipMapping = MipMapping.PER_PIXEL;
            _loc7_.resolution = 5;
            GameData.ciqoby.addToQueue(_loc7_,0,false);
            _loc5_.material = _loc7_;
            this.tuce.addDynamic(_loc5_);
         }
      }
   }
}

