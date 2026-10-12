package alternativa.engine3d.containers
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   
   use namespace alternativa3d;
   
   public class ConflictContainer extends Object3DContainer
   {
      
      public var resolveByAABB:Boolean = true;
      
      public var resolveByOOBB:Boolean = true;
      
      public var threshold:Number = 0.01;
      
      public function ConflictContainer()
      {
         super();
      }
      
      override public function clone() : Object3D
      {
         var res:ConflictContainer = new ConflictContainer();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         super.clonePropertiesFrom(source);
         var src:ConflictContainer = source as ConflictContainer;
         this.resolveByAABB = src.resolveByAABB;
         this.resolveByOOBB = src.resolveByOOBB;
         this.threshold = src.threshold;
      }
      
      override alternativa3d function draw(camera:Camera3D) : void
      {
         var debug:int = 0;
         var current:VG = null;
         var geometry:VG = getVG(camera);
         if(geometry != null)
         {
            if(camera.debug && (debug = camera.checkInDebug(this)) > 0)
            {
               if(Boolean(debug & Debug.BOUNDS))
               {
                  Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            if(geometry.next != null)
            {
               calculateInverseMatrix();
               if(this.resolveByAABB)
               {
                  for(current = geometry; current != null; current = current.next)
                  {
                     current.calculateAABB(ima,imb,imc,imd,ime,imf,img,imh,imi,imj,imk,iml);
                  }
                  this.drawAABBGeometry(camera,geometry);
               }
               else if(this.resolveByOOBB)
               {
                  for(current = geometry; current != null; current = current.next)
                  {
                     current.calculateOOBB(this);
                  }
                  this.drawOOBBGeometry(camera,geometry);
               }
               else
               {
                  this.drawConflictGeometry(camera,geometry);
               }
            }
            else
            {
               geometry.draw(camera,this.threshold,this);
               geometry.destroy();
            }
         }
      }
      
      alternativa3d function drawAABBGeometry(camera:Camera3D, geometry:VG) : void
      {
         var coord:Number = NaN;
         var coordMin:Number = NaN;
         var coordMax:Number = NaN;
         var axisX:Boolean = false;
         var axisY:Boolean = false;
         var compared:VG = null;
         var outside:Boolean = false;
         var next:VG = null;
         var negative:VG = null;
         var middle:VG = null;
         var positive:VG = null;
         var min:Number = NaN;
         var max:Number = NaN;
         loop0:
         for(var current:VG = geometry; current != null; )
         {
            coord = current.boundMinX;
            coordMin = coord - this.threshold;
            coordMax = coord + this.threshold;
            outside = false;
            compared = geometry;
            loop1:
            while(true)
            {
               if(compared != null)
               {
                  if(current == compared)
                  {
                     continue;
                  }
                  if(compared.boundMaxX <= coordMax)
                  {
                     outside = true;
                     continue;
                  }
                  if(compared.boundMinX >= coordMin)
                  {
                     continue;
                  }
               }
               if(compared == null && outside)
               {
                  axisX = true;
                  axisY = false;
                  break loop0;
               }
               coord = current.boundMaxX;
               coordMin = coord - this.threshold;
               coordMax = coord + this.threshold;
               outside = false;
               compared = geometry;
               while(true)
               {
                  if(compared != null)
                  {
                     if(current == compared)
                     {
                        continue;
                     }
                     if(compared.boundMinX >= coordMin)
                     {
                        outside = true;
                        continue;
                     }
                     if(compared.boundMaxX <= coordMax)
                     {
                        continue;
                     }
                  }
                  if(compared == null && outside)
                  {
                     axisX = true;
                     axisY = false;
                     break loop0;
                  }
                  coord = current.boundMinY;
                  coordMin = coord - this.threshold;
                  coordMax = coord + this.threshold;
                  outside = false;
                  compared = geometry;
                  while(true)
                  {
                     if(compared != null)
                     {
                        if(current == compared)
                        {
                           continue;
                        }
                        if(compared.boundMaxY <= coordMax)
                        {
                           outside = true;
                           continue;
                        }
                        if(compared.boundMinY >= coordMin)
                        {
                           continue;
                        }
                     }
                     if(compared == null && outside)
                     {
                        axisX = false;
                        axisY = true;
                        break loop0;
                     }
                     coord = current.boundMaxY;
                     coordMin = coord - this.threshold;
                     coordMax = coord + this.threshold;
                     outside = false;
                     compared = geometry;
                     while(true)
                     {
                        if(compared != null)
                        {
                           if(current == compared)
                           {
                              continue;
                           }
                           if(compared.boundMinY >= coordMin)
                           {
                              outside = true;
                              continue;
                           }
                           if(compared.boundMaxY <= coordMax)
                           {
                              continue;
                           }
                        }
                        if(compared == null && outside)
                        {
                           axisX = false;
                           axisY = true;
                           break loop0;
                        }
                        coord = current.boundMinZ;
                        coordMin = coord - this.threshold;
                        coordMax = coord + this.threshold;
                        outside = false;
                        compared = geometry;
                        while(true)
                        {
                           if(compared != null)
                           {
                              if(current == compared)
                              {
                                 continue;
                              }
                              if(compared.boundMaxZ <= coordMax)
                              {
                                 outside = true;
                                 continue;
                              }
                              if(compared.boundMinZ >= coordMin)
                              {
                                 continue;
                              }
                           }
                           if(compared == null && outside)
                           {
                              axisX = false;
                              axisY = false;
                              break loop0;
                           }
                           coord = current.boundMaxZ;
                           coordMin = coord - this.threshold;
                           coordMax = coord + this.threshold;
                           outside = false;
                           compared = geometry;
                           while(true)
                           {
                              if(compared != null)
                              {
                                 if(current == compared)
                                 {
                                    continue;
                                 }
                                 if(compared.boundMinZ >= coordMin)
                                 {
                                    outside = true;
                                    continue;
                                 }
                                 if(compared.boundMaxZ <= coordMax)
                                 {
                                    continue;
                                 }
                              }
                              if(compared == null && outside)
                              {
                                 axisX = false;
                                 axisY = false;
                                 break loop0;
                              }
                              break loop1;
                              compared = compared.next;
                           }
                           break;
                           compared = compared.next;
                        }
                        break;
                        compared = compared.next;
                     }
                     break;
                     compared = compared.next;
                  }
                  break;
                  compared = compared.next;
               }
               break;
               compared = compared.next;
            }
            current = current.next;
         }
         if(current != null)
         {
            while(geometry != null)
            {
               next = geometry.next;
               min = axisX ? geometry.boundMinX : (axisY ? geometry.boundMinY : geometry.boundMinZ);
               max = axisX ? geometry.boundMaxX : (axisY ? geometry.boundMaxY : geometry.boundMaxZ);
               if(max > coordMax)
               {
                  geometry.next = positive;
                  positive = geometry;
               }
               else if(min < coordMin)
               {
                  geometry.next = negative;
                  negative = geometry;
               }
               else
               {
                  geometry.next = middle;
                  middle = geometry;
               }
               geometry = next;
            }
            if(axisX && imd > coord || axisY && imh > coord || !axisX && !axisY && iml > coord)
            {
               if(positive != null)
               {
                  if(positive.next != null)
                  {
                     this.drawAABBGeometry(camera,positive);
                  }
                  else
                  {
                     positive.draw(camera,this.threshold,this);
                     positive.destroy();
                  }
               }
               while(middle != null)
               {
                  next = middle.next;
                  middle.draw(camera,this.threshold,this);
                  middle.destroy();
                  middle = next;
               }
               if(negative != null)
               {
                  if(negative.next != null)
                  {
                     this.drawAABBGeometry(camera,negative);
                  }
                  else
                  {
                     negative.draw(camera,this.threshold,this);
                     negative.destroy();
                  }
               }
            }
            else
            {
               if(negative != null)
               {
                  if(negative.next != null)
                  {
                     this.drawAABBGeometry(camera,negative);
                  }
                  else
                  {
                     negative.draw(camera,this.threshold,this);
                     negative.destroy();
                  }
               }
               while(middle != null)
               {
                  next = middle.next;
                  middle.draw(camera,this.threshold,this);
                  middle.destroy();
                  middle = next;
               }
               if(positive != null)
               {
                  if(positive.next != null)
                  {
                     this.drawAABBGeometry(camera,positive);
                  }
                  else
                  {
                     positive.draw(camera,this.threshold,this);
                     positive.destroy();
                  }
               }
            }
         }
         else if(this.resolveByOOBB)
         {
            for(current = geometry; current != null; current = current.next)
            {
               current.calculateOOBB(this);
            }
            this.drawOOBBGeometry(camera,geometry);
         }
         else
         {
            this.drawConflictGeometry(camera,geometry);
         }
      }
      
      alternativa3d function drawOOBBGeometry(camera:Camera3D, geometry:VG) : void
      {
         var vertex:Vertex = null;
         var plane:Vertex = null;
         var wrapper:Wrapper = null;
         var o:Number = NaN;
         var planeX:Number = NaN;
         var planeY:Number = NaN;
         var planeZ:Number = NaN;
         var planeOffset:Number = NaN;
         var behind:Boolean = false;
         var infront:Boolean = false;
         var current:VG = null;
         var compared:VG = null;
         var outside:Boolean = false;
         var next:VG = null;
         var negative:VG = null;
         var middle:VG = null;
         var positive:VG = null;
         loop0:
         for(current = geometry; current != null; )
         {
            if(current.viewAligned)
            {
               planeOffset = current.object.ml;
               compared = geometry;
               loop2:
               while(true)
               {
                  if(compared != null)
                  {
                     if(!compared.viewAligned)
                     {
                        behind = false;
                        infront = false;
                        vertex = compared.boundVertexList;
                        while(true)
                        {
                           if(vertex != null)
                           {
                              if(vertex.cameraZ > planeOffset)
                              {
                                 if(!behind)
                                 {
                                    infront = true;
                                    continue;
                                 }
                              }
                              else if(!infront)
                              {
                                 behind = true;
                                 continue;
                              }
                           }
                           if(vertex == null)
                           {
                              continue loop2;
                           }
                           vertex = vertex.next;
                        }
                     }
                     continue;
                  }
                  if(compared == null)
                  {
                     break loop0;
                  }
                  break;
                  compared = compared.next;
               }
            }
            else
            {
               plane = current.boundPlaneList;
               loop1:
               while(true)
               {
                  if(plane != null)
                  {
                     planeX = plane.cameraX;
                     planeY = plane.cameraY;
                     planeZ = plane.cameraZ;
                     planeOffset = plane.offset;
                     outside = false;
                     compared = geometry;
                     loop3:
                     while(true)
                     {
                        if(compared != null)
                        {
                           if(current != compared)
                           {
                              behind = false;
                              infront = false;
                              if(compared.viewAligned)
                              {
                                 wrapper = compared.faceStruct.wrapper;
                                 while(true)
                                 {
                                    if(wrapper != null)
                                    {
                                       vertex = wrapper.vertex;
                                       if(vertex.cameraX * planeX + vertex.cameraY * planeY + vertex.cameraZ * planeZ >= planeOffset - this.threshold)
                                       {
                                          if(!behind)
                                          {
                                             outside = true;
                                             infront = true;
                                             continue;
                                          }
                                       }
                                       else if(!infront)
                                       {
                                          behind = true;
                                          continue;
                                       }
                                    }
                                    if(wrapper == null)
                                    {
                                       continue loop3;
                                    }
                                    wrapper = wrapper.next;
                                 }
                              }
                              else
                              {
                                 vertex = compared.boundVertexList;
                                 while(true)
                                 {
                                    if(vertex != null)
                                    {
                                       if(vertex.cameraX * planeX + vertex.cameraY * planeY + vertex.cameraZ * planeZ >= planeOffset - this.threshold)
                                       {
                                          if(!behind)
                                          {
                                             outside = true;
                                             infront = true;
                                             continue;
                                          }
                                       }
                                       else if(!infront)
                                       {
                                          behind = true;
                                          continue;
                                       }
                                    }
                                    if(vertex == null)
                                    {
                                       continue loop3;
                                    }
                                    vertex = vertex.next;
                                 }
                              }
                           }
                           continue;
                        }
                        if(!(compared == null && outside))
                        {
                           continue loop1;
                        }
                        compared = compared.next;
                     }
                     continue;
                  }
                  if(plane != null)
                  {
                     break loop0;
                  }
                  break;
                  plane = plane.next;
               }
            }
            current = current.next;
         }
         if(current != null)
         {
            if(current.viewAligned)
            {
               while(geometry != null)
               {
                  next = geometry.next;
                  if(geometry.viewAligned)
                  {
                     o = geometry.object.ml - planeOffset;
                     if(o < -this.threshold)
                     {
                        geometry.next = positive;
                        positive = geometry;
                     }
                     else if(o > this.threshold)
                     {
                        geometry.next = negative;
                        negative = geometry;
                     }
                     else
                     {
                        geometry.next = middle;
                        middle = geometry;
                     }
                  }
                  else
                  {
                     vertex = geometry.boundVertexList;
                     while(true)
                     {
                        if(vertex != null)
                        {
                           o = vertex.cameraZ - planeOffset;
                           if(o < -this.threshold)
                           {
                              geometry.next = positive;
                              positive = geometry;
                           }
                           else
                           {
                              if(o <= this.threshold)
                              {
                                 continue;
                              }
                              geometry.next = negative;
                              negative = geometry;
                           }
                        }
                        if(vertex == null)
                        {
                           geometry.next = middle;
                           middle = geometry;
                        }
                        break;
                        vertex = vertex.next;
                     }
                  }
                  geometry = next;
               }
            }
            else
            {
               while(geometry != null)
               {
                  next = geometry.next;
                  if(geometry.viewAligned)
                  {
                     wrapper = geometry.faceStruct.wrapper;
                     while(true)
                     {
                        if(wrapper != null)
                        {
                           vertex = wrapper.vertex;
                           o = vertex.cameraX * planeX + vertex.cameraY * planeY + vertex.cameraZ * planeZ - planeOffset;
                           if(o < -this.threshold)
                           {
                              geometry.next = negative;
                              negative = geometry;
                           }
                           else
                           {
                              if(o <= this.threshold)
                              {
                                 continue;
                              }
                              geometry.next = positive;
                              positive = geometry;
                           }
                        }
                        if(wrapper == null)
                        {
                           geometry.next = middle;
                           middle = geometry;
                        }
                        break;
                        wrapper = wrapper.next;
                     }
                  }
                  else
                  {
                     vertex = geometry.boundVertexList;
                     while(true)
                     {
                        if(vertex != null)
                        {
                           o = vertex.cameraX * planeX + vertex.cameraY * planeY + vertex.cameraZ * planeZ - planeOffset;
                           if(o < -this.threshold)
                           {
                              geometry.next = negative;
                              negative = geometry;
                           }
                           else
                           {
                              if(o <= this.threshold)
                              {
                                 continue;
                              }
                              geometry.next = positive;
                              positive = geometry;
                           }
                        }
                        if(vertex == null)
                        {
                           geometry.next = middle;
                           middle = geometry;
                        }
                        break;
                        vertex = vertex.next;
                     }
                  }
                  geometry = next;
               }
            }
            if(current.viewAligned || planeOffset < 0)
            {
               if(positive != null)
               {
                  if(positive.next != null)
                  {
                     this.drawOOBBGeometry(camera,positive);
                  }
                  else
                  {
                     positive.draw(camera,this.threshold,this);
                     positive.destroy();
                  }
               }
               while(middle != null)
               {
                  next = middle.next;
                  middle.draw(camera,this.threshold,this);
                  middle.destroy();
                  middle = next;
               }
               if(negative != null)
               {
                  if(negative.next != null)
                  {
                     this.drawOOBBGeometry(camera,negative);
                  }
                  else
                  {
                     negative.draw(camera,this.threshold,this);
                     negative.destroy();
                  }
               }
            }
            else
            {
               if(negative != null)
               {
                  if(negative.next != null)
                  {
                     this.drawOOBBGeometry(camera,negative);
                  }
                  else
                  {
                     negative.draw(camera,this.threshold,this);
                     negative.destroy();
                  }
               }
               while(middle != null)
               {
                  next = middle.next;
                  middle.draw(camera,this.threshold,this);
                  middle.destroy();
                  middle = next;
               }
               if(positive != null)
               {
                  if(positive.next != null)
                  {
                     this.drawOOBBGeometry(camera,positive);
                  }
                  else
                  {
                     positive.draw(camera,this.threshold,this);
                     positive.destroy();
                  }
               }
            }
         }
         else
         {
            this.drawConflictGeometry(camera,geometry);
         }
      }
      
      alternativa3d function drawConflictGeometry(camera:Camera3D, geometry:VG) : void
      {
         var face:Face = null;
         var next:Face = null;
         var nextGeometry:VG = null;
         var bspGeometry:VG = null;
         var conflict:VG = null;
         var dynamicBSPFirst:Face = null;
         var dynamicBSPLast:Face = null;
         var averageZFirst:Face = null;
         var averageZLast:Face = null;
         var list:Face = null;
         var first:Face = null;
         var last:Face = null;
         var drawList:Face = null;
         var inverse:Face = null;
         var changeGeometry:Boolean = false;
         while(geometry != null)
         {
            nextGeometry = geometry.next;
            if(geometry.space == 1)
            {
               geometry.transformStruct(geometry.faceStruct,++geometry.object.transformId,ma,mb,mc,md,me,mf,mg,mh,mi,mj,mk,ml);
            }
            if(geometry.sorting == 3)
            {
               geometry.next = bspGeometry;
               bspGeometry = geometry;
            }
            else
            {
               if(geometry.sorting == 2)
               {
                  if(dynamicBSPFirst != null)
                  {
                     dynamicBSPLast.processNext = geometry.faceStruct;
                  }
                  else
                  {
                     dynamicBSPFirst = geometry.faceStruct;
                  }
                  dynamicBSPLast = geometry.faceStruct;
                  for(dynamicBSPLast.geometry = geometry; dynamicBSPLast.processNext != null; )
                  {
                     dynamicBSPLast = dynamicBSPLast.processNext;
                     dynamicBSPLast.geometry = geometry;
                  }
               }
               else
               {
                  if(averageZFirst != null)
                  {
                     averageZLast.processNext = geometry.faceStruct;
                  }
                  else
                  {
                     averageZFirst = geometry.faceStruct;
                  }
                  averageZLast = geometry.faceStruct;
                  for(averageZLast.geometry = geometry; averageZLast.processNext != null; )
                  {
                     averageZLast = averageZLast.processNext;
                     averageZLast.geometry = geometry;
                  }
               }
               geometry.faceStruct = null;
               geometry.next = conflict;
               conflict = geometry;
            }
            geometry = nextGeometry;
         }
         if(conflict != null)
         {
            for(geometry = conflict; geometry.next != null; )
            {
               geometry = geometry.next;
            }
            geometry.next = bspGeometry;
         }
         else
         {
            conflict = bspGeometry;
         }
         if(dynamicBSPFirst != null)
         {
            list = dynamicBSPFirst;
            dynamicBSPLast.processNext = averageZFirst;
         }
         else
         {
            list = averageZFirst;
         }
         if(bspGeometry != null)
         {
            bspGeometry.faceStruct.geometry = bspGeometry;
            list = this.collectNode(bspGeometry.faceStruct,list,camera,this.threshold,true);
            bspGeometry.faceStruct = null;
            for(bspGeometry = bspGeometry.next; bspGeometry != null; bspGeometry = bspGeometry.next)
            {
               bspGeometry.faceStruct.geometry = bspGeometry;
               list = this.collectNode(bspGeometry.faceStruct,list,camera,this.threshold,false);
               bspGeometry.faceStruct = null;
            }
         }
         else if(dynamicBSPFirst != null)
         {
            list = this.collectNode(null,list,camera,this.threshold,true);
         }
         else if(averageZFirst != null)
         {
            list = camera.sortByAverageZ(list);
         }
         for(face = list; face != null; )
         {
            next = face.processNext;
            geometry = face.geometry;
            face.geometry = null;
            changeGeometry = next == null || geometry != next.geometry;
            if(changeGeometry || face.material != next.material)
            {
               face.processNext = null;
               if(changeGeometry)
               {
                  if(first != null)
                  {
                     last.processNegative = list;
                     first = null;
                     last = null;
                  }
                  else
                  {
                     list.processPositive = drawList;
                     drawList = list;
                     drawList.geometry = geometry;
                  }
               }
               else
               {
                  if(first != null)
                  {
                     last.processNegative = list;
                  }
                  else
                  {
                     list.processPositive = drawList;
                     drawList = list;
                     drawList.geometry = geometry;
                     first = list;
                  }
                  last = list;
               }
               list = next;
            }
            face = next;
         }
         if(camera.debug)
         {
            for(list = drawList; list != null; list = list.processPositive)
            {
               if(Boolean(list.geometry.debug & Debug.EDGES))
               {
                  for(face = list; face != null; face = face.processNegative)
                  {
                     Debug.drawEdges(camera,face,16711680);
                  }
               }
            }
         }
         while(drawList != null)
         {
            list = drawList;
            drawList = list.processPositive;
            list.processPositive = null;
            geometry = list.geometry;
            list.geometry = null;
            for(inverse = null; list != null; )
            {
               next = list.processNegative;
               if(list.material != null)
               {
                  list.processNegative = inverse;
                  inverse = list;
               }
               else
               {
                  for(list.processNegative = null; list != null; )
                  {
                     face = list.processNext;
                     list.processNext = null;
                     list = face;
                  }
               }
               list = next;
            }
            for(list = inverse; list != null; list = next)
            {
               next = list.processNegative;
               list.processNegative = null;
               camera.addTransparent(list,geometry.object);
            }
         }
         for(geometry = conflict; geometry != null; geometry = nextGeometry)
         {
            nextGeometry = geometry.next;
            geometry.destroy();
         }
      }
      
      private function collectNode(splitter:Face, list:Face, camera:Camera3D, threshold:Number, sort:Boolean, result:Face = null) : Face
      {
         var w:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var v:Vertex = null;
         var normalX:Number = NaN;
         var normalY:Number = NaN;
         var normalZ:Number = NaN;
         var offset:Number = NaN;
         var splitterLast:Face = null;
         var negativeNode:Face = null;
         var positiveNode:Face = null;
         var geometry:VG = null;
         var negativeFirst:Face = null;
         var negativeLast:Face = null;
         var positiveFirst:Face = null;
         var positiveLast:Face = null;
         var next:Face = null;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var length:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         var nl:Number = NaN;
         var ao:Number = NaN;
         var bo:Number = NaN;
         var co:Number = NaN;
         var behind:Boolean = false;
         var infront:Boolean = false;
         var vo:Number = NaN;
         var negative:Face = null;
         var positive:Face = null;
         var wNegative:Wrapper = null;
         var wPositive:Wrapper = null;
         var wNew:Wrapper = null;
         var interpolateNormals:Boolean = false;
         var t:Number = NaN;
         if(splitter != null)
         {
            geometry = splitter.geometry;
            if(splitter.offset < 0)
            {
               negativeNode = splitter.processNegative;
               positiveNode = splitter.processPositive;
               normalX = splitter.normalX;
               normalY = splitter.normalY;
               normalZ = splitter.normalZ;
               offset = splitter.offset;
            }
            else
            {
               negativeNode = splitter.processPositive;
               positiveNode = splitter.processNegative;
               normalX = -splitter.normalX;
               normalY = -splitter.normalY;
               normalZ = -splitter.normalZ;
               offset = -splitter.offset;
            }
            splitter.processNegative = null;
            splitter.processPositive = null;
            if(splitter.wrapper != null)
            {
               for(splitterLast = splitter; splitterLast.processNext != null; )
               {
                  splitterLast = splitterLast.processNext;
                  splitterLast.geometry = geometry;
               }
            }
            else
            {
               splitter.geometry = null;
               splitter = null;
            }
         }
         else
         {
            splitter = list;
            list = splitter.processNext;
            splitterLast = splitter;
            w = splitter.wrapper;
            a = w.vertex;
            w = w.next;
            b = w.vertex;
            ax = a.cameraX;
            ay = a.cameraY;
            az = a.cameraZ;
            abx = b.cameraX - ax;
            aby = b.cameraY - ay;
            abz = b.cameraZ - az;
            normalX = 0;
            normalY = 0;
            normalZ = 1;
            offset = az;
            length = 0;
            for(w = w.next; w != null; w = w.next)
            {
               v = w.vertex;
               acx = v.cameraX - ax;
               acy = v.cameraY - ay;
               acz = v.cameraZ - az;
               nx = acz * aby - acy * abz;
               ny = acx * abz - acz * abx;
               nz = acy * abx - acx * aby;
               nl = nx * nx + ny * ny + nz * nz;
               if(nl > threshold)
               {
                  nl = 1 / Math.sqrt(nl);
                  normalX = nx * nl;
                  normalY = ny * nl;
                  normalZ = nz * nl;
                  offset = ax * normalX + ay * normalY + az * normalZ;
                  break;
               }
               if(nl > length)
               {
                  nl = 1 / Math.sqrt(nl);
                  normalX = nx * nl;
                  normalY = ny * nl;
                  normalZ = nz * nl;
                  offset = ax * normalX + ay * normalY + az * normalZ;
                  length = nl;
               }
            }
         }
         var offsetMin:Number = offset - threshold;
         var offsetMax:Number = offset + threshold;
         for(var face:Face = list; face != null; )
         {
            next = face.processNext;
            w = face.wrapper;
            a = w.vertex;
            w = w.next;
            b = w.vertex;
            w = w.next;
            c = w.vertex;
            w = w.next;
            ao = a.cameraX * normalX + a.cameraY * normalY + a.cameraZ * normalZ;
            bo = b.cameraX * normalX + b.cameraY * normalY + b.cameraZ * normalZ;
            co = c.cameraX * normalX + c.cameraY * normalY + c.cameraZ * normalZ;
            behind = ao < offsetMin || bo < offsetMin || co < offsetMin;
            for(infront = ao > offsetMax || bo > offsetMax || co > offsetMax; w != null; )
            {
               v = w.vertex;
               vo = v.cameraX * normalX + v.cameraY * normalY + v.cameraZ * normalZ;
               if(vo < offsetMin)
               {
                  behind = true;
               }
               else if(vo > offsetMax)
               {
                  infront = true;
               }
               v.offset = vo;
               w = w.next;
            }
            if(!behind)
            {
               if(!infront)
               {
                  if(splitter != null)
                  {
                     splitterLast.processNext = face;
                  }
                  else
                  {
                     splitter = face;
                  }
                  splitterLast = face;
               }
               else
               {
                  if(positiveFirst != null)
                  {
                     positiveLast.processNext = face;
                  }
                  else
                  {
                     positiveFirst = face;
                  }
                  positiveLast = face;
               }
            }
            else if(!infront)
            {
               if(negativeFirst != null)
               {
                  negativeLast.processNext = face;
               }
               else
               {
                  negativeFirst = face;
               }
               negativeLast = face;
            }
            else
            {
               a.offset = ao;
               b.offset = bo;
               c.offset = co;
               negative = face.create();
               negative.material = face.material;
               negative.geometry = face.geometry;
               camera.lastFace.next = negative;
               camera.lastFace = negative;
               positive = face.create();
               positive.material = face.material;
               positive.geometry = face.geometry;
               camera.lastFace.next = positive;
               camera.lastFace = positive;
               wNegative = null;
               wPositive = null;
               for(w = face.wrapper.next.next; w.next != null; w = w.next)
               {
               }
               a = w.vertex;
               ao = a.offset;
               interpolateNormals = face.material != null && face.material.useVerticesNormals;
               for(w = face.wrapper; w != null; w = w.next)
               {
                  b = w.vertex;
                  bo = b.offset;
                  if(ao < offsetMin && bo > offsetMax || ao > offsetMax && bo < offsetMin)
                  {
                     t = (offset - ao) / (bo - ao);
                     v = b.create();
                     camera.lastVertex.next = v;
                     camera.lastVertex = v;
                     v.cameraX = a.cameraX + (b.cameraX - a.cameraX) * t;
                     v.cameraY = a.cameraY + (b.cameraY - a.cameraY) * t;
                     v.cameraZ = a.cameraZ + (b.cameraZ - a.cameraZ) * t;
                     v.u = a.u + (b.u - a.u) * t;
                     v.v = a.v + (b.v - a.v) * t;
                     if(interpolateNormals)
                     {
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                        v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                        v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                     }
                     wNew = w.create();
                     wNew.vertex = v;
                     if(wNegative != null)
                     {
                        wNegative.next = wNew;
                     }
                     else
                     {
                        negative.wrapper = wNew;
                     }
                     wNegative = wNew;
                     wNew = w.create();
                     wNew.vertex = v;
                     if(wPositive != null)
                     {
                        wPositive.next = wNew;
                     }
                     else
                     {
                        positive.wrapper = wNew;
                     }
                     wPositive = wNew;
                  }
                  if(bo <= offsetMax)
                  {
                     wNew = w.create();
                     wNew.vertex = b;
                     if(wNegative != null)
                     {
                        wNegative.next = wNew;
                     }
                     else
                     {
                        negative.wrapper = wNew;
                     }
                     wNegative = wNew;
                  }
                  if(bo >= offsetMin)
                  {
                     wNew = w.create();
                     wNew.vertex = b;
                     if(wPositive != null)
                     {
                        wPositive.next = wNew;
                     }
                     else
                     {
                        positive.wrapper = wNew;
                     }
                     wPositive = wNew;
                  }
                  a = b;
                  ao = bo;
               }
               if(negativeFirst != null)
               {
                  negativeLast.processNext = negative;
               }
               else
               {
                  negativeFirst = negative;
               }
               negativeLast = negative;
               if(positiveFirst != null)
               {
                  positiveLast.processNext = positive;
               }
               else
               {
                  positiveFirst = positive;
               }
               positiveLast = positive;
               face.processNext = null;
               face.geometry = null;
            }
            face = next;
         }
         if(positiveNode != null)
         {
            positiveNode.geometry = geometry;
            if(positiveLast != null)
            {
               positiveLast.processNext = null;
            }
            result = this.collectNode(positiveNode,positiveFirst,camera,threshold,sort,result);
         }
         else if(positiveFirst != null)
         {
            if(sort && positiveFirst != positiveLast)
            {
               if(positiveLast != null)
               {
                  positiveLast.processNext = null;
               }
               if(positiveFirst.geometry.sorting == 2)
               {
                  result = this.collectNode(null,positiveFirst,camera,threshold,sort,result);
               }
               else
               {
                  positiveFirst = camera.sortByAverageZ(positiveFirst);
                  for(positiveLast = positiveFirst.processNext; positiveLast.processNext != null; positiveLast = positiveLast.processNext)
                  {
                  }
                  positiveLast.processNext = result;
                  result = positiveFirst;
               }
            }
            else
            {
               positiveLast.processNext = result;
               result = positiveFirst;
            }
         }
         if(splitter != null)
         {
            splitterLast.processNext = result;
            result = splitter;
         }
         if(negativeNode != null)
         {
            negativeNode.geometry = geometry;
            if(negativeLast != null)
            {
               negativeLast.processNext = null;
            }
            result = this.collectNode(negativeNode,negativeFirst,camera,threshold,sort,result);
         }
         else if(negativeFirst != null)
         {
            if(sort && negativeFirst != negativeLast)
            {
               if(negativeLast != null)
               {
                  negativeLast.processNext = null;
               }
               if(negativeFirst.geometry.sorting == 2)
               {
                  result = this.collectNode(null,negativeFirst,camera,threshold,sort,result);
               }
               else
               {
                  negativeFirst = camera.sortByAverageZ(negativeFirst);
                  for(negativeLast = negativeFirst.processNext; negativeLast.processNext != null; negativeLast = negativeLast.processNext)
                  {
                  }
                  negativeLast.processNext = result;
                  result = negativeFirst;
               }
            }
            else
            {
               negativeLast.processNext = result;
               result = negativeFirst;
            }
         }
         return result;
      }
   }
}

