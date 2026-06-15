package kihi
{
   import flash.utils.getQualifiedClassName;
   
   public class dudyqo
   {
      
      public var cubegyw:Number = 1e+308;
      
      public var nicomosa:Number = 1e+308;
      
      public var gesuwi:Number = 1e+308;
      
      public var jys:Number = -1e+308;
      
      public var juri:Number = -1e+308;
      
      public var zepoci:Number = -1e+308;
      
      public function dudyqo()
      {
         super();
      }
      
      public function wigikot(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this.cubegyw = param1;
         this.nicomosa = param2;
         this.gesuwi = param3;
         this.jys = param4;
         this.juri = param5;
         this.zepoci = param6;
      }
      
      public function fajabym(param1:dudyqo) : void
      {
         this.cubegyw = param1.cubegyw < this.cubegyw ? param1.cubegyw : this.cubegyw;
         this.nicomosa = param1.nicomosa < this.nicomosa ? param1.nicomosa : this.nicomosa;
         this.gesuwi = param1.gesuwi < this.gesuwi ? param1.gesuwi : this.gesuwi;
         this.jys = param1.jys > this.jys ? param1.jys : this.jys;
         this.juri = param1.juri > this.juri ? param1.juri : this.juri;
         this.zepoci = param1.zepoci > this.zepoci ? param1.zepoci : this.zepoci;
      }
      
      public function sediw(param1:Number, param2:Number, param3:Number) : void
      {
         if(param1 < this.cubegyw)
         {
            this.cubegyw = param1;
         }
         if(param1 > this.jys)
         {
            this.jys = param1;
         }
         if(param2 < this.nicomosa)
         {
            this.nicomosa = param2;
         }
         if(param2 > this.juri)
         {
            this.juri = param2;
         }
         if(param3 < this.gesuwi)
         {
            this.gesuwi = param3;
         }
         if(param3 > this.zepoci)
         {
            this.zepoci = param3;
         }
      }
      
      public function pyjerupof() : void
      {
         this.cubegyw = 1e+308;
         this.nicomosa = 1e+308;
         this.gesuwi = 1e+308;
         this.jys = -1e+308;
         this.juri = -1e+308;
         this.zepoci = -1e+308;
      }
      
      public function hoguqatec(param1:dudyqo, param2:Number) : Boolean
      {
         return !(this.cubegyw > param1.jys + param2 || this.jys < param1.cubegyw - param2 || this.nicomosa > param1.juri + param2 || this.juri < param1.nicomosa - param2 || this.gesuwi > param1.zepoci + param2 || this.zepoci < param1.gesuwi - param2);
      }
      
      public function hyr(param1:dudyqo) : void
      {
         this.cubegyw = param1.cubegyw;
         this.nicomosa = param1.nicomosa;
         this.gesuwi = param1.gesuwi;
         this.jys = param1.jys;
         this.juri = param1.juri;
         this.zepoci = param1.zepoci;
      }
      
      public function bet() : dudyqo
      {
         var _loc1_:dudyqo = new dudyqo();
         _loc1_.hyr(this);
         return _loc1_;
      }
      
      public function bojo() : Number
      {
         return this.jys - this.cubegyw;
      }
      
      public function vywudyqit() : Number
      {
         return this.juri - this.nicomosa;
      }
      
      public function kul() : Number
      {
         return this.zepoci - this.gesuwi;
      }
      
      public function nuw() : String
      {
         return getQualifiedClassName(this) + "(" + this.cubegyw.toFixed(3) + ", " + this.nicomosa.toFixed(3) + ", " + this.gesuwi.toFixed(3) + ": " + this.jys.toFixed(3) + ", " + this.juri.toFixed(3) + ", " + this.zepoci.toFixed(3) + ")";
      }
   }
}

