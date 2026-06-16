package movieclips
{
   import §^O§.§3Y§;
   import flash.display.MovieClip;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import tutorial.commons.Lang;
   import tutorial.commons.LocalizedStrings;
   
   public class TurnedUpClip extends MovieClip
   {
      
      private var deleteMC:Class = TurnedUpClip_deleteMC;
      
      private var deleteDeMC:Class = TurnedUpClip_deleteDeMC;
      
      private var pictogram:MovieClip;
      
      private var tf1:TextField;
      
      private var tf2:TextField;
      
      private var tf3:TextField;
      
      public function TurnedUpClip()
      {
         super();
         this.pictogram = Lang.language == Lang.DE ? new this.deleteDeMC() as MovieClip : new this.deleteMC() as MovieClip;
         this.tf1 = §3Y§.§#6§(Lang.getText(LocalizedStrings.ROLLED_OVER),42,500,"left");
         this.tf2 = §3Y§.§#6§(Lang.getText(LocalizedStrings.PRESS),42,500,"left");
         if(Lang.language == Lang.CN)
         {
            this.tf3 = §3Y§.§#6§("键就可以恢复！",42,500,"left");
         }
         else
         {
            this.tf3 = §3Y§.§#6§("",42,500,"left");
         }
         this.tf1.autoSize = TextFieldAutoSize.LEFT;
         this.tf1.text = this.tf1.text;
         this.tf1.x = -this.tf1.width / 2;
         addChild(this.tf1);
         this.tf2.autoSize = TextFieldAutoSize.LEFT;
         this.tf2.text = this.tf2.text;
         this.tf2.x = -this.tf2.width / 2 - this.pictogram.width / 2 - 10;
         this.tf2.y = 65;
         addChild(this.tf2);
         this.pictogram.x = this.tf2.x + this.tf2.width + 20;
         this.pictogram.y = 65;
         addChild(this.pictogram);
         this.tf3.autoSize = TextFieldAutoSize.LEFT;
         this.tf3.text = this.tf3.text;
         this.tf3.x = this.pictogram.x + this.pictogram.width + 20;
         this.tf3.y = 65;
         addChild(this.tf3);
         var _loc1_:Number = -Math.min(this.tf1.x,this.tf2.x);
         this.tf1.x += _loc1_;
         this.pictogram.x += _loc1_;
         this.tf2.x += _loc1_;
         this.tf3.x += _loc1_;
      }
   }
}

