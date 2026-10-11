package alternativa.tanks.vehicles.tank.skin
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import flash.utils.Dictionary;
   
   public class TrackSkin
   {
      
      private var faces:Vector.<Face> = new Vector.<Face>();
      
      private var vertices:Vector.<Vertex>;
      
      private var ratio:Number;
      
      public function TrackSkin()
      {
         super();
      }
      
      private static function getRatio(face:Face) : Number
      {
         var faceVertices:Vector.<Vertex> = face.vertices;
         return getRatioForVertices(faceVertices[0],faceVertices[1]);
      }
      
      private static function getRatioForVertices(a:Vertex, b:Vertex) : Number
      {
         var dx:Number = a.x - b.x;
         var dy:Number = a.y - b.y;
         var dz:Number = a.z - b.z;
         var distance:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
         var du:Number = a.u - b.u;
         var dv:Number = a.v - b.v;
         var uvDistance:Number = Math.sqrt(du * du + dv * dv);
         return uvDistance / distance;
      }
      
      public function addFace(face:Face) : void
      {
         this.faces.push(face);
      }
      
      public function init() : void
      {
         var face:Face = null;
         var key:* = undefined;
         var vertex:Vertex = null;
         var ratioSum:Number = 0;
         var map:Dictionary = new Dictionary();
         for each(face in this.faces)
         {
            for each(vertex in face.vertices)
            {
               map[vertex] = true;
            }
            ratioSum += getRatio(face);
         }
         this.ratio = ratioSum / this.faces.length;
         this.vertices = new Vector.<Vertex>();
         for(key in map)
         {
            this.vertices.push(key);
         }
      }
      
      public function move(delta:Number) : void
      {
         var vertex:Vertex = null;
         for each(vertex in this.vertices)
         {
            vertex.u += delta * this.ratio;
         }
      }
      
      public function setMaterial(material:Material) : void
      {
         var face:Face = null;
         for each(face in this.faces)
         {
            face.material = material;
         }
      }
   }
}

