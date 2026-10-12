package alternativa.engine3d.lights
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import flash.display.Sprite;
   
   use namespace alternativa3d;
   
   public class OmniLight extends Light3D
   {
      
      public var attenuationBegin:Number;
      
      public var attenuationEnd:Number;
      
      public function OmniLight(color:uint, attenuationBegin:Number, attenuationEnd:Number)
      {
         super();
         this.color = color;
         this.attenuationBegin = attenuationBegin;
         this.attenuationEnd = attenuationEnd;
         calculateBounds();
      }
      
      override public function clone() : Object3D
      {
         var res:OmniLight = new OmniLight(color,this.attenuationBegin,this.attenuationEnd);
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override alternativa3d function drawDebug(camera:Camera3D) : void
      {
         var canvas:Sprite = null;
         var r:Number = NaN;
         var g:Number = NaN;
         var b:Number = NaN;
         var rgb:int = 0;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var scale:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var size:Number = NaN;
         var debug:int = camera.checkInDebug(this);
         if(debug > 0)
         {
            canvas = camera.view.canvas;
            if(Boolean(debug & Debug.LIGHTS) && ml > camera.nearClipping)
            {
               r = (color >> 16 & 0xFF) * intensity;
               g = (color >> 8 & 0xFF) * intensity;
               b = (color & 0xFF) * intensity;
               rgb = ((r > 255 ? 255 : r) << 16) + ((g > 255 ? 255 : g) << 8) + (b > 255 ? 255 : b);
               ax = ma * camera.viewSizeX / camera.focalLength;
               ay = me * camera.viewSizeY / camera.focalLength;
               scale = Math.sqrt(ax * ax + ay * ay + mi * mi);
               ax = mb * camera.viewSizeX / camera.focalLength;
               ay = mf * camera.viewSizeY / camera.focalLength;
               scale += Math.sqrt(ax * ax + ay * ay + mj * mj);
               ax = mc * camera.viewSizeX / camera.focalLength;
               ay = mg * camera.viewSizeY / camera.focalLength;
               scale += Math.sqrt(ax * ax + ay * ay + mk * mk);
               scale /= 3;
               x = Math.round(md * camera.viewSizeX / ml);
               y = Math.round(mh * camera.viewSizeY / ml);
               size = 8;
               canvas.graphics.lineStyle(1,rgb);
               canvas.graphics.moveTo(x - size,y);
               canvas.graphics.lineTo(x + size,y);
               canvas.graphics.moveTo(x,y - size);
               canvas.graphics.lineTo(x,y + size);
               canvas.graphics.moveTo(x - size * 0.7,y - size * 0.7);
               canvas.graphics.lineTo(x + size * 0.7,y + size * 0.7);
               canvas.graphics.moveTo(x - size * 0.7,y + size * 0.7);
               canvas.graphics.lineTo(x + size * 0.7,y - size * 0.7);
               canvas.graphics.drawCircle(x,y,this.attenuationBegin * scale * camera.focalLength / ml);
               canvas.graphics.lineStyle(1,rgb,0.5);
               canvas.graphics.drawCircle(x,y,this.attenuationEnd * scale * camera.focalLength / ml);
            }
            if(Boolean(debug & Debug.BOUNDS))
            {
               Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ,10092288);
            }
         }
      }
      
      override alternativa3d function updateBounds(bounds:Object3D, transformation:Object3D = null) : void
      {
         var vertex:Vertex = null;
         if(transformation != null)
         {
            vertex = boundVertexList;
            vertex.x = -this.attenuationEnd;
            vertex.y = -this.attenuationEnd;
            vertex.z = -this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = this.attenuationEnd;
            vertex.y = -this.attenuationEnd;
            vertex.z = -this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = -this.attenuationEnd;
            vertex.y = this.attenuationEnd;
            vertex.z = -this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = this.attenuationEnd;
            vertex.y = this.attenuationEnd;
            vertex.z = -this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = -this.attenuationEnd;
            vertex.y = -this.attenuationEnd;
            vertex.z = this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = this.attenuationEnd;
            vertex.y = -this.attenuationEnd;
            vertex.z = this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = -this.attenuationEnd;
            vertex.y = this.attenuationEnd;
            vertex.z = this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = this.attenuationEnd;
            vertex.y = this.attenuationEnd;
            vertex.z = this.attenuationEnd;
            for(vertex = boundVertexList; vertex != null; vertex = vertex.next)
            {
               vertex.cameraX = transformation.ma * vertex.x + transformation.mb * vertex.y + transformation.mc * vertex.z + transformation.md;
               vertex.cameraY = transformation.me * vertex.x + transformation.mf * vertex.y + transformation.mg * vertex.z + transformation.mh;
               vertex.cameraZ = transformation.mi * vertex.x + transformation.mj * vertex.y + transformation.mk * vertex.z + transformation.ml;
               if(vertex.cameraX < bounds.boundMinX)
               {
                  bounds.boundMinX = vertex.cameraX;
               }
               if(vertex.cameraX > bounds.boundMaxX)
               {
                  bounds.boundMaxX = vertex.cameraX;
               }
               if(vertex.cameraY < bounds.boundMinY)
               {
                  bounds.boundMinY = vertex.cameraY;
               }
               if(vertex.cameraY > bounds.boundMaxY)
               {
                  bounds.boundMaxY = vertex.cameraY;
               }
               if(vertex.cameraZ < bounds.boundMinZ)
               {
                  bounds.boundMinZ = vertex.cameraZ;
               }
               if(vertex.cameraZ > bounds.boundMaxZ)
               {
                  bounds.boundMaxZ = vertex.cameraZ;
               }
            }
         }
         else
         {
            if(-this.attenuationEnd < bounds.boundMinX)
            {
               bounds.boundMinX = -this.attenuationEnd;
            }
            if(this.attenuationEnd > bounds.boundMaxX)
            {
               bounds.boundMaxX = this.attenuationEnd;
            }
            if(-this.attenuationEnd < bounds.boundMinY)
            {
               bounds.boundMinY = -this.attenuationEnd;
            }
            if(this.attenuationEnd > bounds.boundMaxY)
            {
               bounds.boundMaxY = this.attenuationEnd;
            }
            if(-this.attenuationEnd < bounds.boundMinZ)
            {
               bounds.boundMinZ = -this.attenuationEnd;
            }
            if(this.attenuationEnd > bounds.boundMaxZ)
            {
               bounds.boundMaxZ = this.attenuationEnd;
            }
         }
      }
   }
}

