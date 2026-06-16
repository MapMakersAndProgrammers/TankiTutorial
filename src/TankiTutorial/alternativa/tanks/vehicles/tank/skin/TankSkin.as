package alternativa.tanks.vehicles.tank.skin
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.Shadow;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tank.TankConst;
   import alternativa.tanks.vehicles.tank.TankHull;
   import alternativa.tanks.vehicles.tank.TankPart;
   import alternativa.tanks.vehicles.tank.TankTurret;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Shape;
   import flash.utils.Dictionary;
   import tutorial.GameData;
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;

   public class TankSkin
   {
      
      private static const qopo:Matrix4 = new Matrix4();
      
      private static const zyrirerip:Matrix4 = new Matrix4();
      
      private static const fyqynyfy:Vector3 = new Vector3();
      
      private var qev:BitmapData;
      
      private var cocehi:TankHull;
      
      private var mema:Mesh;
      
      private var lygawe:TankTurret;
      
      private var kimiwacun:Mesh;
      
      private var danewazam:Object3DContainer;
      
      private var rehyzomi:TrackSkin;
      
      private var vyjo:TrackSkin;
      
      private var niheji:Dictionary;
      
      public var butefu:Camera3D;
      
      public var nuvyma:Shadow;
      
      public function TankSkin()
      {
         super();
      }
      
      private static function setObjectTransformation(param1:Object3D, param2:Matrix4) : void
      {
         param2.getEulerAngles(fyqynyfy);
         param1.x = param2.kyvuru;
         param1.y = param2.zumidynip;
         param1.z = param2.sunafepo;
         param1.rotationX = fyqynyfy.x;
         param1.rotationY = fyqynyfy.y;
         param1.rotationZ = fyqynyfy.z;
      }
      
      public function get visible() : Boolean
      {
         return this.mema.visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this.mema.visible = param1;
         this.kimiwacun.visible = param1;
      }
      
      public function setAlpha(param1:Number) : void
      {
         this.mema.alpha = param1;
         this.kimiwacun.alpha = param1;
         if(this.nuvyma != null)
         {
            this.nuvyma.alpha = param1;
         }
      }
      
      public function addToContainer(param1:Object3DContainer, param2:Camera3D) : void
      {
         this.danewazam = param1;
         if(this.mema != null)
         {
            param1.addChild(this.mema);
         }
         if(this.kimiwacun != null)
         {
            param1.addChild(this.kimiwacun);
         }
         this.butefu = param2;
         this.nuvyma = new Shadow(128,8,100,5000,10000,516,0.95);
         this.nuvyma.offset = 100;
         this.nuvyma.backFadeRange = 100;
         this.nuvyma.direction = GameData.ruda;
         if(this.mema != null)
         {
            this.nuvyma.addCaster(this.mema);
         }
         if(this.kimiwacun != null)
         {
            this.nuvyma.addCaster(this.kimiwacun);
         }
         param2.addShadow(this.nuvyma);
      }
      
      public function removeFromContainer() : void
      {
         if(this.danewazam != null)
         {
            if(this.mema != null)
            {
               this.danewazam.removeChild(this.mema);
            }
            if(this.kimiwacun != null)
            {
               this.danewazam.removeChild(this.kimiwacun);
            }
         }
         if(this.butefu != null)
         {
            this.nuvyma.removeAllCasters();
            this.butefu.removeShadow(this.nuvyma);
            this.nuvyma = null;
            this.butefu = null;
         }
      }
      
      public function get hullMesh() : Mesh
      {
         return this.mema;
      }
      
      public function get turretMesh() : Mesh
      {
         return this.kimiwacun;
      }
      
      public function getHull() : TankHull
      {
         return this.cocehi;
      }
      
      public function setHull(param1:TankHull) : void
      {
         if(this.cocehi != null && this.danewazam != null)
         {
            this.danewazam.removeChild(this.mema);
         }
         this.cocehi = param1;
         if(this.cocehi != null)
         {
            this.mema = Mesh(this.cocehi.kuca.clone());
            this.mema.sorting = Sorting.DYNAMIC_BSP;
            this.parseTrackSkins(this.mema);
            if(this.danewazam != null)
            {
               this.danewazam.addChild(this.mema);
            }
         }
         this.updatePartTexture(this.cocehi,this.mema);
         if(this.nuvyma != null)
         {
            this.nuvyma.removeAllCasters();
            if(this.mema != null)
            {
               this.nuvyma.addCaster(this.mema);
            }
            if(this.kimiwacun != null)
            {
               this.nuvyma.addCaster(this.kimiwacun);
            }
         }
      }
      
      private function parseTrackSkins(param1:Mesh) : void
      {
         var _loc2_:Face = null;
         this.rehyzomi = new TrackSkin();
         this.vyjo = new TrackSkin();
         this.niheji = new Dictionary();
         for each(_loc2_ in param1.faces)
         {
            if(_loc2_.material.name == "tracks")
            {
               this.addFaceToTrackSkin(_loc2_);
               this.niheji[_loc2_] = true;
            }
         }
         this.rehyzomi.init();
         this.vyjo.init();
      }
      
      private function addFaceToTrackSkin(param1:Face) : void
      {
         var _loc2_:Vertex = param1.vertices[0];
         if(_loc2_.x < 0)
         {
            this.rehyzomi.addFace(param1);
         }
         else
         {
            this.vyjo.addFace(param1);
         }
      }
      
      public function getTurret() : TankTurret
      {
         return this.lygawe;
      }
      
      public function setTurret(param1:TankTurret) : void
      {
         var _loc2_:Object3DContainer = null;
         var _loc3_:Mesh = null;
         if(this.lygawe != null)
         {
            _loc2_ = this.kimiwacun.parent;
            this.kimiwacun.removeFromParent();
            _loc3_ = this.kimiwacun;
         }
         this.lygawe = param1;
         if(this.lygawe != null)
         {
            this.kimiwacun = Mesh(this.lygawe.kuca.clone());
            this.kimiwacun.sorting = Sorting.DYNAMIC_BSP;
            if(_loc3_ != null)
            {
               this.kimiwacun.x = _loc3_.x;
               this.kimiwacun.y = _loc3_.y;
               this.kimiwacun.z = _loc3_.z;
               this.kimiwacun.rotationX = _loc3_.rotationX;
               this.kimiwacun.rotationY = _loc3_.rotationY;
               this.kimiwacun.rotationZ = _loc3_.rotationZ;
            }
            if(_loc2_ != null)
            {
               _loc2_.addChild(this.kimiwacun);
            }
         }
         this.updatePartTexture(this.lygawe,this.kimiwacun);
         if(this.nuvyma != null)
         {
            this.nuvyma.removeAllCasters();
            if(this.mema != null)
            {
               this.nuvyma.addCaster(this.mema);
            }
            if(this.kimiwacun != null)
            {
               this.nuvyma.addCaster(this.kimiwacun);
            }
         }
      }
      
      public function setColormap(param1:BitmapData) : void
      {
         if(param1 != null)
         {
            this.qev = param1;
            this.updatePartTexture(this.cocehi,this.mema);
            this.updatePartTexture(this.lygawe,this.kimiwacun);
         }
      }
      
      private function getHalfHeight() : Number
      {
         return (this.mema.boundMaxZ - this.mema.boundMinZ) / 2;
      }
      
      public function updateTransform(param1:Vector3, param2:Quaternion, param3:Number) : void
      {
         if(this.cocehi != null)
         {
            param2.toMatrix4(qopo);
            qopo.setPosition(param1);
            zyrirerip.toIdentity();
            zyrirerip.sunafepo = -(this.getHalfHeight() + TankConst.puna);
            zyrirerip.append(qopo);
            setObjectTransformation(this.mema,zyrirerip);
            if(this.lygawe != null)
            {
               qopo.toIdentity();
               qopo.setPosition(this.cocehi.sih);
               qopo.setRotationMatrix(0,0,-param3);
               qopo.append(zyrirerip);
               setObjectTransformation(this.kimiwacun,qopo);
            }
         }
      }
      
      public function updateTracks(param1:Number, param2:Number) : void
      {
         this.rehyzomi.move(param1);
         this.vyjo.move(param2);
      }
      
      private function updatePartTexture(param1:TankPart, param2:Mesh) : void
      {
         var _loc3_:Shape = null;
         var _loc4_:BitmapData = null;
         var _loc5_:TextureMaterial = null;
         var _loc6_:TrackMaterial = null;
         var _loc7_:Face = null;
         if(param1 != null && this.qev != null)
         {
            _loc3_ = new Shape();
            _loc3_.graphics.beginBitmapFill(this.qev);
            _loc3_.graphics.drawRect(0,0,param1.sut.width,param1.sut.height);
            _loc4_ = new BitmapData(param1.sut.width,param1.sut.height,false,0);
            _loc4_.draw(_loc3_);
            _loc4_.draw(param1.sut,null,null,BlendMode.HARDLIGHT);
            _loc4_.draw(param1.vypupital);
            GameData.colorize(_loc4_);
            _loc5_ = new TextureMaterial(_loc4_,true,true,MipMapping.PER_PIXEL,2.5);
            _loc6_ = new TrackMaterial(_loc4_,true,true,MipMapping.PER_PIXEL,2.5);
            for each(_loc7_ in param2.faces)
            {
               if(this.niheji[_loc7_] == null)
               {
                  _loc7_.material = _loc5_;
               }
               else
               {
                  _loc7_.material = _loc6_;
               }
            }
            param2.removeVertex(param2.addVertex(0,0,0));
         }
      }
   }
}

import alternativa.engine3d.materials.Material;
import alternativa.engine3d.materials.TextureMaterial;
import flash.display.BitmapData;
import alternativa.engine3d.alternativa3d;

use namespace alternativa3d;

class TrackMaterial extends TextureMaterial
{
   
   public function TrackMaterial(param1:BitmapData = null, param2:Boolean = false, param3:Boolean = true, param4:int = 0, param5:Number = 1)
   {
      super(param1,param2,param3,param4,param5);
   }
   
   override alternativa3d function get transparent() : Boolean
   {
      return true;
   }
}
