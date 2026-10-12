package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.materials.Material;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   use namespace alternativa3d;
   
   public class Face
   {
      
      alternativa3d static var collector:Face;
      
      public var material:Material;
      
      public var smoothingGroups:uint = 0;
      
      alternativa3d var normalX:Number;
      
      alternativa3d var normalY:Number;
      
      alternativa3d var normalZ:Number;
      
      alternativa3d var offset:Number;
      
      alternativa3d var wrapper:Wrapper;
      
      alternativa3d var next:Face;
      
      alternativa3d var processNext:Face;
      
      alternativa3d var processNegative:Face;
      
      alternativa3d var processPositive:Face;
      
      alternativa3d var distance:Number;
      
      alternativa3d var geometry:VG;
      
      public var id:Object;
      
      public function Face()
      {
         super();
      }
      
      alternativa3d static function create() : Face
      {
         var res:Face = null;
         if(collector != null)
         {
            res = collector;
            collector = res.next;
            res.next = null;
            return res;
         }
         return new Face();
      }
      
      alternativa3d function create() : Face
      {
         var res:Face = null;
         if(collector != null)
         {
            res = collector;
            collector = res.next;
            res.next = null;
            return res;
         }
         return new Face();
      }
      
      public function get normal() : Vector3D
      {
         var w:Wrapper = this.wrapper;
         var a:Vertex = w.vertex;
         w = w.next;
         var b:Vertex = w.vertex;
         w = w.next;
         var c:Vertex = w.vertex;
         var abx:Number = b.x - a.x;
         var aby:Number = b.y - a.y;
         var abz:Number = b.z - a.z;
         var acx:Number = c.x - a.x;
         var acy:Number = c.y - a.y;
         var acz:Number = c.z - a.z;
         var nx:Number = acz * aby - acy * abz;
         var ny:Number = acx * abz - acz * abx;
         var nz:Number = acy * abx - acx * aby;
         var len:Number = nx * nx + ny * ny + nz * nz;
         if(len > 0.001)
         {
            len = 1 / Math.sqrt(len);
            nx *= len;
            ny *= len;
            nz *= len;
         }
         return new Vector3D(nx,ny,nz,a.x * nx + a.y * ny + a.z * nz);
      }
      
      public function get vertices() : Vector.<Vertex>
      {
         var res:Vector.<Vertex> = new Vector.<Vertex>();
         var len:int = 0;
         for(var w:Wrapper = this.wrapper; w != null; w = w.next)
         {
            res[len] = w.vertex;
            len++;
         }
         return res;
      }
      
      public function getUV(point:Vector3D) : Point
      {
         var a:Vertex = this.wrapper.vertex;
         var b:Vertex = this.wrapper.next.vertex;
         var c:Vertex = this.wrapper.next.next.vertex;
         var abx:Number = b.x - a.x;
         var aby:Number = b.y - a.y;
         var abz:Number = b.z - a.z;
         var abu:Number = b.u - a.u;
         var abv:Number = b.v - a.v;
         var acx:Number = c.x - a.x;
         var acy:Number = c.y - a.y;
         var acz:Number = c.z - a.z;
         var acu:Number = c.u - a.u;
         var acv:Number = c.v - a.v;
         var det:Number = -this.normalX * acy * abz + acx * this.normalY * abz + this.normalX * aby * acz - abx * this.normalY * acz - acx * aby * this.normalZ + abx * acy * this.normalZ;
         var ima:Number = (-this.normalY * acz + acy * this.normalZ) / det;
         var imb:Number = (this.normalX * acz - acx * this.normalZ) / det;
         var imc:Number = (-this.normalX * acy + acx * this.normalY) / det;
         var imd:Number = (a.x * this.normalY * acz - this.normalX * a.y * acz - a.x * acy * this.normalZ + acx * a.y * this.normalZ + this.normalX * acy * a.z - acx * this.normalY * a.z) / det;
         var ime:Number = (this.normalY * abz - aby * this.normalZ) / det;
         var imf:Number = (-this.normalX * abz + abx * this.normalZ) / det;
         var img:Number = (this.normalX * aby - abx * this.normalY) / det;
         var imh:Number = (this.normalX * a.y * abz - a.x * this.normalY * abz + a.x * aby * this.normalZ - abx * a.y * this.normalZ - this.normalX * aby * a.z + abx * this.normalY * a.z) / det;
         var ma:Number = abu * ima + acu * ime;
         var mb:Number = abu * imb + acu * imf;
         var mc:Number = abu * imc + acu * img;
         var md:Number = abu * imd + acu * imh + a.u;
         var me:Number = abv * ima + acv * ime;
         var mf:Number = abv * imb + acv * imf;
         var mg:Number = abv * imc + acv * img;
         var mh:Number = abv * imd + acv * imh + a.v;
         return new Point(ma * point.x + mb * point.y + mc * point.z + md,me * point.x + mf * point.y + mg * point.z + mh);
      }
      
      public function toString() : String
      {
         return "[Face " + this.id + "]";
      }
      
      alternativa3d function calculateBestSequenceAndNormal() : void
      {
         var w:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
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
         var max:Number = NaN;
         var s:Wrapper = null;
         var sm:Wrapper = null;
         var sp:Wrapper = null;
         var wn:Wrapper = null;
         var wm:Wrapper = null;
         if(this.wrapper.next.next.next != null)
         {
            max = -1e+22;
            for(w = this.wrapper; w != null; w = w.next)
            {
               wn = w.next != null ? w.next : this.wrapper;
               wm = wn.next != null ? wn.next : this.wrapper;
               a = w.vertex;
               b = wn.vertex;
               c = wm.vertex;
               abx = b.x - a.x;
               aby = b.y - a.y;
               abz = b.z - a.z;
               acx = c.x - a.x;
               acy = c.y - a.y;
               acz = c.z - a.z;
               nx = acz * aby - acy * abz;
               ny = acx * abz - acz * abx;
               nz = acy * abx - acx * aby;
               nl = nx * nx + ny * ny + nz * nz;
               if(nl > max)
               {
                  max = nl;
                  s = w;
               }
            }
            if(s != this.wrapper)
            {
               for(sm = this.wrapper.next.next.next; sm.next != null; )
               {
                  sm = sm.next;
               }
               sp = this.wrapper;
               while(sp.next != s && sp.next != null)
               {
                  sp = sp.next;
               }
               sm.next = this.wrapper;
               sp.next = null;
               this.wrapper = s;
            }
         }
         w = this.wrapper;
         a = w.vertex;
         w = w.next;
         b = w.vertex;
         w = w.next;
         c = w.vertex;
         abx = b.x - a.x;
         aby = b.y - a.y;
         abz = b.z - a.z;
         acx = c.x - a.x;
         acy = c.y - a.y;
         acz = c.z - a.z;
         nx = acz * aby - acy * abz;
         ny = acx * abz - acz * abx;
         nz = acy * abx - acx * aby;
         nl = nx * nx + ny * ny + nz * nz;
         if(nl > 0)
         {
            nl = 1 / Math.sqrt(nl);
            nx *= nl;
            ny *= nl;
            nz *= nl;
            this.normalX = nx;
            this.normalY = ny;
            this.normalZ = nz;
         }
         this.offset = a.x * nx + a.y * ny + a.z * nz;
      }
   }
}

