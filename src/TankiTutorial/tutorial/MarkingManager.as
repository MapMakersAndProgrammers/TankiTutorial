package tutorial
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.RayIntersectionData;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.materials.FillMaterial;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.primitives.Sphere;
   import alternativa.math.Vector3;
   import alternativa.tanks.shared.camera.GameCamera;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import tutorial.commons.Assets;
   import tutorial.commons.Shared;
   
   public class MarkingManager
   {
      
      private static const cuzuf:int = 250;
      
      private const jiso:Number = 400;
      
      private const ziryjefom:Number = 501.5;
      
      private const vezuq:Number = 1600;
      
      private const pag:Number = 5000;
      
      private const fowovany:Number = 7000;
      
      private var nuqybap:TextureMaterial;
      
      private var bak:FillMaterial;
      
      private var vyhomopog:Vector3D;
      
      private var ruda:Vector3D;
      
      private var stage:Stage;
      
      private var butefu:Camera3D;
      
      private var danewazam:KDContainer;
      
      private var citacir:Tank;
      
      private var kaweq:Boolean;
      
      private var wyma:Vector.<Vector3D>;
      
      private var jariba:Vector.<Object3D>;
      
      private var jowidycuw:Dictionary;
      
      private var mitysosu:Dictionary;
      
      private var qiqegoken:Dictionary;
      
      private var fyryvujut:Number;
      
      private var qywavage:Number;
      
      private var kes:Object3D = null;
      
      private var zulynuwy:Boolean = false;
      
      public function MarkingManager(param1:Stage, param2:Camera3D, param3:KDContainer, param4:Tank, param5:Boolean = false)
      {
         var _loc6_:Vector3D = null;
         this.vyhomopog = new Vector3D();
         this.ruda = new Vector3D();
         this.wyma = new Vector.<Vector3D>();
         this.jariba = new Vector.<Object3D>();
         this.jowidycuw = new Dictionary();
         this.mitysosu = new Dictionary();
         this.qiqegoken = new Dictionary();
         super();
         this.stage = param1;
         this.butefu = param2;
         this.danewazam = param3;
         this.citacir = param4;
         this.kaweq = param5;
         this.wyma.push(new Vector3D(3000.4304152027394,-5150.442578640652,0));
         this.wyma.push(new Vector3D(2853.2959168387215,-4514.402183382978,0));
         this.wyma.push(new Vector3D(2722.7739361528966,-4216.32423984746,0));
         this.wyma.push(new Vector3D(2555.4916416070278,-3754.3224328743945,0));
         this.wyma.push(new Vector3D(2547.6451746392645,-3191.207805418414,0));
         this.wyma.push(new Vector3D(2538.9142371600483,-2850.7747812586576,10));
         this.wyma.push(new Vector3D(2625.7624633155056,-2508.1406194578785,0));
         this.wyma.push(new Vector3D(2800.774496445428,-1967.5122090495179,0));
         this.wyma.push(new Vector3D(3098.6019033962266,-1316.1389742348067,0));
         this.wyma.push(new Vector3D(3214.7792727402725,-1061.5087656775381,0));
         this.wyma.push(new Vector3D(3247.340143968684,-823.157496169054,0));
         this.wyma.push(new Vector3D(3249.9295289447236,367.3348778626091,-600));
         this.wyma.push(new Vector3D(3367.776419816074,821.4269011793573,-600));
         this.wyma.push(new Vector3D(3625.899496901398,1113.8213961625472,-600));
         this.wyma.push(new Vector3D(3964.4345658175826,1228.577455213981,-600));
         this.wyma.push(new Vector3D(4736.4472191871055,1279.3006305618183,-600));
         this.wyma.push(new Vector3D(5233.994773991302,1267.429629337654,-616.3424520831422));
         this.wyma.push(new Vector3D(6386.8895480920455,1249.8747309299604,-1200));
         this.wyma.push(new Vector3D(7049.110586282284,1547.5975118121992,-1200));
         this.wyma.push(new Vector3D(7504.743424919196,2092.388469640213,-1200));
         this.wyma.push(new Vector3D(7665.8464853677415,2556.7478081187105,-1200));
         this.wyma.push(new Vector3D(7652.102828702433,3030.213756510041,-1200));
         this.wyma.push(new Vector3D(7509.615681479855,3460.0734808684347,-1200));
         this.wyma.push(new Vector3D(7162.750619936882,3887.7512718918174,-1200));
         this.wyma.push(new Vector3D(6683.175087434381,4299.04226345357,-1200));
         this.wyma.push(new Vector3D(5963.462253210884,4850.798229744866,-1199.999999999999));
         this.wyma.push(new Vector3D(5275.328834548684,5331.71349855082,-1200));
         this.wyma.push(new Vector3D(4850.437893600176,5599.832950305227,-1200));
         this.wyma.push(new Vector3D(4421.727603474693,5726.582330281722,-1200));
         this.wyma.push(new Vector3D(3120.8067742918674,5754.230464577145,-599.999939367649));
         this.wyma.push(new Vector3D(2794.5221613006333,5864.1734995744555,-600.0000000000005));
         this.wyma.push(new Vector3D(2359.8576265946413,6101.673384747236,-600));
         this.wyma.push(new Vector3D(1731.3456574368795,6723.152325736999,-599.9999999999991));
         this.wyma.push(new Vector3D(1144.4414060605927,7659.3613183703355,-600));
         this.wyma.push(new Vector3D(635.7894935671845,8651.230407140025,-600));
         this.wyma.push(new Vector3D(414.9456791668341,9705.138812374289,-600));
         this.wyma.push(new Vector3D(243.11387750451686,10626.137430608387,-600));
         this.wyma.push(new Vector3D(235.44981825888817,11885.487761986831,0.0000615370126979542));
         this.wyma.push(new Vector3D(256.7144740536511,12158.944396268509,0));
         this.wyma.push(new Vector3D(417.60397440636496,12840.8985714797,0));
         this.wyma.push(new Vector3D(735.5082651599066,13510.146167494286,0));
         this.wyma.push(new Vector3D(1158.2153098379301,14127.978419597903,0));
         this.wyma.push(new Vector3D(1701.940935179659,15104.214067951329,0));
         this.wyma.push(new Vector3D(2502.433830507002,16231.80177686567,0));
         this.wyma.push(new Vector3D(3056.210836203401,16811.280603765637,0));
         this.wyma.push(new Vector3D(3817.744791989682,17213.86854139798,0));
         this.wyma.push(new Vector3D(4152.274880917437,17257.554426886258,5.4107546337627355));
         this.wyma.push(new Vector3D(5301.414676411978,17227.875710633496,600));
         this.wyma.push(new Vector3D(5966.3563184794075,17329.65931459977,600));
         this.wyma.push(new Vector3D(6668.5118297350555,17461.49918956589,600));
         this.wyma.push(new Vector3D(7491.799227975729,17515.935408001886,600));
         this.wyma.push(new Vector3D(9997.956773898366,17506.583873367053,600));
         this.wyma.push(new Vector3D(11201.680432523766,17422.785966467545,600));
         this.wyma.push(new Vector3D(12367.535924754367,17290.07092297762,600));
         this.wyma.push(new Vector3D(12639.334332902597,17274.228154812823,600));
         this.wyma.push(new Vector3D(13868.503612589779,17252.23858395794,1196.8252402665612));
         this.wyma.push(new Vector3D(14354.423260475836,17217.356856049253,1200));
         this.wyma.push(new Vector3D(14956.801576615813,17042.679624845958,1200));
         this.wyma.push(new Vector3D(15504.310089997767,16709.2543310878,1200));
         this.wyma.push(new Vector3D(16000.025013623883,16118.528493330721,1200));
         this.wyma.push(new Vector3D(16250.493722212415,15485.949430715522,1200));
         this.wyma.push(new Vector3D(16255.028522424594,11398.802197655652,1200.3991792886395));
         this.wyma.push(new Vector3D(16255.874994099668,10511.326299178605,1496.2244786185693));
         this.wyma.push(new Vector3D(16245.020728517724,10377.831026404881,0));
         this.wyma.push(new Vector3D(16253.48642396853,9835.612010902481,11.699941098399677));
         this.wyma.push(new Vector3D(16240.060515150863,8718.759640939563,591.5677427639584));
         this.wyma.push(new Vector3D(16250.111211979056,8313.092529102027,600));
         this.wyma.push(new Vector3D(16260.791452495903,7139.446593772094,0));
         this.wyma.push(new Vector3D(16255.81109903368,6781.990925800339,0));
         this.wyma.push(new Vector3D(16126.261060040993,6280.695365459735,0));
         this.wyma.push(new Vector3D(15912.67315850296,5809.955756785598,0));
         this.wyma.push(new Vector3D(15517.912470151643,4912.8316755907335,0));
         this.wyma.push(new Vector3D(14931.335304217431,4118.876870911354,0));
         this.wyma.push(new Vector3D(14307.372623867346,3560.6994493279517,0));
         this.wyma.push(new Vector3D(13585.981456653979,3088.655912696128,0));
         if(param5)
         {
            this.bak = new FillMaterial(16776960);
            for each(_loc6_ in this.wyma)
            {
               this.createSphere(_loc6_);
            }
            param2.view.doubleClickEnabled = true;
            param2.view.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            param2.view.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            param2.view.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            param2.view.addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
            this.tracePoints();
         }
         this.nuqybap = new TextureMaterial(Assets.getData("marking",BitmapData),false,true,MipMapping.PER_PIXEL);
         this.nuqybap.resolution = this.jiso / this.nuqybap.texture.width;
         this.rebuild();
         param1.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private static function calculateAlphaMultiplyForDecal(param1:Decal) : Number
      {
         var _loc5_:Number = NaN;
         var _loc6_:Vector3 = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:Number = 1;
         var _loc3_:int = int(GameData.wuhibota.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = GameData.wuhibota[_loc4_];
            _loc7_ = _loc6_.x - param1.x;
            _loc8_ = _loc6_.y - param1.y;
            _loc9_ = _loc6_.qyririg - param1.z;
            _loc10_ = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_ + _loc9_ * _loc9_);
            if(_loc10_ < cuzuf)
            {
               _loc5_ = 0;
            }
            else
            {
               _loc5_ = 1;
            }
            _loc2_ = Math.min(_loc2_,_loc5_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      private function rebuild() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector3D = null;
         var _loc8_:Vector3D = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         for(_loc1_ in this.mitysosu)
         {
            this.danewazam.removeChild(_loc1_);
            delete this.jowidycuw[_loc1_];
            delete this.mitysosu[_loc1_];
         }
         _loc2_ = 0;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc5_ = 1;
         _loc6_ = int(this.wyma.length);
         while(_loc4_ < _loc6_ - 1)
         {
            _loc7_ = this.wyma[_loc4_];
            _loc8_ = this.wyma[_loc5_];
            _loc9_ = _loc8_.x - _loc7_.x;
            _loc10_ = _loc8_.y - _loc7_.y;
            _loc11_ = _loc8_.z - _loc7_.z;
            _loc12_ = Math.sqrt(_loc9_ * _loc9_ + _loc10_ * _loc10_ + _loc11_ * _loc11_);
            _loc9_ /= _loc12_;
            _loc10_ /= _loc12_;
            _loc11_ /= _loc12_;
            if(_loc4_ == 0)
            {
               this.createDecal(_loc7_.x,_loc7_.y,_loc7_.z,_loc9_,_loc10_,_loc11_);
            }
            _loc2_ += _loc12_;
            _loc13_ = _loc2_ % this.ziryjefom;
            while(_loc3_ < int(_loc2_ / this.ziryjefom))
            {
               if(Math.abs(_loc11_) < 0.75)
               {
                  this.createDecal(_loc8_.x - _loc9_ * _loc13_,_loc8_.y - _loc10_ * _loc13_,_loc8_.z - _loc11_ * _loc13_,_loc9_,_loc10_,_loc11_);
               }
               _loc3_++;
               _loc13_ += this.ziryjefom;
            }
            _loc4_++;
            _loc5_++;
         }
      }
      
      private function createDecal(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this.vyhomopog.x = param1;
         this.vyhomopog.y = param2;
         this.vyhomopog.z = param3;
         this.ruda.x = 0;
         this.ruda.y = 0;
         this.ruda.z = 1;
         var _loc7_:Decal = this.danewazam.createDecal(this.vyhomopog,this.ruda,this.jiso / 2,Math.atan2(param4,param5) + Math.PI,75 * Math.PI / 180,500,this.nuqybap);
         if(!Shared.gpu || GameData.mawoqu < 11)
         {
            _loc7_.z += 10;
            _loc7_.sorting = Sorting.DYNAMIC_BSP;
         }
         _loc7_.useLight = false;
         _loc7_.useShadowMap = false;
         _loc7_.shadowMapAlphaThreshold = 2;
         _loc7_.depthMapAlphaThreshold = 2;
         if(!this.kaweq)
         {
            _loc7_.visible = false;
         }
         this.danewazam.addChild(_loc7_);
         this.mitysosu[_loc7_] = true;
         this.jowidycuw[_loc7_] = true;
         this.qiqegoken[_loc7_] = calculateAlphaMultiplyForDecal(_loc7_);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Vector3 = null;
         var _loc3_:* = undefined;
         var _loc4_:Object3D = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         if(!this.kaweq)
         {
            if(this.citacir.hogys != null)
            {
               _loc2_ = this.citacir.hogys.body.kejo.position;
               for(_loc3_ in this.mitysosu)
               {
                  _loc4_ = _loc3_;
                  _loc5_ = _loc2_.x - _loc4_.x;
                  _loc6_ = _loc2_.y - _loc4_.y;
                  _loc7_ = _loc2_.qyririg - _loc4_.z;
                  _loc8_ = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_ + _loc7_ * _loc7_);
                  _loc9_ = Number(this.qiqegoken[_loc4_]);
                  if(_loc9_ == 1 && _loc8_ < this.fowovany)
                  {
                     _loc4_.visible = true;
                     if(_loc8_ > this.pag)
                     {
                        _loc4_.alpha = 1 - (_loc8_ - this.pag) / (this.fowovany - this.pag);
                     }
                     else if(_loc8_ < this.vezuq)
                     {
                        _loc4_.alpha = _loc8_ / this.vezuq;
                        _loc4_.alpha *= _loc4_.alpha;
                     }
                     else
                     {
                        _loc4_.alpha = 1;
                     }
                  }
                  else
                  {
                     _loc4_.visible = false;
                  }
               }
            }
         }
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:SpectatorCameraController = null;
         var _loc4_:Vector3D = null;
         this.butefu.calculateRay(this.vyhomopog,this.ruda,this.butefu.view.mouseX,this.butefu.view.mouseY);
         var _loc2_:RayIntersectionData = this.danewazam.intersectRay(this.vyhomopog,this.ruda,this.mitysosu);
         if(_loc2_ != null)
         {
            if(_loc2_.object is Sphere)
            {
               _loc3_ = (this.butefu as GameCamera).controller as SpectatorCameraController;
               if(_loc3_ != null)
               {
                  _loc3_.vucofena = false;
               }
               this.kes = _loc2_.object;
               _loc4_ = this.butefu.projectGlobal(new Vector3D(this.kes.x,this.kes.y,this.kes.z));
               this.fyryvujut = this.butefu.view.mouseX - _loc4_.x;
               this.qywavage = this.butefu.view.mouseY - _loc4_.y;
               this.zulynuwy = false;
            }
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:RayIntersectionData = null;
         var _loc3_:Vector3D = null;
         if(this.kes != null)
         {
            this.butefu.calculateRay(this.vyhomopog,this.ruda,this.butefu.view.mouseX - this.fyryvujut,this.butefu.view.mouseY - this.qywavage);
            _loc2_ = this.danewazam.intersectRay(this.vyhomopog,this.ruda,this.jowidycuw);
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.object.localToGlobal(_loc2_.point);
               this.kes.x = _loc3_.x;
               this.kes.y = _loc3_.y;
               this.kes.z = _loc3_.z;
               this.zulynuwy = true;
            }
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         var _loc3_:Vector3D = null;
         var _loc2_:SpectatorCameraController = (this.butefu as GameCamera).controller as SpectatorCameraController;
         if(_loc2_ != null)
         {
            _loc2_.vucofena = true;
         }
         if(this.zulynuwy)
         {
            _loc3_ = this.wyma[this.jariba.indexOf(this.kes)];
            _loc3_.x = this.kes.x;
            _loc3_.y = this.kes.y;
            _loc3_.z = this.kes.z;
            this.tracePoints();
            this.rebuild();
         }
         this.kes = null;
         this.zulynuwy = false;
      }
      
      private function onDoubleClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector3D = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Vector3D = null;
         var _loc10_:Vector3D = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         this.butefu.calculateRay(this.vyhomopog,this.ruda,this.butefu.view.mouseX,this.butefu.view.mouseY);
         var _loc2_:RayIntersectionData = this.danewazam.intersectRay(this.vyhomopog,this.ruda,this.mitysosu);
         if(_loc2_ != null)
         {
            _loc5_ = int(this.wyma.length);
            if(_loc2_.object is Sphere)
            {
               this.removeSphere(_loc2_.object);
               _loc3_ = this.jariba.indexOf(_loc2_.object);
               _loc4_ = _loc3_ + 1;
               while(_loc3_ < _loc5_ - 1)
               {
                  this.wyma[_loc3_] = this.wyma[_loc4_];
                  this.jariba[_loc3_] = this.jariba[_loc4_];
                  _loc3_++;
                  _loc4_++;
               }
               this.wyma.length = _loc5_ - 1;
               this.jariba.length = _loc5_ - 1;
            }
            else
            {
               _loc6_ = _loc2_.object.localToGlobal(_loc2_.point);
               if(_loc5_ > 1)
               {
                  _loc7_ = 1e+22;
                  _loc8_ = -1;
                  _loc3_ = 0;
                  _loc4_ = 1;
                  while(_loc3_ < _loc5_ - 1)
                  {
                     _loc9_ = this.wyma[_loc3_];
                     _loc10_ = this.wyma[_loc4_];
                     _loc11_ = _loc10_.x - _loc9_.x;
                     _loc12_ = _loc10_.y - _loc9_.y;
                     _loc13_ = _loc10_.z - _loc9_.z;
                     _loc14_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_ + _loc13_ * _loc13_);
                     _loc11_ /= _loc14_;
                     _loc12_ /= _loc14_;
                     _loc13_ /= _loc14_;
                     _loc15_ = _loc6_.x - _loc9_.x;
                     _loc16_ = _loc6_.y - _loc9_.y;
                     _loc17_ = _loc6_.z - _loc9_.z;
                     _loc18_ = _loc15_ * _loc11_ + _loc16_ * _loc12_ + _loc17_ * _loc13_;
                     if(_loc18_ >= 0)
                     {
                        if(_loc18_ <= _loc14_)
                        {
                           _loc11_ = _loc6_.x - (_loc9_.x + _loc11_ * _loc18_);
                           _loc12_ = _loc6_.y - (_loc9_.y + _loc12_ * _loc18_);
                           _loc13_ = _loc6_.z - (_loc9_.z + _loc13_ * _loc18_);
                           _loc14_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_ + _loc13_ * _loc13_);
                           if(_loc14_ < _loc7_)
                           {
                              _loc7_ = _loc14_;
                              _loc8_ = _loc3_ + 1;
                           }
                        }
                        else
                        {
                           _loc11_ = _loc6_.x - _loc10_.x;
                           _loc12_ = _loc6_.y - _loc10_.y;
                           _loc13_ = _loc6_.z - _loc10_.z;
                           _loc14_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_ + _loc13_ * _loc13_);
                           if(_loc14_ < _loc7_)
                           {
                              _loc7_ = _loc14_;
                              _loc8_ = _loc4_ + 1;
                           }
                        }
                     }
                     else
                     {
                        _loc14_ = Math.sqrt(_loc15_ * _loc15_ + _loc16_ * _loc16_ + _loc17_ * _loc17_);
                        if(_loc14_ < _loc7_)
                        {
                           _loc7_ = _loc14_;
                           _loc8_ = _loc3_;
                        }
                     }
                     _loc3_++;
                     _loc4_++;
                  }
                  _loc3_ = _loc5_ - 1;
                  _loc4_ = _loc5_;
                  while(_loc3_ >= _loc8_)
                  {
                     this.wyma[_loc4_] = this.wyma[_loc3_];
                     this.jariba[_loc4_] = this.jariba[_loc3_];
                     _loc3_--;
                     _loc4_--;
                  }
                  this.wyma[_loc8_] = _loc6_;
               }
               else
               {
                  this.wyma.push(_loc6_);
               }
               this.createSphere(_loc6_);
            }
            this.tracePoints();
            this.rebuild();
         }
      }
      
      private function createSphere(param1:Vector3D) : void
      {
         var _loc2_:Sphere = new Sphere(20,6,5,false,this.bak);
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.z = param1.z;
         _loc2_.useLight = false;
         _loc2_.useShadowMap = false;
         _loc2_.shadowMapAlphaThreshold = 2;
         _loc2_.depthMapAlphaThreshold = 2;
         this.jariba[this.wyma.indexOf(param1)] = _loc2_;
         this.danewazam.addChild(_loc2_);
         this.jowidycuw[_loc2_] = true;
      }
      
      private function removeSphere(param1:Object3D) : void
      {
         this.danewazam.removeChild(param1);
         delete this.jowidycuw[param1];
      }
      
      private function tracePoints() : void
      {
         var _loc2_:Vector3D = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.wyma.length)
         {
            _loc2_ = this.wyma[_loc1_];
            _loc1_++;
         }
      }
   }
}

