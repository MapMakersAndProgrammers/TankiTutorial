package tutorial.loader.proplib
{
   import alternativa.engine3d.materials.TextureMaterial;
   
   public class PropTexture
   {
      
      public var name:String;
      
      private var diffuseMapURL:String;
      
      private var _material:TextureMaterial;
      
      public function PropTexture(name:String, diffuseMap:String, baseURL:String)
      {
         super();
         this.name = name;
         this.diffuseMapURL = baseURL + diffuseMap;
      }
      
      public function get material() : TextureMaterial
      {
         if(this._material == null)
         {
            this._material = new TextureMaterial();
            this._material.diffuseMapURL = this.diffuseMapURL;
            this._material.name = this.name;
         }
         return this._material;
      }
   }
}

