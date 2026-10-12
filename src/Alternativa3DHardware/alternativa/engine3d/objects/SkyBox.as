package alternativa.engine3d.objects
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.VG;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   use namespace alternativa3d;
   
   public class SkyBox extends Mesh
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
      
      public static const BACK:String = "back";
      
      public static const FRONT:String = "front";
      
      public static const BOTTOM:String = "bottom";
      
      public static const TOP:String = "top";
      
      private var leftFace:Face;
      
      private var rightFace:Face;
      
      private var backFace:Face;
      
      private var frontFace:Face;
      
      private var bottomFace:Face;
      
      private var topFace:Face;
      
      public var autoSize:Boolean = true;
      
      alternativa3d var transform:Vector.<Number> = new Vector.<Number>(4);
      
      public function SkyBox(size:Number, left:Material = null, right:Material = null, back:Material = null, front:Material = null, bottom:Material = null, top:Material = null, uvPadding:Number = 0)
      {
         super();
         size *= 0.5;
         var a:Vertex = this.createVertex(-size,-size,size,uvPadding,uvPadding);
         var b:Vertex = this.createVertex(-size,-size,-size,uvPadding,1 - uvPadding);
         var c:Vertex = this.createVertex(-size,size,-size,1 - uvPadding,1 - uvPadding);
         var d:Vertex = this.createVertex(-size,size,size,1 - uvPadding,uvPadding);
         this.leftFace = this.createQuad(a,b,c,d,left);
         a = this.createVertex(size,size,size,uvPadding,uvPadding);
         b = this.createVertex(size,size,-size,uvPadding,1 - uvPadding);
         c = this.createVertex(size,-size,-size,1 - uvPadding,1 - uvPadding);
         d = this.createVertex(size,-size,size,1 - uvPadding,uvPadding);
         this.rightFace = this.createQuad(a,b,c,d,right);
         a = this.createVertex(size,-size,size,uvPadding,uvPadding);
         b = this.createVertex(size,-size,-size,uvPadding,1 - uvPadding);
         c = this.createVertex(-size,-size,-size,1 - uvPadding,1 - uvPadding);
         d = this.createVertex(-size,-size,size,1 - uvPadding,uvPadding);
         this.backFace = this.createQuad(a,b,c,d,back);
         a = this.createVertex(-size,size,size,uvPadding,uvPadding);
         b = this.createVertex(-size,size,-size,uvPadding,1 - uvPadding);
         c = this.createVertex(size,size,-size,1 - uvPadding,1 - uvPadding);
         d = this.createVertex(size,size,size,1 - uvPadding,uvPadding);
         this.frontFace = this.createQuad(a,b,c,d,front);
         a = this.createVertex(-size,size,-size,uvPadding,uvPadding);
         b = this.createVertex(-size,-size,-size,uvPadding,1 - uvPadding);
         c = this.createVertex(size,-size,-size,1 - uvPadding,1 - uvPadding);
         d = this.createVertex(size,size,-size,1 - uvPadding,uvPadding);
         this.bottomFace = this.createQuad(a,b,c,d,bottom);
         a = this.createVertex(-size,-size,size,uvPadding,uvPadding);
         b = this.createVertex(-size,size,size,uvPadding,1 - uvPadding);
         c = this.createVertex(size,size,size,1 - uvPadding,1 - uvPadding);
         d = this.createVertex(size,-size,size,1 - uvPadding,uvPadding);
         this.topFace = this.createQuad(a,b,c,d,top);
         calculateBounds();
         calculateFacesNormals(true);
         clipping = Clipping.FACE_CLIPPING;
         sorting = Sorting.NONE;
      }
      
      public function getSide(side:String) : Face
      {
         switch(side)
         {
            case LEFT:
               return this.leftFace;
            case RIGHT:
               return this.rightFace;
            case BACK:
               return this.backFace;
            case FRONT:
               return this.frontFace;
            case BOTTOM:
               return this.bottomFace;
            case TOP:
               return this.topFace;
            default:
               return null;
         }
      }
      
      public function transformUV(side:String, matrix:Matrix) : void
      {
         var wrapper:Wrapper = null;
         var vertex:Vertex = null;
         var res:Point = null;
         var face:Face = this.getSide(side);
         if(face != null)
         {
            for(wrapper = face.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               vertex = wrapper.vertex;
               res = matrix.transformPoint(new Point(vertex.u,vertex.v));
               vertex.u = res.x;
               vertex.v = res.y;
            }
         }
      }
      
      override public function clone() : Object3D
      {
         var res:SkyBox = new SkyBox(0);
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         super.clonePropertiesFrom(source);
         var src:SkyBox = source as SkyBox;
         this.autoSize = src.autoSize;
         var face:Face = src.faceList;
         var newFace:Face = faceList;
         while(face != null)
         {
            if(face == src.leftFace)
            {
               this.leftFace = newFace;
            }
            else if(face == src.rightFace)
            {
               this.rightFace = newFace;
            }
            else if(face == src.backFace)
            {
               this.backFace = newFace;
            }
            else if(face == src.frontFace)
            {
               this.frontFace = newFace;
            }
            else if(face == src.bottomFace)
            {
               this.bottomFace = newFace;
            }
            else if(face == src.topFace)
            {
               this.topFace = newFace;
            }
            face = face.next;
            newFace = newFace.next;
         }
      }
      
      private function createVertex(x:Number, y:Number, z:Number, u:Number, v:Number) : Vertex
      {
         var newVertex:Vertex = new Vertex();
         newVertex.next = vertexList;
         vertexList = newVertex;
         newVertex.x = x;
         newVertex.y = y;
         newVertex.z = z;
         newVertex.u = u;
         newVertex.v = v;
         return newVertex;
      }
      
      private function createQuad(a:Vertex, b:Vertex, c:Vertex, d:Vertex, material:Material) : Face
      {
         var newFace:Face = new Face();
         newFace.material = material;
         newFace.next = faceList;
         faceList = newFace;
         newFace.wrapper = new Wrapper();
         newFace.wrapper.vertex = a;
         newFace.wrapper.next = new Wrapper();
         newFace.wrapper.next.vertex = b;
         newFace.wrapper.next.next = new Wrapper();
         newFace.wrapper.next.next.vertex = c;
         newFace.wrapper.next.next.next = new Wrapper();
         newFace.wrapper.next.next.next.vertex = d;
         return newFace;
      }
      
      override alternativa3d function draw(camera:Camera3D) : void
      {
         if(faceList == null)
         {
            return;
         }
         if(this.autoSize)
         {
            this.calculateTransform(camera);
         }
         if(clipping == 0)
         {
            if(Boolean(culling & 1))
            {
               return;
            }
            culling = 0;
         }
         prepareResources();
         addOpaque(camera);
         transformConst[0] = ma;
         transformConst[1] = mb;
         transformConst[2] = mc;
         transformConst[3] = md;
         transformConst[4] = me;
         transformConst[5] = mf;
         transformConst[6] = mg;
         transformConst[7] = mh;
         transformConst[8] = mi;
         transformConst[9] = mj;
         transformConst[10] = mk;
         transformConst[11] = ml;
         var debug:int = camera.debug ? camera.checkInDebug(this) : 0;
         if(Boolean(debug & Debug.BOUNDS))
         {
            Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ);
         }
      }
      
      override alternativa3d function getVG(camera:Camera3D) : VG
      {
         this.draw(camera);
         return null;
      }
      
      override alternativa3d function cullingInCamera(camera:Camera3D, culling:int) : int
      {
         return super.alternativa3d::cullingInCamera(camera,culling = culling & ~3);
      }
      
      private function calculateTransform(camera:Camera3D) : void
      {
         var offset:Number = NaN;
         calculateInverseMatrix();
         var farX:Number = imj * ime - imf * imi;
         var farY:Number = imb * imi - imj * ima;
         var farZ:Number = imf * ima - imb * ime;
         var farOffset:Number = (imc * farX + img * farY + imk * farZ) * camera.farClipping;
         var maxOffset:Number = -1e+22;
         offset = (boundMinX - imd) * farX + (boundMinY - imh) * farY + (boundMinZ - iml) * farZ;
         if(offset > maxOffset)
         {
            maxOffset = offset;
         }
         offset = (boundMaxX - imd) * farX + (boundMinY - imh) * farY + (boundMinZ - iml) * farZ;
         if(offset > maxOffset)
         {
            maxOffset = offset;
         }
         offset = (boundMinX - imd) * farX + (boundMaxY - imh) * farY + (boundMinZ - iml) * farZ;
         if(offset > maxOffset)
         {
            maxOffset = offset;
         }
         offset = (boundMaxX - imd) * farX + (boundMaxY - imh) * farY + (boundMinZ - iml) * farZ;
         if(offset > maxOffset)
         {
            maxOffset = offset;
         }
         offset = (boundMinX - imd) * farX + (boundMinY - imh) * farY + (boundMaxZ - iml) * farZ;
         if(offset > maxOffset)
         {
            maxOffset = offset;
         }
         offset = (boundMaxX - imd) * farX + (boundMinY - imh) * farY + (boundMaxZ - iml) * farZ;
         if(offset > maxOffset)
         {
            maxOffset = offset;
         }
         offset = (boundMinX - imd) * farX + (boundMaxY - imh) * farY + (boundMaxZ - iml) * farZ;
         if(offset > maxOffset)
         {
            maxOffset = offset;
         }
         offset = (boundMaxX - imd) * farX + (boundMaxY - imh) * farY + (boundMaxZ - iml) * farZ;
         if(offset > maxOffset)
         {
            maxOffset = offset;
         }
         this.transform[0] = imd;
         this.transform[1] = imh;
         this.transform[2] = iml;
         this.transform[3] = farOffset / maxOffset;
      }
   }
}

