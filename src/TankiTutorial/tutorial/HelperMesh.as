package tutorial
{
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.primitives.Plane;
   
   public class HelperMesh extends BSP
   {
      
      public function HelperMesh()
      {
         super();
         var plane:Plane = new Plane();
         createTree(plane);
         z = -20000;
         name = "static";
         useShadowMap = false;
         useLight = false;
      }
   }
}

