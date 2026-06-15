package tup
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import flash.utils.Dictionary;
   
   public class haluly
   {
      
      private var zakorez:Vector.<Face> = new Vector.<Face>();
      
      private var redy:Vector.<Vertex>;
      
      private var ryqyfi:Number;
      
      public function haluly()
      {
         super();
      }
      
      private static function tov(param1:Face) : Number
      {
         var _loc2_:Vector.<Vertex> = param1.vertices;
         return nok(_loc2_[0],_loc2_[1]);
      }
      
      private static function nok(param1:Vertex, param2:Vertex) : Number
      {
         var _loc3_:Number = param1.x - param2.x;
         var _loc4_:Number = param1.y - param2.y;
         var _loc5_:Number = param1.z - param2.z;
         var _loc6_:Number = Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_ + _loc5_ * _loc5_);
         var _loc7_:Number = param1.u - param2.u;
         var _loc8_:Number = param1.v - param2.v;
         var _loc9_:Number = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
         return _loc9_ / _loc6_;
      }
      
      public function gyzaw(param1:Face) : void
      {
         this.zakorez.push(param1);
      }
      
      public function cabor() : void
      {
         var _loc3_:Face = null;
         var _loc4_:* = undefined;
         var _loc5_:Vertex = null;
         var _loc1_:Number = 0;
         var _loc2_:Dictionary = new Dictionary();
         for each(_loc3_ in this.zakorez)
         {
            for each(_loc5_ in _loc3_.vertices)
            {
               _loc2_[_loc5_] = true;
            }
            _loc1_ += tov(_loc3_);
         }
         this.ryqyfi = _loc1_ / this.zakorez.length;
         this.redy = new Vector.<Vertex>();
         for(_loc4_ in _loc2_)
         {
            this.redy.push(_loc4_);
         }
      }
      
      public function tajebe(param1:Number) : void
      {
         var _loc2_:Vertex = null;
         for each(_loc2_ in this.redy)
         {
            _loc2_.u += param1 * this.ryqyfi;
         }
      }
      
      public function muzobyd(param1:Material) : void
      {
         var _loc2_:Face = null;
         for each(_loc2_ in this.zakorez)
         {
            _loc2_.material = param1;
         }
      }
   }
}

