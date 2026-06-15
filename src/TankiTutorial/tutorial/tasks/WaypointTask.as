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
      
      private static var domihyv:TextureMaterial;
      
      private static var boqa:TextureMaterial;
      
      private var gomys:Sprite3D;
      
      private var nuvyma:Plane;
      
      private var hon:Function;
      
      private var magizegyc:KDContainer = GameData.guzinizub;
      
      private var citacir:Tank;
      
      private var range:Number = 800;
      
      public var position:Vector3;
      
      private var dodycoli:Number;
      
      private var dusy:Boolean = false;
      
      public function WaypointTask(param1:Vector3, param2:Tank, param3:Function)
      {
         super();
         if(domihyv == null)
         {
            domihyv = new TextureMaterial(Assets.getData("arrow",BitmapData),false,true,MipMapping.PER_PIXEL,2.5);
            boqa = new TextureMaterial(Assets.getData("shadow",BitmapData),false,true,MipMapping.PER_PIXEL,2.5);
         }
         this.citacir = param2;
         this.hon = param3;
         this.position = param1;
         this.position.qyririg += 200;
         this.dodycoli = 0;
      }
      
      override public function process() : Boolean
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this.gomys == null)
         {
            this.gomys = new Sprite3D(200,400,domihyv);
            this.gomys.x = this.position.x;
            this.gomys.y = this.position.y;
            this.gomys.z = this.position.qyririg;
            this.gomys.originY = 1;
            this.gomys.useShadowMap = false;
            this.gomys.useLight = false;
            this.gomys.visible = false;
            this.nuvyma = new Plane(300,300,1,1,true,false,false,boqa,boqa);
            this.nuvyma.x = this.position.x;
            this.nuvyma.y = this.position.y;
            this.nuvyma.z = this.position.qyririg - 190;
            this.nuvyma.useShadowMap = false;
            this.nuvyma.useLight = false;
            this.nuvyma.visible = false;
            this.nuvyma.shadowMapAlphaThreshold = 2;
            this.nuvyma.depthMapAlphaThreshold = 2;
            this.magizegyc.addChild(this.gomys);
            this.magizegyc.addChild(this.nuvyma);
         }
         var _loc1_:TimeData = GameData.lecopojen;
         if(this.dusy)
         {
            this.gomys.z += 300 * _loc1_.ziqod;
            this.gomys.alpha -= _loc1_.ziqod;
            this.nuvyma.alpha -= _loc1_.ziqod;
            if(this.gomys.alpha <= 0)
            {
               this.magizegyc.removeChild(this.gomys);
               this.magizegyc.removeChild(this.nuvyma);
               this.gomys = null;
               this.nuvyma = null;
               return true;
            }
         }
         else
         {
            this.dodycoli += 5 * _loc1_.ziqod;
            _loc2_ = Math.sin(this.dodycoli);
            this.gomys.z = this.position.qyririg + _loc2_ * 100;
            if(Boolean(this.citacir.inGame) && Boolean(this.citacir.kat))
            {
               _loc3_ = Number(this.citacir.kuca.hullMesh.x);
               _loc4_ = Number(this.citacir.kuca.hullMesh.y);
               _loc5_ = (_loc3_ - this.position.x) * (_loc3_ - this.position.x) + (_loc4_ - this.position.y) * (_loc4_ - this.position.y);
               if(_loc5_ < this.range * this.range)
               {
                  this.dusy = true;
                  if(this.hon != null)
                  {
                     this.citacir.setCheckpoint();
                     this.hon();
                  }
               }
            }
         }
         return false;
      }
   }
}

