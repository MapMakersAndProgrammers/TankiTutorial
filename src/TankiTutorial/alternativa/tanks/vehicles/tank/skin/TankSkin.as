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
      
      private static const matrix:Matrix4 = new Matrix4();
      
      private static const hullMatrix:Matrix4 = new Matrix4();
      
      private static const eulerAngles:Vector3 = new Vector3();
      
      private var colormap:BitmapData;
      
      private var hull:TankHull;
      
      private var _hullMesh:Mesh;
      
      private var turret:TankTurret;
      
      private var _turretMesh:Mesh;
      
      private var container:Object3DContainer;
      
      private var leftTrackSkin:TrackSkin;
      
      private var rightTrackSkin:TrackSkin;
      
      private var trackFaces:Dictionary;
      
      public var camera:Camera3D;
      
      public var shadow:Shadow;
      
      public function TankSkin()
      {
         super();
      }
      
      private static function setObjectTransformation(object:Object3D, transform:Matrix4) : void
      {
         transform.getEulerAngles(eulerAngles);
         object.x = transform.md;
         object.y = transform.mh;
         object.z = transform.ml;
         object.rotationX = eulerAngles.x;
         object.rotationY = eulerAngles.y;
         object.rotationZ = eulerAngles.z;
      }
      
      public function get visible() : Boolean
      {
         return this._hullMesh.visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         this._hullMesh.visible = value;
         this._turretMesh.visible = value;
      }
      
      public function setAlpha(value:Number) : void
      {
         this._hullMesh.alpha = value;
         this._turretMesh.alpha = value;
         if(this.shadow != null)
         {
            this.shadow.alpha = value;
         }
      }
      
      public function addToContainer(param1:Object3DContainer, param2:Camera3D) : void
      {
         this.container = param1;
         if(this._hullMesh != null)
         {
            param1.addChild(this._hullMesh);
         }
         if(this._turretMesh != null)
         {
            param1.addChild(this._turretMesh);
         }
         this.camera = param2;
         this.shadow = new Shadow(128,8,100,5000,10000,516,0.95);
         this.shadow.offset = 100;
         this.shadow.backFadeRange = 100;
         this.shadow.direction = GameData.direction;
         if(this._hullMesh != null)
         {
            this.shadow.addCaster(this._hullMesh);
         }
         if(this._turretMesh != null)
         {
            this.shadow.addCaster(this._turretMesh);
         }
         param2.addShadow(this.shadow);
      }
      
      public function removeFromContainer() : void
      {
         if(this.container != null)
         {
            if(this._hullMesh != null)
            {
               this.container.removeChild(this._hullMesh);
            }
            if(this._turretMesh != null)
            {
               this.container.removeChild(this._turretMesh);
            }
         }
         if(this.camera != null)
         {
            this.shadow.removeAllCasters();
            this.camera.removeShadow(this.shadow);
            this.shadow = null;
            this.camera = null;
         }
      }
      
      public function get hullMesh() : Mesh
      {
         return this._hullMesh;
      }
      
      public function get turretMesh() : Mesh
      {
         return this._turretMesh;
      }
      
      public function getHull() : TankHull
      {
         return this.hull;
      }
      
      public function setHull(param1:TankHull) : void
      {
         if(this.hull != null && this.container != null)
         {
            this.container.removeChild(this._hullMesh);
         }
         this.hull = param1;
         if(this.hull != null)
         {
            this._hullMesh = Mesh(this.hull.skin.clone());
            this._hullMesh.sorting = Sorting.DYNAMIC_BSP;
            this.parseTrackSkins(this._hullMesh);
            if(this.container != null)
            {
               this.container.addChild(this._hullMesh);
            }
         }
         this.updatePartTexture(this.hull,this._hullMesh);
         if(this.shadow != null)
         {
            this.shadow.removeAllCasters();
            if(this._hullMesh != null)
            {
               this.shadow.addCaster(this._hullMesh);
            }
            if(this._turretMesh != null)
            {
               this.shadow.addCaster(this._turretMesh);
            }
         }
      }
      
      private function parseTrackSkins(mesh:Mesh) : void
      {
         var face:Face = null;
         this.leftTrackSkin = new TrackSkin();
         this.rightTrackSkin = new TrackSkin();
         this.trackFaces = new Dictionary();
         for each(face in mesh.faces)
         {
            if(face.material.name == "tracks")
            {
               this.addFaceToTrackSkin(face);
               this.trackFaces[face] = true;
            }
         }
         this.leftTrackSkin.init();
         this.rightTrackSkin.init();
      }
      
      private function addFaceToTrackSkin(face:Face) : void
      {
         var vertex:Vertex = face.vertices[0];
         if(vertex.x < 0)
         {
            this.leftTrackSkin.addFace(face);
         }
         else
         {
            this.rightTrackSkin.addFace(face);
         }
      }
      
      public function getTurret() : TankTurret
      {
         return this.turret;
      }
      
      public function setTurret(param1:TankTurret) : void
      {
         var parentContainer:Object3DContainer = null;
         var oldMesh:Mesh = null;
         if(this.turret != null)
         {
            parentContainer = this._turretMesh.parent;
            this._turretMesh.removeFromParent();
            oldMesh = this._turretMesh;
         }
         this.turret = param1;
         if(this.turret != null)
         {
            this._turretMesh = Mesh(this.turret.skin.clone());
            this._turretMesh.sorting = Sorting.DYNAMIC_BSP;
            if(oldMesh != null)
            {
               this._turretMesh.x = oldMesh.x;
               this._turretMesh.y = oldMesh.y;
               this._turretMesh.z = oldMesh.z;
               this._turretMesh.rotationX = oldMesh.rotationX;
               this._turretMesh.rotationY = oldMesh.rotationY;
               this._turretMesh.rotationZ = oldMesh.rotationZ;
            }
            if(parentContainer != null)
            {
               parentContainer.addChild(this._turretMesh);
            }
         }
         this.updatePartTexture(this.turret,this._turretMesh);
         if(this.shadow != null)
         {
            this.shadow.removeAllCasters();
            if(this._hullMesh != null)
            {
               this.shadow.addCaster(this._hullMesh);
            }
            if(this._turretMesh != null)
            {
               this.shadow.addCaster(this._turretMesh);
            }
         }
      }
      
      public function setColormap(param1:BitmapData) : void
      {
         if(param1 != null)
         {
            this.colormap = param1;
            this.updatePartTexture(this.hull,this._hullMesh);
            this.updatePartTexture(this.turret,this._turretMesh);
         }
      }
      
      private function getHalfHeight() : Number
      {
         return (this._hullMesh.boundMaxZ - this._hullMesh.boundMinZ) / 2;
      }
      
      public function updateTransform(position:Vector3, orientation:Quaternion, turretDirection:Number) : void
      {
         if(this.hull != null)
         {
            orientation.toMatrix4(matrix);
            matrix.setPosition(position);
            hullMatrix.toIdentity();
            hullMatrix.ml = -(this.getHalfHeight() + TankConst.puna);
            hullMatrix.append(matrix);
            setObjectTransformation(this._hullMesh,hullMatrix);
            if(this.turret != null)
            {
               matrix.toIdentity();
               matrix.setPosition(this.hull.mountPoint);
               matrix.setRotationMatrix(0,0,-turretDirection);
               matrix.append(hullMatrix);
               setObjectTransformation(this._turretMesh,matrix);
            }
         }
      }
      
      public function updateTracks(leftDelta:Number, rightDelta:Number) : void
      {
         this.leftTrackSkin.move(leftDelta);
         this.rightTrackSkin.move(rightDelta);
      }
      
      private function updatePartTexture(part:TankPart, mesh:Mesh) : void
      {
         var shape:Shape = null;
         var texture:BitmapData = null;
         var material:TextureMaterial = null;
         var trackMaterial:TrackMaterial = null;
         var face:Face = null;
         if(part != null && this.colormap != null)
         {
            shape = new Shape();
            shape.graphics.beginBitmapFill(this.colormap);
            shape.graphics.drawRect(0,0,part.lightmapTexture.width,part.lightmapTexture.height);
            texture = new BitmapData(part.lightmapTexture.width,part.lightmapTexture.height,false,0);
            texture.draw(shape);
            texture.draw(part.lightmapTexture,null,null,BlendMode.HARDLIGHT);
            texture.draw(part.detailsTexture);
            GameData.colorize(texture);
            material = new TextureMaterial(texture,true,true,MipMapping.PER_PIXEL,2.5);
            trackMaterial = new TrackMaterial(texture,true,true,MipMapping.PER_PIXEL,2.5);
            for each(face in mesh.faces)
            {
               if(this.trackFaces[face] == null)
               {
                  face.material = material;
               }
               else
               {
                  face.material = trackMaterial;
               }
            }
            mesh.removeVertex(mesh.addVertex(0,0,0));
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
