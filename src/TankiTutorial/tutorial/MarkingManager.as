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
      
      private const size:Number = 400;
      
      private const DECAL_SPACING:Number = 501.5;
      
      private const NEAR_FADE_DISTANCE:Number = 1600;
      
      private const FAR_FADE_START:Number = 5000;
      
      private const FAR_FADE_END:Number = 7000;
      
      private var material:TextureMaterial;
      
      private var sphereMaterial:FillMaterial;
      
      private var origin:Vector3D;
      
      private var direction:Vector3D;
      
      private var stage:Stage;
      
      private var camera:Camera3D;
      
      private var container:KDContainer;
      
      private var tank:Tank;
      
      private var editMode:Boolean;
      
      private var points:Vector.<Vector3D>;
      
      private var spheres:Vector.<Object3D>;
      
      private var excludedObjects:Dictionary;
      
      private var decals:Dictionary;
      
      private var alphaMultipliers:Dictionary;
      
      private var offsetX:Number;
      
      private var offsetY:Number;
      
      private var target:Object3D = null;
      
      private var moved:Boolean = false;
      
      public function MarkingManager(stage:Stage, camera:Camera3D, container:KDContainer, tank:Tank, editMode:Boolean = false)
      {
         var point:Vector3D = null;
         this.origin = new Vector3D();
         this.direction = new Vector3D();
         this.points = new Vector.<Vector3D>();
         this.spheres = new Vector.<Object3D>();
         this.excludedObjects = new Dictionary();
         this.decals = new Dictionary();
         this.alphaMultipliers = new Dictionary();
         super();
         this.stage = stage;
         this.camera = camera;
         this.container = container;
         this.tank = tank;
         this.editMode = editMode;
         this.points.push(new Vector3D(3000.4304152027394,-5150.442578640652,0));
         this.points.push(new Vector3D(2853.2959168387215,-4514.402183382978,0));
         this.points.push(new Vector3D(2722.7739361528966,-4216.32423984746,0));
         this.points.push(new Vector3D(2555.4916416070278,-3754.3224328743945,0));
         this.points.push(new Vector3D(2547.6451746392645,-3191.207805418414,0));
         this.points.push(new Vector3D(2538.9142371600483,-2850.7747812586576,10));
         this.points.push(new Vector3D(2625.7624633155056,-2508.1406194578785,0));
         this.points.push(new Vector3D(2800.774496445428,-1967.5122090495179,0));
         this.points.push(new Vector3D(3098.6019033962266,-1316.1389742348067,0));
         this.points.push(new Vector3D(3214.7792727402725,-1061.5087656775381,0));
         this.points.push(new Vector3D(3247.340143968684,-823.157496169054,0));
         this.points.push(new Vector3D(3249.9295289447236,367.3348778626091,-600));
         this.points.push(new Vector3D(3367.776419816074,821.4269011793573,-600));
         this.points.push(new Vector3D(3625.899496901398,1113.8213961625472,-600));
         this.points.push(new Vector3D(3964.4345658175826,1228.577455213981,-600));
         this.points.push(new Vector3D(4736.4472191871055,1279.3006305618183,-600));
         this.points.push(new Vector3D(5233.994773991302,1267.429629337654,-616.3424520831422));
         this.points.push(new Vector3D(6386.8895480920455,1249.8747309299604,-1200));
         this.points.push(new Vector3D(7049.110586282284,1547.5975118121992,-1200));
         this.points.push(new Vector3D(7504.743424919196,2092.388469640213,-1200));
         this.points.push(new Vector3D(7665.8464853677415,2556.7478081187105,-1200));
         this.points.push(new Vector3D(7652.102828702433,3030.213756510041,-1200));
         this.points.push(new Vector3D(7509.615681479855,3460.0734808684347,-1200));
         this.points.push(new Vector3D(7162.750619936882,3887.7512718918174,-1200));
         this.points.push(new Vector3D(6683.175087434381,4299.04226345357,-1200));
         this.points.push(new Vector3D(5963.462253210884,4850.798229744866,-1199.999999999999));
         this.points.push(new Vector3D(5275.328834548684,5331.71349855082,-1200));
         this.points.push(new Vector3D(4850.437893600176,5599.832950305227,-1200));
         this.points.push(new Vector3D(4421.727603474693,5726.582330281722,-1200));
         this.points.push(new Vector3D(3120.8067742918674,5754.230464577145,-599.999939367649));
         this.points.push(new Vector3D(2794.5221613006333,5864.1734995744555,-600.0000000000005));
         this.points.push(new Vector3D(2359.8576265946413,6101.673384747236,-600));
         this.points.push(new Vector3D(1731.3456574368795,6723.152325736999,-599.9999999999991));
         this.points.push(new Vector3D(1144.4414060605927,7659.3613183703355,-600));
         this.points.push(new Vector3D(635.7894935671845,8651.230407140025,-600));
         this.points.push(new Vector3D(414.9456791668341,9705.138812374289,-600));
         this.points.push(new Vector3D(243.11387750451686,10626.137430608387,-600));
         this.points.push(new Vector3D(235.44981825888817,11885.487761986831,0.0000615370126979542));
         this.points.push(new Vector3D(256.7144740536511,12158.944396268509,0));
         this.points.push(new Vector3D(417.60397440636496,12840.8985714797,0));
         this.points.push(new Vector3D(735.5082651599066,13510.146167494286,0));
         this.points.push(new Vector3D(1158.2153098379301,14127.978419597903,0));
         this.points.push(new Vector3D(1701.940935179659,15104.214067951329,0));
         this.points.push(new Vector3D(2502.433830507002,16231.80177686567,0));
         this.points.push(new Vector3D(3056.210836203401,16811.280603765637,0));
         this.points.push(new Vector3D(3817.744791989682,17213.86854139798,0));
         this.points.push(new Vector3D(4152.274880917437,17257.554426886258,5.4107546337627355));
         this.points.push(new Vector3D(5301.414676411978,17227.875710633496,600));
         this.points.push(new Vector3D(5966.3563184794075,17329.65931459977,600));
         this.points.push(new Vector3D(6668.5118297350555,17461.49918956589,600));
         this.points.push(new Vector3D(7491.799227975729,17515.935408001886,600));
         this.points.push(new Vector3D(9997.956773898366,17506.583873367053,600));
         this.points.push(new Vector3D(11201.680432523766,17422.785966467545,600));
         this.points.push(new Vector3D(12367.535924754367,17290.07092297762,600));
         this.points.push(new Vector3D(12639.334332902597,17274.228154812823,600));
         this.points.push(new Vector3D(13868.503612589779,17252.23858395794,1196.8252402665612));
         this.points.push(new Vector3D(14354.423260475836,17217.356856049253,1200));
         this.points.push(new Vector3D(14956.801576615813,17042.679624845958,1200));
         this.points.push(new Vector3D(15504.310089997767,16709.2543310878,1200));
         this.points.push(new Vector3D(16000.025013623883,16118.528493330721,1200));
         this.points.push(new Vector3D(16250.493722212415,15485.949430715522,1200));
         this.points.push(new Vector3D(16255.028522424594,11398.802197655652,1200.3991792886395));
         this.points.push(new Vector3D(16255.874994099668,10511.326299178605,1496.2244786185693));
         this.points.push(new Vector3D(16245.020728517724,10377.831026404881,0));
         this.points.push(new Vector3D(16253.48642396853,9835.612010902481,11.699941098399677));
         this.points.push(new Vector3D(16240.060515150863,8718.759640939563,591.5677427639584));
         this.points.push(new Vector3D(16250.111211979056,8313.092529102027,600));
         this.points.push(new Vector3D(16260.791452495903,7139.446593772094,0));
         this.points.push(new Vector3D(16255.81109903368,6781.990925800339,0));
         this.points.push(new Vector3D(16126.261060040993,6280.695365459735,0));
         this.points.push(new Vector3D(15912.67315850296,5809.955756785598,0));
         this.points.push(new Vector3D(15517.912470151643,4912.8316755907335,0));
         this.points.push(new Vector3D(14931.335304217431,4118.876870911354,0));
         this.points.push(new Vector3D(14307.372623867346,3560.6994493279517,0));
         this.points.push(new Vector3D(13585.981456653979,3088.655912696128,0));
         if(editMode)
         {
            this.sphereMaterial = new FillMaterial(16776960);
            for each(point in this.points)
            {
               this.createSphere(point);
            }
            camera.view.doubleClickEnabled = true;
            camera.view.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            camera.view.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
            camera.view.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            camera.view.addEventListener(MouseEvent.DOUBLE_CLICK,this.onDoubleClick);
            this.tracePoints();
         }
         this.material = new TextureMaterial(Assets.getData("marking",BitmapData),false,true,MipMapping.PER_PIXEL);
         this.material.resolution = this.size / this.material.texture.width;
         this.rebuild();
         stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private static function calculateAlphaMultiplyForDecal(decal:Decal) : Number
      {
         var alpha:Number = NaN;
         var region:Vector3 = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var distance:Number = NaN;
         var result:Number = 1;
         var len:int = int(GameData.bonusRegions.length);
         var i:int = 0;
         while(i < len)
         {
            region = GameData.bonusRegions[i];
            dx = region.x - decal.x;
            dy = region.y - decal.y;
            dz = region.z - decal.z;
            distance = Math.sqrt(dx * dx + dy * dy + dz * dz);
            if(distance < cuzuf)
            {
               alpha = 0;
            }
            else
            {
               alpha = 1;
            }
            result = Math.min(result,alpha);
            i++;
         }
         return result;
      }
      
      private function rebuild() : void
      {
         var decal:* = undefined;
         var pathLength:Number = NaN;
         var numDecals:int = 0;
         var i:int = 0;
         var j:int = 0;
         var len:int = 0;
         var a:Vector3D = null;
         var b:Vector3D = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var segmentLength:Number = NaN;
         var _loc13_:Number = NaN;
         for(decal in this.decals)
         {
            this.container.removeChild(decal);
            delete this.excludedObjects[decal];
            delete this.decals[decal];
         }
         pathLength = 0;
         numDecals = 0;
         i = 0;
         j = 1;
         len = int(this.points.length);
         while(i < len - 1)
         {
            a = this.points[i];
            b = this.points[j];
            dx = b.x - a.x;
            dy = b.y - a.y;
            dz = b.z - a.z;
            segmentLength = Math.sqrt(dx * dx + dy * dy + dz * dz);
            dx /= segmentLength;
            dy /= segmentLength;
            dz /= segmentLength;
            if(i == 0)
            {
               this.createDecal(a.x,a.y,a.z,dx,dy,dz);
            }
            pathLength += segmentLength;
            _loc13_ = pathLength % this.DECAL_SPACING;
            while(numDecals < int(pathLength / this.DECAL_SPACING))
            {
               if(Math.abs(dz) < 0.75)
               {
                  this.createDecal(b.x - dx * _loc13_,b.y - dy * _loc13_,b.z - dz * _loc13_,dx,dy,dz);
               }
               numDecals++;
               _loc13_ += this.DECAL_SPACING;
            }
            i++;
            j++;
         }
      }
      
      private function createDecal(x:Number, y:Number, z:Number, dx:Number, dy:Number, dz:Number) : void
      {
         this.origin.x = x;
         this.origin.y = y;
         this.origin.z = z;
         this.direction.x = 0;
         this.direction.y = 0;
         this.direction.z = 1;
         var decal:Decal = this.container.createDecal(this.origin,this.direction,this.size / 2,Math.atan2(dx,dy) + Math.PI,75 * Math.PI / 180,500,this.material);
         if(!Shared.gpu || GameData.version < 11)
         {
            decal.z += 10;
            decal.sorting = Sorting.DYNAMIC_BSP;
         }
         decal.useLight = false;
         decal.useShadowMap = false;
         decal.shadowMapAlphaThreshold = 2;
         decal.depthMapAlphaThreshold = 2;
         if(!this.editMode)
         {
            decal.visible = false;
         }
         this.container.addChild(decal);
         this.decals[decal] = true;
         this.excludedObjects[decal] = true;
         this.alphaMultipliers[decal] = calculateAlphaMultiplyForDecal(decal);
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var position:Vector3 = null;
         var key:* = undefined;
         var decal:Object3D = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var distance:Number = NaN;
         var alphaMultiplier:Number = NaN;
         if(!this.editMode)
         {
            if(this.tank.hogys != null)
            {
               position = this.tank.hogys.body.state.position;
               for(key in this.decals)
               {
                  decal = key;
                  dx = position.x - decal.x;
                  dy = position.y - decal.y;
                  dz = position.z - decal.z;
                  distance = Math.sqrt(dx * dx + dy * dy + dz * dz);
                  alphaMultiplier = Number(this.alphaMultipliers[decal]);
                  if(alphaMultiplier == 1 && distance < this.FAR_FADE_END)
                  {
                     decal.visible = true;
                     if(distance > this.FAR_FADE_START)
                     {
                        decal.alpha = 1 - (distance - this.FAR_FADE_START) / (this.FAR_FADE_END - this.FAR_FADE_START);
                     }
                     else if(distance < this.NEAR_FADE_DISTANCE)
                     {
                        decal.alpha = distance / this.NEAR_FADE_DISTANCE;
                        decal.alpha *= decal.alpha;
                     }
                     else
                     {
                        decal.alpha = 1;
                     }
                  }
                  else
                  {
                     decal.visible = false;
                  }
               }
            }
         }
      }
      
      private function onMouseDown(mouseEvent:MouseEvent) : void
      {
         var controller:SpectatorCameraController = null;
         var projected:Vector3D = null;
         this.camera.calculateRay(this.origin,this.direction,this.camera.view.mouseX,this.camera.view.mouseY);
         var data:RayIntersectionData = this.container.intersectRay(this.origin,this.direction,this.decals);
         if(data != null)
         {
            if(data.object is Sphere)
            {
               controller = (this.camera as GameCamera).controller as SpectatorCameraController;
               if(controller != null)
               {
                  controller.mouseEnabled = false;
               }
               this.target = data.object;
               projected = this.camera.projectGlobal(new Vector3D(this.target.x,this.target.y,this.target.z));
               this.offsetX = this.camera.view.mouseX - projected.x;
               this.offsetY = this.camera.view.mouseY - projected.y;
               this.moved = false;
            }
         }
      }
      
      private function onMouseMove(mouseEvent:MouseEvent) : void
      {
         var data:RayIntersectionData = null;
         var point:Vector3D = null;
         if(this.target != null)
         {
            this.camera.calculateRay(this.origin,this.direction,this.camera.view.mouseX - this.offsetX,this.camera.view.mouseY - this.offsetY);
            data = this.container.intersectRay(this.origin,this.direction,this.excludedObjects);
            if(data != null)
            {
               point = data.object.localToGlobal(data.point);
               this.target.x = point.x;
               this.target.y = point.y;
               this.target.z = point.z;
               this.moved = true;
            }
         }
      }
      
      private function onMouseUp(mouseEvent:MouseEvent) : void
      {
         var point:Vector3D = null;
         var controller:SpectatorCameraController = (this.camera as GameCamera).controller as SpectatorCameraController;
         if(controller != null)
         {
            controller.mouseEnabled = true;
         }
         if(this.moved)
         {
            point = this.points[this.spheres.indexOf(this.target)];
            point.x = this.target.x;
            point.y = this.target.y;
            point.z = this.target.z;
            this.tracePoints();
            this.rebuild();
         }
         this.target = null;
         this.moved = false;
      }
      
      private function onDoubleClick(mouseEvent:MouseEvent) : void
      {
         var i:int = 0;
         var j:int = 0;
         var len:int = 0;
         var point:Vector3D = null;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var a:Vector3D = null;
         var b:Vector3D = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         this.camera.calculateRay(this.origin,this.direction,this.camera.view.mouseX,this.camera.view.mouseY);
         var data:RayIntersectionData = this.container.intersectRay(this.origin,this.direction,this.decals);
         if(data != null)
         {
            len = int(this.points.length);
            if(data.object is Sphere)
            {
               this.removeSphere(data.object);
               i = this.spheres.indexOf(data.object);
               j = i + 1;
               while(i < len - 1)
               {
                  this.points[i] = this.points[j];
                  this.spheres[i] = this.spheres[j];
                  i++;
                  j++;
               }
               this.points.length = len - 1;
               this.spheres.length = len - 1;
            }
            else
            {
               point = data.object.localToGlobal(data.point);
               if(len > 1)
               {
                  _loc7_ = 1e+22;
                  _loc8_ = -1;
                  i = 0;
                  j = 1;
                  while(i < len - 1)
                  {
                     a = this.points[i];
                     b = this.points[j];
                     _loc11_ = b.x - a.x;
                     _loc12_ = b.y - a.y;
                     _loc13_ = b.z - a.z;
                     _loc14_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_ + _loc13_ * _loc13_);
                     _loc11_ /= _loc14_;
                     _loc12_ /= _loc14_;
                     _loc13_ /= _loc14_;
                     _loc15_ = point.x - a.x;
                     _loc16_ = point.y - a.y;
                     _loc17_ = point.z - a.z;
                     _loc18_ = _loc15_ * _loc11_ + _loc16_ * _loc12_ + _loc17_ * _loc13_;
                     if(_loc18_ >= 0)
                     {
                        if(_loc18_ <= _loc14_)
                        {
                           _loc11_ = point.x - (a.x + _loc11_ * _loc18_);
                           _loc12_ = point.y - (a.y + _loc12_ * _loc18_);
                           _loc13_ = point.z - (a.z + _loc13_ * _loc18_);
                           _loc14_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_ + _loc13_ * _loc13_);
                           if(_loc14_ < _loc7_)
                           {
                              _loc7_ = _loc14_;
                              _loc8_ = i + 1;
                           }
                        }
                        else
                        {
                           _loc11_ = point.x - b.x;
                           _loc12_ = point.y - b.y;
                           _loc13_ = point.z - b.z;
                           _loc14_ = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_ + _loc13_ * _loc13_);
                           if(_loc14_ < _loc7_)
                           {
                              _loc7_ = _loc14_;
                              _loc8_ = j + 1;
                           }
                        }
                     }
                     else
                     {
                        _loc14_ = Math.sqrt(_loc15_ * _loc15_ + _loc16_ * _loc16_ + _loc17_ * _loc17_);
                        if(_loc14_ < _loc7_)
                        {
                           _loc7_ = _loc14_;
                           _loc8_ = i;
                        }
                     }
                     i++;
                     j++;
                  }
                  i = len - 1;
                  j = len;
                  while(i >= _loc8_)
                  {
                     this.points[j] = this.points[i];
                     this.spheres[j] = this.spheres[i];
                     i--;
                     j--;
                  }
                  this.points[_loc8_] = point;
               }
               else
               {
                  this.points.push(point);
               }
               this.createSphere(point);
            }
            this.tracePoints();
            this.rebuild();
         }
      }
      
      private function createSphere(point:Vector3D) : void
      {
         var sphere:Sphere = new Sphere(20,6,5,false,this.sphereMaterial);
         sphere.x = point.x;
         sphere.y = point.y;
         sphere.z = point.z;
         sphere.useLight = false;
         sphere.useShadowMap = false;
         sphere.shadowMapAlphaThreshold = 2;
         sphere.depthMapAlphaThreshold = 2;
         this.spheres[this.points.indexOf(point)] = sphere;
         this.container.addChild(sphere);
         this.excludedObjects[sphere] = true;
      }
      
      private function removeSphere(sphere:Object3D) : void
      {
         this.container.removeChild(sphere);
         delete this.excludedObjects[sphere];
      }
      
      private function tracePoints() : void
      {
         var point:Vector3D = null;
         var i:int = 0;
         while(i < this.points.length)
         {
            point = this.points[i];
            i++;
         }
      }
   }
}

