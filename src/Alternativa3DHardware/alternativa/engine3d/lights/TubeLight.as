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
   
   public class TubeLight extends Light3D
   {
      
      public var length:Number;
      
      public var attenuationBegin:Number;
      
      public var attenuationEnd:Number;
      
      public var falloff:Number;
      
      public function TubeLight(color:uint, length:Number, attenuationBegin:Number, attenuationEnd:Number, falloff:Number)
      {
         super();
         this.color = color;
         this.length = length;
         this.attenuationBegin = attenuationBegin;
         this.attenuationEnd = attenuationEnd;
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
         var res:TubeLight = new TubeLight(color,this.length,this.attenuationBegin,this.attenuationEnd,this.falloff);
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
         var ax1:Number = NaN;
         var ay1:Number = NaN;
         var az1:Number = NaN;
         var ax2:Number = NaN;
         var ay2:Number = NaN;
         var az2:Number = NaN;
         var ax3:Number = NaN;
         var ay3:Number = NaN;
         var az3:Number = NaN;
         var ax4:Number = NaN;
         var ay4:Number = NaN;
         var az4:Number = NaN;
         var ax5:Number = NaN;
         var ay5:Number = NaN;
         var az5:Number = NaN;
         var ax6:Number = NaN;
         var ay6:Number = NaN;
         var az6:Number = NaN;
         var ax7:Number = NaN;
         var ay7:Number = NaN;
         var az7:Number = NaN;
         var ax8:Number = NaN;
         var ay8:Number = NaN;
         var az8:Number = NaN;
         var bx1:Number = NaN;
         var by1:Number = NaN;
         var bz1:Number = NaN;
         var bx2:Number = NaN;
         var by2:Number = NaN;
         var bz2:Number = NaN;
         var bx3:Number = NaN;
         var by3:Number = NaN;
         var bz3:Number = NaN;
         var bx4:Number = NaN;
         var by4:Number = NaN;
         var bz4:Number = NaN;
         var bx5:Number = NaN;
         var by5:Number = NaN;
         var bz5:Number = NaN;
         var bx6:Number = NaN;
         var by6:Number = NaN;
         var bz6:Number = NaN;
         var bx7:Number = NaN;
         var by7:Number = NaN;
         var bz7:Number = NaN;
         var bx8:Number = NaN;
         var by8:Number = NaN;
         var bz8:Number = NaN;
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
               ax1 = md + ma * this.attenuationBegin;
               ay1 = mh + me * this.attenuationBegin;
               az1 = ml + mi * this.attenuationBegin;
               ax2 = md + (ma * this.attenuationBegin + mb * this.attenuationBegin) * 0.9;
               ay2 = mh + (me * this.attenuationBegin + mf * this.attenuationBegin) * 0.9;
               az2 = ml + (mi * this.attenuationBegin + mj * this.attenuationBegin) * 0.9;
               ax3 = md + mb * this.attenuationBegin;
               ay3 = mh + mf * this.attenuationBegin;
               az3 = ml + mj * this.attenuationBegin;
               ax4 = md - (ma * this.attenuationBegin - mb * this.attenuationBegin) * 0.9;
               ay4 = mh - (me * this.attenuationBegin - mf * this.attenuationBegin) * 0.9;
               az4 = ml - (mi * this.attenuationBegin - mj * this.attenuationBegin) * 0.9;
               ax5 = md - ma * this.attenuationBegin;
               ay5 = mh - me * this.attenuationBegin;
               az5 = ml - mi * this.attenuationBegin;
               ax6 = md - (ma * this.attenuationBegin + mb * this.attenuationBegin) * 0.9;
               ay6 = mh - (me * this.attenuationBegin + mf * this.attenuationBegin) * 0.9;
               az6 = ml - (mi * this.attenuationBegin + mj * this.attenuationBegin) * 0.9;
               ax7 = md - mb * this.attenuationBegin;
               ay7 = mh - mf * this.attenuationBegin;
               az7 = ml - mj * this.attenuationBegin;
               ax8 = md + (ma * this.attenuationBegin - mb * this.attenuationBegin) * 0.9;
               ay8 = mh + (me * this.attenuationBegin - mf * this.attenuationBegin) * 0.9;
               az8 = ml + (mi * this.attenuationBegin - mj * this.attenuationBegin) * 0.9;
               bx1 = md + mc * this.length + ma * this.attenuationBegin;
               by1 = mh + mg * this.length + me * this.attenuationBegin;
               bz1 = ml + mk * this.length + mi * this.attenuationBegin;
               bx2 = md + mc * this.length + (ma * this.attenuationBegin + mb * this.attenuationBegin) * 0.9;
               by2 = mh + mg * this.length + (me * this.attenuationBegin + mf * this.attenuationBegin) * 0.9;
               bz2 = ml + mk * this.length + (mi * this.attenuationBegin + mj * this.attenuationBegin) * 0.9;
               bx3 = md + mc * this.length + mb * this.attenuationBegin;
               by3 = mh + mg * this.length + mf * this.attenuationBegin;
               bz3 = ml + mk * this.length + mj * this.attenuationBegin;
               bx4 = md + mc * this.length - (ma * this.attenuationBegin - mb * this.attenuationBegin) * 0.9;
               by4 = mh + mg * this.length - (me * this.attenuationBegin - mf * this.attenuationBegin) * 0.9;
               bz4 = ml + mk * this.length - (mi * this.attenuationBegin - mj * this.attenuationBegin) * 0.9;
               bx5 = md + mc * this.length - ma * this.attenuationBegin;
               by5 = mh + mg * this.length - me * this.attenuationBegin;
               bz5 = ml + mk * this.length - mi * this.attenuationBegin;
               bx6 = md + mc * this.length - (ma * this.attenuationBegin + mb * this.attenuationBegin) * 0.9;
               by6 = mh + mg * this.length - (me * this.attenuationBegin + mf * this.attenuationBegin) * 0.9;
               bz6 = ml + mk * this.length - (mi * this.attenuationBegin + mj * this.attenuationBegin) * 0.9;
               bx7 = md + mc * this.length - mb * this.attenuationBegin;
               by7 = mh + mg * this.length - mf * this.attenuationBegin;
               bz7 = ml + mk * this.length - mj * this.attenuationBegin;
               bx8 = md + mc * this.length + (ma * this.attenuationBegin - mb * this.attenuationBegin) * 0.9;
               by8 = mh + mg * this.length + (me * this.attenuationBegin - mf * this.attenuationBegin) * 0.9;
               bz8 = ml + mk * this.length + (mi * this.attenuationBegin - mj * this.attenuationBegin) * 0.9;
               if(az1 > camera.nearClipping && az2 > camera.nearClipping && az3 > camera.nearClipping && az4 > camera.nearClipping && az5 > camera.nearClipping && az6 > camera.nearClipping && az7 > camera.nearClipping && az8 > camera.nearClipping && bz1 > camera.nearClipping && bz2 > camera.nearClipping && bz3 > camera.nearClipping && bz4 > camera.nearClipping && bz5 > camera.nearClipping && bz6 > camera.nearClipping && bz7 > camera.nearClipping && bz8 > camera.nearClipping)
               {
                  canvas.graphics.lineStyle(1,rgb);
                  canvas.graphics.moveTo(ax1 * camera.viewSizeX / az1,ay1 * camera.viewSizeY / az1);
                  canvas.graphics.curveTo(ax2 * camera.viewSizeX / az2,ay2 * camera.viewSizeY / az2,ax3 * camera.viewSizeX / az3,ay3 * camera.viewSizeY / az3);
                  canvas.graphics.curveTo(ax4 * camera.viewSizeX / az4,ay4 * camera.viewSizeY / az4,ax5 * camera.viewSizeX / az5,ay5 * camera.viewSizeY / az5);
                  canvas.graphics.curveTo(ax6 * camera.viewSizeX / az6,ay6 * camera.viewSizeY / az6,ax7 * camera.viewSizeX / az7,ay7 * camera.viewSizeY / az7);
                  canvas.graphics.curveTo(ax8 * camera.viewSizeX / az8,ay8 * camera.viewSizeY / az8,ax1 * camera.viewSizeX / az1,ay1 * camera.viewSizeY / az1);
                  canvas.graphics.moveTo(bx1 * camera.viewSizeX / bz1,by1 * camera.viewSizeY / bz1);
                  canvas.graphics.curveTo(bx2 * camera.viewSizeX / bz2,by2 * camera.viewSizeY / bz2,bx3 * camera.viewSizeX / bz3,by3 * camera.viewSizeY / bz3);
                  canvas.graphics.curveTo(bx4 * camera.viewSizeX / bz4,by4 * camera.viewSizeY / bz4,bx5 * camera.viewSizeX / bz5,by5 * camera.viewSizeY / bz5);
                  canvas.graphics.curveTo(bx6 * camera.viewSizeX / bz6,by6 * camera.viewSizeY / bz6,bx7 * camera.viewSizeX / bz7,by7 * camera.viewSizeY / bz7);
                  canvas.graphics.curveTo(bx8 * camera.viewSizeX / bz8,by8 * camera.viewSizeY / bz8,bx1 * camera.viewSizeX / bz1,by1 * camera.viewSizeY / bz1);
                  canvas.graphics.moveTo(ax1 * camera.viewSizeX / az1,ay1 * camera.viewSizeY / az1);
                  canvas.graphics.lineTo(bx1 * camera.viewSizeX / bz1,by1 * camera.viewSizeY / bz1);
                  canvas.graphics.moveTo(ax3 * camera.viewSizeX / az3,ay3 * camera.viewSizeY / az3);
                  canvas.graphics.lineTo(bx3 * camera.viewSizeX / bz3,by3 * camera.viewSizeY / bz3);
                  canvas.graphics.moveTo(ax5 * camera.viewSizeX / az5,ay5 * camera.viewSizeY / az5);
                  canvas.graphics.lineTo(bx5 * camera.viewSizeX / bz5,by5 * camera.viewSizeY / bz5);
                  canvas.graphics.moveTo(ax7 * camera.viewSizeX / az7,ay7 * camera.viewSizeY / az7);
                  canvas.graphics.lineTo(bx7 * camera.viewSizeX / bz7,by7 * camera.viewSizeY / bz7);
               }
               ax1 = md - mc * this.falloff + ma * this.attenuationEnd;
               ay1 = mh - mg * this.falloff + me * this.attenuationEnd;
               az1 = ml - mk * this.falloff + mi * this.attenuationEnd;
               ax2 = md - mc * this.falloff + (ma * this.attenuationEnd + mb * this.attenuationEnd) * 0.9;
               ay2 = mh - mg * this.falloff + (me * this.attenuationEnd + mf * this.attenuationEnd) * 0.9;
               az2 = ml - mk * this.falloff + (mi * this.attenuationEnd + mj * this.attenuationEnd) * 0.9;
               ax3 = md - mc * this.falloff + mb * this.attenuationEnd;
               ay3 = mh - mg * this.falloff + mf * this.attenuationEnd;
               az3 = ml - mk * this.falloff + mj * this.attenuationEnd;
               ax4 = md - mc * this.falloff - (ma * this.attenuationEnd - mb * this.attenuationEnd) * 0.9;
               ay4 = mh - mg * this.falloff - (me * this.attenuationEnd - mf * this.attenuationEnd) * 0.9;
               az4 = ml - mk * this.falloff - (mi * this.attenuationEnd - mj * this.attenuationEnd) * 0.9;
               ax5 = md - mc * this.falloff - ma * this.attenuationEnd;
               ay5 = mh - mg * this.falloff - me * this.attenuationEnd;
               az5 = ml - mk * this.falloff - mi * this.attenuationEnd;
               ax6 = md - mc * this.falloff - (ma * this.attenuationEnd + mb * this.attenuationEnd) * 0.9;
               ay6 = mh - mg * this.falloff - (me * this.attenuationEnd + mf * this.attenuationEnd) * 0.9;
               az6 = ml - mk * this.falloff - (mi * this.attenuationEnd + mj * this.attenuationEnd) * 0.9;
               ax7 = md - mc * this.falloff - mb * this.attenuationEnd;
               ay7 = mh - mg * this.falloff - mf * this.attenuationEnd;
               az7 = ml - mk * this.falloff - mj * this.attenuationEnd;
               ax8 = md - mc * this.falloff + (ma * this.attenuationEnd - mb * this.attenuationEnd) * 0.9;
               ay8 = mh - mg * this.falloff + (me * this.attenuationEnd - mf * this.attenuationEnd) * 0.9;
               az8 = ml - mk * this.falloff + (mi * this.attenuationEnd - mj * this.attenuationEnd) * 0.9;
               bx1 = md + mc * (this.length + this.falloff) + ma * this.attenuationEnd;
               by1 = mh + mg * (this.length + this.falloff) + me * this.attenuationEnd;
               bz1 = ml + mk * (this.length + this.falloff) + mi * this.attenuationEnd;
               bx2 = md + mc * (this.length + this.falloff) + (ma * this.attenuationEnd + mb * this.attenuationEnd) * 0.9;
               by2 = mh + mg * (this.length + this.falloff) + (me * this.attenuationEnd + mf * this.attenuationEnd) * 0.9;
               bz2 = ml + mk * (this.length + this.falloff) + (mi * this.attenuationEnd + mj * this.attenuationEnd) * 0.9;
               bx3 = md + mc * (this.length + this.falloff) + mb * this.attenuationEnd;
               by3 = mh + mg * (this.length + this.falloff) + mf * this.attenuationEnd;
               bz3 = ml + mk * (this.length + this.falloff) + mj * this.attenuationEnd;
               bx4 = md + mc * (this.length + this.falloff) - (ma * this.attenuationEnd - mb * this.attenuationEnd) * 0.9;
               by4 = mh + mg * (this.length + this.falloff) - (me * this.attenuationEnd - mf * this.attenuationEnd) * 0.9;
               bz4 = ml + mk * (this.length + this.falloff) - (mi * this.attenuationEnd - mj * this.attenuationEnd) * 0.9;
               bx5 = md + mc * (this.length + this.falloff) - ma * this.attenuationEnd;
               by5 = mh + mg * (this.length + this.falloff) - me * this.attenuationEnd;
               bz5 = ml + mk * (this.length + this.falloff) - mi * this.attenuationEnd;
               bx6 = md + mc * (this.length + this.falloff) - (ma * this.attenuationEnd + mb * this.attenuationEnd) * 0.9;
               by6 = mh + mg * (this.length + this.falloff) - (me * this.attenuationEnd + mf * this.attenuationEnd) * 0.9;
               bz6 = ml + mk * (this.length + this.falloff) - (mi * this.attenuationEnd + mj * this.attenuationEnd) * 0.9;
               bx7 = md + mc * (this.length + this.falloff) - mb * this.attenuationEnd;
               by7 = mh + mg * (this.length + this.falloff) - mf * this.attenuationEnd;
               bz7 = ml + mk * (this.length + this.falloff) - mj * this.attenuationEnd;
               bx8 = md + mc * (this.length + this.falloff) + (ma * this.attenuationEnd - mb * this.attenuationEnd) * 0.9;
               by8 = mh + mg * (this.length + this.falloff) + (me * this.attenuationEnd - mf * this.attenuationEnd) * 0.9;
               bz8 = ml + mk * (this.length + this.falloff) + (mi * this.attenuationEnd - mj * this.attenuationEnd) * 0.9;
               if(az1 > camera.nearClipping && az2 > camera.nearClipping && az3 > camera.nearClipping && az4 > camera.nearClipping && az5 > camera.nearClipping && az6 > camera.nearClipping && az7 > camera.nearClipping && az8 > camera.nearClipping && bz1 > camera.nearClipping && bz2 > camera.nearClipping && bz3 > camera.nearClipping && bz4 > camera.nearClipping && bz5 > camera.nearClipping && bz6 > camera.nearClipping && bz7 > camera.nearClipping && bz8 > camera.nearClipping)
               {
                  canvas.graphics.lineStyle(1,rgb);
                  canvas.graphics.moveTo(ax1 * camera.viewSizeX / az1,ay1 * camera.viewSizeY / az1);
                  canvas.graphics.curveTo(ax2 * camera.viewSizeX / az2,ay2 * camera.viewSizeY / az2,ax3 * camera.viewSizeX / az3,ay3 * camera.viewSizeY / az3);
                  canvas.graphics.curveTo(ax4 * camera.viewSizeX / az4,ay4 * camera.viewSizeY / az4,ax5 * camera.viewSizeX / az5,ay5 * camera.viewSizeY / az5);
                  canvas.graphics.curveTo(ax6 * camera.viewSizeX / az6,ay6 * camera.viewSizeY / az6,ax7 * camera.viewSizeX / az7,ay7 * camera.viewSizeY / az7);
                  canvas.graphics.curveTo(ax8 * camera.viewSizeX / az8,ay8 * camera.viewSizeY / az8,ax1 * camera.viewSizeX / az1,ay1 * camera.viewSizeY / az1);
                  canvas.graphics.moveTo(bx1 * camera.viewSizeX / bz1,by1 * camera.viewSizeY / bz1);
                  canvas.graphics.curveTo(bx2 * camera.viewSizeX / bz2,by2 * camera.viewSizeY / bz2,bx3 * camera.viewSizeX / bz3,by3 * camera.viewSizeY / bz3);
                  canvas.graphics.curveTo(bx4 * camera.viewSizeX / bz4,by4 * camera.viewSizeY / bz4,bx5 * camera.viewSizeX / bz5,by5 * camera.viewSizeY / bz5);
                  canvas.graphics.curveTo(bx6 * camera.viewSizeX / bz6,by6 * camera.viewSizeY / bz6,bx7 * camera.viewSizeX / bz7,by7 * camera.viewSizeY / bz7);
                  canvas.graphics.curveTo(bx8 * camera.viewSizeX / bz8,by8 * camera.viewSizeY / bz8,bx1 * camera.viewSizeX / bz1,by1 * camera.viewSizeY / bz1);
                  canvas.graphics.moveTo(ax1 * camera.viewSizeX / az1,ay1 * camera.viewSizeY / az1);
                  canvas.graphics.lineTo(bx1 * camera.viewSizeX / bz1,by1 * camera.viewSizeY / bz1);
                  canvas.graphics.moveTo(ax3 * camera.viewSizeX / az3,ay3 * camera.viewSizeY / az3);
                  canvas.graphics.lineTo(bx3 * camera.viewSizeX / bz3,by3 * camera.viewSizeY / bz3);
                  canvas.graphics.moveTo(ax5 * camera.viewSizeX / az5,ay5 * camera.viewSizeY / az5);
                  canvas.graphics.lineTo(bx5 * camera.viewSizeX / bz5,by5 * camera.viewSizeY / bz5);
                  canvas.graphics.moveTo(ax7 * camera.viewSizeX / az7,ay7 * camera.viewSizeY / az7);
                  canvas.graphics.lineTo(bx7 * camera.viewSizeX / bz7,by7 * camera.viewSizeY / bz7);
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
         if(transformation != null)
         {
            vertex = boundVertexList;
            vertex.x = -this.attenuationEnd;
            vertex.y = -this.attenuationEnd;
            vertex.z = -this.falloff;
            vertex = vertex.next;
            vertex.x = this.attenuationEnd;
            vertex.y = -this.attenuationEnd;
            vertex.z = -this.falloff;
            vertex = vertex.next;
            vertex.x = -this.attenuationEnd;
            vertex.y = this.attenuationEnd;
            vertex.z = -this.falloff;
            vertex = vertex.next;
            vertex.x = this.attenuationEnd;
            vertex.y = this.attenuationEnd;
            vertex.z = -this.falloff;
            vertex = vertex.next;
            vertex.x = -this.attenuationEnd;
            vertex.y = -this.attenuationEnd;
            vertex.z = this.length + this.falloff;
            vertex = vertex.next;
            vertex.x = this.attenuationEnd;
            vertex.y = -this.attenuationEnd;
            vertex.z = this.length + this.falloff;
            vertex = vertex.next;
            vertex.x = -this.attenuationEnd;
            vertex.y = this.attenuationEnd;
            vertex.z = this.length + this.falloff;
            vertex = vertex.next;
            vertex.x = this.attenuationEnd;
            vertex.y = this.attenuationEnd;
            vertex.z = this.length + this.falloff;
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
            if(-this.falloff < bounds.boundMinZ)
            {
               bounds.boundMinZ = -this.falloff;
            }
            if(this.length + this.falloff > bounds.boundMaxZ)
            {
               bounds.boundMaxZ = this.length + this.falloff;
            }
         }
      }
   }
}

