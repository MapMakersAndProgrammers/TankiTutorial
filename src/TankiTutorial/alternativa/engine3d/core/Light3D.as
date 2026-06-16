package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;
   
   public class Light3D extends Object3D
   {
      
      public var color:uint;
      
      public var intensity:Number = 1;
      
      alternativa3d var localWeight:Number;
      
      alternativa3d var localRed:Number;
      
      alternativa3d var localGreen:Number;
      
      alternativa3d var localBlue:Number;
      
      alternativa3d var cma:Number;
      
      alternativa3d var cmb:Number;
      
      alternativa3d var cmc:Number;
      
      alternativa3d var cmd:Number;
      
      alternativa3d var cme:Number;
      
      alternativa3d var cmf:Number;
      
      alternativa3d var cmg:Number;
      
      alternativa3d var cmh:Number;
      
      alternativa3d var cmi:Number;
      
      alternativa3d var cmj:Number;
      
      alternativa3d var cmk:Number;
      
      alternativa3d var cml:Number;
      
      alternativa3d var oma:Number;
      
      alternativa3d var omb:Number;
      
      alternativa3d var omc:Number;
      
      alternativa3d var omd:Number;
      
      alternativa3d var ome:Number;
      
      alternativa3d var omf:Number;
      
      alternativa3d var omg:Number;
      
      alternativa3d var omh:Number;
      
      alternativa3d var omi:Number;
      
      alternativa3d var omj:Number;
      
      alternativa3d var omk:Number;
      
      alternativa3d var oml:Number;
      
      alternativa3d var nextLight:Light3D;
      
      public function Light3D()
      {
         super();
      }
      
      override public function clone() : Object3D
      {
         var res:Light3D = new Light3D();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         super.clonePropertiesFrom(source);
         var src:Light3D = source as Light3D;
         this.color = src.color;
         this.intensity = src.intensity;
      }
      
      alternativa3d function calculateCameraMatrix(camera:Camera3D) : void
      {
         composeMatrix();
         for(var root:Object3D = this; root._parent != null; )
         {
            root = root._parent;
            root.composeMatrix();
            appendMatrix(root);
         }
         appendMatrix(camera);
         this.cma = ma;
         this.cmb = mb;
         this.cmc = mc;
         this.cmd = md;
         this.cme = me;
         this.cmf = mf;
         this.cmg = mg;
         this.cmh = mh;
         this.cmi = mi;
         this.cmj = mj;
         this.cmk = mk;
         this.cml = ml;
      }
      
      alternativa3d function calculateObjectMatrix(object:Object3D) : void
      {
         this.oma = object.ima * this.cma + object.imb * this.cme + object.imc * this.cmi;
         this.omb = object.ima * this.cmb + object.imb * this.cmf + object.imc * this.cmj;
         this.omc = object.ima * this.cmc + object.imb * this.cmg + object.imc * this.cmk;
         this.omd = object.ima * this.cmd + object.imb * this.cmh + object.imc * this.cml + object.imd;
         this.ome = object.ime * this.cma + object.imf * this.cme + object.img * this.cmi;
         this.omf = object.ime * this.cmb + object.imf * this.cmf + object.img * this.cmj;
         this.omg = object.ime * this.cmc + object.imf * this.cmg + object.img * this.cmk;
         this.omh = object.ime * this.cmd + object.imf * this.cmh + object.img * this.cml + object.imh;
         this.omi = object.imi * this.cma + object.imj * this.cme + object.imk * this.cmi;
         this.omj = object.imi * this.cmb + object.imj * this.cmf + object.imk * this.cmj;
         this.omk = object.imi * this.cmc + object.imj * this.cmg + object.imk * this.cmk;
         this.oml = object.imi * this.cmd + object.imj * this.cmh + object.imk * this.cml + object.iml;
      }
      
      override alternativa3d function setParent(value:Object3DContainer) : void
      {
         var root:Object3DContainer = null;
         var prev:Light3D = null;
         var current:Light3D = null;
         if(value == null)
         {
            for(root = _parent; root._parent != null; )
            {
               root = root._parent;
            }
            for(current = root.lightList; current != null; )
            {
               if(current == this)
               {
                  if(prev != null)
                  {
                     prev.nextLight = this.nextLight;
                  }
                  else
                  {
                     root.lightList = this.nextLight;
                  }
                  this.nextLight = null;
                  break;
               }
               prev = current;
               current = current.nextLight;
            }
         }
         else
         {
            for(root = value; root._parent != null; )
            {
               root = root._parent;
            }
            this.nextLight = root.lightList;
            root.lightList = this;
         }
         _parent = value;
      }
      
      alternativa3d function drawDebug(camera:Camera3D) : void
      {
      }
      
      override alternativa3d function updateBounds(bounds:Object3D, transformation:Object3D = null) : void
      {
         bounds.boundMinX = -1e+22;
         bounds.boundMinY = -1e+22;
         bounds.boundMinZ = -1e+22;
         bounds.boundMaxX = 1e+22;
         bounds.boundMaxY = 1e+22;
         bounds.boundMaxZ = 1e+22;
      }
      
      override alternativa3d function cullingInCamera(camera:Camera3D, culling:int) : int
      {
         return -1;
      }
      
      alternativa3d function checkFrustumCulling(camera:Camera3D) : Boolean
      {
         var vertex:Vertex = boundVertexList;
         vertex.x = boundMinX;
         vertex.y = boundMinY;
         vertex.z = boundMinZ;
         vertex = vertex.next;
         vertex.x = boundMaxX;
         vertex.y = boundMinY;
         vertex.z = boundMinZ;
         vertex = vertex.next;
         vertex.x = boundMinX;
         vertex.y = boundMaxY;
         vertex.z = boundMinZ;
         vertex = vertex.next;
         vertex.x = boundMaxX;
         vertex.y = boundMaxY;
         vertex.z = boundMinZ;
         vertex = vertex.next;
         vertex.x = boundMinX;
         vertex.y = boundMinY;
         vertex.z = boundMaxZ;
         vertex = vertex.next;
         vertex.x = boundMaxX;
         vertex.y = boundMinY;
         vertex.z = boundMaxZ;
         vertex = vertex.next;
         vertex.x = boundMinX;
         vertex.y = boundMaxY;
         vertex.z = boundMaxZ;
         vertex = vertex.next;
         vertex.x = boundMaxX;
         vertex.y = boundMaxY;
         vertex.z = boundMaxZ;
         for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
         {
            vertex.cameraX = ma * vertex.x + mb * vertex.y + mc * vertex.z + md;
            vertex.cameraY = me * vertex.x + mf * vertex.y + mg * vertex.z + mh;
            vertex.cameraZ = mi * vertex.x + mj * vertex.y + mk * vertex.z + ml;
         }
         for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
         {
            if(vertex.cameraZ > camera.nearClipping)
            {
               break;
            }
         }
         if(vertex == null)
         {
            return false;
         }
         for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
         {
            if(vertex.cameraZ < camera.farClipping)
            {
               break;
            }
         }
         if(vertex == null)
         {
            return false;
         }
         for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
         {
            if(-vertex.cameraX < vertex.cameraZ)
            {
               break;
            }
         }
         if(vertex == null)
         {
            return false;
         }
         for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
         {
            if(vertex.cameraX < vertex.cameraZ)
            {
               break;
            }
         }
         if(vertex == null)
         {
            return false;
         }
         for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
         {
            if(-vertex.cameraY < vertex.cameraZ)
            {
               break;
            }
         }
         if(vertex == null)
         {
            return false;
         }
         for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
         {
            if(vertex.cameraY < vertex.cameraZ)
            {
               break;
            }
         }
         if(vertex == null)
         {
            return false;
         }
         return true;
      }
      
      alternativa3d function checkBoundsIntersection(object:Object3D) : Boolean
      {
         var sum:Number = NaN;
         var pro:Number = NaN;
         var w:Number = (boundMaxX - boundMinX) * 0.5;
         var l:Number = (boundMaxY - boundMinY) * 0.5;
         var h:Number = (boundMaxZ - boundMinZ) * 0.5;
         var ax:Number = this.oma * w;
         var ay:Number = this.ome * w;
         var az:Number = this.omi * w;
         var bx:Number = this.omb * l;
         var by:Number = this.omf * l;
         var bz:Number = this.omj * l;
         var cx:Number = this.omc * h;
         var cy:Number = this.omg * h;
         var cz:Number = this.omk * h;
         var hw:Number = (object.boundMaxX - object.boundMinX) * 0.5;
         var hl:Number = (object.boundMaxY - object.boundMinY) * 0.5;
         var hh:Number = (object.boundMaxZ - object.boundMinZ) * 0.5;
         var dx:Number = this.oma * (boundMinX + w) + this.omb * (boundMinY + l) + this.omc * (boundMinZ + h) + this.omd - object.boundMinX - hw;
         var dy:Number = this.ome * (boundMinX + w) + this.omf * (boundMinY + l) + this.omg * (boundMinZ + h) + this.omh - object.boundMinY - hl;
         var dz:Number = this.omi * (boundMinX + w) + this.omj * (boundMinY + l) + this.omk * (boundMinZ + h) + this.oml - object.boundMinZ - hh;
         sum = 0;
         pro = ax >= 0 ? ax : -ax;
         sum += pro;
         pro = bx >= 0 ? bx : -bx;
         sum += pro;
         pro = cx >= 0 ? cx : -cx;
         sum += pro;
         sum += hw;
         pro = dx >= 0 ? dx : -dx;
         sum -= pro;
         if(sum <= 0)
         {
            return false;
         }
         sum = 0;
         pro = ay >= 0 ? ay : -ay;
         sum += pro;
         pro = by >= 0 ? by : -by;
         sum += pro;
         pro = cy >= 0 ? cy : -cy;
         sum += pro;
         sum += hl;
         pro = dy >= 0 ? dy : -dy;
         sum -= pro;
         if(sum <= 0)
         {
            return false;
         }
         sum = 0;
         pro = az >= 0 ? az : -az;
         sum += pro;
         pro = bz >= 0 ? bz : -bz;
         sum += pro;
         pro = cz >= 0 ? cz : -cz;
         sum += pro;
         sum += hl;
         pro = dz >= 0 ? dz : -dz;
         sum -= pro;
         if(sum <= 0)
         {
            return false;
         }
         sum = 0;
         pro = this.oma * ax + this.ome * ay + this.omi * az;
         pro = pro >= 0 ? pro : -pro;
         sum += pro;
         pro = this.oma * bx + this.ome * by + this.omi * bz;
         pro = pro >= 0 ? pro : -pro;
         sum += pro;
         pro = this.oma * cx + this.ome * cy + this.omi * cz;
         pro = pro >= 0 ? pro : -pro;
         sum += pro;
         pro = this.oma >= 0 ? this.oma * hw : -this.oma * hw;
         sum += pro;
         pro = this.ome >= 0 ? this.ome * hl : -this.ome * hl;
         sum += pro;
         pro = this.omi >= 0 ? this.omi * hh : -this.omi * hh;
         sum += pro;
         pro = this.oma * dx + this.ome * dy + this.omi * dz;
         pro = pro >= 0 ? pro : -pro;
         sum -= pro;
         if(sum <= 0)
         {
            return false;
         }
         sum = 0;
         pro = this.omb * ax + this.omf * ay + this.omj * az;
         pro = pro >= 0 ? pro : -pro;
         sum += pro;
         pro = this.omb * bx + this.omf * by + this.omj * bz;
         pro = pro >= 0 ? pro : -pro;
         sum += pro;
         pro = this.omb * cx + this.omf * cy + this.omj * cz;
         pro = pro >= 0 ? pro : -pro;
         sum += pro;
         pro = this.omb >= 0 ? this.omb * hw : -this.omb * hw;
         sum += pro;
         pro = this.omf >= 0 ? this.omf * hl : -this.omf * hl;
         sum += pro;
         pro = this.omj >= 0 ? this.omj * hh : -this.omj * hh;
         sum += pro;
         pro = this.omb * dx + this.omf * dy + this.omj * dz;
         pro = pro >= 0 ? pro : -pro;
         sum -= pro;
         if(sum <= 0)
         {
            return false;
         }
         sum = 0;
         pro = this.omc * ax + this.omg * ay + this.omk * az;
         pro = pro >= 0 ? pro : -pro;
         sum += pro;
         pro = this.omc * bx + this.omg * by + this.omk * bz;
         pro = pro >= 0 ? pro : -pro;
         sum += pro;
         pro = this.omc * cx + this.omg * cy + this.omk * cz;
         pro = pro >= 0 ? pro : -pro;
         sum += pro;
         pro = this.omc >= 0 ? this.omc * hw : -this.omc * hw;
         sum += pro;
         pro = this.omg >= 0 ? this.omg * hl : -this.omg * hl;
         sum += pro;
         pro = this.omk >= 0 ? this.omk * hh : -this.omk * hh;
         sum += pro;
         pro = this.omc * dx + this.omg * dy + this.omk * dz;
         pro = pro >= 0 ? pro : -pro;
         sum -= pro;
         if(sum <= 0)
         {
            return false;
         }
         return true;
      }
   }
}

