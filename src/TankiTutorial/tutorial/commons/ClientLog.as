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
      
      public function addLine(line:String) : void
      {
         var entry:String = null;
         this.lines.push(line);
         if(this.lines.length >= this.maxLines)
         {
            this.lines.shift();
         }
         this.text = "";
         for each(entry in this.lines)
         {
            appendText("> " + entry + "\n");
         }
      }
   }
}

