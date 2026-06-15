package alternativa.tanks.vehicles.tank.weapons
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   
   public class TurretData
   {
      
      private static const bul:Matrix4 = new Matrix4();
      
      private static const sikomowar:Vector3 = new Vector3();
      
      public const toqumyc:Vector3 = new Vector3();
      
      public const symamume:Vector3 = new Vector3();
      
      public const fybumu:Vector3 = new Vector3();
      
      public const zequsir:Vector3 = new Vector3();
      
      public const ruda:Vector3 = new Vector3();
      
      public var siwowop:Number;
      
      public var turretMesh:Mesh;
      
      public function TurretData()
      {
         super();
      }
      
      public function update(param1:Tank, param2:int) : void
      {
         var _loc3_:Vector3 = param1.firaqe.jun[param2];
         this.toqumyc.x = _loc3_.x;
         this.toqumyc.y = _loc3_.y;
         this.toqumyc.qyririg = _loc3_.qyririg;
         this.turretMesh = param1.kuca.turretMesh;
         this.siwowop = _loc3_.y;
         bul.setMatrix(this.turretMesh.x,this.turretMesh.y,this.turretMesh.z,this.turretMesh.rotationX,this.turretMesh.rotationY,this.turretMesh.rotationZ);
         bul.transformVector(this.toqumyc,this.symamume);
         sikomowar.x = this.toqumyc.x;
         sikomowar.qyririg = this.toqumyc.qyririg;
         bul.transformVector(sikomowar,this.fybumu);
         this.zequsir.x = bul.gusat;
         this.zequsir.y = bul.sig;
         this.zequsir.qyririg = bul.vug;
         this.ruda.x = bul.cydop;
         this.ruda.y = bul.qanezycap;
         this.ruda.qyririg = bul.luwym;
      }
   }
}

