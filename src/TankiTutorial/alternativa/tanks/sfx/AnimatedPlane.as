package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.objects.Mesh;
   
   public class AnimatedPlane extends Mesh
   {
      
      private var a:Vertex;
      
      private var b:Vertex;
      
      private var c:Vertex;
      
      private var d:Vertex;
      
      private var frames:Vector.<UVFrame>;
      
      private var numFrames:int;
      
      private var framesPerMs:Number = 0;
      
      public function AnimatedPlane(size:Number)
      {
         super();
         this.createFaces(size);
         sorting = Sorting.DYNAMIC_BSP;
         calculateBounds();
         calculateFacesNormals();
         this.writeVertices();
         useShadowMap = false;
         useLight = false;
         shadowMapAlphaThreshold = 2;
         depthMapAlphaThreshold = 2;
      }
      
      private function createFaces(size:Number) : void
      {
         var halfSize:Number = size / 2;
         var _loc3_:Vector.<Number> = Vector.<Number>([-halfSize,halfSize,0,-halfSize,-halfSize,0,halfSize,-halfSize,0,halfSize,halfSize,0]);
         var uvs:Vector.<Number> = Vector.<Number>([0,0,0,1,1,1,1,0]);
         var indices:Vector.<int> = Vector.<int>([4,0,1,2,3,4,0,3,2,1]);
         addVerticesAndFaces(_loc3_,uvs,indices,true);
      }
      
      private function writeVertices() : void
      {
         var _loc1_:Vector.<Vertex> = this.vertices;
         this.a = _loc1_[0];
         this.b = _loc1_[1];
         this.c = _loc1_[2];
         this.d = _loc1_[3];
      }
      
      public function init(animation:TextureAnimation, framesPerMs:Number) : void
      {
         setMaterialToAllFaces(animation.material);
         this.frames = animation.frames;
         this.numFrames = this.frames.length;
         this.framesPerMs = framesPerMs;
      }
      
      public function setTime(time:Number) : void
      {
         var frameIndex:int = time * this.framesPerMs;
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
         return this.numFrames / this.framesPerMs;
      }
      
      private function setFrame(frame:UVFrame) : void
      {
         this.a.u = frame.topLeftU;
         this.a.v = frame.topLeftV;
         this.b.u = frame.topLeftU;
         this.b.v = frame.bottomRightV;
         this.c.u = frame.bottomRightU;
         this.c.v = frame.bottomRightV;
         this.d.u = frame.bottomRightU;
         this.d.v = frame.topLeftV;
      }
   }
}

