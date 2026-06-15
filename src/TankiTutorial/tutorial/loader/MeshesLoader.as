package tutorial.loader
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class MeshesLoader extends TanksLoader
   {
      
      private var witobovar:Vector.<XML>;
      
      private var wucejydy:String;
      
      private var luwuqap:String;
      
      private var dodycoli:int;
      
      private var zewucadiz:Mesh;
      
      private var wija:URLLoader;
      
      public function MeshesLoader()
      {
         super();
      }
      
      override public function check(param1:XML) : Boolean
      {
         return param1.meshes.length() > 0;
      }
      
      override public function load(param1:String, param2:XML, param3:Function) : void
      {
         var _loc5_:XML = null;
         this.pomagu = param2.meshes[0];
         this.hon = param3;
         this.witobovar = new Vector.<XML>();
         this.dodycoli = 0;
         this.luwuqap = param1 + pomagu.@baseURL;
         var _loc4_:int = 0;
         for each(_loc5_ in pomagu.elements("mesh"))
         {
            this.witobovar[_loc4_] = _loc5_;
            _loc4_++;
         }
         this.loadMesh();
      }
      
      private function loadMesh(param1:BitmapData = null) : void
      {
         var _loc2_:XML = null;
         var _loc3_:ByteArray = null;
         var _loc4_:BitmapData = null;
         var _loc5_:Mesh = null;
         if(param1 != null)
         {
            this.zewucadiz.setMaterialToAllFaces(new TextureMaterial(param1,false,true,MipMapping.PER_PIXEL,2.5));
            Assets.saveData(this.wucejydy,this.zewucadiz,Mesh);
            this.zewucadiz = null;
            ++this.dodycoli;
         }
         if(this.dodycoli < this.witobovar.length)
         {
            _loc2_ = this.witobovar[this.dodycoli];
            this.wucejydy = _loc2_.@id.toString();
            if(Assets.hasData(this.wucejydy,ByteArray))
            {
               _loc3_ = Assets.getData(this.wucejydy,ByteArray);
               _loc4_ = Assets.getData(this.wucejydy,BitmapData);
               _loc5_ = this.parseMesh(_loc3_);
               _loc5_.setMaterialToAllFaces(new TextureMaterial(_loc4_,false,true,MipMapping.PER_PIXEL,2.5));
               Assets.saveData(this.wucejydy,_loc5_,Mesh);
               ++this.dodycoli;
               this.loadMesh();
            }
            else
            {
               this.wija = createURLLoader(this.loadTexture,onError,onProgress);
               this.wija.dataFormat = URLLoaderDataFormat.BINARY;
               julicoj = this.luwuqap + _loc2_.@url.toString();
               this.wija.load(new URLRequest(julicoj));
            }
         }
         else if(hon != null)
         {
            hon();
         }
      }
      
      private function loadTexture(param1:Event) : void
      {
         this.zewucadiz = this.parseMesh(this.wija.data);
         this.wija = null;
         var _loc2_:XML = this.witobovar[this.dodycoli];
         var _loc3_:String = this.luwuqap + _loc2_.@texture.toString();
         bita.load(_loc3_,this.loadMesh);
      }
      
      private function parseMesh(param1:ByteArray) : Mesh
      {
         var _loc5_:Mesh = null;
         var _loc2_:Parser3DS = new Parser3DS();
         _loc2_.parse(param1);
         var _loc3_:int = int(_loc2_.objects.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.objects[_loc4_] as Mesh;
            if(_loc5_ != null)
            {
               _loc5_.sorting = Sorting.DYNAMIC_BSP;
               _loc5_.optimizeForDynamicBSP();
               _loc5_.calculateVerticesNormalsByAngle(GameData.qusejov,GameData.hevarer);
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
   }
}

