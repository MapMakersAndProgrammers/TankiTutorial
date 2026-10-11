package tutorial.tasks
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.engine3d.primitives.Plane;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.Tank;
   import flash.display.BitmapData;
   import tutorial.GameData;
   import tutorial.TimeData;
   import tutorial.commons.Assets;
   
   public class WaypointTask extends Task
   {
      
      private static var arrowMaterial:TextureMaterial;
      
      private static var shadowMaterial:TextureMaterial;
      
      private var arrow:Sprite3D;
      
      private var shadow:Plane;
      
      private var callback:Function;
      
      private var kdContainer:KDContainer = GameData.kdContainer;
      
      private var tank:Tank;
      
      private var range:Number = 800;
      
      public var position:Vector3;
      
      private var phase:Number;
      
      private var reached:Boolean = false;
      
      public function WaypointTask(position:Vector3, tank:Tank, callback:Function)
      {
         super();
         if(arrowMaterial == null)
         {
            arrowMaterial = new TextureMaterial(Assets.getData("arrow",BitmapData),false,true,MipMapping.PER_PIXEL,2.5);
            shadowMaterial = new TextureMaterial(Assets.getData("shadow",BitmapData),false,true,MipMapping.PER_PIXEL,2.5);
         }
         this.tank = tank;
         this.callback = callback;
         this.position = position;
         this.position.z += 200;
         this.phase = 0;
      }
      
      override public function process() : Boolean
      {
         var offset:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var distanceSqr:Number = NaN;
         if(this.arrow == null)
         {
            this.arrow = new Sprite3D(200,400,arrowMaterial);
            this.arrow.x = this.position.x;
            this.arrow.y = this.position.y;
            this.arrow.z = this.position.z;
            this.arrow.originY = 1;
            this.arrow.useShadowMap = false;
            this.arrow.useLight = false;
            this.arrow.visible = false;
            this.shadow = new Plane(300,300,1,1,true,false,false,shadowMaterial,shadowMaterial);
            this.shadow.x = this.position.x;
            this.shadow.y = this.position.y;
            this.shadow.z = this.position.z - 190;
            this.shadow.useShadowMap = false;
            this.shadow.useLight = false;
            this.shadow.visible = false;
            this.shadow.shadowMapAlphaThreshold = 2;
            this.shadow.depthMapAlphaThreshold = 2;
            this.kdContainer.addChild(this.arrow);
            this.kdContainer.addChild(this.shadow);
         }
         var timeData:TimeData = GameData.time;
         if(this.reached)
         {
            this.arrow.z += 300 * timeData.deltaTime;
            this.arrow.alpha -= timeData.deltaTime;
            this.shadow.alpha -= timeData.deltaTime;
            if(this.arrow.alpha <= 0)
            {
               this.kdContainer.removeChild(this.arrow);
               this.kdContainer.removeChild(this.shadow);
               this.arrow = null;
               this.shadow = null;
               return true;
            }
         }
         else
         {
            this.phase += 5 * timeData.deltaTime;
            offset = Math.sin(this.phase);
            this.arrow.z = this.position.z + offset * 100;
            if(Boolean(this.tank.inGame) && Boolean(this.tank.kat))
            {
               x = Number(this.tank.kuca.hullMesh.x);
               y = Number(this.tank.kuca.hullMesh.y);
               distanceSqr = (x - this.position.x) * (x - this.position.x) + (y - this.position.y) * (y - this.position.y);
               if(distanceSqr < this.range * this.range)
               {
                  this.reached = true;
                  if(this.callback != null)
                  {
                     this.tank.setCheckpoint();
                     this.callback();
                  }
               }
            }
         }
         return false;
      }
   }
}

