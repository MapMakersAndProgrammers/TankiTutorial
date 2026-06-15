package tutorial.loader.proplib
{
   import alternativa.engine3d.materials.TextureMaterial;
   
   public class PropTexture
   {
      
      public var gepocivaj:String;
      
      private var dibisewo:String;
      
      private var qeluziked:TextureMaterial;
      
      public function PropTexture(param1:String, param2:String, param3:String)
      {
         super();
         this.gepocivaj = param1;
         this.dibisewo = param3 + param2;
      }
      
      public function get material() : TextureMaterial
      {
         if(this.qeluziked == null)
         {
            this.qeluziked = new TextureMaterial();
            this.qeluziked.diffuseMapURL = this.dibisewo;
            this.qeluziked.name = this.gepocivaj;
         }
         return this.qeluziked;
      }
   }
}

