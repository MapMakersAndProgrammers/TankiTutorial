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
   
   public class SpotLight extends Light3D
   {
      
      public var attenuationBegin:Number;
      
      public var attenuationEnd:Number;
      
      public var hotspot:Number;
      
      public var falloff:Number;
      
      public function SpotLight(color:uint, attenuationBegin:Number, attenuationEnd:Number, hotspot:Number, falloff:Number)
      {
         super();
         this.color = color;
         this.attenuationBegin = attenuationBegin;
         this.attenuationEnd = attenuationEnd;
         this.hotspot = hotspot;
         this.falloff = falloff;
         calculateBounds();
      }
      
      public function lookAt(x:Number, y:Number, z:Number) : void
      {
         var dx:Number = NaN;
         dx = x - this.x;
         var dy:Number = y - this.y;
         var dz:Number = z - this.z;
         rotationX = Math.atan2(dz,Math.sqrt(dx * dx + dy * dy)) - Math.PI / 2;
         rotationY = 0;
         rotationZ = -Math.atan2(dx,dy);
      }
      
      override public function clone() : Object3D
      {
         var res:SpotLight = new SpotLight(color,this.attenuationBegin,this.attenuationEnd,this.hotspot,this.falloff);
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
         var scale:Number = NaN;
         var ox:Number = NaN;
         var oy:Number = NaN;
         var oz:Number = NaN;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var len:Number = NaN;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var bz:Number = NaN;
         var cos:Number = NaN;
         var sin:Number = NaN;
         var x1:Number = NaN;
         var y1:Number = NaN;
         var z1:Number = NaN;
         var x2:Number = NaN;
         var y2:Number = NaN;
         var z2:Number = NaN;
         var x3:Number = NaN;
         var y3:Number = NaN;
         var z3:Number = NaN;
         var x4:Number = NaN;
         var y4:Number = NaN;
         var z4:Number = NaN;
         var x5:Number = NaN;
         var y5:Number = NaN;
         var z5:Number = NaN;
         var x6:Number = NaN;
         var y6:Number = NaN;
         var z6:Number = NaN;
         var x7:Number = NaN;
         var y7:Number = NaN;
         var z7:Number = NaN;
         var x8:Number = NaN;
         var y8:Number = NaN;
         var z8:Number = NaN;
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
               scale = 0;
               ox = md * camera.viewSizeX / camera.focalLength;
               oy = mh * camera.viewSizeY / camera.focalLength;
               oz = ml;
               dx = mc * camera.viewSizeX / camera.focalLength;
               dy = mg * camera.viewSizeY / camera.focalLength;
               dz = mk;
               len = Math.sqrt(dx * dx + dy * dy + dz * dz);
               scale += len;
               dx /= len;
               dy /= len;
               dz /= len;
               ax = ma * camera.viewSizeX / camera.focalLength;
               ay = me * camera.viewSizeY / camera.focalLength;
               az = mi;
               scale += Math.sqrt(ax * ax + ay * ay + az * az);
               bx = az * dy - ay * dz;
               by = ax * dz - az * dx;
               bz = ay * dx - ax * dy;
               len = Math.sqrt(bx * bx + by * by + bz * bz);
               bx /= len;
               by /= len;
               bz /= len;
               ax = mb * camera.viewSizeX / camera.focalLength;
               ay = mf * camera.viewSizeY / camera.focalLength;
               az = mj;
               scale += Math.sqrt(ax * ax + ay * ay + az * az);
               scale /= 3;
               ax = bz * dy - by * dz;
               ay = bx * dz - bz * dx;
               az = by * dx - bx * dy;
               cos = Math.cos(this.hotspot / 2);
               sin = Math.sin(this.hotspot / 2);
               x1 = ox + (dx * cos + ax * sin) * scale * this.attenuationBegin;
               y1 = oy + (dy * cos + ay * sin) * scale * this.attenuationBegin;
               z1 = oz + (dz * cos + az * sin) * scale * this.attenuationBegin;
               x2 = ox + (dx * cos + (ax + bx) * 0.9 * sin) * scale * this.attenuationBegin;
               y2 = oy + (dy * cos + (ay + by) * 0.9 * sin) * scale * this.attenuationBegin;
               z2 = oz + (dz * cos + (az + bz) * 0.9 * sin) * scale * this.attenuationBegin;
               x3 = ox + (dx * cos + bx * sin) * scale * this.attenuationBegin;
               y3 = oy + (dy * cos + by * sin) * scale * this.attenuationBegin;
               z3 = oz + (dz * cos + bz * sin) * scale * this.attenuationBegin;
               x4 = ox + (dx * cos - (ax - bx) * 0.9 * sin) * scale * this.attenuationBegin;
               y4 = oy + (dy * cos - (ay - by) * 0.9 * sin) * scale * this.attenuationBegin;
               z4 = oz + (dz * cos - (az - bz) * 0.9 * sin) * scale * this.attenuationBegin;
               x5 = ox + (dx * cos - ax * sin) * scale * this.attenuationBegin;
               y5 = oy + (dy * cos - ay * sin) * scale * this.attenuationBegin;
               z5 = oz + (dz * cos - az * sin) * scale * this.attenuationBegin;
               x6 = ox + (dx * cos - (ax + bx) * 0.9 * sin) * scale * this.attenuationBegin;
               y6 = oy + (dy * cos - (ay + by) * 0.9 * sin) * scale * this.attenuationBegin;
               z6 = oz + (dz * cos - (az + bz) * 0.9 * sin) * scale * this.attenuationBegin;
               x7 = ox + (dx * cos - bx * sin) * scale * this.attenuationBegin;
               y7 = oy + (dy * cos - by * sin) * scale * this.attenuationBegin;
               z7 = oz + (dz * cos - bz * sin) * scale * this.attenuationBegin;
               x8 = ox + (dx * cos + (ax - bx) * 0.9 * sin) * scale * this.attenuationBegin;
               y8 = oy + (dy * cos + (ay - by) * 0.9 * sin) * scale * this.attenuationBegin;
               z8 = oz + (dz * cos + (az - bz) * 0.9 * sin) * scale * this.attenuationBegin;
               if(z1 > camera.nearClipping && z2 > camera.nearClipping && z3 > camera.nearClipping && z4 > camera.nearClipping && z5 > camera.nearClipping && z6 > camera.nearClipping && z7 > camera.nearClipping && z8 > camera.nearClipping)
               {
                  canvas.graphics.lineStyle(1,rgb);
                  canvas.graphics.moveTo(x1 * camera.focalLength / z1,y1 * camera.focalLength / z1);
                  canvas.graphics.curveTo(x2 * camera.focalLength / z2,y2 * camera.focalLength / z2,x3 * camera.focalLength / z3,y3 * camera.focalLength / z3);
                  canvas.graphics.curveTo(x4 * camera.focalLength / z4,y4 * camera.focalLength / z4,x5 * camera.focalLength / z5,y5 * camera.focalLength / z5);
                  canvas.graphics.curveTo(x6 * camera.focalLength / z6,y6 * camera.focalLength / z6,x7 * camera.focalLength / z7,y7 * camera.focalLength / z7);
                  canvas.graphics.curveTo(x8 * camera.focalLength / z8,y8 * camera.focalLength / z8,x1 * camera.focalLength / z1,y1 * camera.focalLength / z1);
                  canvas.graphics.moveTo(ox * camera.focalLength / oz,oy * camera.focalLength / oz);
                  canvas.graphics.lineTo(x1 * camera.focalLength / z1,y1 * camera.focalLength / z1);
                  canvas.graphics.moveTo(ox * camera.focalLength / oz,oy * camera.focalLength / oz);
                  canvas.graphics.lineTo(x3 * camera.focalLength / z3,y3 * camera.focalLength / z3);
                  canvas.graphics.moveTo(ox * camera.focalLength / oz,oy * camera.focalLength / oz);
                  canvas.graphics.lineTo(x5 * camera.focalLength / z5,y5 * camera.focalLength / z5);
                  canvas.graphics.moveTo(ox * camera.focalLength / oz,oy * camera.focalLength / oz);
                  canvas.graphics.lineTo(x7 * camera.focalLength / z7,y7 * camera.focalLength / z7);
               }
               cos = Math.cos(this.falloff / 2);
               sin = Math.sin(this.falloff / 2);
               x1 = ox + (dx * cos + ax * sin) * scale * this.attenuationEnd;
               y1 = oy + (dy * cos + ay * sin) * scale * this.attenuationEnd;
               z1 = oz + (dz * cos + az * sin) * scale * this.attenuationEnd;
               x2 = ox + (dx * cos + (ax + bx) * 0.9 * sin) * scale * this.attenuationEnd;
               y2 = oy + (dy * cos + (ay + by) * 0.9 * sin) * scale * this.attenuationEnd;
               z2 = oz + (dz * cos + (az + bz) * 0.9 * sin) * scale * this.attenuationEnd;
               x3 = ox + (dx * cos + bx * sin) * scale * this.attenuationEnd;
               y3 = oy + (dy * cos + by * sin) * scale * this.attenuationEnd;
               z3 = oz + (dz * cos + bz * sin) * scale * this.attenuationEnd;
               x4 = ox + (dx * cos - (ax - bx) * 0.9 * sin) * scale * this.attenuationEnd;
               y4 = oy + (dy * cos - (ay - by) * 0.9 * sin) * scale * this.attenuationEnd;
               z4 = oz + (dz * cos - (az - bz) * 0.9 * sin) * scale * this.attenuationEnd;
               x5 = ox + (dx * cos - ax * sin) * scale * this.attenuationEnd;
               y5 = oy + (dy * cos - ay * sin) * scale * this.attenuationEnd;
               z5 = oz + (dz * cos - az * sin) * scale * this.attenuationEnd;
               x6 = ox + (dx * cos - (ax + bx) * 0.9 * sin) * scale * this.attenuationEnd;
               y6 = oy + (dy * cos - (ay + by) * 0.9 * sin) * scale * this.attenuationEnd;
               z6 = oz + (dz * cos - (az + bz) * 0.9 * sin) * scale * this.attenuationEnd;
               x7 = ox + (dx * cos - bx * sin) * scale * this.attenuationEnd;
               y7 = oy + (dy * cos - by * sin) * scale * this.attenuationEnd;
               z7 = oz + (dz * cos - bz * sin) * scale * this.attenuationEnd;
               x8 = ox + (dx * cos + (ax - bx) * 0.9 * sin) * scale * this.attenuationEnd;
               y8 = oy + (dy * cos + (ay - by) * 0.9 * sin) * scale * this.attenuationEnd;
               z8 = oz + (dz * cos + (az - bz) * 0.9 * sin) * scale * this.attenuationEnd;
               if(z1 > camera.nearClipping && z2 > camera.nearClipping && z3 > camera.nearClipping && z4 > camera.nearClipping && z5 > camera.nearClipping && z6 > camera.nearClipping && z7 > camera.nearClipping && z8 > camera.nearClipping)
               {
                  canvas.graphics.lineStyle(1,rgb,0.5);
                  canvas.graphics.moveTo(x1 * camera.focalLength / z1,y1 * camera.focalLength / z1);
                  canvas.graphics.curveTo(x2 * camera.focalLength / z2,y2 * camera.focalLength / z2,x3 * camera.focalLength / z3,y3 * camera.focalLength / z3);
                  canvas.graphics.curveTo(x4 * camera.focalLength / z4,y4 * camera.focalLength / z4,x5 * camera.focalLength / z5,y5 * camera.focalLength / z5);
                  canvas.graphics.curveTo(x6 * camera.focalLength / z6,y6 * camera.focalLength / z6,x7 * camera.focalLength / z7,y7 * camera.focalLength / z7);
                  canvas.graphics.curveTo(x8 * camera.focalLength / z8,y8 * camera.focalLength / z8,x1 * camera.focalLength / z1,y1 * camera.focalLength / z1);
                  canvas.graphics.moveTo(ox * camera.focalLength / oz,oy * camera.focalLength / oz);
                  canvas.graphics.lineTo(x1 * camera.focalLength / z1,y1 * camera.focalLength / z1);
                  canvas.graphics.moveTo(ox * camera.focalLength / oz,oy * camera.focalLength / oz);
                  canvas.graphics.lineTo(x3 * camera.focalLength / z3,y3 * camera.focalLength / z3);
                  canvas.graphics.moveTo(ox * camera.focalLength / oz,oy * camera.focalLength / oz);
                  canvas.graphics.lineTo(x5 * camera.focalLength / z5,y5 * camera.focalLength / z5);
                  canvas.graphics.moveTo(ox * camera.focalLength / oz,oy * camera.focalLength / oz);
                  canvas.graphics.lineTo(x7 * camera.focalLength / z7,y7 * camera.focalLength / z7);
               }
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
         var radius:Number = this.falloff < Math.PI ? Math.sin(this.falloff / 2) * this.attenuationEnd : this.attenuationEnd;
         var bottom:Number = this.falloff < Math.PI ? 0 : Math.cos(this.falloff / 2) * this.attenuationEnd;
         if(transformation != null)
         {
            vertex = boundVertexList;
            vertex.x = -radius;
            vertex.y = -radius;
            vertex.z = bottom;
            vertex = vertex.next;
            vertex.x = radius;
            vertex.y = -radius;
            vertex.z = bottom;
            vertex = vertex.next;
            vertex.x = -radius;
            vertex.y = radius;
            vertex.z = bottom;
            vertex = vertex.next;
            vertex.x = radius;
            vertex.y = radius;
            vertex.z = bottom;
            vertex = vertex.next;
            vertex.x = -radius;
            vertex.y = -radius;
            vertex.z = this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = radius;
            vertex.y = -radius;
            vertex.z = this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = -radius;
            vertex.y = radius;
            vertex.z = this.attenuationEnd;
            vertex = vertex.next;
            vertex.x = radius;
            vertex.y = radius;
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
            if(-radius < bounds.boundMinX)
            {
               bounds.boundMinX = -radius;
            }
            if(radius > bounds.boundMaxX)
            {
               bounds.boundMaxX = radius;
            }
            if(-radius < bounds.boundMinY)
            {
               bounds.boundMinY = -radius;
            }
            if(radius > bounds.boundMaxY)
            {
               bounds.boundMaxY = radius;
            }
            if(bottom < bounds.boundMinZ)
            {
               bounds.boundMinZ = bottom;
            }
            if(this.attenuationEnd > bounds.boundMaxZ)
            {
               bounds.boundMaxZ = this.attenuationEnd;
            }
         }
      }
   }
}

