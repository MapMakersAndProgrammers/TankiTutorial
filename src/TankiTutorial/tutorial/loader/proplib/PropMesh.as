package tutorial.loader.proplib
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.Occluder;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   import tutorial.loader.BaseLoader;
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;

   public class PropMesh extends BaseLoader
   {
      
      public static var hevarer:Number = 0.01;
      
      public static var wugej:Number = 0.01;
      
      public static var mykelak:Number = 0.01;
      
      public static var cugepumab:Number = 0.01;
      
      public static var nadup:int = 1;
      
      public static var sycym:Number = 0.001;
      
      public static var zyqukaqeb:Number = 0.0001;
      
      public static var hysiqa:Number = 0.001;
      
      public static var lylimujab:Number = 0.01;
      
      public var gepocivaj:String;
      
      private var zuqu:String;
      
      private var tylu:Object;
      
      private var cysam:Mesh;
      
      private var hon:Function;
      
      public var lucubegul:Vector.<Occluder>;
      
      private var kose:URLLoader;
      
      private var dekohyze:String;
      
      private var luwuqap:String;
      
      public function PropMesh(param1:XML, param2:String)
      {
         var _loc3_:XML = null;
         var _loc4_:PropTexture = null;
         this.tylu = new Object();
         super();
         this.luwuqap = param2;
         this.zuqu = param2 + XMLUtils.getAttributeAsString(param1,"file");
         for each(_loc3_ in param1.texture)
         {
            _loc4_ = new PropTexture(_loc3_.@name.toString(),XMLUtils.getAttributeAsString(_loc3_,"diffuse-map"),param2);
            this.tylu[_loc4_.gepocivaj] = _loc4_;
         }
      }
      
      public function load(param1:String, param2:Function) : void
      {
         this.dekohyze = param1;
         if(this.cysam == null)
         {
            this.hon = param2;
            if(!Assets.hasData(this.zuqu,Parser3DS))
            {
               julicoj = this.zuqu;
               this.kose = new URLLoader();
               this.kose.dataFormat = URLLoaderDataFormat.BINARY;
               this.kose.addEventListener(ProgressEvent.PROGRESS,onProgress);
               this.kose.addEventListener(Event.COMPLETE,this.onComplete);
               this.kose.load(new URLRequest(this.zuqu));
            }
            else if(this.zuqu.indexOf(".3dz") >= 0)
            {
               this.parse2(Assets.getData(this.zuqu,Parser3DS));
            }
            else
            {
               this.parse(Assets.getData(this.zuqu,ByteArray));
            }
         }
         else
         {
            param2(this.getMesh(),this.lucubegul);
         }
      }
      
      private function initMesh(param1:Mesh) : void
      {
         var _loc3_:TextureMaterial = null;
         param1.weldVertices(sycym,zyqukaqeb);
         param1.weldFaces(hysiqa,zyqukaqeb,lylimujab);
         param1.calculateVerticesNormalsByAngle(GameData.qusejov,GameData.hevarer);
         param1.threshold = hevarer;
         var _loc2_:TextureMaterial = param1.faceList.material as TextureMaterial;
         if(_loc2_ != null)
         {
            _loc3_ = new TextureMaterial();
            _loc3_.diffuseMapURL = this.luwuqap + _loc2_.diffuseMapURL;
            _loc3_.threshold = _loc2_.threshold;
            _loc3_.correctUV = _loc2_.correctUV;
            param1.setMaterialToAllFaces(_loc3_);
         }
      }
      
      private function initMesh2(param1:Mesh) : void
      {
         var _loc3_:TextureMaterial = null;
         param1.threshold = hevarer;
         var _loc2_:TextureMaterial = param1.faceList.material as TextureMaterial;
         if(_loc2_ != null)
         {
            _loc3_ = new TextureMaterial();
            _loc3_.diffuseMapURL = this.luwuqap + _loc2_.diffuseMapURL;
            _loc3_.threshold = _loc2_.threshold;
            _loc3_.correctUV = _loc2_.correctUV;
            param1.setMaterialToAllFaces(_loc3_);
         }
      }
      
      private function parse(param1:ByteArray) : void
      {
         var _loc7_:Object3D = null;
         var _loc8_:String = null;
         var _loc2_:Parser3DS = new Parser3DS();
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeBytes(param1);
         if(this.zuqu.indexOf(".3dz") > 0)
         {
            _loc3_.uncompress();
         }
         _loc3_.position = 0;
         this.kose = null;
         onFinishLoad();
         _loc2_.parse(_loc3_);
         var _loc4_:Vector.<Object3D> = _loc2_.objects;
         var _loc5_:int = int(_loc4_.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc4_[_loc6_];
            _loc8_ = _loc7_.name.toLowerCase();
            if(_loc8_.indexOf("occl") == 0)
            {
               this.addOccluder(Mesh(_loc7_));
            }
            _loc6_++;
         }
         this.cysam = Mesh(_loc4_[0]);
         this.initMesh(this.cysam);
         this.hon(this.getMesh(),this.lucubegul);
         this.hon = null;
      }
      
      private function parse2(param1:Parser3DS) : void
      {
         var _loc5_:Object3D = null;
         var _loc6_:String = null;
         var _loc2_:Vector.<Object3D> = param1.objects;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc6_ = _loc5_.name.toLowerCase();
            if(_loc6_.indexOf("occl") == 0)
            {
               this.addOccluder(Mesh(_loc5_.clone()));
            }
            _loc4_++;
         }
         this.cysam = Mesh(_loc2_[0]);
         this.initMesh2(this.cysam);
         this.hon(this.getMesh(),this.lucubegul);
         this.hon = null;
      }
      
      private function onComplete(param1:Event) : void
      {
         Assets.saveData(this.zuqu,this.kose.data,ByteArray);
         this.parse(this.kose.data);
      }
      
      private function getMesh() : Mesh
      {
         var _loc1_:Mesh = this.cysam.clone() as Mesh;
         if(this.dekohyze == null)
         {
            _loc1_.setMaterialToAllFaces(this.cysam.faceList.material);
         }
         else if(this.dekohyze == "invisible")
         {
            _loc1_.setMaterialToAllFaces(null);
         }
         else
         {
            _loc1_.setMaterialToAllFaces(PropTexture(this.tylu[this.dekohyze]).material);
         }
         return _loc1_;
      }
      
      private function addOccluder(param1:Mesh) : void
      {
         param1.weldVertices(wugej,nadup);
         param1.weldFaces(mykelak,nadup,cugepumab);
         var _loc2_:Occluder = new Occluder();
         _loc2_.createForm(param1,true);
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.z = param1.z;
         _loc2_.rotationX = param1.rotationX;
         _loc2_.rotationY = param1.rotationY;
         _loc2_.rotationZ = param1.rotationZ;
         if(this.lucubegul == null)
         {
            this.lucubegul = new Vector.<Occluder>();
         }
         this.lucubegul.push(_loc2_);
      }
   }
}

