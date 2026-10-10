package alternativa.tanks.shared.usertitle
{
   public class Size2D
   {
      
      public var width:int;
      
      public var height:int;
      
      public function Size2D()
      {
         super();
      }
      
      public function setToZero() : void
      {
         this.width = 0;
         this.height = 0;
      }
      
      public function setWidth(width:int) : void
      {
         this.width = width;
      }
      
      public function setHeight(height:int) : void
      {
         this.height = height;
      }
      
      public function setWidthIfGreater(width:int) : void
      {
         if(this.width < width)
         {
            this.width = width;
         }
      }
      
      public function addHeight(height:int) : void
      {
         this.height += height;
      }
      
      public function addWidth(width:int) : void
      {
         this.width += width;
      }
   }
}

