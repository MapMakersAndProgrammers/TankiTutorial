package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   
   use namespace alternativa3d;
   
   [Event(name="mouseWheel",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseMove",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="rollOut",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="rollOver",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseOut",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseOver",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseUp",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="mouseDown",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="doubleClick",type="alternativa.engine3d.core.MouseEvent3D")]
   [Event(name="click",type="alternativa.engine3d.core.MouseEvent3D")]
   public class Object3D implements IEventDispatcher
   {
      
      alternativa3d static const boundVertexList:Vertex = Vertex.createList(8);
      
      alternativa3d static const tA:Object3D = new Object3D();
      
      alternativa3d static const tB:Object3D = new Object3D();
      
      private static const staticSphere:Vector3D = new Vector3D();
      
      public var x:Number = 0;
      
      public var y:Number = 0;
      
      public var z:Number = 0;
      
      public var rotationX:Number = 0;
      
      public var rotationY:Number = 0;
      
      public var rotationZ:Number = 0;
      
      public var scaleX:Number = 1;
      
      public var scaleY:Number = 1;
      
      public var scaleZ:Number = 1;
      
      public var name:String;
      
      public var visible:Boolean = true;
      
      public var alpha:Number = 1;
      
      public var blendMode:String = "normal";
      
      public var colorTransform:ColorTransform = null;
      
      public var filters:Array = null;
      
      public var mouseEnabled:Boolean = true;
      
      public var doubleClickEnabled:Boolean = false;
      
      public var useHandCursor:Boolean = false;
      
      public var depthMapAlphaThreshold:Number = 1;
      
      public var shadowMapAlphaThreshold:Number = 1;
      
      public var softAttenuation:Number = 0;
      
      public var useShadowMap:Boolean = true;
      
      public var useLight:Boolean = true;
      
      public var boundMinX:Number = -1e+22;
      
      public var boundMinY:Number = -1e+22;
      
      public var boundMinZ:Number = -1e+22;
      
      public var boundMaxX:Number = 1e+22;
      
      public var boundMaxY:Number = 1e+22;
      
      public var boundMaxZ:Number = 1e+22;
      
      alternativa3d var ma:Number;
      
      alternativa3d var mb:Number;
      
      alternativa3d var mc:Number;
      
      alternativa3d var md:Number;
      
      alternativa3d var me:Number;
      
      alternativa3d var mf:Number;
      
      alternativa3d var mg:Number;
      
      alternativa3d var mh:Number;
      
      alternativa3d var mi:Number;
      
      alternativa3d var mj:Number;
      
      alternativa3d var mk:Number;
      
      alternativa3d var ml:Number;
      
      alternativa3d var ima:Number;
      
      alternativa3d var imb:Number;
      
      alternativa3d var imc:Number;
      
      alternativa3d var imd:Number;
      
      alternativa3d var ime:Number;
      
      alternativa3d var imf:Number;
      
      alternativa3d var img:Number;
      
      alternativa3d var imh:Number;
      
      alternativa3d var imi:Number;
      
      alternativa3d var imj:Number;
      
      alternativa3d var imk:Number;
      
      alternativa3d var iml:Number;
      
      alternativa3d var _parent:Object3DContainer;
      
      alternativa3d var next:Object3D;
      
      alternativa3d var culling:int = 0;
      
      alternativa3d var transformId:int = 0;
      
      alternativa3d var distance:Number;
      
      alternativa3d var concatenatedAlpha:Number = 1;
      
      alternativa3d var concatenatedBlendMode:String = "normal";
      
      alternativa3d var concatenatedColorTransform:ColorTransform = null;
      
      alternativa3d var bubbleListeners:Object;
      
      alternativa3d var captureListeners:Object;
      
      alternativa3d var receivedShadows:Vector.<Shadow> = new Vector.<Shadow>();
      
      alternativa3d var receivedShadowsCount:int = 0;
      
      alternativa3d var useDepth:Boolean = false;
      
      alternativa3d var transformConst:Vector.<Number> = new Vector.<Number>(12);
      
      alternativa3d var colorConst:Vector.<Number> = new Vector.<Number>(16);
      
      public function Object3D()
      {
         super();
      }
      
      public function get matrix() : Matrix3D
      {
         tA.composeMatrixFromSource(this);
         return new Matrix3D(Vector.<Number>([tA.ma,tA.me,tA.mi,0,tA.mb,tA.mf,tA.mj,0,tA.mc,tA.mg,tA.mk,0,tA.md,tA.mh,tA.ml,1]));
      }
      
      public function set matrix(value:Matrix3D) : void
      {
         var v:Vector.<Vector3D> = value.decompose();
         var t:Vector3D = v[0];
         var r:Vector3D = v[1];
         var s:Vector3D = v[2];
         this.x = t.x;
         this.y = t.y;
         this.z = t.z;
         this.rotationX = r.x;
         this.rotationY = r.y;
         this.rotationZ = r.z;
         this.scaleX = s.x;
         this.scaleY = s.y;
         this.scaleZ = s.z;
      }
      
      public function get concatenatedMatrix() : Matrix3D
      {
         tA.composeMatrixFromSource(this);
         for(var root:Object3D = this; root._parent != null; )
         {
            root = root._parent;
            tB.composeMatrixFromSource(root);
            tA.appendMatrix(tB);
         }
         return new Matrix3D(Vector.<Number>([tA.ma,tA.me,tA.mi,0,tA.mb,tA.mf,tA.mj,0,tA.mc,tA.mg,tA.mk,0,tA.md,tA.mh,tA.ml,1]));
      }
      
      public function localToGlobal(point:Vector3D) : Vector3D
      {
         tA.composeMatrixFromSource(this);
         for(var root:Object3D = this; root._parent != null; )
         {
            root = root._parent;
            tB.composeMatrixFromSource(root);
            tA.appendMatrix(tB);
         }
         var res:Vector3D = new Vector3D();
         res.x = tA.ma * point.x + tA.mb * point.y + tA.mc * point.z + tA.md;
         res.y = tA.me * point.x + tA.mf * point.y + tA.mg * point.z + tA.mh;
         res.z = tA.mi * point.x + tA.mj * point.y + tA.mk * point.z + tA.ml;
         return res;
      }
      
      public function globalToLocal(point:Vector3D) : Vector3D
      {
         tA.composeMatrixFromSource(this);
         for(var root:Object3D = this; root._parent != null; )
         {
            root = root._parent;
            tB.composeMatrixFromSource(root);
            tA.appendMatrix(tB);
         }
         tA.invertMatrix();
         var res:Vector3D = new Vector3D();
         res.x = tA.ma * point.x + tA.mb * point.y + tA.mc * point.z + tA.md;
         res.y = tA.me * point.x + tA.mf * point.y + tA.mg * point.z + tA.mh;
         res.z = tA.mi * point.x + tA.mj * point.y + tA.mk * point.z + tA.ml;
         return res;
      }
      
      public function get parent() : Object3DContainer
      {
         return this._parent;
      }
      
      alternativa3d function setParent(value:Object3DContainer) : void
      {
         this._parent = value;
      }
      
      public function calculateBounds() : void
      {
         this.boundMinX = 1e+22;
         this.boundMinY = 1e+22;
         this.boundMinZ = 1e+22;
         this.boundMaxX = -1e+22;
         this.boundMaxY = -1e+22;
         this.boundMaxZ = -1e+22;
         this.updateBounds(this,null);
         if(this.boundMinX > this.boundMaxX)
         {
            this.boundMinX = -1e+22;
            this.boundMinY = -1e+22;
            this.boundMinZ = -1e+22;
            this.boundMaxX = 1e+22;
            this.boundMaxY = 1e+22;
            this.boundMaxZ = 1e+22;
         }
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         var listeners:Object = null;
         if(listener == null)
         {
            throw new TypeError("Parameter listener must be non-null.");
         }
         if(useCapture)
         {
            if(this.captureListeners == null)
            {
               this.captureListeners = new Object();
            }
            listeners = this.captureListeners;
         }
         else
         {
            if(this.bubbleListeners == null)
            {
               this.bubbleListeners = new Object();
            }
            listeners = this.bubbleListeners;
         }
         var vector:Vector.<Function> = listeners[type];
         if(vector == null)
         {
            vector = new Vector.<Function>();
            listeners[type] = vector;
         }
         if(vector.indexOf(listener) < 0)
         {
            vector.push(listener);
         }
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         var vector:Vector.<Function> = null;
         var i:int = 0;
         var length:int = 0;
         var j:int = 0;
         var key:* = undefined;
         if(listener == null)
         {
            throw new TypeError("Parameter listener must be non-null.");
         }
         var listeners:Object = useCapture ? this.captureListeners : this.bubbleListeners;
         if(listeners != null)
         {
            vector = listeners[type];
            if(vector != null)
            {
               i = vector.indexOf(listener);
               if(i >= 0)
               {
                  length = int(vector.length);
                  j = i + 1;
                  while(j < length)
                  {
                     vector[i] = vector[j];
                     j++;
                     i++;
                  }
                  if(length > 1)
                  {
                     vector.length = length - 1;
                  }
                  else
                  {
                     delete listeners[type];
                     var _loc10_:int = 0;
                     var _loc11_:* = listeners;
                     for(key in _loc11_)
                     {
                     }
                     if(!key)
                     {
                        if(listeners == this.captureListeners)
                        {
                           this.captureListeners = null;
                        }
                        else
                        {
                           this.bubbleListeners = null;
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         return this.captureListeners != null && Boolean(this.captureListeners[type]) || this.bubbleListeners != null && Boolean(this.bubbleListeners[type]);
      }
      
      public function willTrigger(type:String) : Boolean
      {
         for(var object:Object3D = this; object != null; )
         {
            if(Boolean(object.captureListeners != null) && Boolean(object.captureListeners[type]) || Boolean(object.bubbleListeners != null) && Boolean(object.bubbleListeners[type]))
            {
               return true;
            }
            object = object._parent;
         }
         return false;
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         var object:Object3D = null;
         var vector:Vector.<Function> = null;
         var j:int = 0;
         var length:int = 0;
         var functions:Vector.<Function> = null;
         if(event == null)
         {
            throw new TypeError("Parameter event must be non-null.");
         }
         if(event is MouseEvent3D)
         {
            MouseEvent3D(event)._target = this;
         }
         var branch:Vector.<Object3D> = new Vector.<Object3D>();
         var branchLength:int = 0;
         for(object = this; object != null; object = object._parent)
         {
            branch[branchLength] = object;
            branchLength++;
         }
         for(var i:int = 0; i < branchLength; )
         {
            object = branch[i];
            if(event is MouseEvent3D)
            {
               MouseEvent3D(event)._currentTarget = object;
            }
            if(this.bubbleListeners != null)
            {
               vector = this.bubbleListeners[event.type];
               if(vector != null)
               {
                  length = int(vector.length);
                  functions = new Vector.<Function>();
                  j = 0;
                  while(j < length)
                  {
                     functions[j] = vector[j];
                     j++;
                  }
                  j = 0;
                  while(j < length)
                  {
                     (functions[j] as Function).call(null,event);
                     j++;
                  }
               }
            }
            if(!event.bubbles)
            {
               break;
            }
            i++;
         }
         return true;
      }
      
      public function calculateResolution(textureWidth:int, textureHeight:int, type:int = 1, matrix:Matrix3D = null) : Number
      {
         return 1;
      }
      
      public function intersectRay(origin:Vector3D, direction:Vector3D, excludedObjects:Dictionary = null, camera:Camera3D = null) : RayIntersectionData
      {
         return null;
      }
      
      alternativa3d function checkIntersection(ox:Number, oy:Number, oz:Number, dx:Number, dy:Number, dz:Number, dw:Number, excludedObjects:Dictionary) : Boolean
      {
         return false;
      }
      
      alternativa3d function boundCheckIntersection(ox:Number, oy:Number, oz:Number, dx:Number, dy:Number, dz:Number, dw:Number, boundMinX:Number, boundMinY:Number, boundMinZ:Number, boundMaxX:Number, boundMaxY:Number, boundMaxZ:Number) : Boolean
      {
         var a:Number = NaN;
         var b:Number = NaN;
         var c:Number = NaN;
         var d:Number = NaN;
         var ex:Number = ox + dx * dw;
         var ey:Number = oy + dy * dw;
         var ez:Number = oz + dz * dw;
         if(ox >= boundMinX && ox <= boundMaxX && oy >= boundMinY && oy <= boundMaxY && oz >= boundMinZ && oz <= boundMaxZ || ex >= boundMinX && ex <= boundMaxX && ey >= boundMinY && ey <= boundMaxY && ez >= boundMinZ && ez <= boundMaxZ)
         {
            return true;
         }
         if(ox < boundMinX && ex < boundMinX || ox > boundMaxX && ex > boundMaxX || oy < boundMinY && ey < boundMinY || oy > boundMaxY && ey > boundMaxY || oz < boundMinZ && ez < boundMinZ || oz > boundMaxZ && ez > boundMaxZ)
         {
            return false;
         }
         var threshold:Number = 0.000001;
         if(dx > threshold)
         {
            a = (boundMinX - ox) / dx;
            b = (boundMaxX - ox) / dx;
         }
         else if(dx < -threshold)
         {
            a = (boundMaxX - ox) / dx;
            b = (boundMinX - ox) / dx;
         }
         else
         {
            a = 0;
            b = dw;
         }
         if(dy > threshold)
         {
            c = (boundMinY - oy) / dy;
            d = (boundMaxY - oy) / dy;
         }
         else if(dy < -threshold)
         {
            c = (boundMaxY - oy) / dy;
            d = (boundMinY - oy) / dy;
         }
         else
         {
            c = 0;
            d = dw;
         }
         if(c >= b || d <= a)
         {
            return false;
         }
         if(c < a)
         {
            if(d < b)
            {
               b = d;
            }
         }
         else
         {
            a = c;
            if(d < b)
            {
               b = d;
            }
         }
         if(dz > threshold)
         {
            c = (boundMinZ - oz) / dz;
            d = (boundMaxZ - oz) / dz;
         }
         else if(dz < -threshold)
         {
            c = (boundMaxZ - oz) / dz;
            d = (boundMinZ - oz) / dz;
         }
         else
         {
            c = 0;
            d = dw;
         }
         if(c >= b || d <= a)
         {
            return false;
         }
         return true;
      }
      
      public function clone() : Object3D
      {
         var res:Object3D = new Object3D();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      protected function clonePropertiesFrom(source:Object3D) : void
      {
         this.name = source.name;
         this.visible = source.visible;
         this.alpha = source.alpha;
         this.blendMode = source.blendMode;
         this.mouseEnabled = source.mouseEnabled;
         this.doubleClickEnabled = source.doubleClickEnabled;
         this.useHandCursor = source.useHandCursor;
         this.depthMapAlphaThreshold = source.depthMapAlphaThreshold;
         this.shadowMapAlphaThreshold = source.shadowMapAlphaThreshold;
         this.softAttenuation = source.softAttenuation;
         this.useShadowMap = source.useShadowMap;
         this.useLight = source.useLight;
         this.transformId = source.transformId;
         this.distance = source.distance;
         if(source.colorTransform != null)
         {
            this.colorTransform = new ColorTransform();
            this.colorTransform.concat(source.colorTransform);
         }
         if(source.filters != null)
         {
            this.filters = new Array().concat(source.filters);
         }
         this.x = source.x;
         this.y = source.y;
         this.z = source.z;
         this.rotationX = source.rotationX;
         this.rotationY = source.rotationY;
         this.rotationZ = source.rotationZ;
         this.scaleX = source.scaleX;
         this.scaleY = source.scaleY;
         this.scaleZ = source.scaleZ;
         this.boundMinX = source.boundMinX;
         this.boundMinY = source.boundMinY;
         this.boundMinZ = source.boundMinZ;
         this.boundMaxX = source.boundMaxX;
         this.boundMaxY = source.boundMaxY;
         this.boundMaxZ = source.boundMaxZ;
      }
      
      public function toString() : String
      {
         var className:String = getQualifiedClassName(this);
         return "[" + className.substr(className.indexOf("::") + 2) + " " + this.name + "]";
      }
      
      alternativa3d function draw(camera:Camera3D) : void
      {
      }
      
      alternativa3d function getVG(camera:Camera3D) : VG
      {
         return null;
      }
      
      alternativa3d function updateBounds(bounds:Object3D, transformation:Object3D = null) : void
      {
      }
      
      alternativa3d function concat(parent:Object3DContainer) : void
      {
         this.concatenatedAlpha = parent.concatenatedAlpha * this.alpha;
         this.concatenatedBlendMode = parent.concatenatedBlendMode != "normal" ? parent.concatenatedBlendMode : this.blendMode;
         if(parent.concatenatedColorTransform != null)
         {
            if(this.colorTransform != null)
            {
               this.concatenatedColorTransform = new ColorTransform();
               this.concatenatedColorTransform.redMultiplier = parent.concatenatedColorTransform.redMultiplier;
               this.concatenatedColorTransform.greenMultiplier = parent.concatenatedColorTransform.greenMultiplier;
               this.concatenatedColorTransform.blueMultiplier = parent.concatenatedColorTransform.blueMultiplier;
               this.concatenatedColorTransform.redOffset = parent.concatenatedColorTransform.redOffset;
               this.concatenatedColorTransform.greenOffset = parent.concatenatedColorTransform.greenOffset;
               this.concatenatedColorTransform.blueOffset = parent.concatenatedColorTransform.blueOffset;
               this.concatenatedColorTransform.concat(this.colorTransform);
            }
            else
            {
               this.concatenatedColorTransform = parent.concatenatedColorTransform;
            }
         }
         else
         {
            this.concatenatedColorTransform = this.colorTransform;
         }
         if(this.concatenatedColorTransform != null)
         {
            this.colorConst[0] = this.concatenatedColorTransform.redMultiplier;
            this.colorConst[1] = this.concatenatedColorTransform.greenMultiplier;
            this.colorConst[2] = this.concatenatedColorTransform.blueMultiplier;
            this.colorConst[3] = this.concatenatedAlpha;
            this.colorConst[4] = this.concatenatedColorTransform.redOffset / 255;
            this.colorConst[5] = this.concatenatedColorTransform.greenOffset / 255;
            this.colorConst[6] = this.concatenatedColorTransform.blueOffset / 255;
            this.colorConst[7] = 1 / 4096;
         }
         else if(this.concatenatedAlpha < 1)
         {
            this.colorConst[0] = 1 / 4096;
            this.colorConst[3] = this.concatenatedAlpha;
         }
         else
         {
            this.colorConst[0] = 1 / 4096;
         }
      }
      
      alternativa3d function boundIntersectRay(origin:Vector3D, direction:Vector3D, boundMinX:Number, boundMinY:Number, boundMinZ:Number, boundMaxX:Number, boundMaxY:Number, boundMaxZ:Number) : Boolean
      {
         var a:Number = NaN;
         var b:Number = NaN;
         var c:Number = NaN;
         var d:Number = NaN;
         if(origin.x >= boundMinX && origin.x <= boundMaxX && origin.y >= boundMinY && origin.y <= boundMaxY && origin.z >= boundMinZ && origin.z <= boundMaxZ)
         {
            return true;
         }
         if(origin.x < boundMinX && direction.x <= 0 || origin.x > boundMaxX && direction.x >= 0 || origin.y < boundMinY && direction.y <= 0 || origin.y > boundMaxY && direction.y >= 0 || origin.z < boundMinZ && direction.z <= 0 || origin.z > boundMaxZ && direction.z >= 0)
         {
            return false;
         }
         var threshold:Number = 0.000001;
         if(direction.x > threshold)
         {
            a = (boundMinX - origin.x) / direction.x;
            b = (boundMaxX - origin.x) / direction.x;
         }
         else if(direction.x < -threshold)
         {
            a = (boundMaxX - origin.x) / direction.x;
            b = (boundMinX - origin.x) / direction.x;
         }
         else
         {
            a = 0;
            b = 1e+22;
         }
         if(direction.y > threshold)
         {
            c = (boundMinY - origin.y) / direction.y;
            d = (boundMaxY - origin.y) / direction.y;
         }
         else if(direction.y < -threshold)
         {
            c = (boundMaxY - origin.y) / direction.y;
            d = (boundMinY - origin.y) / direction.y;
         }
         else
         {
            c = 0;
            d = 1e+22;
         }
         if(c >= b || d <= a)
         {
            return false;
         }
         if(c < a)
         {
            if(d < b)
            {
               b = d;
            }
         }
         else
         {
            a = c;
            if(d < b)
            {
               b = d;
            }
         }
         if(direction.z > threshold)
         {
            c = (boundMinZ - origin.z) / direction.z;
            d = (boundMaxZ - origin.z) / direction.z;
         }
         else if(direction.z < -threshold)
         {
            c = (boundMaxZ - origin.z) / direction.z;
            d = (boundMinZ - origin.z) / direction.z;
         }
         else
         {
            c = 0;
            d = 1e+22;
         }
         if(c >= b || d <= a)
         {
            return false;
         }
         return true;
      }
      
      alternativa3d function collectPlanes(center:Vector3D, a:Vector3D, b:Vector3D, c:Vector3D, d:Vector3D, collector:Vector.<Face>, exludedObjects:Dictionary = null) : void
      {
      }
      
      alternativa3d function calculateSphere(center:Vector3D, a:Vector3D, b:Vector3D, c:Vector3D, d:Vector3D, sphere:Vector3D = null) : Vector3D
      {
         this.calculateInverseMatrix();
         var sox:Number = this.ima * center.x + this.imb * center.y + this.imc * center.z + this.imd;
         var soy:Number = this.ime * center.x + this.imf * center.y + this.img * center.z + this.imh;
         var soz:Number = this.imi * center.x + this.imj * center.y + this.imk * center.z + this.iml;
         var sax:Number = this.ima * a.x + this.imb * a.y + this.imc * a.z + this.imd;
         var say:Number = this.ime * a.x + this.imf * a.y + this.img * a.z + this.imh;
         var saz:Number = this.imi * a.x + this.imj * a.y + this.imk * a.z + this.iml;
         var sbx:Number = this.ima * b.x + this.imb * b.y + this.imc * b.z + this.imd;
         var sby:Number = this.ime * b.x + this.imf * b.y + this.img * b.z + this.imh;
         var sbz:Number = this.imi * b.x + this.imj * b.y + this.imk * b.z + this.iml;
         var scx:Number = this.ima * c.x + this.imb * c.y + this.imc * c.z + this.imd;
         var scy:Number = this.ime * c.x + this.imf * c.y + this.img * c.z + this.imh;
         var scz:Number = this.imi * c.x + this.imj * c.y + this.imk * c.z + this.iml;
         var sdx:Number = this.ima * d.x + this.imb * d.y + this.imc * d.z + this.imd;
         var sdy:Number = this.ime * d.x + this.imf * d.y + this.img * d.z + this.imh;
         var sdz:Number = this.imi * d.x + this.imj * d.y + this.imk * d.z + this.iml;
         var dx:Number = sax - sox;
         var dy:Number = say - soy;
         var dz:Number = saz - soz;
         var radius:Number = dx * dx + dy * dy + dz * dz;
         dx = sbx - sox;
         dy = sby - soy;
         dz = sbz - soz;
         var dxyz:Number = dx * dx + dy * dy + dz * dz;
         if(dxyz > radius)
         {
            radius = dxyz;
         }
         dx = scx - sox;
         dy = scy - soy;
         dz = scz - soz;
         dxyz = dx * dx + dy * dy + dz * dz;
         if(dxyz > radius)
         {
            radius = dxyz;
         }
         dx = sdx - sox;
         dy = sdy - soy;
         dz = sdz - soz;
         dxyz = dx * dx + dy * dy + dz * dz;
         if(dxyz > radius)
         {
            radius = dxyz;
         }
         if(sphere == null)
         {
            sphere = staticSphere;
         }
         sphere.x = sox;
         sphere.y = soy;
         sphere.z = soz;
         sphere.w = Math.sqrt(radius);
         return sphere;
      }
      
      alternativa3d function boundIntersectSphere(sphere:Vector3D, boundMinX:Number, boundMinY:Number, boundMinZ:Number, boundMaxX:Number, boundMaxY:Number, boundMaxZ:Number) : Boolean
      {
         return sphere.x + sphere.w > boundMinX && sphere.x - sphere.w < boundMaxX && sphere.y + sphere.w > boundMinY && sphere.y - sphere.w < boundMaxY && sphere.z + sphere.w > boundMinZ && sphere.z - sphere.w < boundMaxZ;
      }
      
      alternativa3d function split(a:Vector3D, b:Vector3D, c:Vector3D, threshold:Number) : Vector.<Object3D>
      {
         return new Vector.<Object3D>(2);
      }
      
      alternativa3d function testSplit(a:Vector3D, b:Vector3D, c:Vector3D, threshold:Number) : int
      {
         var plane:Vector3D = this.calculatePlane(a,b,c);
         if(plane.x >= 0)
         {
            if(plane.y >= 0)
            {
               if(plane.z >= 0)
               {
                  if(this.boundMaxX * plane.x + this.boundMaxY * plane.y + this.boundMaxZ * plane.z <= plane.w + threshold)
                  {
                     return -1;
                  }
                  if(this.boundMinX * plane.x + this.boundMinY * plane.y + this.boundMinZ * plane.z >= plane.w - threshold)
                  {
                     return 1;
                  }
               }
               else
               {
                  if(this.boundMaxX * plane.x + this.boundMaxY * plane.y + this.boundMinZ * plane.z <= plane.w + threshold)
                  {
                     return -1;
                  }
                  if(this.boundMinX * plane.x + this.boundMinY * plane.y + this.boundMaxZ * plane.z >= plane.w - threshold)
                  {
                     return 1;
                  }
               }
            }
            else if(plane.z >= 0)
            {
               if(this.boundMaxX * plane.x + this.boundMinY * plane.y + this.boundMaxZ * plane.z <= plane.w + threshold)
               {
                  return -1;
               }
               if(this.boundMinX * plane.x + this.boundMaxY * plane.y + this.boundMinZ * plane.z >= plane.w - threshold)
               {
                  return 1;
               }
            }
            else
            {
               if(this.boundMaxX * plane.x + this.boundMinY * plane.y + this.boundMinZ * plane.z <= plane.w + threshold)
               {
                  return -1;
               }
               if(this.boundMinX * plane.x + this.boundMaxY * plane.y + this.boundMaxZ * plane.z >= plane.w - threshold)
               {
                  return 1;
               }
            }
         }
         else if(plane.y >= 0)
         {
            if(plane.z >= 0)
            {
               if(this.boundMinX * plane.x + this.boundMaxY * plane.y + this.boundMaxZ * plane.z <= plane.w + threshold)
               {
                  return -1;
               }
               if(this.boundMaxX * plane.x + this.boundMinY * plane.y + this.boundMinZ * plane.z >= plane.w - threshold)
               {
                  return 1;
               }
            }
            else
            {
               if(this.boundMinX * plane.x + this.boundMaxY * plane.y + this.boundMinZ * plane.z <= plane.w + threshold)
               {
                  return -1;
               }
               if(this.boundMaxX * plane.x + this.boundMinY * plane.y + this.boundMaxZ * plane.z >= plane.w - threshold)
               {
                  return 1;
               }
            }
         }
         else if(plane.z >= 0)
         {
            if(this.boundMinX * plane.x + this.boundMinY * plane.y + this.boundMaxZ * plane.z <= plane.w + threshold)
            {
               return -1;
            }
            if(this.boundMaxX * plane.x + this.boundMaxY * plane.y + this.boundMinZ * plane.z >= plane.w - threshold)
            {
               return 1;
            }
         }
         else
         {
            if(this.boundMinX * plane.x + this.boundMinY * plane.y + this.boundMinZ * plane.z <= plane.w + threshold)
            {
               return -1;
            }
            if(this.boundMaxX * plane.x + this.boundMaxY * plane.y + this.boundMaxZ * plane.z >= plane.w - threshold)
            {
               return 1;
            }
         }
         return 0;
      }
      
      alternativa3d function calculatePlane(a:Vector3D, b:Vector3D, c:Vector3D) : Vector3D
      {
         var res:Vector3D = new Vector3D();
         var abx:Number = b.x - a.x;
         var aby:Number = b.y - a.y;
         var abz:Number = b.z - a.z;
         var acx:Number = c.x - a.x;
         var acy:Number = c.y - a.y;
         var acz:Number = c.z - a.z;
         res.x = acz * aby - acy * abz;
         res.y = acx * abz - acz * abx;
         res.z = acy * abx - acx * aby;
         var len:Number = res.x * res.x + res.y * res.y + res.z * res.z;
         if(len > 0.0001)
         {
            len = Math.sqrt(len);
            res.x /= len;
            res.y /= len;
            res.z /= len;
         }
         res.w = a.x * res.x + a.y * res.y + a.z * res.z;
         return res;
      }
      
      alternativa3d function composeMatrix() : void
      {
         var cosX:Number = Math.cos(this.rotationX);
         var sinX:Number = Math.sin(this.rotationX);
         var cosY:Number = Math.cos(this.rotationY);
         var sinY:Number = Math.sin(this.rotationY);
         var cosZ:Number = Math.cos(this.rotationZ);
         var sinZ:Number = Math.sin(this.rotationZ);
         var cosZsinY:Number = cosZ * sinY;
         var sinZsinY:Number = sinZ * sinY;
         var cosYscaleX:Number = cosY * this.scaleX;
         var sinXscaleY:Number = sinX * this.scaleY;
         var cosXscaleY:Number = cosX * this.scaleY;
         var cosXscaleZ:Number = cosX * this.scaleZ;
         var sinXscaleZ:Number = sinX * this.scaleZ;
         this.ma = cosZ * cosYscaleX;
         this.mb = cosZsinY * sinXscaleY - sinZ * cosXscaleY;
         this.mc = cosZsinY * cosXscaleZ + sinZ * sinXscaleZ;
         this.md = this.x;
         this.me = sinZ * cosYscaleX;
         this.mf = sinZsinY * sinXscaleY + cosZ * cosXscaleY;
         this.mg = sinZsinY * cosXscaleZ - cosZ * sinXscaleZ;
         this.mh = this.y;
         this.mi = -sinY * this.scaleX;
         this.mj = cosY * sinXscaleY;
         this.mk = cosY * cosXscaleZ;
         this.ml = this.z;
      }
      
      alternativa3d function composeMatrixFromSource(source:Object3D) : void
      {
         var cosX:Number = Math.cos(source.rotationX);
         var sinX:Number = Math.sin(source.rotationX);
         var cosY:Number = Math.cos(source.rotationY);
         var sinY:Number = Math.sin(source.rotationY);
         var cosZ:Number = Math.cos(source.rotationZ);
         var sinZ:Number = Math.sin(source.rotationZ);
         var cosZsinY:Number = cosZ * sinY;
         var sinZsinY:Number = sinZ * sinY;
         var cosYscaleX:Number = cosY * source.scaleX;
         var sinXscaleY:Number = sinX * source.scaleY;
         var cosXscaleY:Number = cosX * source.scaleY;
         var cosXscaleZ:Number = cosX * source.scaleZ;
         var sinXscaleZ:Number = sinX * source.scaleZ;
         this.ma = cosZ * cosYscaleX;
         this.mb = cosZsinY * sinXscaleY - sinZ * cosXscaleY;
         this.mc = cosZsinY * cosXscaleZ + sinZ * sinXscaleZ;
         this.md = source.x;
         this.me = sinZ * cosYscaleX;
         this.mf = sinZsinY * sinXscaleY + cosZ * cosXscaleY;
         this.mg = sinZsinY * cosXscaleZ - cosZ * sinXscaleZ;
         this.mh = source.y;
         this.mi = -sinY * source.scaleX;
         this.mj = cosY * sinXscaleY;
         this.mk = cosY * cosXscaleZ;
         this.ml = source.z;
      }
      
      alternativa3d function appendMatrix(transform:Object3D) : void
      {
         var a:Number = this.ma;
         var b:Number = this.mb;
         var c:Number = this.mc;
         var d:Number = this.md;
         var e:Number = this.me;
         var f:Number = this.mf;
         var g:Number = this.mg;
         var h:Number = this.mh;
         var i:Number = this.mi;
         var j:Number = this.mj;
         var k:Number = this.mk;
         var l:Number = this.ml;
         this.ma = transform.ma * a + transform.mb * e + transform.mc * i;
         this.mb = transform.ma * b + transform.mb * f + transform.mc * j;
         this.mc = transform.ma * c + transform.mb * g + transform.mc * k;
         this.md = transform.ma * d + transform.mb * h + transform.mc * l + transform.md;
         this.me = transform.me * a + transform.mf * e + transform.mg * i;
         this.mf = transform.me * b + transform.mf * f + transform.mg * j;
         this.mg = transform.me * c + transform.mf * g + transform.mg * k;
         this.mh = transform.me * d + transform.mf * h + transform.mg * l + transform.mh;
         this.mi = transform.mi * a + transform.mj * e + transform.mk * i;
         this.mj = transform.mi * b + transform.mj * f + transform.mk * j;
         this.mk = transform.mi * c + transform.mj * g + transform.mk * k;
         this.ml = transform.mi * d + transform.mj * h + transform.mk * l + transform.ml;
      }
      
      alternativa3d function composeAndAppend(transform:Object3D) : void
      {
         var cosX:Number = Math.cos(this.rotationX);
         var sinX:Number = Math.sin(this.rotationX);
         var cosY:Number = Math.cos(this.rotationY);
         var sinY:Number = Math.sin(this.rotationY);
         var cosZ:Number = Math.cos(this.rotationZ);
         var sinZ:Number = Math.sin(this.rotationZ);
         var cosZsinY:Number = cosZ * sinY;
         var sinZsinY:Number = sinZ * sinY;
         var cosYscaleX:Number = cosY * this.scaleX;
         var sinXscaleY:Number = sinX * this.scaleY;
         var cosXscaleY:Number = cosX * this.scaleY;
         var cosXscaleZ:Number = cosX * this.scaleZ;
         var sinXscaleZ:Number = sinX * this.scaleZ;
         var a:Number = cosZ * cosYscaleX;
         var b:Number = cosZsinY * sinXscaleY - sinZ * cosXscaleY;
         var c:Number = cosZsinY * cosXscaleZ + sinZ * sinXscaleZ;
         var d:Number = this.x;
         var e:Number = sinZ * cosYscaleX;
         var f:Number = sinZsinY * sinXscaleY + cosZ * cosXscaleY;
         var g:Number = sinZsinY * cosXscaleZ - cosZ * sinXscaleZ;
         var h:Number = this.y;
         var i:Number = -sinY * this.scaleX;
         var j:Number = cosY * sinXscaleY;
         var k:Number = cosY * cosXscaleZ;
         var l:Number = this.z;
         this.ma = transform.ma * a + transform.mb * e + transform.mc * i;
         this.mb = transform.ma * b + transform.mb * f + transform.mc * j;
         this.mc = transform.ma * c + transform.mb * g + transform.mc * k;
         this.md = transform.ma * d + transform.mb * h + transform.mc * l + transform.md;
         this.me = transform.me * a + transform.mf * e + transform.mg * i;
         this.mf = transform.me * b + transform.mf * f + transform.mg * j;
         this.mg = transform.me * c + transform.mf * g + transform.mg * k;
         this.mh = transform.me * d + transform.mf * h + transform.mg * l + transform.mh;
         this.mi = transform.mi * a + transform.mj * e + transform.mk * i;
         this.mj = transform.mi * b + transform.mj * f + transform.mk * j;
         this.mk = transform.mi * c + transform.mj * g + transform.mk * k;
         this.ml = transform.mi * d + transform.mj * h + transform.mk * l + transform.ml;
      }
      
      alternativa3d function copyAndAppend(composed:Object3D, transform:Object3D) : void
      {
         this.ma = transform.ma * composed.ma + transform.mb * composed.me + transform.mc * composed.mi;
         this.mb = transform.ma * composed.mb + transform.mb * composed.mf + transform.mc * composed.mj;
         this.mc = transform.ma * composed.mc + transform.mb * composed.mg + transform.mc * composed.mk;
         this.md = transform.ma * composed.md + transform.mb * composed.mh + transform.mc * composed.ml + transform.md;
         this.me = transform.me * composed.ma + transform.mf * composed.me + transform.mg * composed.mi;
         this.mf = transform.me * composed.mb + transform.mf * composed.mf + transform.mg * composed.mj;
         this.mg = transform.me * composed.mc + transform.mf * composed.mg + transform.mg * composed.mk;
         this.mh = transform.me * composed.md + transform.mf * composed.mh + transform.mg * composed.ml + transform.mh;
         this.mi = transform.mi * composed.ma + transform.mj * composed.me + transform.mk * composed.mi;
         this.mj = transform.mi * composed.mb + transform.mj * composed.mf + transform.mk * composed.mj;
         this.mk = transform.mi * composed.mc + transform.mj * composed.mg + transform.mk * composed.mk;
         this.ml = transform.mi * composed.md + transform.mj * composed.mh + transform.mk * composed.ml + transform.ml;
      }
      
      alternativa3d function invertMatrix() : void
      {
         var a:Number = this.ma;
         var b:Number = this.mb;
         var c:Number = this.mc;
         var d:Number = this.md;
         var e:Number = this.me;
         var f:Number = this.mf;
         var g:Number = this.mg;
         var h:Number = this.mh;
         var i:Number = this.mi;
         var j:Number = this.mj;
         var k:Number = this.mk;
         var l:Number = this.ml;
         var det:Number = 1 / (-c * f * i + b * g * i + c * e * j - a * g * j - b * e * k + a * f * k);
         this.ma = (-g * j + f * k) * det;
         this.mb = (c * j - b * k) * det;
         this.mc = (-c * f + b * g) * det;
         this.md = (d * g * j - c * h * j - d * f * k + b * h * k + c * f * l - b * g * l) * det;
         this.me = (g * i - e * k) * det;
         this.mf = (-c * i + a * k) * det;
         this.mg = (c * e - a * g) * det;
         this.mh = (c * h * i - d * g * i + d * e * k - a * h * k - c * e * l + a * g * l) * det;
         this.mi = (-f * i + e * j) * det;
         this.mj = (b * i - a * j) * det;
         this.mk = (-b * e + a * f) * det;
         this.ml = (d * f * i - b * h * i - d * e * j + a * h * j + b * e * l - a * f * l) * det;
      }
      
      alternativa3d function calculateInverseMatrix() : void
      {
         var det:Number = 1 / (-this.mc * this.mf * this.mi + this.mb * this.mg * this.mi + this.mc * this.me * this.mj - this.ma * this.mg * this.mj - this.mb * this.me * this.mk + this.ma * this.mf * this.mk);
         this.ima = (-this.mg * this.mj + this.mf * this.mk) * det;
         this.imb = (this.mc * this.mj - this.mb * this.mk) * det;
         this.imc = (-this.mc * this.mf + this.mb * this.mg) * det;
         this.imd = (this.md * this.mg * this.mj - this.mc * this.mh * this.mj - this.md * this.mf * this.mk + this.mb * this.mh * this.mk + this.mc * this.mf * this.ml - this.mb * this.mg * this.ml) * det;
         this.ime = (this.mg * this.mi - this.me * this.mk) * det;
         this.imf = (-this.mc * this.mi + this.ma * this.mk) * det;
         this.img = (this.mc * this.me - this.ma * this.mg) * det;
         this.imh = (this.mc * this.mh * this.mi - this.md * this.mg * this.mi + this.md * this.me * this.mk - this.ma * this.mh * this.mk - this.mc * this.me * this.ml + this.ma * this.mg * this.ml) * det;
         this.imi = (-this.mf * this.mi + this.me * this.mj) * det;
         this.imj = (this.mb * this.mi - this.ma * this.mj) * det;
         this.imk = (-this.mb * this.me + this.ma * this.mf) * det;
         this.iml = (this.md * this.mf * this.mi - this.mb * this.mh * this.mi - this.md * this.me * this.mj + this.ma * this.mh * this.mj + this.mb * this.me * this.ml - this.ma * this.mf * this.ml) * det;
      }
      
      alternativa3d function cullingInCamera(camera:Camera3D, culling:int) : int
      {
         var vertex:Vertex = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var z:Number = NaN;
         var infront:Boolean = false;
         var behind:Boolean = false;
         var near:Number = NaN;
         var far:Number = NaN;
         var i:int = 0;
         var plane:Vertex = null;
         if(camera.occludedAll)
         {
            return -1;
         }
         var numOccluders:int = camera.numOccluders;
         if(culling > 0 || numOccluders > 0)
         {
            vertex = boundVertexList;
            vertex.x = this.boundMinX;
            vertex.y = this.boundMinY;
            vertex.z = this.boundMinZ;
            vertex = vertex.next;
            vertex.x = this.boundMaxX;
            vertex.y = this.boundMinY;
            vertex.z = this.boundMinZ;
            vertex = vertex.next;
            vertex.x = this.boundMinX;
            vertex.y = this.boundMaxY;
            vertex.z = this.boundMinZ;
            vertex = vertex.next;
            vertex.x = this.boundMaxX;
            vertex.y = this.boundMaxY;
            vertex.z = this.boundMinZ;
            vertex = vertex.next;
            vertex.x = this.boundMinX;
            vertex.y = this.boundMinY;
            vertex.z = this.boundMaxZ;
            vertex = vertex.next;
            vertex.x = this.boundMaxX;
            vertex.y = this.boundMinY;
            vertex.z = this.boundMaxZ;
            vertex = vertex.next;
            vertex.x = this.boundMinX;
            vertex.y = this.boundMaxY;
            vertex.z = this.boundMaxZ;
            vertex = vertex.next;
            vertex.x = this.boundMaxX;
            vertex.y = this.boundMaxY;
            vertex.z = this.boundMaxZ;
            for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
            {
               x = vertex.x;
               y = vertex.y;
               z = vertex.z;
               vertex.cameraX = this.ma * x + this.mb * y + this.mc * z + this.md;
               vertex.cameraY = this.me * x + this.mf * y + this.mg * z + this.mh;
               vertex.cameraZ = this.mi * x + this.mj * y + this.mk * z + this.ml;
            }
         }
         if(culling > 0)
         {
            if(Boolean(culling & 1))
            {
               near = camera.nearClipping;
               vertex = boundVertexList;
               infront = false;
               behind = false;
               while(vertex != null)
               {
                  if(vertex.cameraZ > near)
                  {
                     infront = true;
                     if(behind)
                     {
                        break;
                     }
                  }
                  else
                  {
                     behind = true;
                     if(infront)
                     {
                        break;
                     }
                  }
                  vertex = vertex.next;
               }
               if(behind)
               {
                  if(!infront)
                  {
                     return -1;
                  }
               }
               else
               {
                  culling &= 62;
               }
            }
            if(Boolean(culling & 2))
            {
               far = camera.farClipping;
               vertex = boundVertexList;
               infront = false;
               behind = false;
               while(vertex != null)
               {
                  if(vertex.cameraZ < far)
                  {
                     infront = true;
                     if(behind)
                     {
                        break;
                     }
                  }
                  else
                  {
                     behind = true;
                     if(infront)
                     {
                        break;
                     }
                  }
                  vertex = vertex.next;
               }
               if(behind)
               {
                  if(!infront)
                  {
                     return -1;
                  }
               }
               else
               {
                  culling &= 61;
               }
            }
            if(Boolean(culling & 4))
            {
               vertex = boundVertexList;
               infront = false;
               behind = false;
               while(vertex != null)
               {
                  if(-vertex.cameraX < vertex.cameraZ)
                  {
                     infront = true;
                     if(behind)
                     {
                        break;
                     }
                  }
                  else
                  {
                     behind = true;
                     if(infront)
                     {
                        break;
                     }
                  }
                  vertex = vertex.next;
               }
               if(behind)
               {
                  if(!infront)
                  {
                     return -1;
                  }
               }
               else
               {
                  culling &= 59;
               }
            }
            if(Boolean(culling & 8))
            {
               vertex = boundVertexList;
               infront = false;
               behind = false;
               while(vertex != null)
               {
                  if(vertex.cameraX < vertex.cameraZ)
                  {
                     infront = true;
                     if(behind)
                     {
                        break;
                     }
                  }
                  else
                  {
                     behind = true;
                     if(infront)
                     {
                        break;
                     }
                  }
                  vertex = vertex.next;
               }
               if(behind)
               {
                  if(!infront)
                  {
                     return -1;
                  }
               }
               else
               {
                  culling &= 55;
               }
            }
            if(Boolean(culling & 0x10))
            {
               vertex = boundVertexList;
               infront = false;
               behind = false;
               while(vertex != null)
               {
                  if(-vertex.cameraY < vertex.cameraZ)
                  {
                     infront = true;
                     if(behind)
                     {
                        break;
                     }
                  }
                  else
                  {
                     behind = true;
                     if(infront)
                     {
                        break;
                     }
                  }
                  vertex = vertex.next;
               }
               if(behind)
               {
                  if(!infront)
                  {
                     return -1;
                  }
               }
               else
               {
                  culling &= 47;
               }
            }
            if(Boolean(culling & 0x20))
            {
               vertex = boundVertexList;
               infront = false;
               behind = false;
               while(vertex != null)
               {
                  if(vertex.cameraY < vertex.cameraZ)
                  {
                     infront = true;
                     if(behind)
                     {
                        break;
                     }
                  }
                  else
                  {
                     behind = true;
                     if(infront)
                     {
                        break;
                     }
                  }
                  vertex = vertex.next;
               }
               if(behind)
               {
                  if(!infront)
                  {
                     return -1;
                  }
               }
               else
               {
                  culling &= 31;
               }
            }
         }
         if(numOccluders > 0)
         {
            for(i = 0; i < numOccluders; )
            {
               plane = camera.occluders[i];
               loop8:
               while(true)
               {
                  if(plane != null)
                  {
                     vertex = boundVertexList;
                     while(true)
                     {
                        if(vertex != null)
                        {
                           if(plane.cameraX * vertex.cameraX + plane.cameraY * vertex.cameraY + plane.cameraZ * vertex.cameraZ < 0)
                           {
                              continue;
                           }
                        }
                        if(vertex == null)
                        {
                           continue loop8;
                        }
                        vertex = vertex.next;
                     }
                     continue;
                  }
                  if(plane == null)
                  {
                     return -1;
                  }
                  break;
                  plane = plane.next;
               }
               i++;
            }
         }
         this.culling = culling;
         return culling;
      }
      
      alternativa3d function removeFromParent() : void
      {
         if(this._parent != null)
         {
            this._parent.removeChild(this);
         }
      }
   }
}

