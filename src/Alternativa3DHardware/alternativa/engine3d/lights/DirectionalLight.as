package alternativa.engine3d.lights
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Debug;
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3D;
   import flash.display.Sprite;
   
   use namespace alternativa3d;
   
   public class DirectionalLight extends Light3D
   {
      
      public function DirectionalLight(color:uint)
      {
         super();
         this.color = color;
         calculateBounds();
      }
      
      public function lookAt(x:Number, y:Number, z:Number) : void
      {
         var dx:Number = x - this.x;
         var dy:Number = y - this.y;
         var dz:Number = z - this.z;
         rotationX = Math.atan2(dz,Math.sqrt(dx * dx + dy * dy)) - Math.PI / 2;
         rotationY = 0;
         rotationZ = -Math.atan2(dx,dy);
      }
      
      override public function clone() : Object3D
      {
         var res:DirectionalLight = new DirectionalLight(color);
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
         var k:Number = NaN;
         var l1:Number = NaN;
         var l2:Number = NaN;
         var r1:Number = NaN;
         var r2:Number = NaN;
         var x0:Number = NaN;
         var y0:Number = NaN;
         var z0:Number = NaN;
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
         var x11:Number = NaN;
         var y11:Number = NaN;
         var z11:Number = NaN;
         var x12:Number = NaN;
         var y12:Number = NaN;
         var z12:Number = NaN;
         var x13:Number = NaN;
         var y13:Number = NaN;
         var z13:Number = NaN;
         var x14:Number = NaN;
         var y14:Number = NaN;
         var z14:Number = NaN;
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
               ox = md * camera.viewSizeX / camera.focalLength;
               oy = mh * camera.viewSizeY / camera.focalLength;
               oz = ml;
               dx = mc * camera.viewSizeX / camera.focalLength;
               dy = mg * camera.viewSizeY / camera.focalLength;
               dz = mk;
               len = Math.sqrt(dx * dx + dy * dy + dz * dz);
               dx /= len;
               dy /= len;
               dz /= len;
               ax = ma * camera.viewSizeX / camera.focalLength;
               ay = me * camera.viewSizeY / camera.focalLength;
               az = mi;
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
               ax = bz * dy - by * dz;
               ay = bx * dz - bz * dx;
               az = by * dx - bx * dy;
               k = ml / camera.focalLength;
               dx *= k;
               dy *= k;
               dz *= k;
               ax *= k;
               ay *= k;
               az *= k;
               bx *= k;
               by *= k;
               bz *= k;
               l1 = 16;
               l2 = 24;
               r1 = 4;
               r2 = 8;
               x0 = ox + dx * l2;
               y0 = oy + dy * l2;
               z0 = oz + dz * l2;
               x1 = ox + ax * r1 + bx * r1;
               y1 = oy + ay * r1 + by * r1;
               z1 = oz + az * r1 + bz * r1;
               x2 = ox - ax * r1 + bx * r1;
               y2 = oy - ay * r1 + by * r1;
               z2 = oz - az * r1 + bz * r1;
               x3 = ox - ax * r1 - bx * r1;
               y3 = oy - ay * r1 - by * r1;
               z3 = oz - az * r1 - bz * r1;
               x4 = ox + ax * r1 - bx * r1;
               y4 = oy + ay * r1 - by * r1;
               z4 = oz + az * r1 - bz * r1;
               x5 = ox + dx * l1 + ax * r1 + bx * r1;
               y5 = oy + dy * l1 + ay * r1 + by * r1;
               z5 = oz + dz * l1 + az * r1 + bz * r1;
               x6 = ox + dx * l1 - ax * r1 + bx * r1;
               y6 = oy + dy * l1 - ay * r1 + by * r1;
               z6 = oz + dz * l1 - az * r1 + bz * r1;
               x7 = ox + dx * l1 - ax * r1 - bx * r1;
               y7 = oy + dy * l1 - ay * r1 - by * r1;
               z7 = oz + dz * l1 - az * r1 - bz * r1;
               x8 = ox + dx * l1 + ax * r1 - bx * r1;
               y8 = oy + dy * l1 + ay * r1 - by * r1;
               z8 = oz + dz * l1 + az * r1 - bz * r1;
               x11 = ox + dx * l1 + ax * r2 + bx * r2;
               y11 = oy + dy * l1 + ay * r2 + by * r2;
               z11 = oz + dz * l1 + az * r2 + bz * r2;
               x12 = ox + dx * l1 - ax * r2 + bx * r2;
               y12 = oy + dy * l1 - ay * r2 + by * r2;
               z12 = oz + dz * l1 - az * r2 + bz * r2;
               x13 = ox + dx * l1 - ax * r2 - bx * r2;
               y13 = oy + dy * l1 - ay * r2 - by * r2;
               z13 = oz + dz * l1 - az * r2 - bz * r2;
               x14 = ox + dx * l1 + ax * r2 - bx * r2;
               y14 = oy + dy * l1 + ay * r2 - by * r2;
               z14 = oz + dz * l1 + az * r2 - bz * r2;
               if(z0 > camera.nearClipping && z1 > camera.nearClipping && z2 > camera.nearClipping && z3 > camera.nearClipping && z4 > camera.nearClipping && z5 > camera.nearClipping && z6 > camera.nearClipping && z7 > camera.nearClipping && z8 > camera.nearClipping && z11 > camera.nearClipping && z12 > camera.nearClipping && z13 > camera.nearClipping && z14 > camera.nearClipping)
               {
                  canvas.graphics.lineStyle(1,rgb);
                  canvas.graphics.moveTo(x1 * camera.focalLength / z1,y1 * camera.focalLength / z1);
                  canvas.graphics.lineTo(x2 * camera.focalLength / z2,y2 * camera.focalLength / z2);
                  canvas.graphics.lineTo(x3 * camera.focalLength / z3,y3 * camera.focalLength / z3);
                  canvas.graphics.lineTo(x4 * camera.focalLength / z4,y4 * camera.focalLength / z4);
                  canvas.graphics.lineTo(x1 * camera.focalLength / z1,y1 * camera.focalLength / z1);
                  canvas.graphics.moveTo(x5 * camera.focalLength / z5,y5 * camera.focalLength / z5);
                  canvas.graphics.lineTo(x6 * camera.focalLength / z6,y6 * camera.focalLength / z6);
                  canvas.graphics.lineTo(x7 * camera.focalLength / z7,y7 * camera.focalLength / z7);
                  canvas.graphics.lineTo(x8 * camera.focalLength / z8,y8 * camera.focalLength / z8);
                  canvas.graphics.lineTo(x5 * camera.focalLength / z5,y5 * camera.focalLength / z5);
                  canvas.graphics.moveTo(x11 * camera.focalLength / z11,y11 * camera.focalLength / z11);
                  canvas.graphics.lineTo(x12 * camera.focalLength / z12,y12 * camera.focalLength / z12);
                  canvas.graphics.lineTo(x13 * camera.focalLength / z13,y13 * camera.focalLength / z13);
                  canvas.graphics.lineTo(x14 * camera.focalLength / z14,y14 * camera.focalLength / z14);
                  canvas.graphics.lineTo(x11 * camera.focalLength / z11,y11 * camera.focalLength / z11);
                  canvas.graphics.moveTo(x0 * camera.focalLength / z0,y0 * camera.focalLength / z0);
                  canvas.graphics.lineTo(x11 * camera.focalLength / z11,y11 * camera.focalLength / z11);
                  canvas.graphics.moveTo(x0 * camera.focalLength / z0,y0 * camera.focalLength / z0);
                  canvas.graphics.lineTo(x12 * camera.focalLength / z12,y12 * camera.focalLength / z12);
                  canvas.graphics.moveTo(x0 * camera.focalLength / z0,y0 * camera.focalLength / z0);
                  canvas.graphics.lineTo(x13 * camera.focalLength / z13,y13 * camera.focalLength / z13);
                  canvas.graphics.moveTo(x0 * camera.focalLength / z0,y0 * camera.focalLength / z0);
                  canvas.graphics.lineTo(x14 * camera.focalLength / z14,y14 * camera.focalLength / z14);
                  canvas.graphics.moveTo(x1 * camera.focalLength / z1,y1 * camera.focalLength / z1);
                  canvas.graphics.lineTo(x5 * camera.focalLength / z5,y5 * camera.focalLength / z5);
                  canvas.graphics.moveTo(x2 * camera.focalLength / z2,y2 * camera.focalLength / z2);
                  canvas.graphics.lineTo(x6 * camera.focalLength / z6,y6 * camera.focalLength / z6);
                  canvas.graphics.moveTo(x3 * camera.focalLength / z3,y3 * camera.focalLength / z3);
                  canvas.graphics.lineTo(x7 * camera.focalLength / z7,y7 * camera.focalLength / z7);
                  canvas.graphics.moveTo(x4 * camera.focalLength / z4,y4 * camera.focalLength / z4);
                  canvas.graphics.lineTo(x8 * camera.focalLength / z8,y8 * camera.focalLength / z8);
               }
            }
            if(Boolean(debug & Debug.BOUNDS))
            {
               Debug.drawBounds(camera,this,boundMinX,boundMinY,boundMinZ,boundMaxX,boundMaxY,boundMaxZ,10092288);
            }
         }
      }
   }
}

