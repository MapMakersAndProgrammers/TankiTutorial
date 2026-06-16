package tutorial.commons
{
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class ClientLog extends TextField
   {
      
      private var maxLines:int = 20;
      
      private var lines:Vector.<String> = new Vector.<String>();
      
      public function ClientLog()
      {
         super();
         defaultTextFormat = new TextFormat("Arial",12,65280,true);
         autoSize = TextFieldAutoSize.LEFT;
      }
      
      public function addLine(param1:String) : void
      {
         var _loc2_:String = null;
         this.lines.push(param1);
         if(this.lines.length >= this.maxLines)
         {
            this.lines.shift();
         }
         this.text = "";
         for each(_loc2_ in this.lines)
         {
            appendText("> " + _loc2_ + "\n");
         }
      }
   }
}

