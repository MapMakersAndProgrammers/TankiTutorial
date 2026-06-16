package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class Object3DContainer extends Object3D
   {
      
      public var mouseChildren:Boolean = true;
      
      alternativa3d var childrenList:Object3D;
      
      alternativa3d var lightList:Light3D;
      
      alternativa3d var visibleChildren:Vector.<Object3D> = new Vector.<Object3D>();
      
      alternativa3d var numVisibleChildren:int = 0;
      
      public function Object3DContainer()
      {
         super();
      }
      
      public function addChild(child:Object3D) : Object3D
      {
         if(child == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(child == this)
         {
            throw new ArgumentError("An object cannot be added as a child of itself.");
         }
         for(var container:Object3DContainer = _parent; container != null; container = container._parent)
         {
            if(container == child)
            {
               throw new ArgumentError("An object cannot be added as a child to one of it\'s children (or children\'s children, etc.).");
            }
         }
         if(child._parent != null)
         {
            child._parent.removeChild(child);
         }
         this.addToList(child);
         return child;
      }
      
      public function removeChild(child:Object3D) : Object3D
      {
         var prev:Object3D = null;
         var current:Object3D = null;
         if(child == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(child._parent != this)
         {
            throw new ArgumentError("The supplied Object3D must be a child of the caller.");
         }
         for(current = this.childrenList; current != null; )
         {
            if(current == child)
            {
               if(prev != null)
               {
                  prev.next = current.next;
               }
               else
               {
                  this.childrenList = current.next;
               }
               current.next = null;
               current.setParent(null);
               return child;
            }
            prev = current;
            current = current.next;
         }
         throw new ArgumentError("Cannot remove child.");
      }
      
      public function addChildAt(child:Object3D, index:int) : Object3D
      {
         if(child == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(child == this)
         {
            throw new ArgumentError("An object cannot be added as a child of itself.");
         }
         if(index < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         for(var container:Object3DContainer = _parent; container != null; container = container._parent)
         {
            if(container == child)
            {
               throw new ArgumentError("An object cannot be added as a child to one of it\'s children (or children\'s children, etc.).");
            }
         }
         var current:Object3D = this.childrenList;
         for(var i:int = 0; i < index; i++)
         {
            if(current == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            current = current.next;
         }
         if(child._parent != null)
         {
            child._parent.removeChild(child);
         }
         this.addToList(child,current);
         return child;
      }
      
      public function removeChildAt(index:int) : Object3D
      {
         if(index < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         var current:Object3D = this.childrenList;
         for(var i:int = 0; i < index; i++)
         {
            if(current == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            current = current.next;
         }
         if(current == null)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         this.removeChild(current);
         return current;
      }
      
      public function getChildAt(index:int) : Object3D
      {
         if(index < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         var current:Object3D = this.childrenList;
         for(var i:int = 0; i < index; i++)
         {
            if(current == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            current = current.next;
         }
         if(current == null)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         return current;
      }
      
      public function getChildIndex(child:Object3D) : int
      {
         if(child == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(child._parent != this)
         {
            throw new ArgumentError("The supplied Object3D must be a child of the caller.");
         }
         var index:int = 0;
         for(var current:Object3D = this.childrenList; current != null; current = current.next)
         {
            if(current == child)
            {
               return index;
            }
            index++;
         }
         throw new ArgumentError("Cannot get child index.");
      }
      
      public function setChildIndex(child:Object3D, index:int) : void
      {
         if(child == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(child._parent != this)
         {
            throw new ArgumentError("The supplied Object3D must be a child of the caller.");
         }
         if(index < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         var current:Object3D = this.childrenList;
         for(var i:int = 0; i < index; i++)
         {
            if(current == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            current = current.next;
         }
         this.removeChild(child);
         this.addToList(child,current);
      }
      
      public function swapChildren(child1:Object3D, child2:Object3D) : void
      {
         var nxt:Object3D = null;
         if(child1 == null || child2 == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(child1._parent != this || child2._parent != this)
         {
            throw new ArgumentError("The supplied Object3D must be a child of the caller.");
         }
         if(child1 != child2)
         {
            if(child1.next == child2)
            {
               this.removeChild(child2);
               this.addToList(child2,child1);
            }
            else if(child2.next == child1)
            {
               this.removeChild(child1);
               this.addToList(child1,child2);
            }
            else
            {
               nxt = child1.next;
               this.removeChild(child1);
               this.addToList(child1,child2);
               this.removeChild(child2);
               this.addToList(child2,nxt);
            }
         }
      }
      
      public function swapChildrenAt(index1:int, index2:int) : void
      {
         var i:int = 0;
         var child1:Object3D = null;
         var child2:Object3D = null;
         var nxt:Object3D = null;
         if(index1 < 0 || index2 < 0)
         {
            throw new RangeError("The supplied index is out of bounds.");
         }
         if(index1 != index2)
         {
            child1 = this.childrenList;
            for(i = 0; i < index1; i++)
            {
               if(child1 == null)
               {
                  throw new RangeError("The supplied index is out of bounds.");
               }
               child1 = child1.next;
            }
            if(child1 == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            child2 = this.childrenList;
            for(i = 0; i < index2; i++)
            {
               if(child2 == null)
               {
                  throw new RangeError("The supplied index is out of bounds.");
               }
               child2 = child2.next;
            }
            if(child2 == null)
            {
               throw new RangeError("The supplied index is out of bounds.");
            }
            if(child1 != child2)
            {
               if(child1.next == child2)
               {
                  this.removeChild(child2);
                  this.addToList(child2,child1);
               }
               else if(child2.next == child1)
               {
                  this.removeChild(child1);
                  this.addToList(child1,child2);
               }
               else
               {
                  nxt = child1.next;
                  this.removeChild(child1);
                  this.addToList(child1,child2);
                  this.removeChild(child2);
                  this.addToList(child2,nxt);
               }
            }
         }
      }
      
      public function getChildByName(name:String) : Object3D
      {
         if(name == null)
         {
            throw new TypeError("Parameter name must be non-null.");
         }
         for(var child:Object3D = this.childrenList; child != null; )
         {
            if(child.name == name)
            {
               return child;
            }
            child = child.next;
         }
         return null;
      }
      
      public function contains(child:Object3D) : Boolean
      {
         if(child == null)
         {
            throw new TypeError("Parameter child must be non-null.");
         }
         if(child == this)
         {
            return true;
         }
         for(var object:Object3D = this.childrenList; object != null; )
         {
            if(object is Object3DContainer)
            {
               if((object as Object3DContainer).contains(child))
               {
                  return true;
               }
            }
            else if(object == child)
            {
               return true;
            }
            object = object.next;
         }
         return false;
      }
      
      public function get numChildren() : int
      {
         var num:int = 0;
         var current:Object3D = this.childrenList;
         while(current != null)
         {
            num++;
            current = current.next;
         }
         return num;
      }
      
      override public function intersectRay(origin:Vector3D, direction:Vector3D, excludedObjects:Dictionary = null, camera:Camera3D = null) : RayIntersectionData
      {
         var childOrigin:Vector3D = null;
         var childDirection:Vector3D = null;
         var res:RayIntersectionData = null;
         var data:RayIntersectionData = null;
         if(excludedObjects != null && Boolean(excludedObjects[this]))
         {
            return null;
         }
         if(!boundIntersectRay(origin,direction,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return null;
         }
         var minTime:Number = 1e+22;
         for(var child:Object3D = this.childrenList; child != null; child = child.next)
         {
            child.composeMatrix();
            child.invertMatrix();
            if(childOrigin == null)
            {
               childOrigin = new Vector3D();
               childDirection = new Vector3D();
            }
            childOrigin.x = child.ma * origin.x + child.mb * origin.y + child.mc * origin.z + child.md;
            childOrigin.y = child.me * origin.x + child.mf * origin.y + child.mg * origin.z + child.mh;
            childOrigin.z = child.mi * origin.x + child.mj * origin.y + child.mk * origin.z + child.ml;
            childDirection.x = child.ma * direction.x + child.mb * direction.y + child.mc * direction.z;
            childDirection.y = child.me * direction.x + child.mf * direction.y + child.mg * direction.z;
            childDirection.z = child.mi * direction.x + child.mj * direction.y + child.mk * direction.z;
            data = child.intersectRay(childOrigin,childDirection,excludedObjects,camera);
            if(data != null && data.time < minTime)
            {
               minTime = data.time;
               res = data;
            }
         }
         return res;
      }
      
      override alternativa3d function checkIntersection(ox:Number, oy:Number, oz:Number, dx:Number, dy:Number, dz:Number, dw:Number, excludedObjects:Dictionary) : Boolean
      {
         var cox:Number = NaN;
         var coy:Number = NaN;
         var coz:Number = NaN;
         var cdx:Number = NaN;
         var cdy:Number = NaN;
         var cdz:Number = NaN;
         for(var child:Object3D = this.childrenList; child != null; )
         {
            if(excludedObjects != null && !excludedObjects[child])
            {
               child.composeMatrix();
               child.invertMatrix();
               cox = child.ma * ox + child.mb * oy + child.mc * oz + child.md;
               coy = child.me * ox + child.mf * oy + child.mg * oz + child.mh;
               coz = child.mi * ox + child.mj * oy + child.mk * oz + child.ml;
               cdx = child.ma * dx + child.mb * dy + child.mc * dz;
               cdy = child.me * dx + child.mf * dy + child.mg * dz;
               cdz = child.mi * dx + child.mj * dy + child.mk * dz;
               if(boundCheckIntersection(cox,coy,coz,cdx,cdy,cdz,dw,child.boundMinX,child.boundMinY,child.boundMinZ,child.boundMaxX,child.boundMaxY,child.boundMaxZ) && child.checkIntersection(cox,coy,coz,cdx,cdy,cdz,dw,excludedObjects))
               {
                  return true;
               }
            }
            child = child.next;
         }
         return false;
      }
      
      override alternativa3d function collectPlanes(center:Vector3D, a:Vector3D, b:Vector3D, c:Vector3D, d:Vector3D, collector:Vector.<Face>, excludedObjects:Dictionary = null) : void
      {
         if(excludedObjects != null && Boolean(excludedObjects[this]))
         {
            return;
         }
         var sphere:Vector3D = calculateSphere(center,a,b,c,d);
         if(!boundIntersectSphere(sphere,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ))
         {
            return;
         }
         for(var child:Object3D = this.childrenList; child != null; )
         {
            child.composeAndAppend(this);
            child.collectPlanes(center,a,b,c,d,collector,excludedObjects);
            child = child.next;
         }
      }
      
      override public function clone() : Object3D
      {
         var res:Object3DContainer = new Object3DContainer();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         var lastChild:Object3D = null;
         var newChild:Object3D = null;
         super.clonePropertiesFrom(source);
         var src:Object3DContainer = source as Object3DContainer;
         this.mouseChildren = src.mouseChildren;
         for(var child:Object3D = src.childrenList; child != null; child = child.next)
         {
            newChild = child.clone();
            if(this.childrenList != null)
            {
               lastChild.next = newChild;
            }
            else
            {
               this.childrenList = newChild;
            }
            lastChild = newChild;
            newChild.setParent(this);
         }
      }
      
      override alternativa3d function draw(camera:Camera3D) : void
      {
         var debug:int = 0;
         this.numVisibleChildren = 0;
         for(var child:Object3D = this.childrenList; child != null; child = child.next)
         {
            if(child.visible)
            {
               child.composeAndAppend(this);
               if(child.cullingInCamera(camera,culling) >= 0)
               {
                  child.concat(this);
                  this.visibleChildren[this.numVisibleChildren] = child;
                  ++this.numVisibleChildren;
               }
            }
         }
         if(this.numVisibleChildren > 0)
         {
            if(camera.debug && (debug = camera.checkInDebug(this)) > 0)
            {
               if(Boolean(debug & Debug.BOUNDS))
               {
                  Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            this.drawVisibleChildren(camera);
         }
      }
      
      alternativa3d function drawVisibleChildren(camera:Camera3D) : void
      {
         var child:Object3D = null;
         for(var i:int = this.numVisibleChildren - 1; i >= 0; i--)
         {
            child = this.visibleChildren[i];
            child.draw(camera);
            this.visibleChildren[i] = null;
         }
      }
      
      override alternativa3d function getVG(camera:Camera3D) : VG
      {
         var first:VG = null;
         var last:VG = null;
         var geometry:VG = null;
         for(var child:Object3D = this.childrenList; child != null; child = child.next)
         {
            if(child.visible)
            {
               child.composeAndAppend(this);
               if(child.cullingInCamera(camera,culling) >= 0)
               {
                  child.concat(this);
                  geometry = child.getVG(camera);
                  if(geometry != null)
                  {
                     if(first != null)
                     {
                        last.next = geometry;
                     }
                     else
                     {
                        first = geometry;
                        last = geometry;
                     }
                     while(last.next != null)
                     {
                        last = last.next;
                     }
                  }
               }
            }
         }
         return first;
      }
      
      override alternativa3d function updateBounds(bounds:Object3D, transformation:Object3D = null) : void
      {
         for(var child:Object3D = this.childrenList; child != null; child = child.next)
         {
            if(transformation != null)
            {
               child.composeAndAppend(transformation);
            }
            else
            {
               child.composeMatrix();
            }
            child.updateBounds(bounds,child);
         }
      }
      
      override alternativa3d function split(a:Vector3D, b:Vector3D, c:Vector3D, threshold:Number) : Vector.<Object3D>
      {
         var negativeLast:Object3D = null;
         var positiveLast:Object3D = null;
         var next:Object3D = null;
         var ca:Vector3D = null;
         var cb:Vector3D = null;
         var cc:Vector3D = null;
         var testSplitResult:int = 0;
         var splitResult:Vector.<Object3D> = null;
         var distance:Number = NaN;
         var res:Vector.<Object3D> = new Vector.<Object3D>(2);
         var plane:Vector3D = calculatePlane(a,b,c);
         var childrenList:Object3D = this.childrenList;
         this.childrenList = null;
         var negativeContainer:Object3DContainer = this.clone() as Object3DContainer;
         var positiveContainer:Object3DContainer = this.clone() as Object3DContainer;
         for(var object:Object3D = childrenList; object != null; )
         {
            next = object.next;
            object.next = null;
            object.setParent(null);
            object.composeMatrix();
            object.calculateInverseMatrix();
            ca = new Vector3D(object.ima * a.x + object.imb * a.y + object.imc * a.z + object.imd,object.ime * a.x + object.imf * a.y + object.img * a.z + object.imh,object.imi * a.x + object.imj * a.y + object.imk * a.z + object.iml);
            cb = new Vector3D(object.ima * b.x + object.imb * b.y + object.imc * b.z + object.imd,object.ime * b.x + object.imf * b.y + object.img * b.z + object.imh,object.imi * b.x + object.imj * b.y + object.imk * b.z + object.iml);
            cc = new Vector3D(object.ima * c.x + object.imb * c.y + object.imc * c.z + object.imd,object.ime * c.x + object.imf * c.y + object.img * c.z + object.imh,object.imi * c.x + object.imj * c.y + object.imk * c.z + object.iml);
            testSplitResult = object.testSplit(ca,cb,cc,threshold);
            if(testSplitResult < 0)
            {
               if(negativeLast != null)
               {
                  negativeLast.next = object;
               }
               else
               {
                  negativeContainer.childrenList = object;
               }
               negativeLast = object;
               object.setParent(negativeContainer);
            }
            else if(testSplitResult > 0)
            {
               if(positiveLast != null)
               {
                  positiveLast.next = object;
               }
               else
               {
                  positiveContainer.childrenList = object;
               }
               positiveLast = object;
               object.setParent(positiveContainer);
            }
            else
            {
               splitResult = object.split(ca,cb,cc,threshold);
               distance = object.distance;
               if(splitResult[0] != null)
               {
                  object = splitResult[0];
                  if(negativeLast != null)
                  {
                     negativeLast.next = object;
                  }
                  else
                  {
                     negativeContainer.childrenList = object;
                  }
                  negativeLast = object;
                  object.setParent(negativeContainer);
                  object.distance = distance;
               }
               if(splitResult[1] != null)
               {
                  object = splitResult[1];
                  if(positiveLast != null)
                  {
                     positiveLast.next = object;
                  }
                  else
                  {
                     positiveContainer.childrenList = object;
                  }
                  positiveLast = object;
                  object.setParent(positiveContainer);
                  object.distance = distance;
               }
            }
            object = next;
         }
         if(negativeLast != null)
         {
            negativeContainer.calculateBounds();
            res[0] = negativeContainer;
         }
         if(positiveLast != null)
         {
            positiveContainer.calculateBounds();
            res[1] = positiveContainer;
         }
         return res;
      }
      
      alternativa3d function addToList(child:Object3D, item:Object3D = null) : void
      {
         var current:Object3D = null;
         child.next = item;
         child.setParent(this);
         if(item == this.childrenList)
         {
            this.childrenList = child;
         }
         else
         {
            for(current = this.childrenList; current != null; )
            {
               if(current.next == item)
               {
                  current.next = child;
                  break;
               }
               current = current.next;
            }
         }
      }
      
      override alternativa3d function setParent(value:Object3DContainer) : void
      {
         var root:Object3DContainer = null;
         var light:Light3D = null;
         if(value == null)
         {
            for(root = _parent; root._parent != null; )
            {
               root = root._parent;
            }
            if(root.lightList != null)
            {
               this.transferLights(root,this);
            }
         }
         else if(this.lightList != null)
         {
            for(root = value; root._parent != null; )
            {
               root = root._parent;
            }
            for(light = this.lightList; light.nextLight != null; )
            {
               light = light.nextLight;
            }
            light.nextLight = root.lightList;
            root.lightList = this.lightList;
            this.lightList = null;
         }
         _parent = value;
      }
      
      private function transferLights(root:Object3DContainer, container:Object3DContainer) : void
      {
         var light:Light3D = null;
         var prev:Light3D = null;
         var current:Light3D = null;
         for(var child:Object3D = this.childrenList; child != null; )
         {
            if(child is Light3D)
            {
               light = child as Light3D;
               prev = null;
               for(current = root.lightList; current != null; )
               {
                  if(current == light)
                  {
                     if(prev != null)
                     {
                        prev.nextLight = current.nextLight;
                     }
                     else
                     {
                        root.lightList = current.nextLight;
                     }
                     current.nextLight = container.lightList;
                     container.lightList = current;
                     break;
                  }
                  prev = current;
                  current = current.nextLight;
               }
            }
            else if(child is Object3DContainer)
            {
               (child as Object3DContainer).transferLights(root,container);
            }
            if(root.lightList == null)
            {
               break;
            }
            child = child.next;
         }
      }
   }
}

