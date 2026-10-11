package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   
   public class AnimatedPlane extends Mesh
   {
      
      private var gar:Vertex;
      
      private var nityt:Vertex;
      
      private var fysu:Vertex;
      
      private var rok:Vertex;
      
      private var frames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      private var lelypa:Number = 0;
      
      public function AnimatedPlane(param1:Number)
      {
         super();
         this.createFaces(param1);
         sorting = Sorting.DYNAMIC_BSP;
         calculateBounds();
         calculateFacesNormals();
         this.writeVertices();
         useShadowMap = false;
         useLight = false;
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
      }
      
      private function createFaces(param1:Number) : void
      {
         var halfSize:Number = param1 / 2;
         var _loc3_:Vector.<Number> = Vector.<Number>([-halfSize,halfSize,0,-halfSize,-halfSize,0,halfSize,-halfSize,0,halfSize,halfSize,0]);
         var uvs:Vector.<Number> = Vector.<Number>([0,0,0,1,1,1,1,0]);
         var indices:Vector.<int> = Vector.<int>([4,0,1,2,3,4,0,3,2,1]);
         addVerticesAndFaces(_loc3_,uvs,indices,true);
      }
      
      private function writeVertices() : void
      {
         var _loc1_:Vector.<Vertex> = this.vertices;
         this.gar = _loc1_[0];
         this.nityt = _loc1_[1];
         this.fysu = _loc1_[2];
         this.rok = _loc1_[3];
      }
      
      public function init(animation:TextureAnimation, param2:Number) : void
      {
         setMaterialToAllFaces(animation.material);
         this.frames = animation.frames;
         this.numFrames = this.frames.length;
         this.lelypa = param2;
      }
      
      public function setTime(param1:Number) : void
      {
         var frameIndex:int = param1 * this.lelypa;
         if(frameIndex >= this.numFrames)
         {
            frameIndex = this.numFrames - 1;
         }
         this.setFrame(this.frames[frameIndex]);
      }
      
      public function clear() : void
      {
         setMaterialToAllFaces(null);
         this.frames = null;
         this.numFrames = 0;
      }
      
      public function getOneLoopTime() : Number
      {
         return this.numFrames / this.lelypa;
      }
      
      private function setFrame(frame:UVFrame) : void
      {
         this.gar.u = frame.topLeftU;
         this.gar.v = frame.topLeftV;
         this.nityt.u = frame.topLeftU;
         this.nityt.v = frame.bottomRightV;
         this.fysu.u = frame.bottomRightU;
         this.fysu.v = frame.bottomRightV;
         this.rok.u = frame.bottomRightU;
         this.rok.v = frame.topLeftV;
      }
   }
}

