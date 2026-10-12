package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;
   
   public class VG
   {
      
      private static var collector:VG;
      
      alternativa3d var next:VG;
      
      alternativa3d var faceStruct:Face;
      
      alternativa3d var object:Object3D;
      
      alternativa3d var sorting:int;
      
      alternativa3d var debug:int = 0;
      
      alternativa3d var space:int = 0;
      
      alternativa3d var viewAligned:Boolean = false;
      
      alternativa3d var boundMinX:Number;
      
      alternativa3d var boundMinY:Number;
      
      alternativa3d var boundMinZ:Number;
      
      alternativa3d var boundMaxX:Number;
      
      alternativa3d var boundMaxY:Number;
      
      alternativa3d var boundMaxZ:Number;
      
      alternativa3d var boundVertexList:Vertex = Vertex.createList(8);
      
      alternativa3d var boundPlaneList:Vertex = Vertex.createList(6);
      
      alternativa3d var numOccluders:int;
      
      public function VG()
      {
         super();
      }
      
      alternativa3d static function create(object:Object3D, faceStruct:Face, sorting:int, debug:int, viewAligned:Boolean) : VG
      {
         var res:VG = null;
         if(collector != null)
         {
            res = collector;
            collector = collector.next;
            res.next = null;
         }
         else
         {
            res = new VG();
         }
         res.object = object;
         res.faceStruct = faceStruct;
         res.sorting = sorting;
         res.debug = debug;
         res.viewAligned = viewAligned;
         return res;
      }
      
      alternativa3d function destroy() : void
      {
         if(this.faceStruct != null)
         {
            this.destroyFaceStruct(this.faceStruct);
            this.faceStruct = null;
         }
         this.object = null;
         this.numOccluders = 0;
         this.debug = 0;
         this.space = 0;
         this.next = collector;
         collector = this;
      }
      
      private function destroyFaceStruct(struct:Face) : void
      {
         if(struct.processNegative != null)
         {
            this.destroyFaceStruct(struct.processNegative);
            struct.processNegative = null;
         }
         if(struct.processPositive != null)
         {
            this.destroyFaceStruct(struct.processPositive);
            struct.processPositive = null;
         }
         for(var next:Face = struct.processNext; next != null; next = struct.processNext)
         {
            struct.processNext = null;
            struct = next;
         }
      }
      
      alternativa3d function calculateAABB(a:Number, b:Number, c:Number, d:Number, e:Number, f:Number, g:Number, h:Number, i:Number, j:Number, k:Number, l:Number) : void
      {
         this.boundMinX = 1e+22;
         this.boundMinY = 1e+22;
         this.boundMinZ = 1e+22;
         this.boundMaxX = -1e+22;
         this.boundMaxY = -1e+22;
         this.boundMaxZ = -1e+22;
         this.calculateAABBStruct(this.faceStruct,++this.object.transformId,a,b,c,d,e,f,g,h,i,j,k,l);
         this.space = 1;
      }
      
      alternativa3d function calculateOOBB(container:Object3D) : void
      {
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var d:Vertex = null;
         var e:Vertex = null;
         var f:Vertex = null;
         var g:Vertex = null;
         var h:Vertex = null;
         var vertex:Vertex = null;
         var front:Vertex = null;
         var back:Vertex = null;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var abx:Number = NaN;
         var aby:Number = NaN;
         var abz:Number = NaN;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         var nl:Number = NaN;
         var left:Vertex = null;
         var right:Vertex = null;
         var top:Vertex = null;
         var bottom:Vertex = null;
         if(this.space == 1)
         {
            this.transformStruct(this.faceStruct,++this.object.transformId,container.ma,container.mb,container.mc,container.md,container.me,container.mf,container.mg,container.mh,container.mi,container.mj,container.mk,container.ml);
         }
         if(!this.viewAligned)
         {
            this.boundMinX = 1e+22;
            this.boundMinY = 1e+22;
            this.boundMinZ = 1e+22;
            this.boundMaxX = -1e+22;
            this.boundMaxY = -1e+22;
            this.boundMaxZ = -1e+22;
            this.calculateOOBBStruct(this.faceStruct,++this.object.transformId,this.object.ima,this.object.imb,this.object.imc,this.object.imd,this.object.ime,this.object.imf,this.object.img,this.object.imh,this.object.imi,this.object.imj,this.object.imk,this.object.iml);
            if(this.boundMaxX - this.boundMinX < 1)
            {
               this.boundMaxX = this.boundMinX + 1;
            }
            if(this.boundMaxY - this.boundMinY < 1)
            {
               this.boundMaxY = this.boundMinY + 1;
            }
            if(this.boundMaxZ - this.boundMinZ < 1)
            {
               this.boundMaxZ = this.boundMinZ + 1;
            }
            a = this.boundVertexList;
            a.x = this.boundMinX;
            a.y = this.boundMinY;
            a.z = this.boundMinZ;
            b = a.next;
            b.x = this.boundMaxX;
            b.y = this.boundMinY;
            b.z = this.boundMinZ;
            c = b.next;
            c.x = this.boundMinX;
            c.y = this.boundMaxY;
            c.z = this.boundMinZ;
            d = c.next;
            d.x = this.boundMaxX;
            d.y = this.boundMaxY;
            d.z = this.boundMinZ;
            e = d.next;
            e.x = this.boundMinX;
            e.y = this.boundMinY;
            e.z = this.boundMaxZ;
            f = e.next;
            f.x = this.boundMaxX;
            f.y = this.boundMinY;
            f.z = this.boundMaxZ;
            g = f.next;
            g.x = this.boundMinX;
            g.y = this.boundMaxY;
            g.z = this.boundMaxZ;
            h = g.next;
            h.x = this.boundMaxX;
            h.y = this.boundMaxY;
            h.z = this.boundMaxZ;
            for(vertex = a; vertex != null; vertex = vertex.next)
            {
               vertex.cameraX = this.object.ma * vertex.x + this.object.mb * vertex.y + this.object.mc * vertex.z + this.object.md;
               vertex.cameraY = this.object.me * vertex.x + this.object.mf * vertex.y + this.object.mg * vertex.z + this.object.mh;
               vertex.cameraZ = this.object.mi * vertex.x + this.object.mj * vertex.y + this.object.mk * vertex.z + this.object.ml;
            }
            front = this.boundPlaneList;
            back = front.next;
            ax = a.cameraX;
            ay = a.cameraY;
            az = a.cameraZ;
            abx = b.cameraX - ax;
            aby = b.cameraY - ay;
            abz = b.cameraZ - az;
            acx = e.cameraX - ax;
            acy = e.cameraY - ay;
            acz = e.cameraZ - az;
            nx = acz * aby - acy * abz;
            ny = acx * abz - acz * abx;
            nz = acy * abx - acx * aby;
            nl = 1 / Math.sqrt(nx * nx + ny * ny + nz * nz);
            nx *= nl;
            ny *= nl;
            nz *= nl;
            front.cameraX = nx;
            front.cameraY = ny;
            front.cameraZ = nz;
            front.offset = ax * nx + ay * ny + az * nz;
            back.cameraX = -nx;
            back.cameraY = -ny;
            back.cameraZ = -nz;
            back.offset = -c.cameraX * nx - c.cameraY * ny - c.cameraZ * nz;
            left = back.next;
            right = left.next;
            ax = a.cameraX;
            ay = a.cameraY;
            az = a.cameraZ;
            abx = e.cameraX - ax;
            aby = e.cameraY - ay;
            abz = e.cameraZ - az;
            acx = c.cameraX - ax;
            acy = c.cameraY - ay;
            acz = c.cameraZ - az;
            nx = acz * aby - acy * abz;
            ny = acx * abz - acz * abx;
            nz = acy * abx - acx * aby;
            nl = 1 / Math.sqrt(nx * nx + ny * ny + nz * nz);
            nx *= nl;
            ny *= nl;
            nz *= nl;
            left.cameraX = nx;
            left.cameraY = ny;
            left.cameraZ = nz;
            left.offset = ax * nx + ay * ny + az * nz;
            right.cameraX = -nx;
            right.cameraY = -ny;
            right.cameraZ = -nz;
            right.offset = -b.cameraX * nx - b.cameraY * ny - b.cameraZ * nz;
            top = right.next;
            bottom = top.next;
            ax = e.cameraX;
            ay = e.cameraY;
            az = e.cameraZ;
            abx = f.cameraX - ax;
            aby = f.cameraY - ay;
            abz = f.cameraZ - az;
            acx = g.cameraX - ax;
            acy = g.cameraY - ay;
            acz = g.cameraZ - az;
            nx = acz * aby - acy * abz;
            ny = acx * abz - acz * abx;
            nz = acy * abx - acx * aby;
            nl = 1 / Math.sqrt(nx * nx + ny * ny + nz * nz);
            nx *= nl;
            ny *= nl;
            nz *= nl;
            top.cameraX = nx;
            top.cameraY = ny;
            top.cameraZ = nz;
            top.offset = ax * nx + ay * ny + az * nz;
            bottom.cameraX = -nx;
            bottom.cameraY = -ny;
            bottom.cameraZ = -nz;
            bottom.offset = -a.cameraX * nx - a.cameraY * ny - a.cameraZ * nz;
            if(front.offset < -back.offset)
            {
               back.cameraX = -back.cameraX;
               back.cameraY = -back.cameraY;
               back.cameraZ = -back.cameraZ;
               back.offset = -back.offset;
               front.cameraX = -front.cameraX;
               front.cameraY = -front.cameraY;
               front.cameraZ = -front.cameraZ;
               front.offset = -front.offset;
            }
            if(left.offset < -right.offset)
            {
               left.cameraX = -left.cameraX;
               left.cameraY = -left.cameraY;
               left.cameraZ = -left.cameraZ;
               left.offset = -left.offset;
               right.cameraX = -right.cameraX;
               right.cameraY = -right.cameraY;
               right.cameraZ = -right.cameraZ;
               right.offset = -right.offset;
            }
            if(bottom.offset < -top.offset)
            {
               bottom.cameraX = -bottom.cameraX;
               bottom.cameraY = -bottom.cameraY;
               bottom.cameraZ = -bottom.cameraZ;
               bottom.offset = -bottom.offset;
               top.cameraX = -top.cameraX;
               top.cameraY = -top.cameraY;
               top.cameraZ = -top.cameraZ;
               top.offset = -top.offset;
            }
         }
         this.space = 2;
      }
      
      private function calculateAABBStruct(struct:Face, transformId:int, a:Number, b:Number, c:Number, d:Number, e:Number, f:Number, g:Number, h:Number, i:Number, j:Number, k:Number, l:Number) : void
      {
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         var cameraX:Number = NaN;
         var cameraY:Number = NaN;
         var cameraZ:Number = NaN;
         for(var face:Face = struct; face != null; face = face.processNext)
         {
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               vertex = wrapper.vertex;
               if(vertex.transformId != transformId)
               {
                  cameraX = vertex.cameraX;
                  cameraY = vertex.cameraY;
                  cameraZ = vertex.cameraZ;
                  vertex.cameraX = a * cameraX + b * cameraY + c * cameraZ + d;
                  vertex.cameraY = e * cameraX + f * cameraY + g * cameraZ + h;
                  vertex.cameraZ = i * cameraX + j * cameraY + k * cameraZ + l;
                  if(vertex.cameraX < this.boundMinX)
                  {
                     this.boundMinX = vertex.cameraX;
                  }
                  if(vertex.cameraX > this.boundMaxX)
                  {
                     this.boundMaxX = vertex.cameraX;
                  }
                  if(vertex.cameraY < this.boundMinY)
                  {
                     this.boundMinY = vertex.cameraY;
                  }
                  if(vertex.cameraY > this.boundMaxY)
                  {
                     this.boundMaxY = vertex.cameraY;
                  }
                  if(vertex.cameraZ < this.boundMinZ)
                  {
                     this.boundMinZ = vertex.cameraZ;
                  }
                  if(vertex.cameraZ > this.boundMaxZ)
                  {
                     this.boundMaxZ = vertex.cameraZ;
                  }
                  vertex.transformId = transformId;
               }
            }
         }
         if(struct.processNegative != null)
         {
            this.calculateAABBStruct(struct.processNegative,transformId,a,b,c,d,e,f,g,h,i,j,k,l);
         }
         if(struct.processPositive != null)
         {
            this.calculateAABBStruct(struct.processPositive,transformId,a,b,c,d,e,f,g,h,i,j,k,l);
         }
      }
      
      private function calculateOOBBStruct(struct:Face, transformId:int, a:Number, b:Number, c:Number, d:Number, e:Number, f:Number, g:Number, h:Number, i:Number, j:Number, k:Number, l:Number) : void
      {
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         for(var face:Face = struct; face != null; face = face.processNext)
         {
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               vertex = wrapper.vertex;
               if(vertex.transformId != transformId)
               {
                  if(vertex.x < this.boundMinX)
                  {
                     this.boundMinX = vertex.x;
                  }
                  if(vertex.x > this.boundMaxX)
                  {
                     this.boundMaxX = vertex.x;
                  }
                  if(vertex.y < this.boundMinY)
                  {
                     this.boundMinY = vertex.y;
                  }
                  if(vertex.y > this.boundMaxY)
                  {
                     this.boundMaxY = vertex.y;
                  }
                  if(vertex.z < this.boundMinZ)
                  {
                     this.boundMinZ = vertex.z;
                  }
                  if(vertex.z > this.boundMaxZ)
                  {
                     this.boundMaxZ = vertex.z;
                  }
                  vertex.transformId = transformId;
               }
            }
         }
         if(struct.processNegative != null)
         {
            this.calculateOOBBStruct(struct.processNegative,transformId,a,b,c,d,e,f,g,h,i,j,k,l);
         }
         if(struct.processPositive != null)
         {
            this.calculateOOBBStruct(struct.processPositive,transformId,a,b,c,d,e,f,g,h,i,j,k,l);
         }
      }
      
      private function updateAABBStruct(struct:Face, transformId:int) : void
      {
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         for(var face:Face = struct; face != null; face = face.processNext)
         {
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               vertex = wrapper.vertex;
               if(vertex.transformId != transformId)
               {
                  if(vertex.cameraX < this.boundMinX)
                  {
                     this.boundMinX = vertex.cameraX;
                  }
                  if(vertex.cameraX > this.boundMaxX)
                  {
                     this.boundMaxX = vertex.cameraX;
                  }
                  if(vertex.cameraY < this.boundMinY)
                  {
                     this.boundMinY = vertex.cameraY;
                  }
                  if(vertex.cameraY > this.boundMaxY)
                  {
                     this.boundMaxY = vertex.cameraY;
                  }
                  if(vertex.cameraZ < this.boundMinZ)
                  {
                     this.boundMinZ = vertex.cameraZ;
                  }
                  if(vertex.cameraZ > this.boundMaxZ)
                  {
                     this.boundMaxZ = vertex.cameraZ;
                  }
                  vertex.transformId = transformId;
               }
            }
         }
         if(struct.processNegative != null)
         {
            this.updateAABBStruct(struct.processNegative,transformId);
         }
         if(struct.processPositive != null)
         {
            this.updateAABBStruct(struct.processPositive,transformId);
         }
      }
      
      alternativa3d function split(camera:Camera3D, planeX:Number, planeY:Number, planeZ:Number, planeOffset:Number, threshold:Number) : void
      {
         var negative:VG = null;
         var result:Face = this.faceStruct.create();
         this.splitFaceStruct(camera,this.faceStruct,result,planeX,planeY,planeZ,planeOffset,planeOffset - threshold,planeOffset + threshold);
         if(result.processNegative != null)
         {
            if(collector != null)
            {
               negative = collector;
               collector = collector.next;
               negative.next = null;
            }
            else
            {
               negative = new VG();
            }
            this.next = negative;
            negative.faceStruct = result.processNegative;
            result.processNegative = null;
            negative.object = this.object;
            negative.sorting = this.sorting;
            negative.debug = this.debug;
            negative.space = this.space;
            negative.viewAligned = this.viewAligned;
            negative.boundMinX = 1e+22;
            negative.boundMinY = 1e+22;
            negative.boundMinZ = 1e+22;
            negative.boundMaxX = -1e+22;
            negative.boundMaxY = -1e+22;
            negative.boundMaxZ = -1e+22;
            negative.updateAABBStruct(negative.faceStruct,++this.object.transformId);
         }
         else
         {
            this.next = null;
         }
         if(result.processPositive != null)
         {
            this.faceStruct = result.processPositive;
            result.processPositive = null;
            this.boundMinX = 1e+22;
            this.boundMinY = 1e+22;
            this.boundMinZ = 1e+22;
            this.boundMaxX = -1e+22;
            this.boundMaxY = -1e+22;
            this.boundMaxZ = -1e+22;
            this.updateAABBStruct(this.faceStruct,++this.object.transformId);
         }
         else
         {
            this.faceStruct = null;
         }
         result.next = Face.collector;
         Face.collector = result;
      }
      
      alternativa3d function crop(camera:Camera3D, planeX:Number, planeY:Number, planeZ:Number, planeOffset:Number, threshold:Number) : void
      {
         this.faceStruct = this.cropFaceStruct(camera,this.faceStruct,planeX,planeY,planeZ,planeOffset,planeOffset - threshold,planeOffset + threshold);
         if(this.faceStruct != null)
         {
            this.boundMinX = 1e+22;
            this.boundMinY = 1e+22;
            this.boundMinZ = 1e+22;
            this.boundMaxX = -1e+22;
            this.boundMaxY = -1e+22;
            this.boundMaxZ = -1e+22;
            this.updateAABBStruct(this.faceStruct,++this.object.transformId);
         }
      }
      
      private function splitFaceStruct(camera:Camera3D, struct:Face, result:Face, normalX:Number, normalY:Number, normalZ:Number, offset:Number, offsetMin:Number, offsetMax:Number) : void
      {
         var face:Face = null;
         var next:Face = null;
         var w:Wrapper = null;
         var v:Vertex = null;
         var v2:Vertex = null;
         var negativeNegative:Face = null;
         var negativePositive:Face = null;
         var positiveNegative:Face = null;
         var positivePositive:Face = null;
         var negativeFirst:Face = null;
         var negativeLast:Face = null;
         var positiveFirst:Face = null;
         var positiveLast:Face = null;
         var negative:Face = null;
         var positive:Face = null;
         var wNegative:Wrapper = null;
         var wPositive:Wrapper = null;
         var wNew:Wrapper = null;
         var interpolateNormals:Boolean = false;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var ao:Number = NaN;
         var bo:Number = NaN;
         var co:Number = NaN;
         var behind:Boolean = false;
         var infront:Boolean = false;
         var fullBehind:Boolean = false;
         var vo:Number = NaN;
         var t:Number = NaN;
         if(struct.processNegative != null)
         {
            this.splitFaceStruct(camera,struct.processNegative,result,normalX,normalY,normalZ,offset,offsetMin,offsetMax);
            struct.processNegative = null;
            negativeNegative = result.processNegative;
            negativePositive = result.processPositive;
         }
         if(struct.processPositive != null)
         {
            this.splitFaceStruct(camera,struct.processPositive,result,normalX,normalY,normalZ,offset,offsetMin,offsetMax);
            struct.processPositive = null;
            positiveNegative = result.processNegative;
            positivePositive = result.processPositive;
         }
         if(struct.wrapper != null)
         {
            for(face = struct; face != null; )
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
               infront = ao > offsetMax || bo > offsetMax || co > offsetMax;
               for(fullBehind = ao < offsetMin && bo < offsetMin && co < offsetMin; w != null; )
               {
                  v = w.vertex;
                  vo = v.cameraX * normalX + v.cameraY * normalY + v.cameraZ * normalZ;
                  if(vo < offsetMin)
                  {
                     behind = true;
                  }
                  else
                  {
                     fullBehind = false;
                     if(vo > offsetMax)
                     {
                        infront = true;
                     }
                  }
                  v.offset = vo;
                  w = w.next;
               }
               if(!behind)
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
               else if(!infront)
               {
                  if(fullBehind)
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
                     camera.lastFace.next = negative;
                     camera.lastFace = negative;
                     wNegative = null;
                     interpolateNormals = face.material != null && face.material.useVerticesNormals;
                     for(w = face.wrapper; w != null; w = w.next)
                     {
                        b = w.vertex;
                        if(b.offset >= offsetMin)
                        {
                           v2 = b.create();
                           camera.lastVertex.next = v2;
                           camera.lastVertex = v2;
                           v2.x = b.x;
                           v2.y = b.y;
                           v2.z = b.z;
                           v2.u = b.u;
                           v2.v = b.v;
                           v2.cameraX = b.cameraX;
                           v2.cameraY = b.cameraY;
                           v2.cameraZ = b.cameraZ;
                           if(interpolateNormals)
                           {
                              v2.normalX = b.normalX;
                              v2.normalY = b.normalY;
                              v2.normalZ = b.normalZ;
                           }
                           b = v2;
                        }
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
                     if(negativeFirst != null)
                     {
                        negativeLast.processNext = negative;
                     }
                     else
                     {
                        negativeFirst = negative;
                     }
                     negativeLast = negative;
                     face.processNext = null;
                  }
               }
               else
               {
                  a.offset = ao;
                  b.offset = bo;
                  c.offset = co;
                  negative = face.create();
                  negative.material = face.material;
                  camera.lastFace.next = negative;
                  camera.lastFace = negative;
                  positive = face.create();
                  positive.material = face.material;
                  camera.lastFace.next = positive;
                  camera.lastFace = positive;
                  wNegative = null;
                  wPositive = null;
                  for(w = face.wrapper.next.next; w.next != null; )
                  {
                     w = w.next;
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
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.u = a.u + (b.u - a.u) * t;
                        v.v = a.v + (b.v - a.v) * t;
                        v.cameraX = a.cameraX + (b.cameraX - a.cameraX) * t;
                        v.cameraY = a.cameraY + (b.cameraY - a.cameraY) * t;
                        v.cameraZ = a.cameraZ + (b.cameraZ - a.cameraZ) * t;
                        if(interpolateNormals)
                        {
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
                        v2 = b.create();
                        camera.lastVertex.next = v2;
                        camera.lastVertex = v2;
                        v2.x = v.x;
                        v2.y = v.y;
                        v2.z = v.z;
                        v2.u = v.u;
                        v2.v = v.v;
                        v2.cameraX = v.cameraX;
                        v2.cameraY = v.cameraY;
                        v2.cameraZ = v.cameraZ;
                        if(interpolateNormals)
                        {
                           v2.normalX = v.normalX;
                           v2.normalY = v.normalY;
                           v2.normalZ = v.normalZ;
                        }
                        wNew = w.create();
                        wNew.vertex = v2;
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
                     if(b.offset < offsetMin)
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
                     else if(b.offset > offsetMax)
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
                     else
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
                        v2 = b.create();
                        camera.lastVertex.next = v2;
                        camera.lastVertex = v2;
                        v2.x = b.x;
                        v2.y = b.y;
                        v2.z = b.z;
                        v2.u = b.u;
                        v2.v = b.v;
                        v2.cameraX = b.cameraX;
                        v2.cameraY = b.cameraY;
                        v2.cameraZ = b.cameraZ;
                        if(interpolateNormals)
                        {
                           v2.normalX = b.normalX;
                           v2.normalY = b.normalY;
                           v2.normalZ = b.normalZ;
                        }
                        wNew = w.create();
                        wNew.vertex = v2;
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
               }
               face = next;
            }
         }
         if(negativeFirst != null || negativeNegative != null && positiveNegative != null)
         {
            if(negativeFirst == null)
            {
               negativeFirst = struct.create();
               camera.lastFace.next = negativeFirst;
               camera.lastFace = negativeFirst;
            }
            else
            {
               negativeLast.processNext = null;
            }
            if(this.sorting == 3)
            {
               negativeFirst.normalX = struct.normalX;
               negativeFirst.normalY = struct.normalY;
               negativeFirst.normalZ = struct.normalZ;
               negativeFirst.offset = struct.offset;
            }
            negativeFirst.processNegative = negativeNegative;
            negativeFirst.processPositive = positiveNegative;
            result.processNegative = negativeFirst;
         }
         else
         {
            result.processNegative = negativeNegative != null ? negativeNegative : positiveNegative;
         }
         if(positiveFirst != null || negativePositive != null && positivePositive != null)
         {
            if(positiveFirst == null)
            {
               positiveFirst = struct.create();
               camera.lastFace.next = positiveFirst;
               camera.lastFace = positiveFirst;
            }
            else
            {
               positiveLast.processNext = null;
            }
            if(this.sorting == 3)
            {
               positiveFirst.normalX = struct.normalX;
               positiveFirst.normalY = struct.normalY;
               positiveFirst.normalZ = struct.normalZ;
               positiveFirst.offset = struct.offset;
            }
            positiveFirst.processNegative = negativePositive;
            positiveFirst.processPositive = positivePositive;
            result.processPositive = positiveFirst;
         }
         else
         {
            result.processPositive = negativePositive != null ? negativePositive : positivePositive;
         }
      }
      
      private function cropFaceStruct(camera:Camera3D, struct:Face, normalX:Number, normalY:Number, normalZ:Number, offset:Number, offsetMin:Number, offsetMax:Number) : Face
      {
         var face:Face = null;
         var next:Face = null;
         var w:Wrapper = null;
         var v:Vertex = null;
         var negativePositive:Face = null;
         var positivePositive:Face = null;
         var positiveFirst:Face = null;
         var positiveLast:Face = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var ao:Number = NaN;
         var bo:Number = NaN;
         var co:Number = NaN;
         var behind:Boolean = false;
         var infront:Boolean = false;
         var vo:Number = NaN;
         var positive:Face = null;
         var wPositive:Wrapper = null;
         var wNew:Wrapper = null;
         var interpolateNormals:Boolean = false;
         var t:Number = NaN;
         if(struct.processNegative != null)
         {
            negativePositive = this.cropFaceStruct(camera,struct.processNegative,normalX,normalY,normalZ,offset,offsetMin,offsetMax);
            struct.processNegative = null;
         }
         if(struct.processPositive != null)
         {
            positivePositive = this.cropFaceStruct(camera,struct.processPositive,normalX,normalY,normalZ,offset,offsetMin,offsetMax);
            struct.processPositive = null;
         }
         if(struct.wrapper != null)
         {
            for(face = struct; face != null; )
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
               if(!infront)
               {
                  face.processNext = null;
               }
               else if(!behind)
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
               else
               {
                  a.offset = ao;
                  b.offset = bo;
                  c.offset = co;
                  positive = face.create();
                  positive.material = face.material;
                  camera.lastFace.next = positive;
                  camera.lastFace = positive;
                  wPositive = null;
                  for(w = face.wrapper.next.next; w.next != null; )
                  {
                     w = w.next;
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
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.u = a.u + (b.u - a.u) * t;
                        v.v = a.v + (b.v - a.v) * t;
                        v.cameraX = a.cameraX + (b.cameraX - a.cameraX) * t;
                        v.cameraY = a.cameraY + (b.cameraY - a.cameraY) * t;
                        v.cameraZ = a.cameraZ + (b.cameraZ - a.cameraZ) * t;
                        if(interpolateNormals)
                        {
                           v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                           v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                           v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                        }
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
               }
               face = next;
            }
         }
         if(positiveFirst != null || negativePositive != null && positivePositive != null)
         {
            if(positiveFirst == null)
            {
               positiveFirst = struct.create();
               camera.lastFace.next = positiveFirst;
               camera.lastFace = positiveFirst;
            }
            else
            {
               positiveLast.processNext = null;
            }
            if(this.sorting == 3)
            {
               positiveFirst.normalX = struct.normalX;
               positiveFirst.normalY = struct.normalY;
               positiveFirst.normalZ = struct.normalZ;
               positiveFirst.offset = struct.offset;
            }
            positiveFirst.processNegative = negativePositive;
            positiveFirst.processPositive = positivePositive;
            return positiveFirst;
         }
         return negativePositive != null ? negativePositive : positivePositive;
      }
      
      alternativa3d function transformStruct(struct:Face, transformId:int, a:Number, b:Number, c:Number, d:Number, e:Number, f:Number, g:Number, h:Number, i:Number, j:Number, k:Number, l:Number) : void
      {
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         var cameraX:Number = NaN;
         var cameraY:Number = NaN;
         var cameraZ:Number = NaN;
         for(var face:Face = struct; face != null; face = face.processNext)
         {
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               vertex = wrapper.vertex;
               if(vertex.transformId != transformId)
               {
                  cameraX = vertex.cameraX;
                  cameraY = vertex.cameraY;
                  cameraZ = vertex.cameraZ;
                  vertex.cameraX = a * cameraX + b * cameraY + c * cameraZ + d;
                  vertex.cameraY = e * cameraX + f * cameraY + g * cameraZ + h;
                  vertex.cameraZ = i * cameraX + j * cameraY + k * cameraZ + l;
                  vertex.transformId = transformId;
               }
            }
         }
         if(struct.processNegative != null)
         {
            this.transformStruct(struct.processNegative,transformId,a,b,c,d,e,f,g,h,i,j,k,l);
         }
         if(struct.processPositive != null)
         {
            this.transformStruct(struct.processPositive,transformId,a,b,c,d,e,f,g,h,i,j,k,l);
         }
      }
      
      alternativa3d function draw(camera:Camera3D, threshold:Number, container:Object3D) : void
      {
         var list:Face = null;
         var next:Face = null;
         var inverse:Face = null;
         var face:Face = null;
         if(this.space == 1)
         {
            this.transformStruct(this.faceStruct,++this.object.transformId,container.ma,container.mb,container.mc,container.md,container.me,container.mf,container.mg,container.mh,container.mi,container.mj,container.mk,container.ml);
         }
         if(this.viewAligned)
         {
            list = this.faceStruct;
            if(this.debug > 0)
            {
               if(Boolean(this.debug & Debug.EDGES))
               {
                  Debug.drawEdges(camera,list,this.space != 2 ? 16777215 : 16750848);
               }
               if(Boolean(this.debug & Debug.BOUNDS))
               {
                  if(this.space == 1)
                  {
                     Debug.drawBounds(camera,container,this.boundMinX,this.boundMinY,this.boundMinZ,this.boundMaxX,this.boundMaxY,this.boundMaxZ,10092288);
                  }
               }
            }
            camera.addTransparent(list,this.object);
         }
         else
         {
            switch(this.sorting)
            {
               case 0:
                  list = this.faceStruct;
                  break;
               case 1:
                  list = this.faceStruct.processNext != null ? camera.sortByAverageZ(this.faceStruct) : this.faceStruct;
                  break;
               case 2:
                  list = this.faceStruct.processNext != null ? camera.sortByDynamicBSP(this.faceStruct,threshold) : this.faceStruct;
                  break;
               case 3:
                  list = this.collectNode(this.faceStruct);
            }
            if(this.debug > 0)
            {
               if(Boolean(this.debug & Debug.EDGES))
               {
                  Debug.drawEdges(camera,list,16777215);
               }
               if(Boolean(this.debug & Debug.BOUNDS))
               {
                  if(this.space == 1)
                  {
                     Debug.drawBounds(camera,container,this.boundMinX,this.boundMinY,this.boundMinZ,this.boundMaxX,this.boundMaxY,this.boundMaxZ,10092288);
                  }
                  else if(this.space == 2)
                  {
                     Debug.drawBounds(camera,this.object,this.boundMinX,this.boundMinY,this.boundMinZ,this.boundMaxX,this.boundMaxY,this.boundMaxZ,16750848);
                  }
               }
            }
            for(face = list; face != null; )
            {
               next = face.processNext;
               if(next == null || next.material != list.material)
               {
                  face.processNext = null;
                  if(list.material != null)
                  {
                     list.processNegative = inverse;
                     inverse = list;
                  }
                  else
                  {
                     while(list != null)
                     {
                        face = list.processNext;
                        list.processNext = null;
                        list = face;
                     }
                  }
                  list = next;
               }
               face = next;
            }
            for(list = inverse; list != null; list = next)
            {
               next = list.processNegative;
               list.processNegative = null;
               camera.addTransparent(list,this.object);
            }
         }
         this.faceStruct = null;
      }
      
      private function collectNode(node:Face, result:Face = null) : Face
      {
         var last:Face = null;
         var negative:Face = null;
         var positive:Face = null;
         if(node.offset < 0)
         {
            negative = node.processNegative;
            positive = node.processPositive;
         }
         else
         {
            negative = node.processPositive;
            positive = node.processNegative;
         }
         node.processNegative = null;
         node.processPositive = null;
         if(positive != null)
         {
            result = this.collectNode(positive,result);
         }
         if(node.wrapper != null)
         {
            for(last = node; last.processNext != null; )
            {
               last = last.processNext;
            }
            last.processNext = result;
            result = node;
         }
         if(negative != null)
         {
            result = this.collectNode(negative,result);
         }
         return result;
      }
   }
}

