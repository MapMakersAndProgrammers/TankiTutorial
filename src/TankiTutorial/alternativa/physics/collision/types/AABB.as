package alternativa.physics.collision.types
{
   import flash.utils.getQualifiedClassName;
   
   public class AABB
   {
      
      public var cubegyw:Number = 1e+308;
      
      public var nicomosa:Number = 1e+308;
      
      public var gesuwi:Number = 1e+308;
      
      public var jys:Number = -1e+308;
      
      public var juri:Number = -1e+308;
      
      public var zepoci:Number = -1e+308;
      
      public function AABB()
      {
         super();
      }
      
      public function setSize(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : void
      {
         this.cubegyw = param1;
         this.nicomosa = param2;
         this.gesuwi = param3;
         this.jys = param4;
         this.juri = param5;
         this.zepoci = param6;
      }
      
      public function addBoundBox(param1:AABB) : void
      {
         this.cubegyw = param1.cubegyw < this.cubegyw ? param1.cubegyw : this.cubegyw;
         this.nicomosa = param1.nicomosa < this.nicomosa ? param1.nicomosa : this.nicomosa;
         this.gesuwi = param1.gesuwi < this.gesuwi ? param1.gesuwi : this.gesuwi;
         this.jys = param1.jys > this.jys ? param1.jys : this.jys;
         this.juri = param1.juri > this.juri ? param1.juri : this.juri;
         this.zepoci = param1.zepoci > this.zepoci ? param1.zepoci : this.zepoci;
      }
      
      public function addPoint(param1:Number, param2:Number, param3:Number) : void
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
      
      public function infinity() : void
      {
         this.cubegyw = 1e+308;
         this.nicomosa = 1e+308;
         this.gesuwi = 1e+308;
         this.jys = -1e+308;
         this.juri = -1e+308;
         this.zepoci = -1e+308;
      }
      
      public function intersects(param1:AABB, param2:Number) : Boolean
      {
         return !(this.cubegyw > param1.jys + param2 || this.jys < param1.cubegyw - param2 || this.nicomosa > param1.juri + param2 || this.juri < param1.nicomosa - param2 || this.gesuwi > param1.zepoci + param2 || this.zepoci < param1.gesuwi - param2);
      }
      
      public function copyFrom(param1:AABB) : void
      {
         this.cubegyw = param1.cubegyw;
         this.nicomosa = param1.nicomosa;
         this.gesuwi = param1.gesuwi;
         this.jys = param1.jys;
         this.juri = param1.juri;
         this.zepoci = param1.zepoci;
      }
      
      public function clone() : AABB
      {
         var _loc1_:AABB = new AABB();
         _loc1_.copyFrom(this);
         return _loc1_;
      }
      
      public function getSizeX() : Number
      {
         return this.jys - this.cubegyw;
      }
      
      public function getSizeY() : Number
      {
         return this.juri - this.nicomosa;
      }
      
      public function getSizeZ() : Number
      {
         return this.zepoci - this.gesuwi;
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this) + "(" + this.cubegyw.toFixed(3) + ", " + this.nicomosa.toFixed(3) + ", " + this.gesuwi.toFixed(3) + ": " + this.jys.toFixed(3) + ", " + this.juri.toFixed(3) + ", " + this.zepoci.toFixed(3) + ")";
      }
   }
}

