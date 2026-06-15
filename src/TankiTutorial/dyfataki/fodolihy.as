package dyfataki
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import gafaduzuw.finajylom;
   import gafaduzuw.kyhewil;
   import wijymifun.Lak;
   
   public class fodolihy extends Mesh implements Lak
   {
      
      private static const map:kyhewil = new kyhewil();
      
      private var rowamize:Vector.<Vertex>;
      
      private var sibymu:Vector.<finajylom>;
      
      private var fyto:Vertex;
      
      private var gili:finajylom;
      
      private var mavibiroh:int;
      
      private var giqo:cogaj;
      
      private var kyvedu:lufoloje;
      
      private var supy:Number = 1;
      
      private var fidemujil:Number = 1;
      
      public function fodolihy(param1:Number, param2:Number, param3:int, param4:Material)
      {
         super();
         this.mavibiroh = param3;
         this.rowamize = new Vector.<Vertex>(2 * param3);
         this.sibymu = new Vector.<finajylom>(param3);
         this.nufybak(param1,param2);
         setMaterialToAllFaces(param4);
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
      }
      
      public function cabor(param1:cogaj, param2:lufoloje) : void
      {
         this.giqo = param1;
         this.kyvedu = param2;
         scaleX = 1;
         scaleY = 1;
         scaleZ = 1;
         alpha = 1;
         this.supy = 1;
      }
      
      public function sapavaj() : void
      {
         this.giqo = null;
         this.kyvedu = null;
         wapakojy.jawoj(this);
      }
      
      public function lojak() : void
      {
         var _loc1_:finajylom = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Vertex = null;
         map.lowefuwi(this.kyvedu.x,this.kyvedu.y,this.kyvedu.z,this.kyvedu.rotationX,this.kyvedu.rotationY,this.kyvedu.rotationZ);
         var _loc2_:int = 0;
         while(_loc2_ < this.mavibiroh)
         {
            _loc1_ = this.sibymu[_loc2_];
            _loc3_ = _loc1_.kan * map.gusat + _loc1_.zofydizug * map.cydop + _loc1_.qyririg * map.sivy + map.kyvuru;
            _loc4_ = _loc1_.kan * map.sig + _loc1_.zofydizug * map.qanezycap + _loc1_.qyririg * map.wyvukog + map.zumidynip;
            _loc5_ = _loc1_.kan * map.vug + _loc1_.zofydizug * map.luwym + _loc1_.qyririg * map.tari + map.sunafepo;
            _loc6_ = this.rowamize[2 * _loc2_];
            _loc6_.x = _loc3_;
            _loc6_.y = _loc4_;
            _loc6_.z = _loc5_;
            _loc6_ = this.rowamize[2 * _loc2_ + 1];
            _loc6_.x = _loc3_;
            _loc6_.y = _loc4_;
            _loc6_.z = _loc5_;
            _loc2_++;
         }
         map.lowefuwi(this.giqo.x,this.giqo.y,this.giqo.z,this.giqo.rotationX,this.giqo.rotationY,this.giqo.rotationZ);
         _loc1_ = this.gili;
         this.fyto.x = _loc1_.kan * map.gusat + _loc1_.zofydizug * map.cydop + _loc1_.qyririg * map.sivy + map.kyvuru;
         this.fyto.y = _loc1_.kan * map.sig + _loc1_.zofydizug * map.qanezycap + _loc1_.qyririg * map.wyvukog + map.zumidynip;
         this.fyto.z = _loc1_.kan * map.vug + _loc1_.zofydizug * map.luwym + _loc1_.qyririg * map.tari + map.sunafepo;
         calculateBounds();
         calculateFacesNormals();
      }
      
      private function nufybak(param1:Number, param2:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:finajylom = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         this.gili = new finajylom(0,0,param2);
         this.fyto = this.bilico(0,0,param2,0,1);
         var _loc3_:Number = 2 * Math.PI / this.mavibiroh;
         var _loc4_:int = 0;
         while(_loc4_ < this.mavibiroh)
         {
            _loc6_ = _loc4_ * _loc3_;
            _loc7_ = new finajylom(param1 * Math.cos(_loc6_),param1 * Math.sin(_loc6_),0);
            this.sibymu[_loc4_] = _loc7_;
            this.rowamize[2 * _loc4_] = this.bilico(_loc7_.kan,_loc7_.zofydizug,_loc7_.qyririg,0,0);
            this.rowamize[2 * _loc4_ + 1] = this.bilico(_loc7_.kan,_loc7_.zofydizug,_loc7_.qyririg,1,1);
            _loc4_++;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this.mavibiroh)
         {
            _loc8_ = 2 * _loc5_;
            _loc9_ = _loc8_ + 3;
            if(_loc9_ >= 2 * this.mavibiroh)
            {
               _loc9_ -= 2 * this.mavibiroh;
            }
            this.linulah(this.fyto,this.rowamize[_loc8_],this.rowamize[_loc9_]);
            this.linulah(this.fyto,this.rowamize[_loc9_],this.rowamize[_loc8_]);
            _loc5_++;
         }
      }
      
      private function bilico(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Vertex
      {
         var _loc6_:Vertex = new Vertex();
         _loc6_.next = vertexList;
         vertexList = _loc6_;
         _loc6_.x = param1;
         _loc6_.y = param2;
         _loc6_.z = param3;
         _loc6_.u = param4;
         _loc6_.v = param5;
         return _loc6_;
      }
      
      private function linulah(param1:Vertex, param2:Vertex, param3:Vertex) : Face
      {
         var _loc4_:Face = new Face();
         _loc4_.next = faceList;
         faceList = _loc4_;
         _loc4_.wrapper = new Wrapper();
         _loc4_.wrapper.vertex = param1;
         _loc4_.wrapper.next = new Wrapper();
         _loc4_.wrapper.next.vertex = param2;
         _loc4_.wrapper.next.next = new Wrapper();
         _loc4_.wrapper.next.next.vertex = param3;
         return _loc4_;
      }
      
      public function newofelan(param1:Number) : void
      {
         this.supy = param1;
         this.ruwy();
      }
      
      private function ruwy() : void
      {
         alpha = this.fidemujil * this.supy;
      }
      
      public function zimas(param1:finajylom) : void
      {
         param1.kan = x;
         param1.zofydizug = y;
         param1.qyririg = z;
      }
      
      public function tahuh(param1:Number) : void
      {
         this.fidemujil = param1;
         this.ruwy();
      }
   }
}

