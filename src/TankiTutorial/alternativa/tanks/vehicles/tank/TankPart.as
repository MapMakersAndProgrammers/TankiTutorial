package alternativa.tanks.vehicles.tank
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import flash.display.BitmapData;
   
   public class TankPart
   {
      
      public var gepocivaj:String;
      
      public var kuca:Mesh;
      
      public var sut:BitmapData;
      
      public var vypupital:BitmapData;
      
      public function TankPart()
      {
         super();
      }
      
      public function getSkinDimensions() : Vector3
      {
         return new Vector3(this.kuca.boundMaxX - this.kuca.boundMinX,this.kuca.boundMaxY - this.kuca.boundMinY,this.kuca.boundMaxZ - this.kuca.boundMinZ);
      }
   }
}

