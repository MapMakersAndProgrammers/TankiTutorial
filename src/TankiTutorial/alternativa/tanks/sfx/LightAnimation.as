package alternativa.tanks.sfx
{
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.lights.SpotLight;
   import alternativa.engine3d.lights.TubeLight;
   
   public final class LightAnimation
   {
      
      private var numFrames:int;
      
      private var time:Vector.<uint>;
      
      private var intensities:Vector.<Number>;
      
      private var color:Vector.<uint>;
      
      private var attenuationBegins:Vector.<Number>;
      
      private var attenuationEnds:Vector.<Number>;
      
      public function LightAnimation(records:Vector.<LightingEfectRecord>)
      {
         var record:LightingEfectRecord = null;
         super();
         this.numFrames = records.length;
         this.intensities = new Vector.<Number>(this.numFrames,true);
         this.color = new Vector.<uint>(this.numFrames,true);
         this.attenuationBegins = new Vector.<Number>(this.numFrames,true);
         this.attenuationEnds = new Vector.<Number>(this.numFrames,true);
         this.time = new Vector.<uint>(this.numFrames,true);
         var i:int = 0;
         while(i < this.numFrames)
         {
            record = records[i];
            this.intensities[i] = Number(record.intensity);
            this.color[i] = uint(record.color);
            this.attenuationBegins[i] = Number(record.attenuationBegin);
            this.attenuationEnds[i] = Number(record.attenuationEnd);
            this.time[i] = uint(record.time);
            i++;
         }
      }
      
      private static function lerpNumber(a:Number, b:Number, t:Number) : Number
      {
         return a + (b - a) * t;
      }
      
      private static function lerpColor(color1:uint, color2:uint, t:Number) : uint
      {
         var r1:Number = (color1 >> 16 & 0xFF) / 255;
         var g1:Number = (color1 >> 8 & 0xFF) / 255;
         var b1:Number = (color1 & 0xFF) / 255;
         var r2:Number = (color2 >> 16 & 0xFF) / 255;
         var g2:Number = (color2 >> 8 & 0xFF) / 255;
         var b2:Number = (color2 & 0xFF) / 255;
         var r:int = lerpNumber(r1,r2,t) * 255;
         var g:int = lerpNumber(g1,g2,t) * 255;
         var b:int = lerpNumber(b1,b2,t) * 255;
         return r << 16 | g << 8 | b;
      }
      
      private function getFrameByTime(param1:Number) : Number
      {
         var i:int = 0;
         var startTime:Number = NaN;
         var endTime:Number = NaN;
         var t:Number = NaN;
         var frame:Number = 0;
         if(param1 < this.time[this.numFrames - 1])
         {
            i = 0;
            while(i < this.numFrames - 1)
            {
               startTime = this.time[i];
               endTime = this.time[i + 1];
               if(param1 >= startTime && param1 < endTime)
               {
                  t = (param1 - startTime) / (endTime - startTime);
                  frame = i + t;
                  break;
               }
               i++;
            }
         }
         else
         {
            frame = this.numFrames - 1;
         }
         return frame;
      }
      
      public function getFramesCount() : int
      {
         return this.numFrames;
      }
      
      private function limitFrame(frame:int) : int
      {
         return frame < this.numFrames ? frame : int(this.numFrames - 1);
      }
      
      public function updateByFrame(light:Light3D, frame:Number) : void
      {
         var spotLight:SpotLight = null;
         var tubeLight:TubeLight = null;
         var omniLight:OmniLight = light as OmniLight;
         if(omniLight != null)
         {
            this.updateOmniLight(frame,omniLight);
         }
         else
         {
            spotLight = light as SpotLight;
            if(spotLight != null)
            {
               this.updateSpotLight(frame,spotLight);
            }
            else
            {
               tubeLight = light as TubeLight;
               if(tubeLight != null)
               {
                  this.updateTubeLight(frame,tubeLight);
               }
            }
         }
         light.calculateBounds();
      }
      
      private function updateSpotLight(frame:Number, light:SpotLight) : void
      {
         var frame1:int = this.limitFrame(Math.floor(frame));
         var frame2:int = this.limitFrame(Math.ceil(frame));
         var t:Number = frame - frame1;
         var intensity1:Number = this.intensities[frame1];
         var intensity2:Number = this.intensities[frame2];
         var color1:uint = this.color[frame1];
         var color2:uint = this.color[frame2];
         var attenuationBegin1:Number = this.attenuationBegins[frame1];
         var attenuationBegin2:Number = this.attenuationBegins[frame2];
         var attenuationEnd1:Number = this.attenuationEnds[frame1];
         var attenuationEnd2:Number = this.attenuationEnds[frame2];
         light.intensity = lerpNumber(intensity1,intensity2,t);
         light.color = lerpColor(color1,color2,t);
         light.attenuationBegin = lerpNumber(attenuationBegin1,attenuationBegin2,t);
         light.attenuationEnd = lerpNumber(attenuationEnd1,attenuationEnd2,t);
      }
      
      private function updateOmniLight(frame:Number, light:OmniLight) : void
      {
         var frame1:int = this.limitFrame(Math.floor(frame));
         var frame2:int = this.limitFrame(Math.ceil(frame));
         var t:Number = frame - frame1;
         var intensity1:Number = this.intensities[frame1];
         var intensity2:Number = this.intensities[frame2];
         var color1:uint = this.color[frame1];
         var color2:uint = this.color[frame2];
         var attenuationBegin1:Number = this.attenuationBegins[frame1];
         var attenuationBegin2:Number = this.attenuationBegins[frame2];
         var attenuationEnd1:Number = this.attenuationEnds[frame1];
         var attenuationEnd2:Number = this.attenuationEnds[frame2];
         light.intensity = lerpNumber(intensity1,intensity2,t);
         light.color = lerpColor(color1,color2,t);
         light.attenuationBegin = lerpNumber(attenuationBegin1,attenuationBegin2,t);
         light.attenuationEnd = lerpNumber(attenuationEnd1,attenuationEnd2,t);
      }
      
      private function updateTubeLight(frame:Number, light:TubeLight) : void
      {
         var frame1:int = this.limitFrame(Math.floor(frame));
         var frame2:int = this.limitFrame(Math.ceil(frame));
         var t:Number = frame - frame1;
         var intensity1:Number = this.intensities[frame1];
         var intensity2:Number = this.intensities[frame2];
         var color1:uint = this.color[frame1];
         var color2:uint = this.color[frame2];
         var attenuationBegin1:Number = this.attenuationBegins[frame1];
         var attenuationBegin2:Number = this.attenuationBegins[frame2];
         var attenuationEnd1:Number = this.attenuationEnds[frame1];
         var attenuationEnd2:Number = this.attenuationEnds[frame2];
         light.intensity = lerpNumber(intensity1,intensity2,t);
         light.color = lerpColor(color1,color2,t);
         light.attenuationBegin = lerpNumber(attenuationBegin1,attenuationBegin2,t);
         light.attenuationEnd = lerpNumber(attenuationEnd1,attenuationEnd2,t);
      }
      
      public function updateByTime(light:Light3D, param2:int, duration:int = -1) : void
      {
         var _loc4_:Number = 1;
         if(duration > 0 && this.numFrames > 0)
         {
            _loc4_ = this.time[this.numFrames - 1] / duration;
         }
         var frame:Number = this.getFrameByTime(param2 * _loc4_);
         this.updateByFrame(light,frame);
      }
      
      public function getLiveTime() : int
      {
         return this.time[this.numFrames - 1];
      }
   }
}

