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
   import alternativa.physics.collision.primitives.tygymamej;
   import tutorial.GameData;
   import tutorial.commons.Assets;
   
   public class PropObject
   {
      
      private static const biby:PhysicsMaterial = new PhysicsMaterial(0,1);
      
      public var leqib:Vector.<Object3D>;
      
      public var lucubegul:Vector.<Occluder>;
      
      public var jehi:Vector.<CollisionShape>;
      
      private var tylu:Vector.<String>;
      
      private var dodycoli:int;
      
      private var gulot:PropLibrary;
      
      private var caqiqata:String;
      
      public var gepocivaj:String;
      
      private var hon:Function;
      
      public var gohigewam:int;
      
      public function PropObject()
      {
         super();
      }
      
      public function load(param1:XML, param2:Function) : void
      {
         var _loc4_:XML = null;
         this.hon = param2;
         this.leqib = new Vector.<Object3D>();
         this.lucubegul = new Vector.<Occluder>();
         this.jehi = new Vector.<CollisionShape>();
         this.tylu = new Vector.<String>();
         this.dodycoli = -1;
         var _loc3_:String = XMLUtils.getAttributeAsString(param1,"library-name","");
         this.caqiqata = XMLUtils.getAttributeAsString(param1,"group-name","");
         this.gepocivaj = XMLUtils.getAttributeAsString(param1,"name","");
         this.gulot = Assets.getData(_loc3_,PropLibrary);
         this.gohigewam = this.gulot.gohigewam;
         this.tylu.push(null);
         for each(_loc4_ in param1.elements("texture-name"))
         {
            this.tylu.push(_loc4_.toString());
         }
         this.parsePhysics(param1);
         this.loadObject();
      }
      
      private function parsePhysics(param1:XML) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:CollisionShape = null;
         var _loc8_:Vector3 = null;
         var _loc9_:Vector3 = null;
         var _loc11_:Vector3 = null;
         var _loc12_:Vector3 = null;
         var _loc13_:Vector3 = null;
         var _loc14_:Vector3 = null;
         var _loc5_:Boolean = GameData.bisoga && param1.attribute("name") == "Billboard";
         _loc6_ = 255;
         _loc8_ = new Vector3();
         _loc9_ = new Vector3();
         var _loc10_:Matrix3 = new Matrix3();
         _loc2_ = param1.elements("collision-triangle");
         _loc3_ = _loc2_.length();
         _loc11_ = new Vector3();
         _loc12_ = new Vector3();
         _loc13_ = new Vector3();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(!_loc5_)
            {
               _loc11_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("v0")[0],"x",0);
               _loc11_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("v0")[0],"y",0);
               _loc12_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("v1")[0],"x",0);
               _loc12_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("v1")[0],"y",0);
               _loc13_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("v2")[0],"x",0);
               _loc13_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("v2")[0],"y",0);
               _loc8_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("position")[0],"x",0);
               _loc8_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("position")[0],"y",0);
               _loc8_.qyririg = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("position")[0],"z",0);
               _loc9_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("angles")[0],"x",0);
               _loc9_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("angles")[0],"y",0);
               _loc9_.qyririg = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("angles")[0],"z",0);
               _loc7_ = new CollisionTriangle(_loc11_,_loc12_,_loc13_,_loc6_,biby);
               _loc10_.setRotationMatrix(_loc9_.x,_loc9_.y,_loc9_.qyririg);
               _loc7_.wet.setFromMatrix3(_loc10_,_loc8_);
               this.jehi.push(_loc7_);
            }
            _loc4_++;
         }
         _loc2_ = param1.elements("collision-rect");
         _loc3_ = _loc2_.length();
         _loc14_ = new Vector3();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc14_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("size")[0],"x",0) * 0.5;
            _loc14_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("size")[0],"y",0) * 0.5;
            _loc14_.qyririg = 0;
            _loc8_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("position")[0],"x",0);
            _loc8_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("position")[0],"y",0);
            _loc8_.qyririg = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("position")[0],"z",0);
            _loc9_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("angles")[0],"x",0);
            _loc9_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("angles")[0],"y",0);
            _loc9_.qyririg = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("angles")[0],"z",0);
            _loc7_ = new CollisionRect(_loc14_,_loc6_,biby);
            _loc10_.setRotationMatrix(_loc9_.x,_loc9_.y,_loc9_.qyririg);
            _loc7_.wet.setFromMatrix3(_loc10_,_loc8_);
            this.jehi.push(_loc7_);
            _loc4_++;
         }
         _loc2_ = param1.elements("collision-box");
         _loc3_ = _loc2_.length();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(!_loc5_)
            {
               _loc14_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("size")[0],"x",0) * 0.5;
               _loc14_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("size")[0],"y",0) * 0.5;
               _loc14_.qyririg = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("size")[0],"z",0) * 0.5;
               _loc8_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("position")[0],"x",0);
               _loc8_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("position")[0],"y",0);
               _loc8_.qyririg = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("position")[0],"z",0);
               _loc9_.x = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("angles")[0],"x",0);
               _loc9_.y = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("angles")[0],"y",0);
               _loc9_.qyririg = XMLUtils.getAttributeAsNumber(_loc2_[_loc4_].elements("angles")[0],"z",0);
               _loc7_ = new tygymamej(_loc14_,_loc6_,biby);
               _loc10_.setRotationMatrix(_loc9_.x,_loc9_.y,_loc9_.qyririg);
               _loc7_.wet.setFromMatrix3(_loc10_,_loc8_);
               this.jehi.push(_loc7_);
            }
            _loc4_++;
         }
      }
      
      private function loadObject(param1:Object3D = null, param2:Vector.<Occluder> = null) : void
      {
         var _loc3_:int = 0;
         if(param1 != null)
         {
            this.leqib.push(param1);
            if(this.lucubegul.length == 0 && param2 != null)
            {
               _loc3_ = 0;
               while(_loc3_ < param2.length)
               {
                  this.lucubegul[_loc3_] = param2[_loc3_];
                  _loc3_++;
               }
            }
         }
         ++this.dodycoli;
         if(this.dodycoli < this.tylu.length)
         {
            this.gulot.loadObject(this.caqiqata,this.gepocivaj,this.tylu[this.dodycoli],this.loadObject);
         }
         else
         {
            this.hon(this);
         }
      }
   }
}

