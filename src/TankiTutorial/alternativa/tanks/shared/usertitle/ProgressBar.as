package alternativa.tanks.shared.usertitle
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ProgressBar
   {
      
      private static var gijalatyt:Matrix = new Matrix();
      
      public var zabiso:int;
      
      private var mevyjyhe:int;
      
      private var dyfami:int;
      
      private var bowi:int;
      
      private var zanipubon:int;
      
      private var pym:int;
      
      private var kuca:ProgressBarSkin;
      
      private var tami:int;
      
      private var nedyjoj:int;
      
      private var mukehefa:int;
      
      private var pediri:Shape = new Shape();
      
      private var x:int;
      
      private var y:int;
      
      private var wobycezu:Rectangle;
      
      public function ProgressBar(param1:int, param2:int, param3:int, param4:int, param5:ProgressBarSkin)
      {
         super();
         this.x = param1;
         this.y = param2;
         this.zabiso = param3;
         this.mevyjyhe = param4;
         this.setSkin(param5);
         this.wobycezu = new Rectangle(param1,param2,2 * this.dyfami + param4,this.bowi);
      }
      
      public function setSkin(param1:ProgressBarSkin) : void
      {
         this.kuca = param1;
         this.tami = param1.row.width;
         this.nedyjoj = param1.row.height;
         this.dyfami = param1.roga.width;
         this.bowi = param1.nuvyma.height;
         this.zanipubon = this.dyfami - this.tami;
         this.pym = this.bowi - this.nedyjoj >> 1;
      }
      
      public function get progress() : int
      {
         return this.mukehefa;
      }
      
      public function set progress(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > this.zabiso)
         {
            param1 = this.zabiso;
         }
         this.mukehefa = param1;
      }
      
      public function draw(param1:BitmapData) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Graphics = this.pediri.graphics;
         _loc2_.clear();
         _loc2_.beginBitmapFill(this.kuca.roga);
         _loc2_.drawRect(0,0,this.dyfami,this.bowi);
         _loc2_.beginBitmapFill(this.kuca.nuvyma);
         _loc2_.drawRect(this.dyfami,0,this.mevyjyhe - 2 * this.tami,this.bowi);
         _loc2_.beginBitmapFill(this.kuca.bavofyhe);
         _loc2_.drawRect(this.dyfami + this.mevyjyhe - 2 * this.tami,0,this.dyfami,this.bowi);
         _loc2_.endFill();
         var _loc3_:int = this.mevyjyhe * this.mukehefa / this.zabiso;
         var _loc5_:int = this.mevyjyhe - this.tami;
         if(_loc3_ >= this.tami)
         {
            if(_loc3_ == this.mevyjyhe)
            {
               this.drawFullBar(_loc2_,this.kuca.color,this.kuca.bypot,this.kuca.cyv);
               _loc4_ = _loc3_;
            }
            else
            {
               gijalatyt.tx = this.zanipubon;
               gijalatyt.ty = this.pym;
               _loc2_.beginBitmapFill(this.kuca.bypot,gijalatyt,false);
               _loc2_.drawRect(this.zanipubon,this.pym,this.tami,this.nedyjoj);
               if(_loc3_ > this.tami)
               {
                  if(_loc3_ > _loc5_)
                  {
                     _loc3_ = _loc5_;
                  }
                  _loc4_ = _loc3_;
                  _loc2_.beginFill(this.kuca.color);
                  _loc2_.drawRect(this.zanipubon + this.tami,this.pym,_loc3_ - this.tami,this.nedyjoj);
               }
               else
               {
                  _loc4_ = this.tami;
               }
            }
         }
         if(_loc4_ == 0)
         {
            this.drawFullBar(_loc2_,this.kuca.furoveb,this.kuca.row,this.kuca.sikaq);
         }
         else if(_loc4_ < this.mevyjyhe)
         {
            _loc2_.beginFill(this.kuca.furoveb);
            _loc2_.drawRect(this.zanipubon + _loc4_,this.pym,_loc5_ - _loc4_,this.nedyjoj);
            gijalatyt.tx = this.zanipubon + _loc5_;
            gijalatyt.ty = this.pym;
            _loc2_.beginBitmapFill(this.kuca.sikaq,gijalatyt,false);
            _loc2_.drawRect(this.zanipubon + _loc5_,this.pym,this.tami,this.nedyjoj);
         }
         _loc2_.endFill();
         param1.fillRect(this.wobycezu,0);
         gijalatyt.tx = this.x;
         gijalatyt.ty = this.y;
         param1.draw(this.pediri,gijalatyt);
      }
      
      private function drawFullBar(param1:Graphics, param2:uint, param3:BitmapData, param4:BitmapData) : void
      {
         var _loc5_:int = this.mevyjyhe - this.tami;
         gijalatyt.tx = this.zanipubon;
         gijalatyt.ty = this.pym;
         param1.beginBitmapFill(param3,gijalatyt,false);
         param1.drawRect(this.zanipubon,this.pym,this.tami,this.nedyjoj);
         param1.beginFill(param2);
         param1.drawRect(this.zanipubon + this.tami,this.pym,_loc5_ - this.tami,this.nedyjoj);
         gijalatyt.tx = this.zanipubon + _loc5_;
         param1.beginBitmapFill(param4,gijalatyt,false);
         param1.drawRect(this.zanipubon + _loc5_,this.pym,this.tami,this.nedyjoj);
      }
   }
}

