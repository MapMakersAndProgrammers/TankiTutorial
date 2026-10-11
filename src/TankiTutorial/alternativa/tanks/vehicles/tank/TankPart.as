package alternativa.tanks.vehicles.tank
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import flash.display.BitmapData;
   
   public class TankPart
   {
      
      public var name:String;
      
      public var skin:Mesh;
      
      public var lightmapTexture:BitmapData;
      
      public var detailsTexture:BitmapData;
      
      public function TankPart()
      {
         super();
      }
      
      public function getSkinDimensions() : Vector3
      {
         return new Vector3(this.skin.boundMaxX - this.skin.boundMinX,this.skin.boundMaxY - this.skin.boundMinY,this.skin.boundMaxZ - this.skin.boundMinZ);
      }
   }
}

