package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public interface StreamWeaponEffects
   {
      
      function startEffects(param1:Body, param2:Vector3, param3:Mesh) : void;
      
      function stopEffects() : void;
   }
}

