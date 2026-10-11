package alternativa.tanks.sfx.flamethrower
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public interface StreamWeaponEffects
   {
      
      function startEffects(body:Body, localMuzzlePosition:Vector3, turretMesh:Mesh) : void;
      
      function stopEffects() : void;
   }
}

