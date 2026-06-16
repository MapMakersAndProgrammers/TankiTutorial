package alternativa.engine3d.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.RayIntersectionData;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.lights.SpotLight;
   import alternativa.engine3d.lights.TubeLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class Sprite3D extends Object3D
   {
      
      public var material:Material;
      
      public var originX:Number = 0.5;
      
      public var originY:Number = 0.5;
      
      public var sorting:int = 0;
      
      public var clipping:int = 2;
      
      public var rotation:Number = 0;
      
      public var autoSize:Boolean = false;
      
      public var width:Number;
      
      public var height:Number;
      
      public var perspectiveScale:Boolean = true;
      
      public var topLeftU:Number = 0;
      
      public var topLeftV:Number = 0;
      
      public var bottomRightU:Number = 1;
      
      public var bottomRightV:Number = 1;
      
      alternativa3d var lightConst:Vector.<Number> = Vector.<Number>([0,0,0,1]);
      
      public function Sprite3D(width:Number, height:Number, material:Material = null)
      {
         super();
         this.width = width;
         this.height = height;
         this.material = material;
      }
      
      override public function intersectRay(origin:Vector3D, direction:Vector3D, excludedObjects:Dictionary = null, camera:Camera3D = null) : RayIntersectionData
      {
         var res:RayIntersectionData = null;
         var vertex:Vertex = null;
         var offset:Number = NaN;
         var time:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var cz:Number = NaN;
         var point:Vector3D = null;
         if(camera == null || Boolean(excludedObjects != null) && Boolean(excludedObjects[this]))
         {
            return null;
         }
         camera.composeCameraMatrix();
         for(var root:Object3D = camera; root._parent != null; )
         {
            root = root._parent;
            root.composeMatrix();
            camera.appendMatrix(root);
         }
         camera.invertMatrix();
         composeMatrix();
         for(root = this; root._parent != null; )
         {
            root = root._parent;
            root.composeMatrix();
            appendMatrix(root);
         }
         appendMatrix(camera);
         calculateInverseMatrix();
         var nc:Number = camera.nearClipping;
         var fc:Number = camera.farClipping;
         camera.nearClipping = -Number.MAX_VALUE;
         camera.farClipping = Number.MAX_VALUE;
         culling = 0;
         var face:Face = this.calculateFace(camera);
         camera.nearClipping = nc;
         camera.farClipping = fc;
         for(var wrapper:Wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
         {
            vertex = wrapper.vertex;
            vertex.x = ima * vertex.cameraX + imb * vertex.cameraY + imc * vertex.cameraZ + imd;
            vertex.y = ime * vertex.cameraX + imf * vertex.cameraY + img * vertex.cameraZ + imh;
            vertex.z = imi * vertex.cameraX + imj * vertex.cameraY + imk * vertex.cameraZ + iml;
         }
         var w:Wrapper = face.wrapper;
         var a:Vertex = w.vertex;
         w = w.next;
         var b:Vertex = w.vertex;
         w = w.next;
         var c:Vertex = w.vertex;
         w = w.next;
         var d:Vertex = w.vertex;
         a.u = this.topLeftU;
         a.v = this.topLeftV;
         b.u = this.topLeftU;
         b.v = this.bottomRightV;
         c.u = this.bottomRightU;
         c.v = this.bottomRightV;
         d.u = this.bottomRightU;
         d.v = this.topLeftV;
         var abx:Number = b.x - a.x;
         var aby:Number = b.y - a.y;
         var abz:Number = b.z - a.z;
         var acx:Number = c.x - a.x;
         var acy:Number = c.y - a.y;
         var acz:Number = c.z - a.z;
         face.normalX = acz * aby - acy * abz;
         face.normalY = acx * abz - acz * abx;
         face.normalZ = acy * abx - acx * aby;
         var len:Number = 1 / Math.sqrt(face.normalX * face.normalX + face.normalY * face.normalY + face.normalZ * face.normalZ);
         face.normalX *= len;
         face.normalY *= len;
         face.normalZ *= len;
         face.offset = a.x * face.normalX + a.y * face.normalY + a.z * face.normalZ;
         var dot:Number = direction.x * face.normalX + direction.y * face.normalY + direction.z * face.normalZ;
         if(dot < 0)
         {
            offset = origin.x * face.normalX + origin.y * face.normalY + origin.z * face.normalZ - face.offset;
            if(offset > 0)
            {
               time = -offset / dot;
               cx = origin.x + direction.x * time;
               cy = origin.y + direction.y * time;
               cz = origin.z + direction.z * time;
               for(wrapper = face.wrapper; wrapper != null; )
               {
                  a = wrapper.vertex;
                  b = wrapper.next != null ? wrapper.next.vertex : face.wrapper.vertex;
                  abx = b.x - a.x;
                  aby = b.y - a.y;
                  abz = b.z - a.z;
                  acx = cx - a.x;
                  acy = cy - a.y;
                  acz = cz - a.z;
                  if((acz * aby - acy * abz) * face.normalX + (acx * abz - acz * abx) * face.normalY + (acy * abx - acx * aby) * face.normalZ < 0)
                  {
                     break;
                  }
                  wrapper = wrapper.next;
               }
               if(wrapper == null)
               {
                  point = new Vector3D(cx,cy,cz);
                  res = new RayIntersectionData();
                  res.object = this;
                  res.face = null;
                  res.point = point;
                  res.uv = face.getUV(point);
                  res.time = time;
               }
            }
         }
         camera.deferredDestroy();
         return res;
      }
      
      override public function clone() : Object3D
      {
         var res:Sprite3D = new Sprite3D(this.width,this.height);
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         super.clonePropertiesFrom(source);
         var src:Sprite3D = source as Sprite3D;
         this.width = src.width;
         this.height = src.height;
         this.autoSize = src.autoSize;
         this.material = src.material;
         this.clipping = src.clipping;
         this.sorting = src.sorting;
         this.originX = src.originX;
         this.originY = src.originY;
         this.topLeftU = src.topLeftU;
         this.topLeftV = src.topLeftV;
         this.bottomRightU = src.bottomRightU;
         this.bottomRightV = src.bottomRightV;
         this.rotation = src.rotation;
         this.perspectiveScale = src.perspectiveScale;
      }
      
      override alternativa3d function draw(camera:Camera3D) : void
      {
         var debug:int = 0;
         var textureMaterial:TextureMaterial = null;
         if(this.material == null)
         {
            return;
         }
         var face:Face = this.calculateFace(camera);
         if(face != null)
         {
            if(useLight && !camera.view.constrained && camera.deferredLighting && camera.deferredLightingStrength > 0)
            {
               this.calculateLight(camera);
            }
            if(this.material.name == "title" && this.material is TextureMaterial)
            {
               textureMaterial = this.material as TextureMaterial;
               if(textureMaterial._texture != null)
               {
                  camera.device.§?^§(textureMaterial.textureResource);
               }
            }
            if(camera.debug && (debug = camera.checkInDebug(this)) > 0)
            {
               if(Boolean(debug & Debug.EDGES))
               {
                  Debug.drawEdges(camera,face,16777215);
               }
               if(Boolean(debug & Debug.BOUNDS))
               {
                  Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
               }
            }
            camera.addTransparent(face,this);
         }
      }
      
      override alternativa3d function getVG(camera:Camera3D) : VG
      {
         var textureMaterial:TextureMaterial = null;
         if(this.material == null)
         {
            return null;
         }
         var face:Face = this.calculateFace(camera);
         if(face != null)
         {
            if(useLight && !camera.view.constrained && camera.deferredLighting && camera.deferredLightingStrength > 0)
            {
               this.calculateLight(camera);
            }
            if(this.material.name == "title" && this.material is TextureMaterial)
            {
               textureMaterial = this.material as TextureMaterial;
               if(textureMaterial._texture != null)
               {
                  camera.device.§?^§(textureMaterial.textureResource);
               }
            }
            face.normalX = 0;
            face.normalY = 0;
            face.normalZ = -1;
            face.offset = -ml;
            return VG.create(this,face,this.sorting,camera.debug ? camera.checkInDebug(this) : 0,true);
         }
         return null;
      }
      
      private function calculateLight(camera:Camera3D) : void
      {
         var i:int = 0;
         var lx:Number = NaN;
         var ly:Number = NaN;
         var lz:Number = NaN;
         var r:Number = NaN;
         var atten:Number = NaN;
         var atten2:Number = NaN;
         var dot:Number = NaN;
         var str:Number = NaN;
         var omni:OmniLight = null;
         var spot:SpotLight = null;
         var dd:Number = NaN;
         var falloff:Number = NaN;
         var tube:TubeLight = null;
         var halfLen:Number = NaN;
         var halfLenF:Number = NaN;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         var proj:Number = NaN;
         var cvx:Number = camera.viewSizeX / camera.focalLength;
         var cvy:Number = camera.viewSizeY / camera.focalLength;
         if(!camera.view.constrained && (camera.directionalLight != null && camera.directionalLightStrength > 0 || camera.shadowMap != null && camera.shadowMapStrength > 0))
         {
            this.lightConst[0] = 0;
            this.lightConst[1] = 0;
            this.lightConst[2] = 0;
         }
         else
         {
            this.lightConst[0] = 1;
            this.lightConst[1] = 1;
            this.lightConst[2] = 1;
         }
         var sx:Number = md * cvx;
         var sy:Number = mh * cvy;
         var sz:Number = ml;
         var ll:Number = Math.sqrt(sx * sx + sy * sy + sz * sz);
         var cx:Number = -sx / ll;
         var cy:Number = -sy / ll;
         var cz:Number = -sz / ll;
         for(i = 0; i < camera.omniesCount; i++)
         {
            omni = camera.omnies[i];
            lx = omni.cmd * cvx;
            ly = omni.cmh * cvy;
            lz = omni.cml;
            r = omni.attenuationEnd;
            if(lx - r < sx && lx + r > sx && ly - r < sy && ly + r > sy && lz - r < sz && lz + r > sz)
            {
               lx -= sx;
               ly -= sy;
               lz -= sz;
               ll = Math.sqrt(lx * lx + ly * ly + lz * lz);
               if(ll > 0 && ll < r)
               {
                  lx /= ll;
                  ly /= ll;
                  lz /= ll;
                  atten = (r - ll) / (omni.attenuationEnd - omni.attenuationBegin);
                  if(atten > 1)
                  {
                     atten = 1;
                  }
                  if(atten < 0)
                  {
                     atten = 0;
                  }
                  atten *= atten;
                  dot = lx * cx + ly * cy + lz * cz;
                  dot *= 0.5;
                  dot += 0.5;
                  str = atten * dot * omni.intensity * 2 * camera.deferredLightingStrength;
                  this.lightConst[0] += str * (omni.color >> 16 & 0xFF) / 255;
                  this.lightConst[1] += str * (omni.color >> 8 & 0xFF) / 255;
                  this.lightConst[2] += str * (omni.color & 0xFF) / 255;
               }
            }
         }
         for(i = 0; i < camera.spotsCount; i++)
         {
            spot = camera.spots[i];
            lx = spot.cmd * cvx;
            ly = spot.cmh * cvy;
            lz = spot.cml;
            r = spot.attenuationEnd;
            if(lx - r < sx && lx + r > sx && ly - r < sy && ly + r > sy && lz - r < sz && lz + r > sz)
            {
               lx -= sx;
               ly -= sy;
               lz -= sz;
               ll = Math.sqrt(lx * lx + ly * ly + lz * lz);
               if(ll > 0 && ll < r)
               {
                  lx /= ll;
                  ly /= ll;
                  lz /= ll;
                  dd = -lx * spot.cmc * cvx - ly * spot.cmg * cvy - lz * spot.cmk;
                  falloff = Math.cos(spot.falloff * 0.5);
                  if(dd > falloff)
                  {
                     dot = lx * cx + ly * cy + lz * cz;
                     dot *= 0.5;
                     dot += 0.5;
                     atten = (r - ll) / (spot.attenuationEnd - spot.attenuationBegin);
                     if(atten > 1)
                     {
                        atten = 1;
                     }
                     if(atten < 0)
                     {
                        atten = 0;
                     }
                     atten *= atten;
                     atten2 = (dd - falloff) / (Math.cos(spot.hotspot * 0.5) - falloff);
                     if(atten2 > 1)
                     {
                        atten2 = 1;
                     }
                     if(atten2 < 0)
                     {
                        atten2 = 0;
                     }
                     atten2 *= atten2;
                     str = atten * atten2 * dot * spot.intensity * 2 * camera.deferredLightingStrength;
                     this.lightConst[0] += str * (spot.color >> 16 & 0xFF) / 255;
                     this.lightConst[1] += str * (spot.color >> 8 & 0xFF) / 255;
                     this.lightConst[2] += str * (spot.color & 0xFF) / 255;
                  }
               }
            }
         }
         for(i = 0; i < camera.tubesCount; i++)
         {
            tube = camera.tubes[i];
            halfLen = tube.length * 0.5;
            halfLenF = halfLen + tube.falloff;
            nx = tube.cmc * cvx;
            ny = tube.cmg * cvx;
            nz = tube.cmk;
            lx = tube.cmd * cvx + nx * halfLen;
            ly = tube.cmh * cvy + ny * halfLen;
            lz = tube.cml + nz * halfLen;
            proj = nx * (sx - lx) + ny * (sy - ly) + nz * (sz - lz);
            if(proj > -halfLenF && proj < halfLenF)
            {
               lx += nx * proj - sx;
               ly += ny * proj - sy;
               lz += nz * proj - sz;
               ll = Math.sqrt(lx * lx + ly * ly + lz * lz);
               if(ll > 0 && ll < tube.attenuationEnd)
               {
                  lx /= ll;
                  ly /= ll;
                  lz /= ll;
                  dot = lx * cx + ly * cy + lz * cz;
                  dot *= 0.5;
                  dot += 0.5;
                  atten = (tube.attenuationEnd - ll) / (tube.attenuationEnd - tube.attenuationBegin);
                  if(atten > 1)
                  {
                     atten = 1;
                  }
                  if(atten < 0)
                  {
                     atten = 0;
                  }
                  atten *= atten;
                  if(proj < 0)
                  {
                     proj = -proj;
                  }
                  atten2 = (halfLenF - proj) / (halfLenF - halfLen);
                  if(atten2 > 1)
                  {
                     atten2 = 1;
                  }
                  if(atten2 < 0)
                  {
                     atten2 = 0;
                  }
                  atten2 *= atten2;
                  str = atten * atten2 * dot * tube.intensity * 2 * camera.deferredLightingStrength;
                  this.lightConst[0] += str * (tube.color >> 16 & 0xFF) / 255;
                  this.lightConst[1] += str * (tube.color >> 8 & 0xFF) / 255;
                  this.lightConst[2] += str * (tube.color & 0xFF) / 255;
               }
            }
         }
      }
      
      private function calculateFace(camera:Camera3D) : Face
      {
         var ax:Number = NaN;
         var ay:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var first:Vertex = null;
         var last:Vertex = null;
         var scale:Number = NaN;
         var texture:BitmapData = null;
         var cameraWidth:Number = NaN;
         var cameraHeight:Number = NaN;
         var sin:Number = NaN;
         var cos:Number = NaN;
         var cameraWidthX:Number = NaN;
         var cameraWidthY:Number = NaN;
         var cameraHeightX:Number = NaN;
         var cameraHeightY:Number = NaN;
         culling &= 60;
         var z:Number = ml;
         if(z <= camera.nearClipping || z >= camera.farClipping)
         {
            return null;
         }
         var ww:Number = this.width;
         var hh:Number = this.height;
         var deltaU:Number = this.bottomRightU - this.topLeftU;
         var deltaV:Number = this.bottomRightV - this.topLeftV;
         if(this.autoSize && this.material is TextureMaterial)
         {
            texture = (this.material as TextureMaterial)._texture;
            if(texture != null)
            {
               ww = texture.width * deltaU;
               hh = texture.height * deltaV;
            }
         }
         var projectionX:Number = camera.viewSizeX / z;
         var projectionY:Number = camera.viewSizeY / z;
         var projectionZ:Number = camera.focalLength / z;
         var perspectiveScaleX:Number = camera.focalLength / camera.viewSizeX;
         var perspectiveScaleY:Number = camera.focalLength / camera.viewSizeY;
         ax = ma / perspectiveScaleX;
         ay = me / perspectiveScaleY;
         scale = Math.sqrt(ax * ax + ay * ay + mi * mi);
         ax = mb / perspectiveScaleX;
         ay = mf / perspectiveScaleY;
         scale += Math.sqrt(ax * ax + ay * ay + mj * mj);
         ax = mc / perspectiveScaleX;
         ay = mg / perspectiveScaleY;
         scale += Math.sqrt(ax * ax + ay * ay + mk * mk);
         scale /= 3;
         if(!this.perspectiveScale)
         {
            scale /= projectionZ;
         }
         if(this.rotation == 0)
         {
            cameraWidth = scale * ww * perspectiveScaleX;
            cameraHeight = scale * hh * perspectiveScaleY;
            ax = md - this.originX * cameraWidth;
            ay = mh - this.originY * cameraHeight;
            cx = ax + cameraWidth;
            cy = ay + cameraHeight;
            if(culling > 0 && (ax > z || ay > z || cx < -z || cy < -z))
            {
               return null;
            }
            first = Vertex.createList(4);
            last = first;
            last.cameraX = ax;
            last.cameraY = ay;
            last.cameraZ = z;
            last.u = this.topLeftU;
            last.v = this.topLeftV;
            last = last.next;
            last.cameraX = ax;
            last.cameraY = cy;
            last.cameraZ = z;
            last.u = this.topLeftU;
            last.v = this.bottomRightV;
            last = last.next;
            last.cameraX = cx;
            last.cameraY = cy;
            last.cameraZ = z;
            last.u = this.bottomRightU;
            last.v = this.bottomRightV;
            last = last.next;
            last.cameraX = cx;
            last.cameraY = ay;
            last.cameraZ = z;
            last.u = this.bottomRightU;
            last.v = this.topLeftV;
         }
         else
         {
            sin = -Math.sin(this.rotation) * scale;
            cos = Math.cos(this.rotation) * scale;
            cameraWidthX = cos * ww * perspectiveScaleX;
            cameraWidthY = -sin * ww * perspectiveScaleY;
            cameraHeightX = sin * hh * perspectiveScaleX;
            cameraHeightY = cos * hh * perspectiveScaleY;
            ax = md - this.originX * cameraWidthX - this.originY * cameraHeightX;
            ay = mh - this.originX * cameraWidthY - this.originY * cameraHeightY;
            bx = ax + cameraHeightX;
            by = ay + cameraHeightY;
            cx = ax + cameraWidthX + cameraHeightX;
            cy = ay + cameraWidthY + cameraHeightY;
            dx = ax + cameraWidthX;
            dy = ay + cameraWidthY;
            if(culling > 0)
            {
               if(this.clipping == 1)
               {
                  if(Boolean(culling & 4 && z <= -ax && z <= -bx) && Boolean(z <= -cx) && z <= -dx)
                  {
                     return null;
                  }
                  if(Boolean(culling & 8 && z <= ax && z <= bx) && Boolean(z <= cx) && z <= dx)
                  {
                     return null;
                  }
                  if(Boolean(culling & 0x10 && z <= -ay && z <= -by) && Boolean(z <= -cy) && z <= -dy)
                  {
                     return null;
                  }
                  if(Boolean(culling & 0x20 && z <= ay && z <= by) && Boolean(z <= cy) && z <= dy)
                  {
                     return null;
                  }
                  first = Vertex.createList(4);
                  last = first;
                  last.cameraX = ax;
                  last.cameraY = ay;
                  last.cameraZ = z;
                  last.u = this.topLeftU;
                  last.v = this.topLeftV;
                  last = last.next;
                  last.cameraX = ax + cameraHeightX;
                  last.cameraY = ay + cameraHeightY;
                  last.cameraZ = z;
                  last.u = this.topLeftU;
                  last.v = this.bottomRightV;
                  last = last.next;
                  last.cameraX = ax + cameraWidthX + cameraHeightX;
                  last.cameraY = ay + cameraWidthY + cameraHeightY;
                  last.cameraZ = z;
                  last.u = this.bottomRightU;
                  last.v = this.bottomRightV;
                  last = last.next;
                  last.cameraX = ax + cameraWidthX;
                  last.cameraY = ay + cameraWidthY;
                  last.cameraZ = z;
                  last.u = this.bottomRightU;
                  last.v = this.topLeftV;
               }
               else
               {
                  if(Boolean(culling & 4))
                  {
                     if(z <= -ax && z <= -bx && z <= -cx && z <= -dx)
                     {
                        return null;
                     }
                     if(z > -ax && z > -bx && z > -cx && z > -dx)
                     {
                        culling &= 59;
                     }
                  }
                  if(Boolean(culling & 8))
                  {
                     if(z <= ax && z <= bx && z <= cx && z <= dx)
                     {
                        return null;
                     }
                     if(z > ax && z > bx && z > cx && z > dx)
                     {
                        culling &= 55;
                     }
                  }
                  if(Boolean(culling & 0x10))
                  {
                     if(z <= -ay && z <= -by && z <= -cy && z <= -dy)
                     {
                        return null;
                     }
                     if(z > -ay && z > -by && z > -cy && z > -dy)
                     {
                        culling &= 47;
                     }
                  }
                  if(Boolean(culling & 0x20))
                  {
                     if(z <= ay && z <= by && z <= cy && z <= dy)
                     {
                        return null;
                     }
                     if(z > ay && z > by && z > cy && z > dy)
                     {
                        culling &= 31;
                     }
                  }
                  first = Vertex.createList(4);
                  last = first;
                  last.cameraX = ax;
                  last.cameraY = ay;
                  last.cameraZ = z;
                  last.u = this.topLeftU;
                  last.v = this.topLeftV;
                  last = last.next;
                  last.cameraX = ax + cameraHeightX;
                  last.cameraY = ay + cameraHeightY;
                  last.cameraZ = z;
                  last.u = this.topLeftU;
                  last.v = this.bottomRightV;
                  last = last.next;
                  last.cameraX = ax + cameraWidthX + cameraHeightX;
                  last.cameraY = ay + cameraWidthY + cameraHeightY;
                  last.cameraZ = z;
                  last.u = this.bottomRightU;
                  last.v = this.bottomRightV;
                  last = last.next;
                  last.cameraX = ax + cameraWidthX;
                  last.cameraY = ay + cameraWidthY;
                  last.cameraZ = z;
                  last.u = this.bottomRightU;
                  last.v = this.topLeftV;
               }
            }
            else
            {
               first = Vertex.createList(4);
               last = first;
               last.cameraX = ax;
               last.cameraY = ay;
               last.cameraZ = z;
               last.u = this.topLeftU;
               last.v = this.topLeftV;
               last = last.next;
               last.cameraX = ax + cameraHeightX;
               last.cameraY = ay + cameraHeightY;
               last.cameraZ = z;
               last.u = this.topLeftU;
               last.v = this.bottomRightV;
               last = last.next;
               last.cameraX = ax + cameraWidthX + cameraHeightX;
               last.cameraY = ay + cameraWidthY + cameraHeightY;
               last.cameraZ = z;
               last.u = this.bottomRightU;
               last.v = this.bottomRightV;
               last = last.next;
               last.cameraX = ax + cameraWidthX;
               last.cameraY = ay + cameraWidthY;
               last.cameraZ = z;
               last.u = this.bottomRightU;
               last.v = this.topLeftV;
            }
         }
         camera.lastVertex.next = first;
         camera.lastVertex = last;
         var face:Face = Face.create();
         face.material = this.material;
         camera.lastFace.next = face;
         camera.lastFace = face;
         var wrapper:Wrapper = Wrapper.create();
         face.wrapper = wrapper;
         wrapper.vertex = first;
         for(first = first.next; first != null; first = first.next)
         {
            wrapper.next = wrapper.create();
            wrapper = wrapper.next;
            wrapper.vertex = first;
         }
         return face;
      }
      
      override alternativa3d function updateBounds(bounds:Object3D, transformation:Object3D = null) : void
      {
         var texture:BitmapData = null;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var size:Number = NaN;
         var ww:Number = this.width;
         var hh:Number = this.height;
         if(this.autoSize && this.material is TextureMaterial)
         {
            texture = (this.material as TextureMaterial)._texture;
            if(texture != null)
            {
               ww = texture.width * (this.bottomRightU - this.topLeftU);
               hh = texture.height * (this.bottomRightV - this.topLeftV);
            }
         }
         var w:Number = (this.originX >= 0.5 ? this.originX : 1 - this.originX) * ww;
         var h:Number = (this.originY >= 0.5 ? this.originY : 1 - this.originY) * hh;
         var radius:Number = Math.sqrt(w * w + h * h);
         var cx:Number = 0;
         var cy:Number = 0;
         var cz:Number = 0;
         if(transformation != null)
         {
            ax = transformation.ma;
            ay = transformation.me;
            az = transformation.mi;
            size = Math.sqrt(ax * ax + ay * ay + az * az);
            ax = transformation.mb;
            ay = transformation.mf;
            az = transformation.mj;
            size += Math.sqrt(ax * ax + ay * ay + az * az);
            ax = transformation.mc;
            ay = transformation.mg;
            az = transformation.mk;
            size += Math.sqrt(ax * ax + ay * ay + az * az);
            radius *= size / 3;
            cx = transformation.md;
            cy = transformation.mh;
            cz = transformation.ml;
         }
         if(cx - radius < bounds.boundMinX)
         {
            bounds.boundMinX = cx - radius;
         }
         if(cx + radius > bounds.boundMaxX)
         {
            bounds.boundMaxX = cx + radius;
         }
         if(cy - radius < bounds.boundMinY)
         {
            bounds.boundMinY = cy - radius;
         }
         if(cy + radius > bounds.boundMaxY)
         {
            bounds.boundMaxY = cy + radius;
         }
         if(cz - radius < bounds.boundMinZ)
         {
            bounds.boundMinZ = cz - radius;
         }
         if(cz + radius > bounds.boundMaxZ)
         {
            bounds.boundMaxZ = cz + radius;
         }
      }
   }
}

